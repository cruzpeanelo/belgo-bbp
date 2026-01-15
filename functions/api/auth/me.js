// =====================================================
// BELGO BBP - API de Usuario Logado
// GET /api/auth/me
// =====================================================

import { extractToken, validateSession, getUserModules, jsonResponse, errorResponse } from '../../lib/auth.js';

export async function onRequestGet(context) {
    try {
        const token = extractToken(context.request);

        if (!token) {
            return errorResponse('Token nao fornecido', 401);
        }

        const usuario = await validateSession(context.env.DB, token);

        if (!usuario) {
            return errorResponse('Sessao invalida ou expirada', 401);
        }

        // Buscar modulos do usuario
        const modulos = await getUserModules(context.env.DB, usuario.id);

        return jsonResponse({
            success: true,
            usuario: {
                id: usuario.id,
                email: usuario.email,
                nome: usuario.nome,
                nomeCompleto: usuario.nomeCompleto,
                area: usuario.area,
                cargo: usuario.cargo,
                isAdmin: usuario.isAdmin,
                primeiroAcesso: usuario.primeiroAcesso
            },
            modulos
        });

    } catch (error) {
        console.error('Erro ao buscar usuario:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
