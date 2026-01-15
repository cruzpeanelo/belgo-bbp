// =====================================================
// BELGO BBP - API de Campo Individual
// /api/projetos/:id/entidades/:entidadeId/campos/:campoId
// =====================================================

import { jsonResponse, errorResponse } from '../../../../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../../../../lib/audit.js';
import { isProjetoAdmin } from '../../../../../../lib/permissions.js';

// GET - Obter detalhes de um campo
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeId = context.params.entidadeId;
        const campoId = context.params.campoId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeId || isNaN(entidadeId)) {
            return errorResponse('ID da entidade nao fornecido', 400);
        }

        if (!campoId || isNaN(campoId)) {
            return errorResponse('ID do campo nao fornecido', 400);
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

        // Verificar se entidade pertence ao projeto
        const entidade = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        // Buscar campo
        const campo = await context.env.DB.prepare(`
            SELECT
                id,
                codigo,
                nome,
                descricao,
                tipo,
                subtipo,
                obrigatorio,
                unico,
                valor_padrao,
                regex_validacao,
                min_valor,
                max_valor,
                ordem,
                visivel_listagem,
                visivel_formulario,
                visivel_mobile,
                largura_coluna,
                opcoes_config,
                relacao_entidade_id,
                relacao_campo_exibir,
                created_at
            FROM projeto_entidade_campos
            WHERE id = ? AND entidade_id = ?
        `).bind(campoId, entidadeId).first();

        if (!campo) {
            return errorResponse('Campo nao encontrado', 404);
        }

        // Buscar opcoes se for select/multiselect
        let opcoes = [];
        if (campo.tipo === 'select' || campo.tipo === 'multiselect') {
            const opcoesResult = await context.env.DB.prepare(`
                SELECT id, valor, label, cor, icone, ordem, ativo
                FROM projeto_entidade_opcoes
                WHERE entidade_id = ? AND campo_codigo = ?
                ORDER BY ordem ASC
            `).bind(entidadeId, campo.codigo).all();
            opcoes = opcoesResult.results || [];
        }

        return jsonResponse({
            success: true,
            campo: {
                ...campo,
                opcoes
            }
        });

    } catch (error) {
        console.error('Erro ao obter campo:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// PUT - Atualizar campo
export async function onRequestPut(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeId = context.params.entidadeId;
        const campoId = context.params.campoId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeId || isNaN(entidadeId)) {
            return errorResponse('ID da entidade nao fornecido', 400);
        }

        if (!campoId || isNaN(campoId)) {
            return errorResponse('ID do campo nao fornecido', 400);
        }

        // Verificar permissao
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeEditar) {
            return errorResponse('Sem permissao para gerenciar campos deste projeto', 403);
        }

        // Verificar se entidade pertence ao projeto
        const entidade = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        // Verificar se campo existe
        const campoExistente = await context.env.DB.prepare(`
            SELECT id, codigo FROM projeto_entidade_campos WHERE id = ? AND entidade_id = ?
        `).bind(campoId, entidadeId).first();

        if (!campoExistente) {
            return errorResponse('Campo nao encontrado', 404);
        }

        const body = await context.request.json();
        const {
            nome,
            descricao,
            subtipo,
            obrigatorio,
            unico,
            valor_padrao,
            regex_validacao,
            min_valor,
            max_valor,
            ordem,
            visivel_listagem,
            visivel_formulario,
            visivel_mobile,
            largura_coluna,
            opcoes_config,
            relacao_entidade_id,
            relacao_campo_exibir,
            opcoes // Array de opcoes para atualizar
        } = body;

        // Atualizar campo
        await context.env.DB.prepare(`
            UPDATE projeto_entidade_campos
            SET nome = COALESCE(?, nome),
                descricao = COALESCE(?, descricao),
                subtipo = COALESCE(?, subtipo),
                obrigatorio = COALESCE(?, obrigatorio),
                unico = COALESCE(?, unico),
                valor_padrao = COALESCE(?, valor_padrao),
                regex_validacao = COALESCE(?, regex_validacao),
                min_valor = COALESCE(?, min_valor),
                max_valor = COALESCE(?, max_valor),
                ordem = COALESCE(?, ordem),
                visivel_listagem = COALESCE(?, visivel_listagem),
                visivel_formulario = COALESCE(?, visivel_formulario),
                visivel_mobile = COALESCE(?, visivel_mobile),
                largura_coluna = COALESCE(?, largura_coluna),
                opcoes_config = COALESCE(?, opcoes_config),
                relacao_entidade_id = COALESCE(?, relacao_entidade_id),
                relacao_campo_exibir = COALESCE(?, relacao_campo_exibir)
            WHERE id = ? AND entidade_id = ?
        `).bind(
            nome || null,
            descricao !== undefined ? descricao : null,
            subtipo !== undefined ? subtipo : null,
            obrigatorio !== undefined ? (obrigatorio ? 1 : 0) : null,
            unico !== undefined ? (unico ? 1 : 0) : null,
            valor_padrao !== undefined ? valor_padrao : null,
            regex_validacao !== undefined ? regex_validacao : null,
            min_valor !== undefined ? min_valor : null,
            max_valor !== undefined ? max_valor : null,
            ordem !== undefined ? ordem : null,
            visivel_listagem !== undefined ? (visivel_listagem ? 1 : 0) : null,
            visivel_formulario !== undefined ? (visivel_formulario ? 1 : 0) : null,
            visivel_mobile !== undefined ? (visivel_mobile ? 1 : 0) : null,
            largura_coluna !== undefined ? largura_coluna : null,
            opcoes_config ? JSON.stringify(opcoes_config) : null,
            relacao_entidade_id !== undefined ? relacao_entidade_id : null,
            relacao_campo_exibir !== undefined ? relacao_campo_exibir : null,
            campoId,
            entidadeId
        ).run();

        // Atualizar opcoes se fornecidas
        if (opcoes && Array.isArray(opcoes)) {
            // Remover opcoes antigas
            await context.env.DB.prepare(`
                DELETE FROM projeto_entidade_opcoes
                WHERE entidade_id = ? AND campo_codigo = ?
            `).bind(entidadeId, campoExistente.codigo).run();

            // Inserir novas opcoes
            for (let i = 0; i < opcoes.length; i++) {
                const opcao = opcoes[i];
                await context.env.DB.prepare(`
                    INSERT INTO projeto_entidade_opcoes (
                        entidade_id,
                        campo_codigo,
                        valor,
                        label,
                        cor,
                        icone,
                        ordem
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                `).bind(
                    entidadeId,
                    campoExistente.codigo,
                    opcao.valor,
                    opcao.label,
                    opcao.cor || null,
                    opcao.icone || null,
                    opcao.ordem !== undefined ? opcao.ordem : i
                ).run();
            }
        }

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EDITAR,
            entidade: 'projeto_entidade_campo',
            entidadeId: campoId,
            detalhes: { projetoId, entidadeId, alteracoes: body },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Campo atualizado com sucesso'
        });

    } catch (error) {
        console.error('Erro ao atualizar campo:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Remover campo
export async function onRequestDelete(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeId = context.params.entidadeId;
        const campoId = context.params.campoId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeId || isNaN(entidadeId)) {
            return errorResponse('ID da entidade nao fornecido', 400);
        }

        if (!campoId || isNaN(campoId)) {
            return errorResponse('ID do campo nao fornecido', 400);
        }

        // Verificar permissao
        const podeExcluir = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeExcluir) {
            return errorResponse('Sem permissao para gerenciar campos deste projeto', 403);
        }

        // Verificar se entidade pertence ao projeto
        const entidade = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        // Verificar se campo existe
        const campo = await context.env.DB.prepare(`
            SELECT id, codigo, nome FROM projeto_entidade_campos WHERE id = ? AND entidade_id = ?
        `).bind(campoId, entidadeId).first();

        if (!campo) {
            return errorResponse('Campo nao encontrado', 404);
        }

        // Remover opcoes do campo
        await context.env.DB.prepare(`
            DELETE FROM projeto_entidade_opcoes
            WHERE entidade_id = ? AND campo_codigo = ?
        `).bind(entidadeId, campo.codigo).run();

        // Remover campo
        await context.env.DB.prepare(`
            DELETE FROM projeto_entidade_campos WHERE id = ? AND entidade_id = ?
        `).bind(campoId, entidadeId).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EXCLUIR,
            entidade: 'projeto_entidade_campo',
            entidadeId: campoId,
            detalhes: { projetoId, entidadeId, codigo: campo.codigo, nome: campo.nome },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Campo removido com sucesso'
        });

    } catch (error) {
        console.error('Erro ao remover campo:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Projeto-Id',
            'Access-Control-Max-Age': '86400'
        }
    });
}
