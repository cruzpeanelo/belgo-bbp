// =====================================================
// API: Listar Templates
// GET /api/templates
// =====================================================

import { verificarAuth } from '../lib/auth.js';

export async function onRequestGet(context) {
    const { request, env } = context;

    try {
        // Verificar autenticacao
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Buscar templates ativos
        // Se usuario eh admin, mostra todos
        // Senao, mostra apenas publicos
        const query = usuario.admin
            ? `SELECT id, codigo, nome, descricao, icone, cor, versao, publico,
                      projeto_origem_id, created_at
               FROM projeto_templates
               WHERE ativo = 1
               ORDER BY nome`
            : `SELECT id, codigo, nome, descricao, icone, cor, versao, publico,
                      projeto_origem_id, created_at
               FROM projeto_templates
               WHERE ativo = 1 AND publico = 1
               ORDER BY nome`;

        const result = await env.DB.prepare(query).all();
        const templates = result.results || [];

        // Para cada template, contar entidades e menus do config_completo
        const templatesComStats = await Promise.all(templates.map(async (t) => {
            let stats = { entidades: 0, menus: 0, campos: 0 };

            // Tentar ler do config_completo
            const templateCompleto = await env.DB.prepare(`
                SELECT config_completo FROM projeto_templates WHERE id = ?
            `).bind(t.id).first();

            if (templateCompleto?.config_completo) {
                try {
                    const config = JSON.parse(templateCompleto.config_completo);
                    stats.entidades = (config.entidades || []).length;
                    stats.menus = (config.menus || []).length;
                    stats.campos = (config.entidades || []).reduce((sum, e) => sum + (e.campos || []).length, 0);
                } catch (e) {
                    // Ignorar erro de parse
                }
            }

            return {
                id: t.id,
                codigo: t.codigo,
                nome: t.nome,
                descricao: t.descricao,
                icone: t.icone,
                cor: t.cor,
                versao: t.versao,
                publico: t.publico,
                projeto_origem_id: t.projeto_origem_id,
                created_at: t.created_at,
                stats
            };
        }));

        return new Response(JSON.stringify({
            success: true,
            templates: templatesComStats
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao listar templates:', error);
        return new Response(JSON.stringify({
            success: false,
            error: 'Erro interno ao listar templates',
            details: error.message
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// GET /api/templates/:id - Detalhes de um template
export async function onRequestGetById(context) {
    const { request, env, params } = context;
    const templateId = parseInt(params.id);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const template = await env.DB.prepare(`
            SELECT * FROM projeto_templates WHERE id = ? AND ativo = 1
        `).bind(templateId).first();

        if (!template) {
            return new Response(JSON.stringify({ success: false, error: 'Template nao encontrado' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Verificar acesso
        if (!usuario.admin && !template.publico) {
            return new Response(JSON.stringify({ success: false, error: 'Sem permissao para acessar este template' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Parse do config_completo
        let config = null;
        if (template.config_completo) {
            try {
                config = JSON.parse(template.config_completo);
            } catch (e) {
                config = null;
            }
        }

        return new Response(JSON.stringify({
            success: true,
            template: {
                ...template,
                config_completo: config
            }
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao buscar template:', error);
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
