// =====================================================
// BELGO BBP - API de Menu Individual
// /api/menus/:projetoId/:menuId
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../lib/audit.js';
import { isProjetoAdmin } from '../../../lib/permissions.js';

// PUT - Atualizar menu
export async function onRequestPut(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.projetoId;
        const menuId = context.params.menuId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!menuId || isNaN(menuId)) {
            return errorResponse('ID do menu nao fornecido', 400);
        }

        // Verificar permissao
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeEditar) {
            return errorResponse('Sem permissao para gerenciar menus deste projeto', 403);
        }

        // Verificar se menu existe e pertence ao projeto
        const menuExistente = await context.env.DB.prepare(`
            SELECT id FROM projeto_menus WHERE id = ? AND projeto_id = ?
        `).bind(menuId, projetoId).first();

        if (!menuExistente) {
            return errorResponse('Menu nao encontrado', 404);
        }

        const body = await context.request.json();
        const { nome, url: menuUrl, icone, ordem, ativo } = body;

        // Atualizar menu
        await context.env.DB.prepare(`
            UPDATE projeto_menus
            SET nome = COALESCE(?, nome),
                url = COALESCE(?, url),
                icone = COALESCE(?, icone),
                ordem = COALESCE(?, ordem),
                ativo = COALESCE(?, ativo)
            WHERE id = ? AND projeto_id = ?
        `).bind(
            nome || null,
            menuUrl || null,
            icone || null,
            ordem !== undefined ? ordem : null,
            ativo !== undefined ? (ativo ? 1 : 0) : null,
            menuId,
            projetoId
        ).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EDITAR,
            entidade: 'menu',
            entidadeId: menuId,
            detalhes: { projetoId, alteracoes: body },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Menu atualizado com sucesso'
        });

    } catch (error) {
        console.error('Erro ao atualizar menu:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Remover menu
export async function onRequestDelete(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.projetoId;
        const menuId = context.params.menuId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!menuId || isNaN(menuId)) {
            return errorResponse('ID do menu nao fornecido', 400);
        }

        // Verificar permissao
        const podeExcluir = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeExcluir) {
            return errorResponse('Sem permissao para gerenciar menus deste projeto', 403);
        }

        // Verificar se menu existe
        const menu = await context.env.DB.prepare(`
            SELECT id, nome FROM projeto_menus WHERE id = ? AND projeto_id = ?
        `).bind(menuId, projetoId).first();

        if (!menu) {
            return errorResponse('Menu nao encontrado', 404);
        }

        // Remover menu (hard delete)
        await context.env.DB.prepare(`
            DELETE FROM projeto_menus WHERE id = ? AND projeto_id = ?
        `).bind(menuId, projetoId).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EXCLUIR,
            entidade: 'menu',
            entidadeId: menuId,
            detalhes: { projetoId, nome: menu.nome },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Menu removido com sucesso'
        });

    } catch (error) {
        console.error('Erro ao remover menu:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Projeto-Id',
            'Access-Control-Max-Age': '86400'
        }
    });
}
