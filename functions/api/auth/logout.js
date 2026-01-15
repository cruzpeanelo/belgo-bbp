// =====================================================
// BELGO BBP - API de Logout
// POST /api/auth/logout
// =====================================================

import { extractToken, validateSession, jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../../lib/audit.js';

export async function onRequestPost(context) {
    try {
        const token = extractToken(context.request);

        if (!token) {
            return errorResponse('Token nao fornecido', 401);
        }

        // Validar sessao atual
        const usuario = await validateSession(context.env.DB, token);

        if (usuario) {
            // Registrar logout
            await registrarAuditoria(context.env.DB, {
                usuarioId: usuario.id,
                acao: ACOES.LOGOUT,
                entidade: ENTIDADES.SESSAO,
                detalhes: { email: usuario.email },
                ip: getClientIP(context.request)
            });
        }

        // Remover sessao (mesmo se nao encontrar usuario, remove o token)
        await context.env.DB.prepare('DELETE FROM sessoes WHERE token = ?')
            .bind(token).run();

        return jsonResponse({
            success: true,
            message: 'Logout realizado com sucesso'
        });

    } catch (error) {
        console.error('Erro no logout:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
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
