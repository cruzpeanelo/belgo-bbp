// =====================================================
// BELGO BBP - API de Entidades Dinamicas
// /api/projetos/:id/entidades
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../lib/audit.js';
import { isProjetoAdmin } from '../../../lib/permissions.js';

// GET - Listar entidades de um projeto
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

        // Buscar entidades do projeto
        const entidades = await context.env.DB.prepare(`
            SELECT
                id,
                codigo,
                nome,
                nome_plural,
                descricao,
                icone,
                tipo,
                permite_criar,
                permite_editar,
                permite_excluir,
                permite_importar,
                permite_exportar,
                config_funcionalidades,
                created_at,
                updated_at
            FROM projeto_entidades
            WHERE projeto_id = ?
            ORDER BY nome ASC
        `).bind(projetoId).all();

        return jsonResponse({
            success: true,
            entidades: entidades.results || []
        });

    } catch (error) {
        console.error('Erro ao listar entidades:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// POST - Criar entidade em um projeto
export async function onRequestPost(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        // Verificar permissao (admin global ou admin do projeto)
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeEditar) {
            return errorResponse('Sem permissao para gerenciar entidades deste projeto', 403);
        }

        const body = await context.request.json();
        const {
            codigo,
            nome,
            nome_plural,
            descricao,
            icone,
            tipo,
            permite_criar,
            permite_editar,
            permite_excluir,
            permite_importar,
            permite_exportar
        } = body;

        // Validacoes
        if (!codigo || !nome) {
            return errorResponse('Codigo e nome sao obrigatorios', 400);
        }

        // Verificar se codigo ja existe no projeto
        const existente = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades WHERE projeto_id = ? AND codigo = ?
        `).bind(projetoId, codigo).first();

        if (existente) {
            return errorResponse('Ja existe uma entidade com este codigo neste projeto', 409);
        }

        // Inserir entidade
        const result = await context.env.DB.prepare(`
            INSERT INTO projeto_entidades (
                projeto_id,
                codigo,
                nome,
                nome_plural,
                descricao,
                icone,
                tipo,
                permite_criar,
                permite_editar,
                permite_excluir,
                permite_importar,
                permite_exportar
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
            projetoId,
            codigo,
            nome,
            nome_plural || nome + 's',
            descricao || null,
            icone || '📋',
            tipo || 'tabela',
            permite_criar !== undefined ? (permite_criar ? 1 : 0) : 1,
            permite_editar !== undefined ? (permite_editar ? 1 : 0) : 1,
            permite_excluir !== undefined ? (permite_excluir ? 1 : 0) : 1,
            permite_importar !== undefined ? (permite_importar ? 1 : 0) : 1,
            permite_exportar !== undefined ? (permite_exportar ? 1 : 0) : 1
        ).run();

        const entidadeId = result.meta.last_row_id;

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.CRIAR,
            entidade: 'projeto_entidade',
            entidadeId: String(entidadeId),
            detalhes: { projetoId, codigo, nome },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Entidade criada com sucesso',
            entidade: {
                id: entidadeId,
                codigo,
                nome,
                nome_plural: nome_plural || nome + 's',
                icone: icone || '📋',
                tipo: tipo || 'tabela'
            }
        }, 201);

    } catch (error) {
        console.error('Erro ao criar entidade:', error);
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
