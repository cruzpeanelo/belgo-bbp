// =====================================================
// BELGO BBP - API de Membros do Projeto
// /api/projetos/:id/membros
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../lib/audit.js';
import { isProjetoAdmin, buscarPermissoesUsuario } from '../../../lib/permissions.js';

// GET - Listar membros do projeto
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto invalido', 400);
        }

        // Verificar se projeto existe
        const projeto = await context.env.DB.prepare(`
            SELECT id, nome FROM projetos WHERE id = ? AND ativo = 1
        `).bind(projetoId).first();

        if (!projeto) {
            return errorResponse('Projeto nao encontrado', 404);
        }

        // Verificar acesso (admin global ou membro do projeto)
        if (!usuario.isAdmin) {
            const temAcesso = await context.env.DB.prepare(`
                SELECT 1 FROM usuario_projeto_papel
                WHERE usuario_id = ? AND projeto_id = ? AND ativo = 1
            `).bind(usuario.id, projetoId).first();

            if (!temAcesso) {
                return errorResponse('Sem acesso a este projeto', 403);
            }
        }

        // Buscar membros com seus papeis
        const membros = await context.env.DB.prepare(`
            SELECT u.id, u.email, u.nome, u.nome_completo, u.area, u.cargo,
                   p.id as papel_id, p.codigo as papel_codigo, p.nome as papel_nome,
                   p.nivel as papel_nivel, p.cor as papel_cor,
                   upp.permissoes_extras, upp.permissoes_removidas,
                   upp.created_at as membro_desde
            FROM usuario_projeto_papel upp
            JOIN usuarios u ON upp.usuario_id = u.id
            JOIN papeis p ON upp.papel_id = p.id
            WHERE upp.projeto_id = ? AND upp.ativo = 1 AND u.ativo = 1
            ORDER BY p.nivel DESC, u.nome
        `).bind(projetoId).all();

        return jsonResponse({
            success: true,
            projeto: {
                id: projeto.id,
                nome: projeto.nome
            },
            membros: membros.results || [],
            total: membros.results?.length || 0
        });

    } catch (error) {
        console.error('Erro ao listar membros:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// POST - Adicionar membro ao projeto
export async function onRequestPost(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto invalido', 400);
        }

        // Verificar permissao (admin global ou admin do projeto)
        const podeGerenciar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeGerenciar) {
            return errorResponse('Sem permissao para gerenciar membros deste projeto', 403);
        }

        const body = await context.request.json();
        const { usuarioId, papelId, permissoesExtras, permissoesRemovidas } = body;

        if (!usuarioId || !papelId) {
            return errorResponse('Usuario e papel sao obrigatorios', 400);
        }

        // Verificar se usuario existe
        const usuarioAlvo = await context.env.DB.prepare(`
            SELECT id, email, nome FROM usuarios WHERE id = ? AND ativo = 1
        `).bind(usuarioId).first();

        if (!usuarioAlvo) {
            return errorResponse('Usuario nao encontrado', 404);
        }

        // Verificar se papel existe
        const papel = await context.env.DB.prepare(`
            SELECT id, nome FROM papeis WHERE id = ?
        `).bind(papelId).first();

        if (!papel) {
            return errorResponse('Papel nao encontrado', 404);
        }

        // Verificar se ja e membro
        const jaMembro = await context.env.DB.prepare(`
            SELECT id FROM usuario_projeto_papel
            WHERE usuario_id = ? AND projeto_id = ?
        `).bind(usuarioId, projetoId).first();

        if (jaMembro) {
            // Reativar se estava inativo
            await context.env.DB.prepare(`
                UPDATE usuario_projeto_papel
                SET papel_id = ?, ativo = 1,
                    permissoes_extras = ?, permissoes_removidas = ?
                WHERE usuario_id = ? AND projeto_id = ?
            `).bind(
                papelId,
                permissoesExtras ? JSON.stringify(permissoesExtras) : null,
                permissoesRemovidas ? JSON.stringify(permissoesRemovidas) : null,
                usuarioId,
                projetoId
            ).run();
        } else {
            // Adicionar novo membro
            await context.env.DB.prepare(`
                INSERT INTO usuario_projeto_papel (usuario_id, projeto_id, papel_id, permissoes_extras, permissoes_removidas)
                VALUES (?, ?, ?, ?, ?)
            `).bind(
                usuarioId,
                projetoId,
                papelId,
                permissoesExtras ? JSON.stringify(permissoesExtras) : null,
                permissoesRemovidas ? JSON.stringify(permissoesRemovidas) : null
            ).run();
        }

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: 'adicionar_membro',
            entidade: 'projeto',
            entidadeId: projetoId,
            detalhes: {
                membroEmail: usuarioAlvo.email,
                membroNome: usuarioAlvo.nome,
                papel: papel.nome,
                adicionadoPor: usuario.email
            },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: `${usuarioAlvo.nome} adicionado ao projeto como ${papel.nome}`
        }, 201);

    } catch (error) {
        console.error('Erro ao adicionar membro:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// PUT - Atualizar papel/permissoes de um membro
export async function onRequestPut(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const url = new URL(context.request.url);
        const pathParts = url.pathname.split('/').filter(p => p);

        // Extrair usuario_id do path: /api/projetos/:id/membros/:uid
        const membroId = pathParts[pathParts.length - 1];

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto invalido', 400);
        }

        if (!membroId || isNaN(membroId) || membroId === 'membros') {
            return errorResponse('ID do membro nao fornecido', 400);
        }

        // Verificar permissao
        const podeGerenciar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeGerenciar) {
            return errorResponse('Sem permissao para gerenciar membros deste projeto', 403);
        }

        // Verificar se membro existe no projeto
        const vinculo = await context.env.DB.prepare(`
            SELECT upp.*, u.email, u.nome
            FROM usuario_projeto_papel upp
            JOIN usuarios u ON upp.usuario_id = u.id
            WHERE upp.usuario_id = ? AND upp.projeto_id = ?
        `).bind(membroId, projetoId).first();

        if (!vinculo) {
            return errorResponse('Membro nao encontrado neste projeto', 404);
        }

        const body = await context.request.json();
        const { papelId, permissoesExtras, permissoesRemovidas, ativo } = body;

        // Atualizar vinculo
        await context.env.DB.prepare(`
            UPDATE usuario_projeto_papel
            SET papel_id = COALESCE(?, papel_id),
                permissoes_extras = COALESCE(?, permissoes_extras),
                permissoes_removidas = COALESCE(?, permissoes_removidas),
                ativo = COALESCE(?, ativo)
            WHERE usuario_id = ? AND projeto_id = ?
        `).bind(
            papelId || null,
            permissoesExtras !== undefined ? JSON.stringify(permissoesExtras) : null,
            permissoesRemovidas !== undefined ? JSON.stringify(permissoesRemovidas) : null,
            ativo !== undefined ? (ativo ? 1 : 0) : null,
            membroId,
            projetoId
        ).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EDITAR,
            entidade: 'membro_projeto',
            entidadeId: `${projetoId}-${membroId}`,
            detalhes: {
                membroEmail: vinculo.email,
                alteracoes: body,
                editadoPor: usuario.email
            },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: `Permissoes de ${vinculo.nome} atualizadas`
        });

    } catch (error) {
        console.error('Erro ao atualizar membro:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Remover membro do projeto
export async function onRequestDelete(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const url = new URL(context.request.url);
        const pathParts = url.pathname.split('/').filter(p => p);
        const membroId = pathParts[pathParts.length - 1];

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto invalido', 400);
        }

        if (!membroId || isNaN(membroId) || membroId === 'membros') {
            return errorResponse('ID do membro nao fornecido', 400);
        }

        // Nao permitir remover a si mesmo
        if (parseInt(membroId) === usuario.id) {
            return errorResponse('Voce nao pode remover a si mesmo do projeto', 400);
        }

        // Verificar permissao
        const podeGerenciar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeGerenciar) {
            return errorResponse('Sem permissao para gerenciar membros deste projeto', 403);
        }

        // Verificar se membro existe
        const vinculo = await context.env.DB.prepare(`
            SELECT upp.*, u.email, u.nome
            FROM usuario_projeto_papel upp
            JOIN usuarios u ON upp.usuario_id = u.id
            WHERE upp.usuario_id = ? AND upp.projeto_id = ?
        `).bind(membroId, projetoId).first();

        if (!vinculo) {
            return errorResponse('Membro nao encontrado neste projeto', 404);
        }

        // Remover (soft delete - desativar)
        await context.env.DB.prepare(`
            UPDATE usuario_projeto_papel
            SET ativo = 0
            WHERE usuario_id = ? AND projeto_id = ?
        `).bind(membroId, projetoId).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: 'remover_membro',
            entidade: 'projeto',
            entidadeId: projetoId,
            detalhes: {
                membroEmail: vinculo.email,
                membroNome: vinculo.nome,
                removidoPor: usuario.email
            },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: `${vinculo.nome} removido do projeto`
        });

    } catch (error) {
        console.error('Erro ao remover membro:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Projeto-Id',
            'Access-Control-Max-Age': '86400'
        }
    });
}
