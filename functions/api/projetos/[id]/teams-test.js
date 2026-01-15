// =====================================================
// BELGO BBP - API de Teste de Webhook Teams
// POST /api/projetos/:id/teams-test
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';
import { isProjetoAdmin } from '../../../lib/permissions.js';
import { enviarNotificacaoTeams, TEMPLATES } from '../../../lib/teams.js';

// POST - Testar webhook do Teams
export async function onRequestPost(context) {
    try {
        const usuario = context.data.usuario;
        const { id } = context.params;

        if (!id || isNaN(id)) {
            return errorResponse('ID do projeto nao fornecido', 400);
        }

        // Verificar se projeto existe
        const projeto = await context.env.DB.prepare(`
            SELECT id, codigo, nome, teams_webhook_url FROM projetos WHERE id = ?
        `).bind(id).first();

        if (!projeto) {
            return errorResponse('Projeto nao encontrado', 404);
        }

        // Verificar permissao (admin global ou admin do projeto)
        const podeTestar = usuario.isAdmin || await isProjetoAdmin(context.env.DB, usuario.id, parseInt(id));
        if (!podeTestar) {
            return errorResponse('Sem permissao para testar webhook', 403);
        }

        // Obter webhook URL do body ou do projeto
        const body = await context.request.json().catch(() => ({}));
        const webhookUrl = body.webhookUrl || projeto.teams_webhook_url;

        if (!webhookUrl) {
            return errorResponse('Webhook URL nao configurada', 400);
        }

        // Enviar mensagem de teste
        const mensagem = TEMPLATES.testeWebhook(projeto.nome);
        const resultado = await enviarNotificacaoTeams(webhookUrl, mensagem);

        if (!resultado.success) {
            return errorResponse(`Falha ao enviar notificacao: ${resultado.error}`, 400);
        }

        return jsonResponse({
            success: true,
            message: 'Notificacao de teste enviada com sucesso!'
        });

    } catch (error) {
        console.error('Erro ao testar webhook Teams:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
