// =====================================================
// BELGO BBP - API de Ativação de Conta
// POST /api/auth/activate
// =====================================================

import { hashPassword, jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../../lib/audit.js';

export async function onRequestPost(context) {
    try {
        const { token, novaSenha, confirmarSenha } = await context.request.json();

        // Validações
        if (!token) {
            return errorResponse('Token de ativação não fornecido', 400);
        }

        if (!novaSenha || !confirmarSenha) {
            return errorResponse('Senha e confirmação são obrigatórias', 400);
        }

        if (novaSenha !== confirmarSenha) {
            return errorResponse('As senhas não conferem', 400);
        }

        if (novaSenha.length < 8) {
            return errorResponse('A senha deve ter pelo menos 8 caracteres', 400);
        }

        // Buscar convite
        const convite = await context.env.DB.prepare(`
            SELECT c.*, u.email as criador_email
            FROM convites c
            JOIN usuarios u ON c.criado_por = u.id
            WHERE c.token = ? AND c.usado = 0
        `).bind(token).first();

        if (!convite) {
            return errorResponse('Convite inválido ou já utilizado', 400);
        }

        // Verificar expiração
        if (new Date(convite.expires_at) < new Date()) {
            return errorResponse('Convite expirado. Solicite um novo ao administrador.', 400);
        }

        // Buscar usuário pelo email do convite
        const usuario = await context.env.DB.prepare(`
            SELECT id, email, nome FROM usuarios WHERE email = ?
        `).bind(convite.email).first();

        if (!usuario) {
            return errorResponse('Usuário não encontrado', 404);
        }

        // Atualizar senha e ativar usuário
        const senhaHash = await hashPassword(novaSenha);
        await context.env.DB.prepare(`
            UPDATE usuarios
            SET senha_hash = ?, primeiro_acesso = 0, ativo = 1, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `).bind(senhaHash, usuario.id).run();

        // Marcar convite como usado
        await context.env.DB.prepare(`
            UPDATE convites SET usado = 1 WHERE id = ?
        `).bind(convite.id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.ATIVAR_CONTA,
            entidade: ENTIDADES.USUARIO,
            entidadeId: String(usuario.id),
            detalhes: { email: usuario.email, conviteId: convite.id },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Conta ativada com sucesso! Você já pode fazer login.',
            email: usuario.email
        });

    } catch (error) {
        console.error('Erro ao ativar conta:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// GET - Validar token antes de mostrar formulário
export async function onRequestGet(context) {
    try {
        const url = new URL(context.request.url);
        const token = url.searchParams.get('token');

        if (!token) {
            return errorResponse('Token não fornecido', 400);
        }

        const convite = await context.env.DB.prepare(`
            SELECT c.email, c.expires_at, c.usado
            FROM convites c
            WHERE c.token = ?
        `).bind(token).first();

        if (!convite) {
            return jsonResponse({ valid: false, message: 'Convite inválido' });
        }

        if (convite.usado) {
            return jsonResponse({ valid: false, message: 'Convite já utilizado' });
        }

        if (new Date(convite.expires_at) < new Date()) {
            return jsonResponse({ valid: false, message: 'Convite expirado' });
        }

        return jsonResponse({
            valid: true,
            email: convite.email
        });

    } catch (error) {
        console.error('Erro ao validar token:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Max-Age': '86400'
        }
    });
}
