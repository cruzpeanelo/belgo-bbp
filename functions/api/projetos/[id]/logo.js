// =====================================================
// BELGO BBP - API de Upload de Logo
// POST/DELETE /api/projetos/:id/logo
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../../lib/audit.js';
import { isProjetoAdmin } from '../../../lib/permissions.js';

// Tipos de arquivo permitidos
const TIPOS_PERMITIDOS = ['image/png', 'image/jpeg', 'image/jpg'];
const TAMANHO_MAXIMO = 2 * 1024 * 1024; // 2MB

// POST - Upload de logo
export async function onRequestPost(context) {
    try {
        const usuario = context.data.usuario;
        const { id } = context.params;

        if (!id || isNaN(id)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        // Verificar se projeto existe
        const projeto = await context.env.DB.prepare(`
            SELECT id, codigo, nome, logo_url FROM projetos WHERE id = ?
        `).bind(id).first();

        if (!projeto) {
            return errorResponse('Projeto nao encontrado', 404);
        }

        // Verificar permissao (admin global ou admin do projeto)
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(id));
        if (!podeEditar) {
            return errorResponse('Sem permissao para editar este projeto', 403);
        }

        // Verificar se R2 esta configurado
        if (!context.env.LOGOS_BUCKET) {
            return errorResponse('Bucket R2 nao configurado', 500);
        }

        // Parsear multipart form data
        const formData = await context.request.formData();
        const arquivo = formData.get('logo');

        if (!arquivo || !(arquivo instanceof File)) {
            return errorResponse('Arquivo nao enviado', 400);
        }

        // Validar tipo
        if (!TIPOS_PERMITIDOS.includes(arquivo.type)) {
            return errorResponse('Tipo de arquivo invalido. Use PNG ou JPG', 400);
        }

        // Validar tamanho
        if (arquivo.size > TAMANHO_MAXIMO) {
            return errorResponse('Arquivo muito grande. Maximo 2MB', 400);
        }

        // Gerar nome unico
        const extensao = arquivo.type === 'image/png' ? 'png' : 'jpg';
        const nomeArquivo = `projeto-${id}-${Date.now()}.${extensao}`;

        // Fazer upload para R2
        const arrayBuffer = await arquivo.arrayBuffer();
        await context.env.LOGOS_BUCKET.put(nomeArquivo, arrayBuffer, {
            httpMetadata: {
                contentType: arquivo.type,
                cacheControl: 'public, max-age=31536000' // 1 ano
            }
        });

        // Deletar logo anterior se existir
        if (projeto.logo_url) {
            const nomeAntigo = projeto.logo_url.split('/').pop();
            try {
                await context.env.LOGOS_BUCKET.delete(nomeAntigo);
            } catch (e) {
                console.warn('Nao foi possivel deletar logo antigo:', e);
            }
        }

        // Construir URL publica
        // NOTA: Para acesso publico, precisa configurar custom domain ou public bucket
        const logoUrl = `/api/projetos/${id}/logo/${nomeArquivo}`;

        // Atualizar campo no banco
        await context.env.DB.prepare(`
            UPDATE projetos SET logo_url = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?
        `).bind(logoUrl, id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EDITAR,
            entidade: 'projeto',
            entidadeId: String(id),
            detalhes: { acao: 'upload_logo', arquivo: nomeArquivo, editadoPor: usuario.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Logo atualizado com sucesso',
            logoUrl
        });

    } catch (error) {
        console.error('Erro ao fazer upload de logo:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Remover logo
export async function onRequestDelete(context) {
    try {
        const usuario = context.data.usuario;
        const { id } = context.params;

        if (!id || isNaN(id)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        // Verificar se projeto existe
        const projeto = await context.env.DB.prepare(`
            SELECT id, codigo, logo_url FROM projetos WHERE id = ?
        `).bind(id).first();

        if (!projeto) {
            return errorResponse('Projeto nao encontrado', 404);
        }

        // Verificar permissao
        const podeEditar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(id));
        if (!podeEditar) {
            return errorResponse('Sem permissao para editar este projeto', 403);
        }

        // Deletar do R2 se existir
        if (projeto.logo_url && context.env.LOGOS_BUCKET) {
            const nomeArquivo = projeto.logo_url.split('/').pop();
            try {
                await context.env.LOGOS_BUCKET.delete(nomeArquivo);
            } catch (e) {
                console.warn('Nao foi possivel deletar logo:', e);
            }
        }

        // Limpar campo no banco
        await context.env.DB.prepare(`
            UPDATE projetos SET logo_url = NULL, updated_at = CURRENT_TIMESTAMP WHERE id = ?
        `).bind(id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.EDITAR,
            entidade: 'projeto',
            entidadeId: String(id),
            detalhes: { acao: 'remover_logo', editadoPor: usuario.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Logo removido com sucesso'
        });

    } catch (error) {
        console.error('Erro ao remover logo:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// GET - Servir logo (proxy para R2)
export async function onRequestGet(context) {
    try {
        const { id } = context.params;
        const url = new URL(context.request.url);
        const pathParts = url.pathname.split('/');
        const nomeArquivo = pathParts[pathParts.length - 1];

        if (!nomeArquivo || nomeArquivo === 'logo') {
            // Se so passou /logo, buscar logo atual do projeto
            const projeto = await context.env.DB.prepare(`
                SELECT logo_url FROM projetos WHERE id = ?
            `).bind(id).first();

            if (!projeto || !projeto.logo_url) {
                return errorResponse('Logo nao encontrado', 404);
            }

            // Redirecionar para URL correta
            return Response.redirect(projeto.logo_url, 302);
        }

        // Servir arquivo do R2
        if (!context.env.LOGOS_BUCKET) {
            return errorResponse('Bucket R2 nao configurado', 500);
        }

        const objeto = await context.env.LOGOS_BUCKET.get(nomeArquivo);

        if (!objeto) {
            return errorResponse('Arquivo nao encontrado', 404);
        }

        const headers = new Headers();
        headers.set('Content-Type', objeto.httpMetadata?.contentType || 'image/png');
        headers.set('Cache-Control', 'public, max-age=31536000');

        return new Response(objeto.body, { headers });

    } catch (error) {
        console.error('Erro ao servir logo:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS
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
