// =====================================================
// BELGO BBP - API de Projetos
// /api/projetos
// =====================================================

import { jsonResponse, errorResponse } from '../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../lib/audit.js';
import { buscarProjetosUsuario, isProjetoAdmin, buscarPermissoesUsuario } from '../lib/permissions.js';
import { isCorValida, COR_PADRAO } from '../lib/colors.js';
import { isSharePointValido, isDriveIdValido, isFolderIdValido } from '../lib/sharepoint.js';

// GET - Listar projetos do usuario ou detalhes de um projeto
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const url = new URL(context.request.url);
        const pathParts = url.pathname.split('/').filter(p => p);

        // /api/projetos/:id - Detalhes de um projeto
        if (pathParts.length >= 3 && pathParts[2] !== 'projetos') {
            const id = pathParts[2];
            return await getProjetoById(context, id);
        }

        // /api/projetos - Listar projetos do usuario
        const projetos = await buscarProjetosUsuario(
            context.env.DB,
            usuario.id,
            usuario.isAdmin
        );

        return jsonResponse({
            success: true,
            projetos,
            total: projetos.length
        });

    } catch (error) {
        console.error('Erro ao listar projetos:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// Buscar projeto por ID
async function getProjetoById(context, id) {
    const usuario = context.data.usuario;

    const projeto = await context.env.DB.prepare(`
        SELECT p.*,
               u.nome as criador_nome, u.email as criador_email,
               (SELECT COUNT(*) FROM usuario_projeto_papel WHERE projeto_id = p.id AND ativo = 1) as total_membros
        FROM projetos p
        LEFT JOIN usuarios u ON p.criado_por = u.id
        WHERE p.id = ?
    `).bind(id).first();

    if (!projeto) {
        return errorResponse('Projeto nao encontrado', 404);
    }

    // Verificar acesso (admin global ou membro do projeto)
    if (!usuario.isAdmin) {
        const temAcesso = await context.env.DB.prepare(`
            SELECT 1 FROM usuario_projeto_papel
            WHERE usuario_id = ? AND projeto_id = ? AND ativo = 1
        `).bind(usuario.id, id).first();

        if (!temAcesso) {
            return errorResponse('Sem acesso a este projeto', 403);
        }
    }

    // Buscar modulos do projeto
    const modulos = await context.env.DB.prepare(`
        SELECT m.id, m.codigo, m.nome, m.icone, m.cor, pm.ordem, pm.ativo
        FROM projeto_modulos pm
        JOIN modulos m ON pm.modulo_id = m.id
        WHERE pm.projeto_id = ?
        ORDER BY pm.ordem
    `).bind(id).all();

    // Buscar permissoes do usuario neste projeto
    const permissoes = await buscarPermissoesUsuario(context.env.DB, usuario.id, parseInt(id));

    return jsonResponse({
        success: true,
        projeto: {
            ...projeto,
            modulos: modulos.results || [],
            minhasPermissoes: permissoes
        }
    });
}

// POST - Criar novo projeto
export async function onRequestPost(context) {
    try {
        const usuario = context.data.usuario;

        // Apenas admins globais podem criar projetos
        if (!usuario.isAdmin) {
            return errorResponse('Apenas administradores podem criar projetos', 403);
        }

        const body = await context.request.json();
        const {
            codigo, nome, descricao, icone, cor, visibilidade, modulos,
            teamsChannelUrl, teamsWebhookUrl,
            sharepointFolderUrl, sharepointDriveId, sharepointFolderId
        } = body;

        // Validacoes
        if (!codigo || !nome) {
            return errorResponse('Codigo e nome sao obrigatorios', 400);
        }

        // Validar cor contra paleta Belgo
        if (cor && !isCorValida(cor)) {
            return errorResponse('Cor invalida. Use apenas cores da paleta Belgo', 400);
        }

        // Validar URLs do SharePoint
        if (sharepointFolderUrl && !isSharePointValido(sharepointFolderUrl)) {
            return errorResponse('URL do SharePoint invalida', 400);
        }

        const codigoLower = codigo.toLowerCase().trim().replace(/[^a-z0-9-]/g, '-');

        // Verificar se codigo ja existe
        const existe = await context.env.DB.prepare(`
            SELECT id FROM projetos WHERE codigo = ?
        `).bind(codigoLower).first();

        if (existe) {
            return errorResponse('Ja existe um projeto com este codigo', 409);
        }

        // Inserir projeto
        const result = await context.env.DB.prepare(`
            INSERT INTO projetos (
                codigo, nome, descricao, icone, cor, visibilidade, criado_por,
                teams_channel_url, teams_webhook_url,
                sharepoint_folder_url, sharepoint_drive_id, sharepoint_folder_id
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).bind(
            codigoLower,
            nome,
            descricao || null,
            icone || '📁',
            cor || COR_PADRAO,
            visibilidade || 'privado',
            usuario.id,
            teamsChannelUrl || null,
            teamsWebhookUrl || null,
            sharepointFolderUrl || null,
            sharepointDriveId || null,
            sharepointFolderId || null
        ).run();

        const projetoId = result.meta.last_row_id;

        // Adicionar criador como admin do projeto
        const papelAdmin = await context.env.DB.prepare(`
            SELECT id FROM papeis WHERE codigo = 'admin'
        `).first();

        if (papelAdmin) {
            await context.env.DB.prepare(`
                INSERT INTO usuario_projeto_papel (usuario_id, projeto_id, papel_id)
                VALUES (?, ?, ?)
            `).bind(usuario.id, projetoId, papelAdmin.id).run();
        }

        // Associar modulos
        if (modulos && Array.isArray(modulos) && modulos.length > 0) {
            for (let i = 0; i < modulos.length; i++) {
                await context.env.DB.prepare(`
                    INSERT OR IGNORE INTO projeto_modulos (projeto_id, modulo_id, ordem)
                    VALUES (?, ?, ?)
                `).bind(projetoId, modulos[i], i).run();
            }
        }

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.CRIAR,
            entidade: 'projeto',
            entidadeId: String(projetoId),
            detalhes: { codigo: codigoLower, nome, criadoPor: usuario.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Projeto criado com sucesso',
            projeto: {
                id: projetoId,
                codigo: codigoLower,
                nome
            }
        }, 201);

    } catch (error) {
        console.error('Erro ao criar projeto:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// PUT - Atualizar projeto
export async function onRequestPut(context) {
    try {
        const usuario = context.data.usuario;
        const url = new URL(context.request.url);
        const pathParts = url.pathname.split('/').filter(p => p);
        const id = pathParts[pathParts.length - 1];

        if (!id || isNaN(id)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        // Verificar se projeto existe
        const projeto = await context.env.DB.prepare(`
            SELECT id, codigo FROM projetos WHERE id = ?
        `).bind(id).first();

        if (!projeto) {
            return errorResponse('Projeto nao encontrado', 404);
        }

        // Verificar permissao (admin global ou admin do projeto)
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(id));
        if (!podeEditar) {
            return errorResponse('Sem permissao para editar este projeto', 403);
        }

        const body = await context.request.json();
        const {
            nome, descricao, icone, cor, visibilidade, ativo, modulos,
            teamsChannelUrl, teamsWebhookUrl,
            sharepointFolderUrl, sharepointDriveId, sharepointFolderId
        } = body;

        // Validar cor contra paleta Belgo
        if (cor && !isCorValida(cor)) {
            return errorResponse('Cor invalida. Use apenas cores da paleta Belgo', 400);
        }

        // Validar URLs do SharePoint
        if (sharepointFolderUrl && !isSharePointValido(sharepointFolderUrl)) {
            return errorResponse('URL do SharePoint invalida', 400);
        }

        // Atualizar dados basicos
        await context.env.DB.prepare(`
            UPDATE projetos
            SET nome = COALESCE(?, nome),
                descricao = COALESCE(?, descricao),
                icone = COALESCE(?, icone),
                cor = COALESCE(?, cor),
                visibilidade = COALESCE(?, visibilidade),
                ativo = COALESCE(?, ativo),
                teams_channel_url = COALESCE(?, teams_channel_url),
                teams_webhook_url = COALESCE(?, teams_webhook_url),
                sharepoint_folder_url = COALESCE(?, sharepoint_folder_url),
                sharepoint_drive_id = COALESCE(?, sharepoint_drive_id),
                sharepoint_folder_id = COALESCE(?, sharepoint_folder_id),
                updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `).bind(
            nome || null,
            descricao !== undefined ? descricao : null,
            icone || null,
            cor || null,
            visibilidade || null,
            ativo !== undefined ? (ativo ? 1 : 0) : null,
            teamsChannelUrl !== undefined ? teamsChannelUrl : null,
            teamsWebhookUrl !== undefined ? teamsWebhookUrl : null,
            sharepointFolderUrl !== undefined ? sharepointFolderUrl : null,
            sharepointDriveId !== undefined ? sharepointDriveId : null,
            sharepointFolderId !== undefined ? sharepointFolderId : null,
            id
        ).run();

        // Atualizar modulos se fornecidos
        if (modulos !== undefined && Array.isArray(modulos)) {
            // Remover modulos antigos
            await context.env.DB.prepare(`
                DELETE FROM projeto_modulos WHERE projeto_id = ?
            `).bind(id).run();

            // Adicionar novos
            for (let i = 0; i < modulos.length; i++) {
                await context.env.DB.prepare(`
                    INSERT INTO projeto_modulos (projeto_id, modulo_id, ordem)
                    VALUES (?, ?, ?)
                `).bind(id, modulos[i], i).run();
            }
        }

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EDITAR,
            entidade: 'projeto',
            entidadeId: id,
            detalhes: { alteracoes: body, editadoPor: usuario.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Projeto atualizado com sucesso'
        });

    } catch (error) {
        console.error('Erro ao atualizar projeto:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Desativar projeto (soft delete)
export async function onRequestDelete(context) {
    try {
        const usuario = context.data.usuario;
        const url = new URL(context.request.url);
        const pathParts = url.pathname.split('/').filter(p => p);
        const id = pathParts[pathParts.length - 1];

        if (!id || isNaN(id)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        // Nao permitir excluir projeto GTM (id=1)
        if (parseInt(id) === 1) {
            return errorResponse('O projeto GTM nao pode ser excluido', 400);
        }

        // Apenas admin global pode excluir projetos
        if (!usuario.isAdmin) {
            return errorResponse('Apenas administradores podem excluir projetos', 403);
        }

        // Verificar se projeto existe
        const projeto = await context.env.DB.prepare(`
            SELECT id, codigo, nome FROM projetos WHERE id = ?
        `).bind(id).first();

        if (!projeto) {
            return errorResponse('Projeto nao encontrado', 404);
        }

        // Desativar (soft delete)
        await context.env.DB.prepare(`
            UPDATE projetos SET ativo = 0, updated_at = CURRENT_TIMESTAMP WHERE id = ?
        `).bind(id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EXCLUIR,
            entidade: 'projeto',
            entidadeId: id,
            detalhes: { codigo: projeto.codigo, nome: projeto.nome, excluídoPor: usuario.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Projeto desativado com sucesso'
        });

    } catch (error) {
        console.error('Erro ao desativar projeto:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Projeto-Id',
            'Access-Control-Max-Age': '86400'
        }
    });
}
