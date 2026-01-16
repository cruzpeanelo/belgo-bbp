// =====================================================
// BELGO BBP - API de Entidade Individual
// /api/projetos/:id/entidades/:entidadeId
// =====================================================

import { jsonResponse, errorResponse } from '../../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../../lib/audit.js';
import { isProjetoAdmin } from '../../../../lib/permissions.js';

// GET - Obter detalhes de uma entidade com seus campos
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeId = context.params.entidadeId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeId || isNaN(entidadeId)) {
            return errorResponse('ID da entidade nao fornecido', 400);
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

        // Buscar entidade
        const entidade = await context.env.DB.prepare(`
            SELECT
                id,
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
                permite_exportar,
                created_at,
                updated_at
            FROM projeto_entidades
            WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        // Buscar campos da entidade
        const campos = await context.env.DB.prepare(`
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
            WHERE entidade_id = ?
            ORDER BY ordem ASC
        `).bind(entidadeId).all();

        // Buscar opcoes para campos select
        const opcoes = await context.env.DB.prepare(`
            SELECT
                id,
                campo_codigo,
                valor,
                label,
                cor,
                icone,
                ordem,
                ativo
            FROM projeto_entidade_opcoes
            WHERE entidade_id = ? AND ativo = 1
            ORDER BY campo_codigo, ordem ASC
        `).bind(entidadeId).all();

        // Organizar opcoes por campo
        const opcoesPorCampo = {};
        for (const opcao of (opcoes.results || [])) {
            if (!opcoesPorCampo[opcao.campo_codigo]) {
                opcoesPorCampo[opcao.campo_codigo] = [];
            }
            opcoesPorCampo[opcao.campo_codigo].push(opcao);
        }

        // Anexar opcoes aos campos
        const camposComOpcoes = (campos.results || []).map(campo => {
            if (campo.tipo === 'select' || campo.tipo === 'multiselect') {
                return {
                    ...campo,
                    opcoes: opcoesPorCampo[campo.codigo] || []
                };
            }
            return campo;
        });

        return jsonResponse({
            success: true,
            entidade: {
                ...entidade,
                campos: camposComOpcoes
            }
        });

    } catch (error) {
        console.error('Erro ao obter entidade:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// PUT - Atualizar entidade
export async function onRequestPut(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeId = context.params.entidadeId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeId || isNaN(entidadeId)) {
            return errorResponse('ID da entidade nao fornecido', 400);
        }

        // Verificar permissao
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeEditar) {
            return errorResponse('Sem permissao para gerenciar entidades deste projeto', 403);
        }

        // Verificar se entidade existe e pertence ao projeto
        const entidadeExistente = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidadeExistente) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        const body = await context.request.json();
        const {
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
            config_funcionalidades
        } = body;

        // Serializar config_funcionalidades se for objeto
        let configStr = null;
        if (config_funcionalidades !== undefined) {
            configStr = typeof config_funcionalidades === 'string'
                ? config_funcionalidades
                : JSON.stringify(config_funcionalidades);
        }

        // Atualizar entidade
        await context.env.DB.prepare(`
            UPDATE projeto_entidades
            SET nome = COALESCE(?, nome),
                nome_plural = COALESCE(?, nome_plural),
                descricao = COALESCE(?, descricao),
                icone = COALESCE(?, icone),
                tipo = COALESCE(?, tipo),
                permite_criar = COALESCE(?, permite_criar),
                permite_editar = COALESCE(?, permite_editar),
                permite_excluir = COALESCE(?, permite_excluir),
                permite_importar = COALESCE(?, permite_importar),
                permite_exportar = COALESCE(?, permite_exportar),
                config_funcionalidades = COALESCE(?, config_funcionalidades),
                updated_at = CURRENT_TIMESTAMP
            WHERE id = ? AND projeto_id = ?
        `).bind(
            nome || null,
            nome_plural || null,
            descricao !== undefined ? descricao : null,
            icone || null,
            tipo || null,
            permite_criar !== undefined ? (permite_criar ? 1 : 0) : null,
            permite_editar !== undefined ? (permite_editar ? 1 : 0) : null,
            permite_excluir !== undefined ? (permite_excluir ? 1 : 0) : null,
            permite_importar !== undefined ? (permite_importar ? 1 : 0) : null,
            permite_exportar !== undefined ? (permite_exportar ? 1 : 0) : null,
            configStr,
            entidadeId,
            projetoId
        ).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EDITAR,
            entidade: 'projeto_entidade',
            entidadeId: entidadeId,
            detalhes: { projetoId, alteracoes: body },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Entidade atualizada com sucesso'
        });

    } catch (error) {
        console.error('Erro ao atualizar entidade:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Remover entidade
export async function onRequestDelete(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeId = context.params.entidadeId;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeId || isNaN(entidadeId)) {
            return errorResponse('ID da entidade nao fornecido', 400);
        }

        // Verificar permissao
        const podeExcluir = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(projetoId));
        if (!podeExcluir) {
            return errorResponse('Sem permissao para gerenciar entidades deste projeto', 403);
        }

        // Verificar se entidade existe
        const entidade = await context.env.DB.prepare(`
            SELECT id, nome, codigo FROM projeto_entidades WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        // Verificar se ha menus vinculados
        const menusVinculados = await context.env.DB.prepare(`
            SELECT COUNT(*) as total FROM projeto_menus WHERE entidade_id = ?
        `).bind(entidadeId).first();

        if (menusVinculados && menusVinculados.total > 0) {
            return errorResponse(`Nao e possivel excluir: existem ${menusVinculados.total} menu(s) vinculado(s) a esta entidade`, 409);
        }

        // Verificar se ha dados cadastrados
        const dadosExistentes = await context.env.DB.prepare(`
            SELECT COUNT(*) as total FROM projeto_dados WHERE entidade_id = ?
        `).bind(entidadeId).first();

        if (dadosExistentes && dadosExistentes.total > 0) {
            return errorResponse(`Nao e possivel excluir: existem ${dadosExistentes.total} registro(s) cadastrado(s) nesta entidade`, 409);
        }

        // Remover opcoes, campos e entidade (cascata esta configurada no banco)
        await context.env.DB.prepare(`
            DELETE FROM projeto_entidades WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EXCLUIR,
            entidade: 'projeto_entidade',
            entidadeId: entidadeId,
            detalhes: { projetoId, codigo: entidade.codigo, nome: entidade.nome },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Entidade removida com sucesso'
        });

    } catch (error) {
        console.error('Erro ao remover entidade:', error);
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
