// =====================================================
// API: Gerenciar Acoes de uma Entidade
// GET/POST /api/projetos/:id/entidades/:entidadeId/acoes
// =====================================================

import { verificarAuth } from '../../../../../lib/auth.js';
import { verificarPermissao } from '../../../../../lib/permissions.js';

// GET - Listar acoes da entidade
export async function onRequestGet(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);
    const entidadeId = parseInt(params.entidadeId);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Buscar acoes da entidade
        const result = await env.DB.prepare(`
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

        return new Response(JSON.stringify({
            success: true,
            acoes
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao listar acoes:', error);
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

// POST - Criar nova acao
export async function onRequestPost(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);
    const entidadeId = parseInt(params.entidadeId);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Verificar permissao (apenas admin pode criar acoes)
        const temPermissao = await verificarPermissao(env.DB, usuario.id, projetoId, 'admin');
        if (!temPermissao && !usuario.admin) {
            return new Response(JSON.stringify({ success: false, error: 'Sem permissao' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const body = await request.json();
        const { codigo, nome, icone, tipo, config, posicao, condicao, permissao_minima, ordem } = body;

        if (!codigo || !nome || !tipo) {
            return new Response(JSON.stringify({ success: false, error: 'codigo, nome e tipo sao obrigatorios' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Inserir acao
        const result = await env.DB.prepare(`
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

        return new Response(JSON.stringify({
            success: true,
            message: 'Acao criada com sucesso',
            acao: {
                id: result.meta.last_row_id,
                codigo,
                nome
            }
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao criar acao:', error);
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

// PUT - Atualizar acao
export async function onRequestPut(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);
    const entidadeId = parseInt(params.entidadeId);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const temPermissao = await verificarPermissao(env.DB, usuario.id, projetoId, 'admin');
        if (!temPermissao && !usuario.admin) {
            return new Response(JSON.stringify({ success: false, error: 'Sem permissao' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const body = await request.json();
        const { id, codigo, nome, icone, tipo, config, posicao, condicao, permissao_minima, ordem, ativo } = body;

        if (!id) {
            return new Response(JSON.stringify({ success: false, error: 'id eh obrigatorio' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        await env.DB.prepare(`
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

        return new Response(JSON.stringify({
            success: true,
            message: 'Acao atualizada'
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao atualizar acao:', error);
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

// DELETE - Excluir acao (soft delete)
export async function onRequestDelete(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);
    const entidadeId = parseInt(params.entidadeId);

    try {
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const temPermissao = await verificarPermissao(env.DB, usuario.id, projetoId, 'admin');
        if (!temPermissao && !usuario.admin) {
            return new Response(JSON.stringify({ success: false, error: 'Sem permissao' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const url = new URL(request.url);
        const acaoId = url.searchParams.get('acaoId');

        if (!acaoId) {
            return new Response(JSON.stringify({ success: false, error: 'acaoId eh obrigatorio' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        await env.DB.prepare(`
            UPDATE projeto_entidade_acoes SET ativo = 0
            WHERE id = ? AND entidade_id = ?
        `).bind(acaoId, entidadeId).run();

        return new Response(JSON.stringify({
            success: true,
            message: 'Acao excluida'
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao excluir acao:', error);
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
