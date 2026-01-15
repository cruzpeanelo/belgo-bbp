// =====================================================
// BELGO BBP - API de Troca de Senha
// POST /api/auth/change-password
// =====================================================

import { extractToken, validateSession, hashPassword, jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../../lib/audit.js';

export async function onRequestPost(context) {
    try {
        const token = extractToken(context.request);

        if (!token) {
            return errorResponse('Token nao fornecido', 401);
        }

        const usuario = await validateSession(context.env.DB, token);

        if (!usuario) {
            return errorResponse('Sessao invalida ou expirada', 401);
        }

        const { senhaAtual, novaSenha, confirmarSenha } = await context.request.json();

        // Validacoes
        if (!senhaAtual || !novaSenha || !confirmarSenha) {
            return errorResponse('Todos os campos sao obrigatorios', 400);
        }

        if (novaSenha !== confirmarSenha) {
            return errorResponse('As senhas nao conferem', 400);
        }

        if (novaSenha.length < 8) {
            return errorResponse('A nova senha deve ter pelo menos 8 caracteres', 400);
        }

        // Verificar senha atual
        const usuarioDb = await context.env.DB.prepare(`
            SELECT senha_hash FROM usuarios WHERE id = ?
        `).bind(usuario.id).first();

        const senhaAtualHash = await hashPassword(senhaAtual);
        if (senhaAtualHash !== usuarioDb.senha_hash) {
            await registrarAuditoria(context.env.DB, {
                usuarioId: usuario.id,
                acao: ACOES.TROCAR_SENHA,
                entidade: ENTIDADES.USUARIO,
                entidadeId: String(usuario.id),
                detalhes: { sucesso: false, motivo: 'senha_atual_incorreta' },
                ip: getClientIP(context.request)
            });
            return errorResponse('Senha atual incorreta', 401);
        }

        // Atualizar senha
        const novaSenhaHash = await hashPassword(novaSenha);
        await context.env.DB.prepare(`
            UPDATE usuarios
            SET senha_hash = ?, primeiro_acesso = 0, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `).bind(novaSenhaHash, usuario.id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.TROCAR_SENHA,
            entidade: ENTIDADES.USUARIO,
            entidadeId: String(usuario.id),
            detalhes: { sucesso: true },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Senha alterada com sucesso'
        });

    } catch (error) {
        console.error('Erro ao trocar senha:', error);
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
