// =====================================================
// BELGO BBP - API de Papeis
// GET /api/papeis - Lista papeis disponiveis
// =====================================================

import { jsonResponse, errorResponse } from '../lib/auth.js';

// GET - Listar papeis disponiveis
export async function onRequestGet(context) {
    try {
        const papeis = await context.env.DB.prepare(`
            SELECT id, codigo, nome, descricao, nivel, cor
            FROM papeis
            ORDER BY nivel DESC
        `).all();

        return jsonResponse({
            success: true,
            papeis: papeis.results || []
        });

    } catch (error) {
        console.error('Erro ao listar papeis:', error);
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
