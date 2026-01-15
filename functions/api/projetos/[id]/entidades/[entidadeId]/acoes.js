// =====================================================
// API: Gerenciar Acoes de uma Entidade
// GET/POST /api/projetos/:id/entidades/:entidadeId/acoes
// =====================================================

import { jsonResponse, errorResponse } from '../../../../../lib/auth.js';
import { isProjetoAdmin } from '../../../../../lib/permissions.js';

// GET - Listar acoes da entidade
export async function onRequestGet(context) {
    const entidadeId = parseInt(context.params.entidadeId);
    const usuario = context.data.usuario;

    try {
        // Buscar acoes da entidade
        const result = await context.env.DB.prepare(`
            SELECT id, codigo, nome, icone, tipo, config, posicao, condicao,
                   permissao_minima, ordem, ativo
            FROM projeto_entidade_acoes
            WHERE entidade_id = ? AND ativo = 1
            ORDER BY ordem, nome
        `).bind(entidadeId).all();

        const acoes = (result.results || []).map(a => ({
            ...a,
            config: a.config ? JSON.parse(a.config) : null,
            condicao: a.condicao ? JSON.parse(a.condicao) : null
        }));

        return jsonResponse({
            success: true,
            acoes
        });

    } catch (error) {
        console.error('Erro ao listar acoes:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// POST - Criar nova acao
export async function onRequestPost(context) {
    const projetoId = parseInt(context.params.id);
    const entidadeId = parseInt(context.params.entidadeId);
    const usuario = context.data.usuario;

    try {
        // Verificar permissao (apenas admin pode criar acoes)
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, projetoId);
        if (!podeEditar) {
            return errorResponse('Sem permissao', 403);
        }

        const body = await context.request.json();
        const { codigo, nome, icone, tipo, config, posicao, condicao, permissao_minima, ordem } = body;

        if (!codigo || !nome || !tipo) {
            return errorResponse('codigo, nome e tipo sao obrigatorios', 400);
        }

        // Inserir acao
        const result = await context.env.DB.prepare(`
            INSERT INTO projeto_entidade_acoes (
                entidade_id, codigo, nome, icone, tipo, config, posicao,
                condicao, permissao_minima, ordem
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
            entidadeId,
            codigo,
            nome,
            icone || null,
            tipo,
            config ? JSON.stringify(config) : null,
            posicao || 'linha',
            condicao ? JSON.stringify(condicao) : null,
            permissao_minima || null,
            ordem || 0
        ).run();

        return jsonResponse({
            success: true,
            message: 'Acao criada com sucesso',
            acao: {
                id: result.meta.last_row_id,
                codigo,
                nome
            }
        });

    } catch (error) {
        console.error('Erro ao criar acao:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// PUT - Atualizar acao
export async function onRequestPut(context) {
    const projetoId = parseInt(context.params.id);
    const entidadeId = parseInt(context.params.entidadeId);
    const usuario = context.data.usuario;

    try {
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, projetoId);
        if (!podeEditar) {
            return errorResponse('Sem permissao', 403);
        }

        const body = await context.request.json();
        const { id, codigo, nome, icone, tipo, config, posicao, condicao, permissao_minima, ordem, ativo } = body;

        if (!id) {
            return errorResponse('id eh obrigatorio', 400);
        }

        await context.env.DB.prepare(`
            UPDATE projeto_entidade_acoes SET
                codigo = COALESCE(?, codigo),
                nome = COALESCE(?, nome),
                icone = ?,
                tipo = COALESCE(?, tipo),
                config = ?,
                posicao = COALESCE(?, posicao),
                condicao = ?,
                permissao_minima = ?,
                ordem = COALESCE(?, ordem),
                ativo = COALESCE(?, ativo)
            WHERE id = ? AND entidade_id = ?
        `).bind(
            codigo || null,
            nome || null,
            icone,
            tipo || null,
            config ? JSON.stringify(config) : null,
            posicao || null,
            condicao ? JSON.stringify(condicao) : null,
            permissao_minima,
            ordem,
            ativo,
            id,
            entidadeId
        ).run();

        return jsonResponse({
            success: true,
            message: 'Acao atualizada'
        });

    } catch (error) {
        console.error('Erro ao atualizar acao:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// DELETE - Excluir acao (soft delete)
export async function onRequestDelete(context) {
    const projetoId = parseInt(context.params.id);
    const entidadeId = parseInt(context.params.entidadeId);
    const usuario = context.data.usuario;

    try {
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, projetoId);
        if (!podeEditar) {
            return errorResponse('Sem permissao', 403);
        }

        const url = new URL(context.request.url);
        const acaoId = url.searchParams.get('acaoId');

        if (!acaoId) {
            return errorResponse('acaoId eh obrigatorio', 400);
        }

        await context.env.DB.prepare(`
            UPDATE projeto_entidade_acoes SET ativo = 0
            WHERE id = ? AND entidade_id = ?
        `).bind(acaoId, entidadeId).run();

        return jsonResponse({
            success: true,
            message: 'Acao excluida'
        });

    } catch (error) {
        console.error('Erro ao excluir acao:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
