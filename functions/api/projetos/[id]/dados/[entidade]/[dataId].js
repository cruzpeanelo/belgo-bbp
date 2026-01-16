// =====================================================
// BELGO BBP - API de Registro Individual
// /api/projetos/:id/dados/:entidade/:dataId
// =====================================================

import { jsonResponse, errorResponse } from '../../../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../../../lib/audit.js';
import { getPermissaoUsuario } from '../../../../../lib/permissions.js';

// Niveis de permissao
const NIVEL_PERMISSAO = {
    'visualizador': 1,
    'executor': 2,
    'key_user': 3,
    'gestor': 4,
    'admin': 5
};

// Verificar se usuario tem permissao minima
function temPermissao(nivelUsuario, nivelMinimo) {
    return (NIVEL_PERMISSAO[nivelUsuario] || 0) >= (NIVEL_PERMISSAO[nivelMinimo] || 0);
}

// GET - Obter registro especifico
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeCodigo = context.params.entidade;
        const dataId = context.params.dataId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeCodigo) {
            return errorResponse('Codigo da entidade nao fornecido', 400);
        }

        if (!dataId || isNaN(dataId)) {
            return errorResponse('ID do registro nao fornecido', 400);
        }

        // Buscar entidade
        const entidade = await context.env.DB.prepare(`
            SELECT id, codigo, nome
            FROM projeto_entidades
            WHERE projeto_id = ? AND codigo = ?
        `).bind(projetoId, entidadeCodigo).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        // Buscar registro
        const registro = await context.env.DB.prepare(`
            SELECT
                pd.id,
                pd.dados,
                pd.criado_por,
                pd.atualizado_por,
                pd.created_at,
                pd.updated_at,
                uc.nome as criado_por_nome,
                ua.nome as atualizado_por_nome
            FROM projeto_dados pd
            LEFT JOIN usuarios uc ON pd.criado_por = uc.id
            LEFT JOIN usuarios ua ON pd.atualizado_por = ua.id
            WHERE pd.id = ? AND pd.projeto_id = ? AND pd.entidade_id = ?
        `).bind(dataId, projetoId, entidade.id).first();

        if (!registro) {
            return errorResponse('Registro nao encontrado', 404);
        }

        return jsonResponse({
            success: true,
            registro: {
                id: registro.id,
                ...JSON.parse(registro.dados || '{}'),
                _meta: {
                    criado_por: registro.criado_por,
                    criado_por_nome: registro.criado_por_nome,
                    atualizado_por: registro.atualizado_por,
                    atualizado_por_nome: registro.atualizado_por_nome,
                    created_at: registro.created_at,
                    updated_at: registro.updated_at
                }
            }
        });

    } catch (error) {
        console.error('Erro ao obter registro:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// PUT - Atualizar registro
export async function onRequestPut(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeCodigo = context.params.entidade;
        const dataId = context.params.dataId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeCodigo) {
            return errorResponse('Codigo da entidade nao fornecido', 400);
        }

        if (!dataId || isNaN(dataId)) {
            return errorResponse('ID do registro nao fornecido', 400);
        }

        // Buscar entidade
        const entidade = await context.env.DB.prepare(`
            SELECT id, codigo, nome, permite_editar
            FROM projeto_entidades
            WHERE projeto_id = ? AND codigo = ?
        `).bind(projetoId, entidadeCodigo).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        if (!entidade.permite_editar) {
            return errorResponse('Esta entidade nao permite edicao de registros', 403);
        }

        // Verificar permissao do usuario
        let nivelUsuario = 'visualizador';
        if (usuario.isAdmin) {
            nivelUsuario = 'admin';
        } else {
            const permissao = await getPermissaoUsuario(context.env.DB, usuario.id, parseInt(projetoId));
            nivelUsuario = permissao || 'visualizador';
        }

        // Buscar permissao minima do menu vinculado
        const menu = await context.env.DB.prepare(`
            SELECT permissao_editar FROM projeto_menus WHERE entidade_id = ? AND ativo = 1 LIMIT 1
        `).bind(entidade.id).first();

        const permissaoMinima = menu?.permissao_editar || 'gestor';

        if (!temPermissao(nivelUsuario, permissaoMinima)) {
            return errorResponse('Sem permissao para editar registros nesta entidade', 403);
        }

        // Verificar se registro existe
        const registroExistente = await context.env.DB.prepare(`
            SELECT id, dados FROM projeto_dados
            WHERE id = ? AND projeto_id = ? AND entidade_id = ?
        `).bind(dataId, projetoId, entidade.id).first();

        if (!registroExistente) {
            return errorResponse('Registro nao encontrado', 404);
        }

        const body = await context.request.json();
        const { dados } = body;

        if (!dados || typeof dados !== 'object') {
            return errorResponse('Dados sao obrigatorios', 400);
        }

        // Buscar campos para validacao
        const campos = await context.env.DB.prepare(`
            SELECT codigo, nome, tipo, obrigatorio, unico
            FROM projeto_entidade_campos
            WHERE entidade_id = ?
        `).bind(entidade.id).all();

        // Validar campos obrigatorios
        for (const campo of (campos.results || [])) {
            if (campo.obrigatorio && dados[campo.codigo] === undefined) {
                // Manter valor existente se nao fornecido
                const dadosExistentes = JSON.parse(registroExistente.dados || '{}');
                if (!dadosExistentes[campo.codigo] && !dados[campo.codigo]) {
                    return errorResponse(`Campo obrigatorio: ${campo.nome}`, 400);
                }
            }

            // Validar unicidade
            if (campo.unico && dados[campo.codigo]) {
                const existente = await context.env.DB.prepare(`
                    SELECT id FROM projeto_dados
                    WHERE projeto_id = ? AND entidade_id = ?
                    AND json_extract(dados, '$.' || ?) = ?
                    AND id != ?
                `).bind(projetoId, entidade.id, campo.codigo, dados[campo.codigo], dataId).first();

                if (existente) {
                    return errorResponse(`Valor duplicado para campo unico: ${campo.nome}`, 409);
                }
            }
        }

        // Mesclar dados existentes com novos
        const dadosExistentes = JSON.parse(registroExistente.dados || '{}');
        const dadosAtualizados = { ...dadosExistentes, ...dados };

        // Atualizar registro
        await context.env.DB.prepare(`
            UPDATE projeto_dados
            SET dados = ?,
                atualizado_por = ?,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = ? AND projeto_id = ? AND entidade_id = ?
        `).bind(
            JSON.stringify(dadosAtualizados),
            usuario.id,
            dataId,
            projetoId,
            entidade.id
        ).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EDITAR,
            entidade: `projeto_dados_${entidadeCodigo}`,
            entidadeId: dataId,
            detalhes: { projetoId, entidadeId: entidade.id, alteracoes: dados },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Registro atualizado com sucesso',
            registro: {
                id: parseInt(dataId),
                ...dadosAtualizados
            }
        });

    } catch (error) {
        console.error('Erro ao atualizar registro:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Remover registro
export async function onRequestDelete(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeCodigo = context.params.entidade;
        const dataId = context.params.dataId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeCodigo) {
            return errorResponse('Codigo da entidade nao fornecido', 400);
        }

        if (!dataId || isNaN(dataId)) {
            return errorResponse('ID do registro nao fornecido', 400);
        }

        // Buscar entidade
        const entidade = await context.env.DB.prepare(`
            SELECT id, codigo, nome, permite_excluir
            FROM projeto_entidades
            WHERE projeto_id = ? AND codigo = ?
        `).bind(projetoId, entidadeCodigo).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        if (!entidade.permite_excluir) {
            return errorResponse('Esta entidade nao permite exclusao de registros', 403);
        }

        // Verificar permissao do usuario
        let nivelUsuario = 'visualizador';
        if (usuario.isAdmin) {
            nivelUsuario = 'admin';
        } else {
            const permissao = await getPermissaoUsuario(context.env.DB, usuario.id, parseInt(projetoId));
            nivelUsuario = permissao || 'visualizador';
        }

        // Buscar permissao minima do menu vinculado
        const menu = await context.env.DB.prepare(`
            SELECT permissao_excluir FROM projeto_menus WHERE entidade_id = ? AND ativo = 1 LIMIT 1
        `).bind(entidade.id).first();

        const permissaoMinima = menu?.permissao_excluir || 'admin';

        if (!temPermissao(nivelUsuario, permissaoMinima)) {
            return errorResponse('Sem permissao para excluir registros nesta entidade', 403);
        }

        // Verificar se registro existe
        const registro = await context.env.DB.prepare(`
            SELECT id, dados FROM projeto_dados
            WHERE id = ? AND projeto_id = ? AND entidade_id = ?
        `).bind(dataId, projetoId, entidade.id).first();

        if (!registro) {
            return errorResponse('Registro nao encontrado', 404);
        }

        // Remover registro
        await context.env.DB.prepare(`
            DELETE FROM projeto_dados
            WHERE id = ? AND projeto_id = ? AND entidade_id = ?
        `).bind(dataId, projetoId, entidade.id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EXCLUIR,
            entidade: `projeto_dados_${entidadeCodigo}`,
            entidadeId: dataId,
            detalhes: { projetoId, entidadeId: entidade.id, dados: JSON.parse(registro.dados || '{}') },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Registro removido com sucesso'
        });

    } catch (error) {
        console.error('Erro ao remover registro:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Projeto-Id',
            'Access-Control-Max-Age': '86400'
        }
    });
}
