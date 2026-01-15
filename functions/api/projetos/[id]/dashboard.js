// =====================================================
// API: Dashboard do Projeto
// GET/PUT /api/projetos/:id/dashboard
// =====================================================

import { verificarAuth } from '../../../lib/auth.js';
import { verificarPermissao } from '../../../lib/permissions.js';

// GET - Obter configuracao e widgets do dashboard
export async function onRequestGet(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Buscar configuracao do dashboard do projeto
        const projeto = await env.DB.prepare(`
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
        const widgetsResult = await env.DB.prepare(`
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

        return new Response(JSON.stringify({
            success: true,
            config,
            widgets
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao obter dashboard:', error);
        return new Response(JSON.stringify({
            success: false,
            error: 'Erro interno',
            details: error.message
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// PUT - Atualizar configuracao do dashboard
export async function onRequestPut(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Verificar permissao (apenas gestor/admin pode configurar dashboard)
        const temPermissao = await verificarPermissao(env.DB, usuario.id, projetoId, 'gestor');
        if (!temPermissao && !usuario.admin) {
            return new Response(JSON.stringify({ success: false, error: 'Sem permissao' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const body = await request.json();
        const { config } = body;

        if (config) {
            await env.DB.prepare(`
                UPDATE projetos SET dashboard_config = ? WHERE id = ?
            `).bind(JSON.stringify(config), projetoId).run();
        }

        return new Response(JSON.stringify({
            success: true,
            message: 'Dashboard atualizado'
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao atualizar dashboard:', error);
        return new Response(JSON.stringify({
            success: false,
            error: 'Erro interno',
            details: error.message
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// POST - Adicionar widget ao dashboard
export async function onRequestPost(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const temPermissao = await verificarPermissao(env.DB, usuario.id, projetoId, 'gestor');
        if (!temPermissao && !usuario.admin) {
            return new Response(JSON.stringify({ success: false, error: 'Sem permissao' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const body = await request.json();
        const { codigo, tipo, titulo, config, posicao_x, posicao_y, largura, altura, ordem } = body;

        if (!codigo || !tipo || !titulo) {
            return new Response(JSON.stringify({
                success: false,
                error: 'codigo, tipo e titulo sao obrigatorios'
            }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const result = await env.DB.prepare(`
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

        return new Response(JSON.stringify({
            success: true,
            message: 'Widget adicionado',
            widget: {
                id: result.meta.last_row_id,
                codigo,
                tipo,
                titulo
            }
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao adicionar widget:', error);
        return new Response(JSON.stringify({
            success: false,
            error: 'Erro interno',
            details: error.message
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// DELETE - Remover widget (soft delete)
export async function onRequestDelete(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const temPermissao = await verificarPermissao(env.DB, usuario.id, projetoId, 'gestor');
        if (!temPermissao && !usuario.admin) {
            return new Response(JSON.stringify({ success: false, error: 'Sem permissao' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const url = new URL(request.url);
        const widgetId = url.searchParams.get('widgetId');

        if (!widgetId) {
            return new Response(JSON.stringify({
                success: false,
                error: 'widgetId eh obrigatorio'
            }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        await env.DB.prepare(`
            UPDATE projeto_dashboard_widgets SET ativo = 0
            WHERE id = ? AND projeto_id = ?
        `).bind(widgetId, projetoId).run();

        return new Response(JSON.stringify({
            success: true,
            message: 'Widget removido'
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao remover widget:', error);
        return new Response(JSON.stringify({
            success: false,
            error: 'Erro interno',
            details: error.message
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
