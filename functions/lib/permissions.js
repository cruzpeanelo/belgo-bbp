// =====================================================
// BELGO BBP - Helpers de Permissoes Multi-Projeto
// =====================================================

import { errorResponse } from './auth.js';

/**
 * Verifica se usuario tem permissao especifica em um projeto
 * @param {D1Database} db - Database D1
 * @param {number} usuarioId - ID do usuario
 * @param {number} projetoId - ID do projeto
 * @param {string} permissao - Codigo da permissao (ex: 'teste.editar')
 * @returns {Promise<boolean>}
 */
export async function verificarPermissao(db, usuarioId, projetoId, permissao) {
    try {
        // 1. Buscar vinculo usuario-projeto-papel
        const vinculo = await db.prepare(`
            SELECT upp.*, p.nivel, p.codigo as papel_codigo,
                   upp.permissoes_extras, upp.permissoes_removidas
            FROM usuario_projeto_papel upp
            JOIN papeis p ON upp.papel_id = p.id
            WHERE upp.usuario_id = ? AND upp.projeto_id = ? AND upp.ativo = 1
        `).bind(usuarioId, projetoId).first();

        if (!vinculo) {
            return false;
        }

        // 2. Admin do projeto (nivel >= 100) tem acesso total
        if (vinculo.nivel >= 100) {
            return true;
        }

        // 3. Verificar se permissao esta nas extras (JSON array)
        if (vinculo.permissoes_extras) {
            try {
                const extras = JSON.parse(vinculo.permissoes_extras);
                if (Array.isArray(extras) && extras.includes(permissao)) {
                    return true;
                }
            } catch (e) {
                console.error('Erro ao parsear permissoes_extras:', e);
            }
        }

        // 4. Verificar se permissao esta nas removidas (JSON array)
        if (vinculo.permissoes_removidas) {
            try {
                const removidas = JSON.parse(vinculo.permissoes_removidas);
                if (Array.isArray(removidas) && removidas.includes(permissao)) {
                    return false;
                }
            } catch (e) {
                console.error('Erro ao parsear permissoes_removidas:', e);
            }
        }

        // 5. Verificar permissoes do papel
        const temPermissao = await db.prepare(`
            SELECT 1 FROM papel_permissoes pp
            JOIN permissoes perm ON pp.permissao_id = perm.id
            WHERE pp.papel_id = ? AND perm.codigo = ?
        `).bind(vinculo.papel_id, permissao).first();

        return !!temPermissao;

    } catch (error) {
        console.error('Erro ao verificar permissao:', error);
        return false;
    }
}

/**
 * Verifica se usuario tem acesso a um projeto (qualquer papel)
 * @param {D1Database} db - Database D1
 * @param {number} usuarioId - ID do usuario
 * @param {number} projetoId - ID do projeto
 * @returns {Promise<boolean>}
 */
export async function verificarAcessoProjeto(db, usuarioId, projetoId) {
    try {
        const vinculo = await db.prepare(`
            SELECT 1 FROM usuario_projeto_papel
            WHERE usuario_id = ? AND projeto_id = ? AND ativo = 1
        `).bind(usuarioId, projetoId).first();

        return !!vinculo;
    } catch (error) {
        console.error('Erro ao verificar acesso ao projeto:', error);
        return false;
    }
}

/**
 * Busca papel do usuario em um projeto
 * @param {D1Database} db - Database D1
 * @param {number} usuarioId - ID do usuario
 * @param {number} projetoId - ID do projeto
 * @returns {Promise<Object|null>}
 */
export async function buscarPapelUsuario(db, usuarioId, projetoId) {
    try {
        const resultado = await db.prepare(`
            SELECT p.id, p.codigo, p.nome, p.nivel, p.cor,
                   upp.permissoes_extras, upp.permissoes_removidas
            FROM usuario_projeto_papel upp
            JOIN papeis p ON upp.papel_id = p.id
            WHERE upp.usuario_id = ? AND upp.projeto_id = ? AND upp.ativo = 1
        `).bind(usuarioId, projetoId).first();

        return resultado || null;
    } catch (error) {
        console.error('Erro ao buscar papel do usuario:', error);
        return null;
    }
}

