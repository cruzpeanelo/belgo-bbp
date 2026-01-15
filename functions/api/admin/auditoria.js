// =====================================================
// BELGO BBP - API de Auditoria (Admin)
// GET /api/admin/auditoria
// =====================================================

import { jsonResponse, errorResponse } from '../../lib/auth.js';

export async function onRequestGet(context) {
    try {
        const url = new URL(context.request.url);

        // Parametros de filtro
        const usuarioId = url.searchParams.get('usuario_id');
        const acao = url.searchParams.get('acao');
        const entidade = url.searchParams.get('entidade');
        const dataInicio = url.searchParams.get('data_inicio');
        const dataFim = url.searchParams.get('data_fim');
        const limite = parseInt(url.searchParams.get('limite')) || 100;
        const offset = parseInt(url.searchParams.get('offset')) || 0;

        // Construir query dinamica
        let query = `
            SELECT a.id, a.acao, a.entidade, a.entidade_id, a.detalhes, a.ip, a.created_at,
                   u.nome as usuario_nome, u.email as usuario_email
            FROM auditoria a
            LEFT JOIN usuarios u ON a.usuario_id = u.id
            WHERE 1=1
        `;
        const params = [];

        if (usuarioId) {
            query += ' AND a.usuario_id = ?';
            params.push(usuarioId);
        }

        if (acao) {
            query += ' AND a.acao = ?';
            params.push(acao);
        }

        if (entidade) {
            query += ' AND a.entidade = ?';
            params.push(entidade);
        }

        if (dataInicio) {
            query += ' AND a.created_at >= ?';
            params.push(dataInicio);
        }

        if (dataFim) {
            query += ' AND a.created_at <= ?';
            params.push(dataFim);
        }

        query += ' ORDER BY a.created_at DESC LIMIT ? OFFSET ?';
        params.push(limite, offset);

        // Executar query
        let stmt = context.env.DB.prepare(query);
        for (let i = 0; i < params.length; i++) {
            stmt = stmt.bind(params[i]);
        }
        const resultados = await stmt.all();

        // Buscar total para paginacao (sem limit)
        let countQuery = `
            SELECT COUNT(*) as total FROM auditoria a WHERE 1=1
        `;
        const countParams = [];

        if (usuarioId) {
            countQuery += ' AND a.usuario_id = ?';
            countParams.push(usuarioId);
        }
        if (acao) {
            countQuery += ' AND a.acao = ?';
            countParams.push(acao);
        }
        if (entidade) {
            countQuery += ' AND a.entidade = ?';
            countParams.push(entidade);
        }
        if (dataInicio) {
            countQuery += ' AND a.created_at >= ?';
            countParams.push(dataInicio);
        }
        if (dataFim) {
            countQuery += ' AND a.created_at <= ?';
            countParams.push(dataFim);
        }

        let countStmt = context.env.DB.prepare(countQuery);
        for (let i = 0; i < countParams.length; i++) {
            countStmt = countStmt.bind(countParams[i]);
        }
        const totalResult = await countStmt.first();

        // Processar detalhes JSON
        const logs = (resultados.results || []).map(log => ({
            ...log,
            detalhes: log.detalhes ? JSON.parse(log.detalhes) : null
        }));

        return jsonResponse({
            success: true,
            logs,
            total: totalResult?.total || 0,
            limite,
            offset
        });

    } catch (error) {
        console.error('Erro ao buscar auditoria:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// Estatisticas de auditoria
export async function onRequestPost(context) {
    try {
        const body = await context.request.json();
        const { periodo } = body; // 'hoje', '7dias', '30dias'

        let dataInicio;
        const agora = new Date();

        switch (periodo) {
            case 'hoje':
                dataInicio = new Date(agora.getFullYear(), agora.getMonth(), agora.getDate());
                break;
            case '7dias':
                dataInicio = new Date(agora.getTime() - 7 * 24 * 60 * 60 * 1000);
                break;
            case '30dias':
            default:
                dataInicio = new Date(agora.getTime() - 30 * 24 * 60 * 60 * 1000);
        }

        // Estatisticas por acao
        const porAcao = await context.env.DB.prepare(`
            SELECT acao, COUNT(*) as total
            FROM auditoria
            WHERE created_at >= ?
            GROUP BY acao
            ORDER BY total DESC
        `).bind(dataInicio.toISOString()).all();

        // Estatisticas por usuario (top 10)
        const porUsuario = await context.env.DB.prepare(`
            SELECT u.nome, u.email, COUNT(*) as total
            FROM auditoria a
            JOIN usuarios u ON a.usuario_id = u.id
            WHERE a.created_at >= ?
            GROUP BY a.usuario_id
            ORDER BY total DESC
            LIMIT 10
        `).bind(dataInicio.toISOString()).all();

        // Total de logins
        const logins = await context.env.DB.prepare(`
            SELECT COUNT(*) as total
            FROM auditoria
            WHERE acao = 'login' AND created_at >= ?
        `).bind(dataInicio.toISOString()).first();

        // Total de acoes
        const totalAcoes = await context.env.DB.prepare(`
            SELECT COUNT(*) as total
            FROM auditoria
            WHERE created_at >= ?
        `).bind(dataInicio.toISOString()).first();

        return jsonResponse({
            success: true,
            estatisticas: {
                periodo,
                dataInicio: dataInicio.toISOString(),
                totalAcoes: totalAcoes?.total || 0,
                totalLogins: logins?.total || 0,
                porAcao: porAcao.results || [],
                porUsuario: porUsuario.results || []
            }
        });

    } catch (error) {
        console.error('Erro ao buscar estatisticas:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
