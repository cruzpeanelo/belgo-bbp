// =====================================================
// API: Listar Templates
// GET /api/templates
// =====================================================

import { jsonResponse, errorResponse } from '../lib/auth.js';

export async function onRequestGet(context) {
    const usuario = context.data.usuario;

    try {
        // Buscar templates ativos
        // Se usuario eh admin, mostra todos
        // Senao, mostra apenas publicos
        const query = usuario.isAdmin
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

        const result = await context.env.DB.prepare(query).all();
        const templates = result.results || [];

        // Para cada template, contar entidades e menus do config_completo
        const templatesComStats = await Promise.all(templates.map(async (t) => {
            let stats = { entidades: 0, menus: 0, campos: 0 };

            // Tentar ler do config_completo
            const templateCompleto = await context.env.DB.prepare(`
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

        return jsonResponse({
            success: true,
            templates: templatesComStats
        });

    } catch (error) {
        console.error('Erro ao listar templates:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