/**
 * Busca todas as permissoes do usuario em um projeto
 * @param {D1Database} db - Database D1
 * @param {number} usuarioId - ID do usuario
 * @param {number} projetoId - ID do projeto
 * @returns {Promise<string[]>} Lista de codigos de permissoes
 */
export async function buscarPermissoesUsuario(db, usuarioId, projetoId) {
    try {
        const vinculo = await db.prepare(`
            SELECT upp.papel_id, p.nivel,
                   upp.permissoes_extras, upp.permissoes_removidas
            FROM usuario_projeto_papel upp
            JOIN papeis p ON upp.papel_id = p.id
            WHERE upp.usuario_id = ? AND upp.projeto_id = ? AND upp.ativo = 1
        `).bind(usuarioId, projetoId).first();

        if (!vinculo) {
            return [];
        }

        // Admin tem todas as permissoes
        if (vinculo.nivel >= 100) {
            const todas = await db.prepare(`
                SELECT codigo FROM permissoes
            `).all();
            return (todas.results || []).map(p => p.codigo);
        }

        // Buscar permissoes do papel
        const permissoesPapel = await db.prepare(`
            SELECT perm.codigo
            FROM papel_permissoes pp
            JOIN permissoes perm ON pp.permissao_id = perm.id
            WHERE pp.papel_id = ?
        `).bind(vinculo.papel_id).all();

        let permissoes = new Set((permissoesPapel.results || []).map(p => p.codigo));

        // Adicionar extras
        if (vinculo.permissoes_extras) {
            try {
                const extras = JSON.parse(vinculo.permissoes_extras);
                if (Array.isArray(extras)) {
                    extras.forEach(p => permissoes.add(p));
                }
            } catch (e) {}
        }

        // Remover removidas
        if (vinculo.permissoes_removidas) {
            try {
                const removidas = JSON.parse(vinculo.permissoes_removidas);
                if (Array.isArray(removidas)) {
                    removidas.forEach(p => permissoes.delete(p));
                }
            } catch (e) {}
        }

        return Array.from(permissoes);

    } catch (error) {
        console.error('Erro ao buscar permissoes do usuario:', error);
        return [];
    }
}

/**
 * Middleware factory para verificar permissao
 * Uso: requirePermission('teste.editar')
 * @param {string} permissao - Codigo da permissao requerida
 * @returns {Function} Middleware function
 */
export function requirePermission(permissao) {
    return async (context, next) => {
        const usuario = context.data?.usuario;
        if (!usuario) {
            return errorResponse('Nao autenticado', 401);
        }

        // Buscar projeto_id do request (query param, body ou path)
        let projetoId = null;

        // 1. Tentar do path params
        if (context.params?.projetoId) {
            projetoId = parseInt(context.params.projetoId);
        }

        // 2. Tentar do query string
        if (!projetoId) {
            const url = new URL(context.request.url);
            const queryProjetoId = url.searchParams.get('projeto_id') || url.searchParams.get('projetoId');
            if (queryProjetoId) {
                projetoId = parseInt(queryProjetoId);
            }
        }

        // 3. Tentar do header
        if (!projetoId) {
            const headerProjetoId = context.request.headers.get('X-Projeto-Id');
            if (headerProjetoId) {
                projetoId = parseInt(headerProjetoId);
            }
        }

        // 4. Default para projeto 1 (GTM) se nao especificado
        if (!projetoId) {
            projetoId = 1;
        }

        // Verificar permissao
        const temPermissao = await verificarPermissao(
            context.env.DB,
            usuario.id,
            projetoId,
            permissao
        );

        if (!temPermissao) {
            return errorResponse(`Sem permissao: ${permissao}`, 403);
        }

        // Adicionar projetoId ao context para uso posterior
        context.data.projetoId = projetoId;

        return next();
    };
}

