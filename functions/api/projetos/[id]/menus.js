// =====================================================
// BELGO BBP - API de Menus por Projeto
// /api/projetos/:id/menus
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';

// GET - Listar menus de um projeto
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;

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

        // Buscar menus do projeto com informacoes da entidade
        const menus = await context.env.DB.prepare(`
            SELECT
                m.id,
                m.nome,
                m.icone,
                m.url,
                m.ordem,
                m.ativo,
                m.permissao_criar,
                m.permissao_editar,
                m.entidade_id,
                e.codigo as entidade_codigo,
                e.nome as entidade_nome,
                e.nome_plural as entidade_nome_plural,
                e.icone as entidade_icone,
                e.config_funcionalidades
            FROM projeto_menus m
            LEFT JOIN projeto_entidades e ON m.entidade_id = e.id
            WHERE m.projeto_id = ?
            ORDER BY m.ordem ASC, m.nome ASC
        `).bind(projetoId).all();

        // Organizar menus em lista
        const menusList = [];

        (menus.results || []).forEach(menu => {
            const item = {
                id: menu.id,
                nome: menu.nome,
                icone: menu.icone || menu.entidade_icone,
                url: menu.url,
                ordem: menu.ordem,
                ativo: menu.ativo === 1,
                entidade_id: menu.entidade_id,
                entidade_codigo: menu.entidade_codigo,
                entidade_nome: menu.entidade_nome,
                entidade_nome_plural: menu.entidade_nome_plural,
                permissoes: {
                    criar: menu.permissao_criar || 'executor',
                    editar: menu.permissao_editar || 'gestor'
                },
                config_funcionalidades: menu.config_funcionalidades
            };

            menusList.push(item);
        });

        return jsonResponse({
            success: true,
            menus: menusList,
            total: menusList.length
        });

    } catch (error) {
        console.error('Erro ao listar menus:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Projeto-Id',
            'Access-Control-Max-Age': '86400'
        }
    });
}
