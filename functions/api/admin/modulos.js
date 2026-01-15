// =====================================================
// BELGO BBP - API de Modulos (Admin)
// GET /api/admin/modulos
// =====================================================

import { jsonResponse, errorResponse } from '../../lib/auth.js';

// GET - Listar modulos disponiveis
export async function onRequestGet(context) {
    try {
        const modulos = await context.env.DB.prepare(`
            SELECT id, codigo, nome, icone, cor, ativo
            FROM modulos
            ORDER BY id
        `).all();

        return jsonResponse({
            success: true,
            modulos: modulos.results || []
        });

    } catch (error) {
        console.error('Erro ao listar modulos:', error);
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
