// =====================================================
// BELGO BBP - API de Reset de Senha (Admin)
// POST /api/admin/reset-senha/:id
// =====================================================

import { hashPassword, jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../../lib/audit.js';

// Senha padrao para reset
const SENHA_PADRAO = 'BelgoGTM2024';

export async function onRequestPost(context) {
    try {
        const admin = context.data.usuario;
        const url = new URL(context.request.url);
        const pathParts = url.pathname.split('/');
        const id = pathParts[pathParts.length - 1];

        if (!id || isNaN(id)) {
            return errorResponse('ID do usuario nao fornecido', 400);
        }

        // Verificar se usuario existe
        const usuario = await context.env.DB.prepare(`
            SELECT id, email, nome FROM usuarios WHERE id = ?
        `).bind(id).first();

        if (!usuario) {
            return errorResponse('Usuario nao encontrado', 404);
        }

        // Reset para senha padrao
        const senhaHash = await hashPassword(SENHA_PADRAO);
        await context.env.DB.prepare(`
            UPDATE usuarios
            SET senha_hash = ?, primeiro_acesso = 1, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `).bind(senhaHash, id).run();

        // Invalidar sessoes do usuario
        await context.env.DB.prepare(`
            DELETE FROM sessoes WHERE usuario_id = ?
        `).bind(id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: admin.id,
            acao: ACOES.RESET_SENHA,
            entidade: ENTIDADES.USUARIO,
            entidadeId: id,
            detalhes: { email: usuario.email, resetadoPor: admin.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: `Senha de ${usuario.nome} resetada para a senha padrao`,
            senhaPadrao: SENHA_PADRAO
        });

    } catch (error) {
        console.error('Erro ao resetar senha:', error);
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
