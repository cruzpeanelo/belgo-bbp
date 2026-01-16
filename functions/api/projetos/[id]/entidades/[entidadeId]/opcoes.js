// =====================================================
// API: Gerenciar Opções de Campos Select
// POST /api/projetos/:id/entidades/:entidadeId/opcoes
// GET /api/projetos/:id/entidades/:entidadeId/opcoes
// =====================================================

import { jsonResponse, errorResponse } from '../../../../../lib/auth.js';

// POST - Criar nova opção
export async function onRequestPost(context) {
    const { id: projetoId, entidadeId } = context.params;
    const usuario = context.data.usuario;

    try {
        const body = await context.request.json();
        const { campo_codigo, valor, label, cor, icone } = body;

        // Validações
        if (!campo_codigo || !valor || !label) {
            return errorResponse('campo_codigo, valor e label são obrigatórios', 400);
        }

        // Verificar se a entidade pertence ao projeto
        const entidade = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades
            WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade não encontrada neste projeto', 404);
        }

        // Verificar se campo existe
        const campo = await context.env.DB.prepare(`
            SELECT id, tipo FROM projeto_entidade_campos
            WHERE entidade_id = ? AND codigo = ?
        `).bind(entidadeId, campo_codigo).first();

        if (!campo) {
            return errorResponse('Campo não encontrado', 404);
        }

        // Verificar se opção já existe
        const existente = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidade_opcoes
            WHERE entidade_id = ? AND campo_codigo = ? AND valor = ?
        `).bind(entidadeId, campo_codigo, valor).first();

        if (existente) {
            return errorResponse('Já existe uma opção com este valor', 400);
        }

        // Obter próxima ordem
        const maxOrdem = await context.env.DB.prepare(`
            SELECT MAX(ordem) as max FROM projeto_entidade_opcoes
            WHERE entidade_id = ? AND campo_codigo = ?
        `).bind(entidadeId, campo_codigo).first();

        const ordem = (maxOrdem?.max || 0) + 1;

        // Inserir opção
        const result = await context.env.DB.prepare(`
            INSERT INTO projeto_entidade_opcoes (entidade_id, campo_codigo, valor, label, cor, icone, ordem, ativo)
            VALUES (?, ?, ?, ?, ?, ?, ?, 1)
        `).bind(
            entidadeId,
            campo_codigo,
            valor,
            label,
            cor || null,
            icone || null,
            ordem
        ).run();

        return jsonResponse({
            success: true,
            message: 'Opção criada com sucesso',
            opcao: {
                id: result.meta.last_row_id,
                campo_codigo,
                valor,
                label,
                cor,
                icone,
                ordem
            }
        });

    } catch (error) {
        console.error('Erro ao criar opção:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// GET - Listar opções de um campo ou todos
export async function onRequestGet(context) {
    const { id: projetoId, entidadeId } = context.params;

    try {
        const url = new URL(context.request.url);
        const campo_codigo = url.searchParams.get('campo');

        // Verificar se a entidade pertence ao projeto
        const entidade = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades
            WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade não encontrada neste projeto', 404);
        }

        let query = `
            SELECT id, campo_codigo, valor, label, cor, icone, ordem, ativo
            FROM projeto_entidade_opcoes
            WHERE entidade_id = ? AND ativo = 1
        `;
        const binds = [entidadeId];

        if (campo_codigo) {
            query += ' AND campo_codigo = ?';
            binds.push(campo_codigo);
        }

        query += ' ORDER BY campo_codigo, ordem ASC';

        const result = await context.env.DB.prepare(query).bind(...binds).all();

        return jsonResponse({
            success: true,
            opcoes: result.results || []
        });

    } catch (error) {
        console.error('Erro ao listar opções:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// DELETE - Remover opção
export async function onRequestDelete(context) {
    const { id: projetoId, entidadeId } = context.params;
    const usuario = context.data.usuario;

    try {
        const url = new URL(context.request.url);
        const opcaoId = url.searchParams.get('id');

        if (!opcaoId) {
            return errorResponse('ID da opção é obrigatório', 400);
        }

        // Verificar se opção existe e pertence à entidade
        const opcao = await context.env.DB.prepare(`
            SELECT o.id
            FROM projeto_entidade_opcoes o
            JOIN projeto_entidades e ON e.id = o.entidade_id
            WHERE o.id = ? AND o.entidade_id = ? AND e.projeto_id = ?
        `).bind(opcaoId, entidadeId, projetoId).first();

        if (!opcao) {
            return errorResponse('Opção não encontrada', 404);
        }

        // Desativar opção (soft delete)
        await context.env.DB.prepare(`
            UPDATE projeto_entidade_opcoes SET ativo = 0 WHERE id = ?
        `).bind(opcaoId).run();

        return jsonResponse({
            success: true,
            message: 'Opção removida com sucesso'
        });

    } catch (error) {
        console.error('Erro ao remover opção:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
