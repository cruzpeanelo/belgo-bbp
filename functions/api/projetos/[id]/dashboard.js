// =====================================================
// API: Dashboard do Projeto
// GET/PUT /api/projetos/:id/dashboard
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';
import { isProjetoAdmin } from '../../../lib/permissions.js';

// GET - Obter configuracao e widgets do dashboard
export async function onRequestGet(context) {
    const projetoId = parseInt(context.params.id);
    const usuario = context.data.usuario;

    try {
        // Buscar configuracao do dashboard do projeto
        const projeto = await context.env.DB.prepare(`
            SELECT dashboard_config FROM projetos WHERE id = ?
        `).bind(projetoId).first();

        let config = {};
        if (projeto?.dashboard_config) {
            try {
                config = JSON.parse(projeto.dashboard_config);
            } catch (e) {
                console.warn('Erro ao parsear dashboard_config:', e);
            }
        }

        // Buscar widgets do dashboard
        const widgetsResult = await context.env.DB.prepare(`
            SELECT id, codigo, tipo, titulo, config, posicao_x, posicao_y,
                   largura, altura, ordem, ativo
            FROM projeto_dashboard_widgets
            WHERE projeto_id = ? AND ativo = 1
            ORDER BY ordem, id
        `).bind(projetoId).all();

        const widgets = (widgetsResult.results || []).map(w => ({
            ...w,
            config: w.config ? JSON.parse(w.config) : {}
        }));

        return jsonResponse({
            success: true,
            config,
            widgets
        });

    } catch (error) {
        console.error('Erro ao obter dashboard:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// PUT - Atualizar configuracao do dashboard
export async function onRequestPut(context) {
    const projetoId = parseInt(context.params.id);
    const usuario = context.data.usuario;

    try {
        // Verificar permissao (admin global ou admin do projeto)
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, projetoId);
        if (!podeEditar) {
            return errorResponse('Sem permissao para editar dashboard', 403);
        }

        const body = await context.request.json();
        const { config } = body;

        if (config) {
            await context.env.DB.prepare(`
                UPDATE projetos SET dashboard_config = ? WHERE id = ?
            `).bind(JSON.stringify(config), projetoId).run();
        }

        return jsonResponse({
            success: true,
            message: 'Dashboard atualizado'
        });

    } catch (error) {
        console.error('Erro ao atualizar dashboard:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// POST - Adicionar widget ao dashboard
export async function onRequestPost(context) {
    const projetoId = parseInt(context.params.id);
    const usuario = context.data.usuario;

    try {
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, projetoId);
        if (!podeEditar) {
            return errorResponse('Sem permissao', 403);
        }

        const body = await context.request.json();
        const { codigo, tipo, titulo, config, posicao_x, posicao_y, largura, altura, ordem } = body;

        if (!codigo || !tipo || !titulo) {
            return errorResponse('codigo, tipo e titulo sao obrigatorios', 400);
        }

        const result = await context.env.DB.prepare(`
            INSERT INTO projeto_dashboard_widgets (
                projeto_id, codigo, tipo, titulo, config,
                posicao_x, posicao_y, largura, altura, ordem
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
            projetoId,
            codigo,
            tipo,
            titulo,
            config ? JSON.stringify(config) : null,
            posicao_x || 0,
            posicao_y || 0,
            largura || 1,
            altura || 1,
            ordem || 0
        ).run();

        return jsonResponse({
            success: true,
            message: 'Widget adicionado',
            widget: {
                id: result.meta.last_row_id,
                codigo,
                tipo,
                titulo
            }
        });

    } catch (error) {
        console.error('Erro ao adicionar widget:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// DELETE - Remover widget (soft delete)
export async function onRequestDelete(context) {
    const projetoId = parseInt(context.params.id);
    const usuario = context.data.usuario;

    try {
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, projetoId);
        if (!podeEditar) {
            return errorResponse('Sem permissao', 403);
        }

        const url = new URL(context.request.url);
        const widgetId = url.searchParams.get('widgetId');

        if (!widgetId) {
            return errorResponse('widgetId eh obrigatorio', 400);
        }

        await context.env.DB.prepare(`
            UPDATE projeto_dashboard_widgets SET ativo = 0
            WHERE id = ? AND projeto_id = ?
        `).bind(widgetId, projetoId).run();

        return jsonResponse({
            success: true,
            message: 'Widget removido'
        });

    } catch (error) {
        console.error('Erro ao remover widget:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, PUT, POST, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
