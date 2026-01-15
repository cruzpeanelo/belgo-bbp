// =====================================================
// BELGO BBP - API de Importacao de Dados
// /api/projetos/:id/dados/:entidade/import
// =====================================================

import { jsonResponse, errorResponse } from '../../../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../../../lib/audit.js';
import { getPermissaoUsuario, isProjetoAdmin } from '../../../../../lib/permissions.js';

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

// POST - Importar dados em massa
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
            SELECT id, codigo, nome, permite_criar, permite_importar
            FROM projeto_entidades
            WHERE projeto_id = ? AND codigo = ?
        `).bind(projetoId, entidadeCodigo).first();

        if (!entidade) {
            return errorResponse('Entidade nao encontrada', 404);
        }

        if (!entidade.permite_importar) {
            return errorResponse('Esta entidade nao permite importacao de dados', 403);
        }

        // Verificar permissao do usuario
        let nivelUsuario = 'visualizador';
        if (usuario.isAdmin) {
            nivelUsuario = 'admin';
        } else {
            const permissao = await getPermissaoUsuario(context.env.DB, usuario.id, parseInt(projetoId));
            nivelUsuario = permissao || 'visualizador';
        }

        // Importacao requer pelo menos nivel key_user
        if (!temPermissao(nivelUsuario, 'key_user')) {
            return errorResponse('Sem permissao para importar dados nesta entidade', 403);
        }

        const body = await context.request.json();
        const { registros, modo } = body;

        if (!registros || !Array.isArray(registros)) {
            return errorResponse('Array de registros e obrigatorio', 400);
        }

        if (registros.length === 0) {
            return errorResponse('Nenhum registro para importar', 400);
        }

        if (registros.length > 1000) {
            return errorResponse('Maximo de 1000 registros por importacao', 400);
        }

        // Buscar campos para validacao
        const campos = await context.env.DB.prepare(`
            SELECT codigo, nome, tipo, obrigatorio, unico
            FROM projeto_entidade_campos
            WHERE entidade_id = ?
        `).bind(entidade.id).all();

        const camposConfig = campos.results || [];
        const camposObrigatorios = camposConfig.filter(c => c.obrigatorio);
        const camposUnicos = camposConfig.filter(c => c.unico);

        // Modo de importacao: 'inserir' (padrao), 'atualizar', 'upsert'
        const modoImportacao = modo || 'inserir';

        let inseridos = 0;
        let atualizados = 0;
        let erros = [];

        for (let i = 0; i < registros.length; i++) {
            const registro = registros[i];
            const linha = i + 1;

            try {
                // Validar campos obrigatorios
                for (const campo of camposObrigatorios) {
                    if (!registro[campo.codigo] && registro[campo.codigo] !== 0 && registro[campo.codigo] !== false) {
                        erros.push({ linha, erro: `Campo obrigatorio: ${campo.nome}` });
                        continue;
                    }
                }

                // Se houve erro de validacao, pular este registro
                if (erros.some(e => e.linha === linha)) {
                    continue;
                }

                // Para modo upsert ou atualizar, verificar se existe registro com campo unico
                let registroExistenteId = null;
                if (modoImportacao === 'upsert' || modoImportacao === 'atualizar') {
                    for (const campo of camposUnicos) {
                        if (registro[campo.codigo]) {
                            const existente = await context.env.DB.prepare(`
                                SELECT id FROM projeto_dados
                                WHERE projeto_id = ? AND entidade_id = ?
                                AND json_extract(dados, '$.' || ?) = ?
                            `).bind(projetoId, entidade.id, campo.codigo, String(registro[campo.codigo])).first();

                            if (existente) {
                                registroExistenteId = existente.id;
                                break;
                            }
                        }
                    }
                }

                if (registroExistenteId && modoImportacao !== 'inserir') {
                    // Atualizar registro existente
                    const registroAtual = await context.env.DB.prepare(`
                        SELECT dados FROM projeto_dados WHERE id = ?
                    `).bind(registroExistenteId).first();

                    const dadosExistentes = JSON.parse(registroAtual?.dados || '{}');
                    const dadosAtualizados = { ...dadosExistentes, ...registro };

                    await context.env.DB.prepare(`
                        UPDATE projeto_dados
                        SET dados = ?,
                            atualizado_por = ?,
                            updated_at = CURRENT_TIMESTAMP
                        WHERE id = ?
                    `).bind(
                        JSON.stringify(dadosAtualizados),
                        usuario.id,
                        registroExistenteId
                    ).run();

                    atualizados++;
                } else if (modoImportacao !== 'atualizar') {
                    // Verificar duplicidade em campos unicos antes de inserir
                    let duplicado = false;
                    for (const campo of camposUnicos) {
                        if (registro[campo.codigo]) {
                            const existente = await context.env.DB.prepare(`
                                SELECT id FROM projeto_dados
                                WHERE projeto_id = ? AND entidade_id = ?
                                AND json_extract(dados, '$.' || ?) = ?
                            `).bind(projetoId, entidade.id, campo.codigo, String(registro[campo.codigo])).first();

                            if (existente) {
                                erros.push({ linha, erro: `Valor duplicado para ${campo.nome}: ${registro[campo.codigo]}` });
                                duplicado = true;
                                break;
                            }
                        }
                    }

                    if (!duplicado) {
                        // Inserir novo registro
                        await context.env.DB.prepare(`
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
                            JSON.stringify(registro),
                            usuario.id
                        ).run();

                        inseridos++;
                    }
                } else {
                    // Modo atualizar, mas registro nao encontrado
                    erros.push({ linha, erro: 'Registro nao encontrado para atualizacao' });
                }

            } catch (error) {
                erros.push({ linha, erro: error.message });
            }
        }

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.IMPORTAR || 'importar',
            entidade: `projeto_dados_${entidadeCodigo}`,
            entidadeId: String(entidade.id),
            detalhes: {
                projetoId,
                modo: modoImportacao,
                total: registros.length,
                inseridos,
                atualizados,
                erros: erros.length
            },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: `Importacao concluida`,
            resultado: {
                total: registros.length,
                inseridos,
                atualizados,
                erros: erros.length,
                detalhes_erros: erros.slice(0, 50) // Limitar detalhes de erros
            }
        });

    } catch (error) {
        console.error('Erro ao importar dados:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Projeto-Id',
            'Access-Control-Max-Age': '86400'
        }
    });
}
