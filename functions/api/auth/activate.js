// =====================================================
// BELGO BBP - API de Ativacao de Conta
// POST /api/auth/activate
// =====================================================

import { hashPassword, jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../../lib/audit.js';

export async function onRequestPost(context) {
    try {
        const { token, novaSenha, confirmarSenha } = await context.request.json();

        // Validacoes
        if (!token) {
            return errorResponse('Token de ativacao nao fornecido', 400);
        }

        if (!novaSenha || !confirmarSenha) {
            return errorResponse('Senha e confirmacao sao obrigatorias', 400);
        }

        if (novaSenha !== confirmarSenha) {
            return errorResponse('As senhas nao conferem', 400);
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
            return errorResponse('Convite invalido ou ja utilizado', 400);
        }

        // Verificar expiracao
        if (new Date(convite.expires_at) < new Date()) {
            return errorResponse('Convite expirado. Solicite um novo ao administrador.', 400);
        }

        // Buscar usuario pelo email do convite
        const usuario = await context.env.DB.prepare(`
            SELECT id, email, nome FROM usuarios WHERE email = ?
        `).bind(convite.email).first();

        if (!usuario) {
            return errorResponse('Usuario nao encontrado', 404);
        }

        // Atualizar senha e ativar usuario
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
            message: 'Conta ativada com sucesso! Voce ja pode fazer login.',
            email: usuario.email
        });

    } catch (error) {
        console.error('Erro ao ativar conta:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// GET - Validar token antes de mostrar formulario
export async function onRequestGet(context) {
    try {
        const url = new URL(context.request.url);
        const token = url.searchParams.get('token');

        if (!token) {
            return errorResponse('Token nao fornecido', 400);
        }

        const convite = await context.env.DB.prepare(`
            SELECT c.email, c.expires_at, c.usado
            FROM convites c
            WHERE c.token = ?
        `).bind(token).first();

        if (!convite) {
            return jsonResponse({ valid: false, message: 'Convite invalido' });
        }

        if (convite.usado) {
            return jsonResponse({ valid: false, message: 'Convite ja utilizado' });
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
