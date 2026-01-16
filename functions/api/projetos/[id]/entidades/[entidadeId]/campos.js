// =====================================================
// BELGO BBP - API de Campos de Entidade
// /api/projetos/:id/entidades/:entidadeId/campos
// =====================================================

import { jsonResponse, errorResponse } from '../../../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../../../lib/audit.js';
import { isProjetoAdmin } from '../../../../../lib/permissions.js';

// GET - Listar campos de uma entidade
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

        // Verificar se entidade pertence ao projeto
        const entidade = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        // Buscar campos (com join para obter codigo da entidade relacionada)
        const campos = await context.env.DB.prepare(`
            SELECT
                c.id,
                c.codigo,
                c.nome,
                c.descricao,
                c.tipo,
                c.subtipo,
                c.obrigatorio,
                c.unico,
                c.valor_padrao,
                c.regex_validacao,
                c.min_valor,
                c.max_valor,
                c.ordem,
                c.visivel_listagem,
                c.visivel_formulario,
                c.visivel_mobile,
                c.largura_coluna,
                c.opcoes_config,
                c.relacao_entidade_id,
                c.relacao_campo_exibir,
                c.created_at,
                re.codigo as relacao_entidade_codigo,
                re.nome as relacao_entidade_nome
            FROM projeto_entidade_campos c
            LEFT JOIN projeto_entidades re ON c.relacao_entidade_id = re.id
            WHERE c.entidade_id = ?
            ORDER BY c.ordem ASC
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
        const camposComOpcoes = (campos.results || []).map(campo => ({
            ...campo,
            opcoes: opcoesPorCampo[campo.codigo] || []
        }));

        return jsonResponse({
            success: true,
            campos: camposComOpcoes
        });

    } catch (error) {
        console.error('Erro ao listar campos:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// POST - Criar campo em uma entidade
export async function onRequestPost(context) {
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
            return errorResponse('Sem permissao para gerenciar campos deste projeto', 403);
        }

        // Verificar se entidade pertence ao projeto
        const entidade = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidades WHERE id = ? AND projeto_id = ?
        `).bind(entidadeId, projetoId).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        const body = await context.request.json();
        const {
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
            opcoes // Array de opcoes para campos select
        } = body;

        // Validacoes
        if (!codigo || !nome || !tipo) {
            return errorResponse('Codigo, nome e tipo sao obrigatorios', 400);
        }

        // Tipos validos
        const tiposValidos = ['text', 'textarea', 'number', 'currency', 'date', 'datetime', 'boolean', 'select', 'multiselect', 'file', 'image', 'relation', 'json'];
        if (!tiposValidos.includes(tipo)) {
            return errorResponse(`Tipo invalido. Tipos validos: ${tiposValidos.join(', ')}`, 400);
        }

        // Verificar se codigo ja existe na entidade
        const existente = await context.env.DB.prepare(`
            SELECT id FROM projeto_entidade_campos WHERE entidade_id = ? AND codigo = ?
        `).bind(entidadeId, codigo).first();

        if (existente) {
            return errorResponse('Ja existe um campo com este codigo nesta entidade', 409);
        }

        // Calcular ordem se nao fornecida
        let ordemFinal = ordem;
        if (ordemFinal === undefined) {
            const maxOrdem = await context.env.DB.prepare(`
                SELECT MAX(ordem) as max_ordem FROM projeto_entidade_campos WHERE entidade_id = ?
            `).bind(entidadeId).first();
            ordemFinal = (maxOrdem?.max_ordem || 0) + 1;
        }

        // Inserir campo
        const result = await context.env.DB.prepare(`
            INSERT INTO projeto_entidade_campos (
                entidade_id,
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
                relacao_campo_exibir
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
            entidadeId,
            codigo,
            nome,
            descricao || null,
            tipo,
            subtipo || null,
            obrigatorio ? 1 : 0,
            unico ? 1 : 0,
            valor_padrao || null,
            regex_validacao || null,
            min_valor || null,
            max_valor || null,
            ordemFinal,
            visivel_listagem !== false ? 1 : 0,
            visivel_formulario !== false ? 1 : 0,
            visivel_mobile !== false ? 1 : 0,
            largura_coluna || null,
            opcoes_config ? JSON.stringify(opcoes_config) : null,
            relacao_entidade_id || null,
            relacao_campo_exibir || null
        ).run();

        const campoId = result.meta.last_row_id;

        // Inserir opcoes se fornecidas (para campos select/multiselect)
        if (opcoes && Array.isArray(opcoes) && opcoes.length > 0) {
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
                    codigo,
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
            acao: ACOES.CRIAR,
            entidade: 'projeto_entidade_campo',
            entidadeId: String(campoId),
            detalhes: { projetoId, entidadeId, codigo, nome, tipo },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Campo criado com sucesso',
            campo: {
                id: campoId,
                codigo,
                nome,
                tipo,
                ordem: ordemFinal
            }
        }, 201);

    } catch (error) {
        console.error('Erro ao criar campo:', error);
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
