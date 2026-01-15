// =====================================================
// BELGO BBP - API de Dados Dinamicos
// /api/projetos/:id/dados/:entidade
// =====================================================

import { jsonResponse, errorResponse } from '../../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../../lib/audit.js';
import { getPermissaoUsuario } from '../../../../lib/permissions.js';

// Niveis de permissao
const NIVEL_PERMISSAO = {
    'visualizador': 1,
    'executor': 2,
    'key_user': 3,
    'gestor': 4,
    'admin': 5
};

// Verificar se usuario tem permissao minima
function temPermissao(nivelUsuario, nivelMinimo) {
    return (NIVEL_PERMISSAO[nivelUsuario] || 0) >= (NIVEL_PERMISSAO[nivelMinimo] || 0);
}

// GET - Listar dados de uma entidade
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeCodigo = context.params.entidade;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeCodigo) {
            return errorResponse('Codigo da entidade nao fornecido', 400);
        }

        // Buscar entidade pelo codigo
        const entidade = await context.env.DB.prepare(`
            SELECT id, codigo, nome, nome_plural
            FROM projeto_entidades
            WHERE projeto_id = ? AND codigo = ?
        `).bind(projetoId, entidadeCodigo).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        // Verificar permissao do usuario
        let nivelUsuario = 'visualizador';
        if (usuario.isAdmin) {
            nivelUsuario = 'admin';
        } else {
            const permissao = await getPermissaoUsuario(context.env.DB, usuario.id, parseInt(projetoId));
            nivelUsuario = permissao || 'visualizador';
        }

        // Buscar dados da entidade
        const url = new URL(context.request.url);
        const page = parseInt(url.searchParams.get('page')) || 1;
        const limit = parseInt(url.searchParams.get('limit')) || 50;
        const offset = (page - 1) * limit;
        const busca = url.searchParams.get('busca') || '';
        const ordenarPor = url.searchParams.get('ordenar') || 'created_at';
        const direcao = url.searchParams.get('direcao') === 'asc' ? 'ASC' : 'DESC';

        // Contar total
        const countResult = await context.env.DB.prepare(`
            SELECT COUNT(*) as total
            FROM projeto_dados
            WHERE projeto_id = ? AND entidade_id = ?
        `).bind(projetoId, entidade.id).first();

        const total = countResult?.total || 0;

        // Buscar dados paginados
        const dados = await context.env.DB.prepare(`
            SELECT
                pd.id,
                pd.dados,
                pd.criado_por,
                pd.atualizado_por,
                pd.created_at,
                pd.updated_at,
                uc.nome as criado_por_nome,
                ua.nome as atualizado_por_nome
            FROM projeto_dados pd
            LEFT JOIN usuarios uc ON pd.criado_por = uc.id
            LEFT JOIN usuarios ua ON pd.atualizado_por = ua.id
            WHERE pd.projeto_id = ? AND pd.entidade_id = ?
            ORDER BY pd.${ordenarPor === 'created_at' || ordenarPor === 'updated_at' ? ordenarPor : 'created_at'} ${direcao}
            LIMIT ? OFFSET ?
        `).bind(projetoId, entidade.id, limit, offset).all();

        // Parse JSON dos dados
        const registros = (dados.results || []).map(r => ({
            id: r.id,
            ...JSON.parse(r.dados || '{}'),
            _meta: {
                criado_por: r.criado_por,
                criado_por_nome: r.criado_por_nome,
                atualizado_por: r.atualizado_por,
                atualizado_por_nome: r.atualizado_por_nome,
                created_at: r.created_at,
                updated_at: r.updated_at
            }
        }));

        return jsonResponse({
            success: true,
            entidade: {
                id: entidade.id,
                codigo: entidade.codigo,
                nome: entidade.nome,
                nome_plural: entidade.nome_plural
            },
            dados: registros,
            paginacao: {
                total,
                pagina: page,
                limite: limit,
                paginas: Math.ceil(total / limit)
            }
        });

    } catch (error) {
        console.error('Erro ao listar dados:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// POST - Criar registro em uma entidade
export async function onRequestPost(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;
        const entidadeCodigo = context.params.entidade;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        if (!entidadeCodigo) {
            return errorResponse('Codigo da entidade nao fornecido', 400);
        }

        // Buscar entidade
        const entidade = await context.env.DB.prepare(`
            SELECT id, codigo, nome, permite_criar
            FROM projeto_entidades
            WHERE projeto_id = ? AND codigo = ?
        `).bind(projetoId, entidadeCodigo).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        if (!entidade.permite_criar) {
            return errorResponse('Esta entidade nao permite criacao de registros', 403);
        }

        // Verificar permissao do usuario
        let nivelUsuario = 'visualizador';
        if (usuario.isAdmin) {
            nivelUsuario = 'admin';
        } else {
            const permissao = await getPermissaoUsuario(context.env.DB, usuario.id, parseInt(projetoId));
            nivelUsuario = permissao || 'visualizador';
        }

        // Buscar permissao minima do menu vinculado
        const menu = await context.env.DB.prepare(`
            SELECT permissao_criar FROM projeto_menus WHERE entidade_id = ? AND ativo = 1 LIMIT 1
        `).bind(entidade.id).first();

        const permissaoMinima = menu?.permissao_criar || 'executor';

        if (!temPermissao(nivelUsuario, permissaoMinima)) {
            return errorResponse('Sem permissao para criar registros nesta entidade', 403);
        }

        const body = await context.request.json();
        const { dados } = body;

        if (!dados || typeof dados !== 'object') {
            return errorResponse('Dados sao obrigatorios', 400);
        }

        // Buscar campos para validacao
        const campos = await context.env.DB.prepare(`
            SELECT codigo, nome, tipo, obrigatorio, unico
            FROM projeto_entidade_campos
            WHERE entidade_id = ?
        `).bind(entidade.id).all();

        // Validar campos obrigatorios
        for (const campo of (campos.results || [])) {
            if (campo.obrigatorio && !dados[campo.codigo]) {
                return errorResponse(`Campo obrigatorio: ${campo.nome}`, 400);
            }

            // Validar unicidade
            if (campo.unico && dados[campo.codigo]) {
                const existente = await context.env.DB.prepare(`
                    SELECT id FROM projeto_dados
                    WHERE projeto_id = ? AND entidade_id = ?
                    AND json_extract(dados, '$.' || ?) = ?
                `).bind(projetoId, entidade.id, campo.codigo, dados[campo.codigo]).first();

                if (existente) {
                    return errorResponse(`Valor duplicado para campo unico: ${campo.nome}`, 409);
                }
            }
        }

        // Inserir registro
        const result = await context.env.DB.prepare(`
            INSERT INTO projeto_dados (
                projeto_id,
                entidade_id,
                dados,
                criado_por
            )
            VALUES (?, ?, ?, ?)
        `).bind(
            projetoId,
            entidade.id,
            JSON.stringify(dados),
            usuario.id
        ).run();

        const registroId = result.meta.last_row_id;

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.CRIAR,
            entidade: `projeto_dados_${entidadeCodigo}`,
            entidadeId: String(registroId),
            detalhes: { projetoId, entidadeId: entidade.id, dados },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Registro criado com sucesso',
            registro: {
                id: registroId,
                ...dados
            }
        }, 201);

    } catch (error) {
        console.error('Erro ao criar registro:', error);
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
