// =====================================================
// BELGO BBP - API de Menus Dinamicos
// /api/menus/:projetoId
// =====================================================

import { jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../lib/audit.js';
import { isProjetoAdmin } from '../../lib/permissions.js';

// GET - Listar menus de um projeto
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.projetoId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        // Verificar se o usuario tem acesso ao projeto
        if (!usuario.isAdmin) {
            const temAcesso = await context.env.DB.prepare(`
                SELECT 1 FROM usuario_projeto_papel
                WHERE usuario_id = ? AND projeto_id = ? AND ativo = 1
            `).bind(usuario.id, projetoId).first();

            if (!temAcesso) {
                return errorResponse('Sem acesso a este projeto', 403);
            }
        }

        // Verificar se deve filtrar apenas menus vinculados a entidades
        const url = new URL(context.request.url);
        const onlyEntities = url.searchParams.get('onlyEntities') === 'true';

        // Buscar menus do projeto
        let query;
        if (onlyEntities) {
            // Apenas menus vinculados a entidades ativas
            query = context.env.DB.prepare(`
                SELECT m.id, m.nome, m.url, m.icone, m.ordem, m.ativo, m.entidade_id
                FROM projeto_menus m
                LEFT JOIN projeto_entidades e ON m.entidade_id = e.id
                WHERE m.projeto_id = ? AND m.ativo = 1
                AND (m.entidade_id IS NOT NULL AND e.ativo = 1)
                ORDER BY m.ordem ASC
            `).bind(projetoId);
        } else {
            // Todos os menus ativos (comportamento padrão)
            query = context.env.DB.prepare(`
                SELECT id, nome, url, icone, ordem, ativo, entidade_id
                FROM projeto_menus
                WHERE projeto_id = ? AND ativo = 1
                ORDER BY ordem ASC
            `).bind(projetoId);
        }
        const menus = await query.all();

        return jsonResponse({
            success: true,
            menus: menus.results || []
        });

    } catch (error) {
        console.error('Erro ao listar menus:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// POST - Adicionar menu a um projeto
export async function onRequestPost(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.projetoId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        // Verificar permissao (admin global ou admin do projeto)
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeEditar) {
            return errorResponse('Sem permissao para gerenciar menus deste projeto', 403);
        }

        const body = await context.request.json();
        const { nome, url: menuUrl, icone, ordem } = body;

        // Validacoes
        if (!nome || !menuUrl) {
            return errorResponse('Nome e URL sao obrigatorios', 400);
        }

        // Calcular ordem se nao fornecida
        let ordemFinal = ordem;
        if (ordemFinal === undefined) {
            const maxOrdem = await context.env.DB.prepare(`
                SELECT MAX(ordem) as max_ordem FROM projeto_menus WHERE projeto_id = ?
            `).bind(projetoId).first();
            ordemFinal = (maxOrdem?.max_ordem || 0) + 1;
        }

        // Inserir menu
        const result = await context.env.DB.prepare(`
            INSERT INTO projeto_menus (projeto_id, nome, url, icone, ordem)
            VALUES (?, ?, ?, ?, ?)
        `).bind(projetoId, nome, menuUrl, icone || '📄', ordemFinal).run();

        const menuId = result.meta.last_row_id;

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.CRIAR,
            entidade: 'menu',
            entidadeId: String(menuId),
            detalhes: { projetoId, nome, url: menuUrl },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Menu adicionado com sucesso',
            menu: { id: menuId, nome, url: menuUrl, icone: icone || '📄', ordem: ordemFinal }
        }, 201);

    } catch (error) {
        console.error('Erro ao adicionar menu:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Projeto-Id',
            'Access-Control-Max-Age': '86400'
        }
    });
}