/**
 * Middleware factory para verificar acesso ao projeto
 * @returns {Function} Middleware function
 */
export function requireProjetoAccess() {
    return async (context, next) => {
        const usuario = context.data?.usuario;
        if (!usuario) {
            return errorResponse('Nao autenticado', 401);
        }

        // Buscar projeto_id
        let projetoId = null;
        const url = new URL(context.request.url);

        // Path param
        if (context.params?.projetoId || context.params?.id) {
            projetoId = parseInt(context.params.projetoId || context.params.id);
        }

        // Query string
        if (!projetoId) {
            const queryProjetoId = url.searchParams.get('projeto_id') || url.searchParams.get('projetoId');
            if (queryProjetoId) {
                projetoId = parseInt(queryProjetoId);
            }
        }

        // Header
        if (!projetoId) {
            const headerProjetoId = context.request.headers.get('X-Projeto-Id');
            if (headerProjetoId) {
                projetoId = parseInt(headerProjetoId);
            }
        }

        // Default
        if (!projetoId) {
            projetoId = 1;
        }

        // Admin global tem acesso a todos os projetos
        if (usuario.isAdmin) {
            context.data.projetoId = projetoId;
            return next();
        }

        // Verificar acesso
        const temAcesso = await verificarAcessoProjeto(
            context.env.DB,
            usuario.id,
            projetoId
        );

        if (!temAcesso) {
            return errorResponse('Sem acesso a este projeto', 403);
        }

        context.data.projetoId = projetoId;
        return next();
    };
}

/**
 * Verifica se usuario e admin de um projeto especifico
 * @param {D1Database} db - Database D1
 * @param {number} usuarioId - ID do usuario
 * @param {number} projetoId - ID do projeto
 * @returns {Promise<boolean>}
 */
export async function isProjetoAdmin(db, usuarioId, projetoId) {
    try {
        const vinculo = await db.prepare(`
            SELECT p.nivel
            FROM usuario_projeto_papel upp
            JOIN papeis p ON upp.papel_id = p.id
            WHERE upp.usuario_id = ? AND upp.projeto_id = ? AND upp.ativo = 1
        `).bind(usuarioId, projetoId).first();

        return vinculo && vinculo.nivel >= 100;
    } catch (error) {
        console.error('Erro ao verificar admin do projeto:', error);
        return false;
    }
}

/**
 * Busca projetos que o usuario tem acesso
 * @param {D1Database} db - Database D1
 * @param {number} usuarioId - ID do usuario
 * @param {boolean} isAdminGlobal - Se usuario e admin global
 * @returns {Promise<Array>}
 */
export async function buscarProjetosUsuario(db, usuarioId, isAdminGlobal = false) {
    try {
        let query;

        if (isAdminGlobal) {
            // Admin global ve todos os projetos ativos
            query = db.prepare(`
                SELECT p.*,
                       (SELECT COUNT(*) FROM usuario_projeto_papel WHERE projeto_id = p.id AND ativo = 1) as total_membros
                FROM projetos p
                WHERE p.ativo = 1
                ORDER BY p.nome
            `);
        } else {
            // Usuario comum ve apenas projetos onde tem acesso
            query = db.prepare(`
                SELECT p.*,
                       pa.codigo as papel_codigo, pa.nome as papel_nome, pa.nivel as papel_nivel,
                       (SELECT COUNT(*) FROM usuario_projeto_papel WHERE projeto_id = p.id AND ativo = 1) as total_membros
                FROM projetos p
                JOIN usuario_projeto_papel upp ON p.id = upp.projeto_id
                JOIN papeis pa ON upp.papel_id = pa.id
                WHERE p.ativo = 1 AND upp.usuario_id = ? AND upp.ativo = 1
                ORDER BY p.nome
            `).bind(usuarioId);
        }

        const resultado = await query.all();
        return resultado.results || [];

    } catch (error) {
        console.error('Erro ao buscar projetos do usuario:', error);
        return [];
    }
}
