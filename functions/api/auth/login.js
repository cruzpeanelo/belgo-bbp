// =====================================================
// BELGO BBP - API de Login
// POST /api/auth/login
// =====================================================

import { hashPassword, generateToken, isValidDomain, getSessionExpiry, jsonResponse, errorResponse, getUserModules } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../../lib/audit.js';

export async function onRequestPost(context) {
    try {
        const { email, senha } = await context.request.json();

        // Validacoes basicas
        if (!email || !senha) {
            return errorResponse('Email e senha sao obrigatorios', 400);
        }

        const emailLower = email.toLowerCase().trim();

        // Validar dominio
        if (!isValidDomain(emailLower)) {
            await registrarAuditoria(context.env.DB, {
                acao: ACOES.LOGIN_FALHA,
                detalhes: { email: emailLower, motivo: 'dominio_invalido' },
                ip: getClientIP(context.request)
            });
            return errorResponse('Dominio de email nao permitido. Use @belgo.com.br ou @arcelormittal.com.br', 403);
        }

        // Buscar usuario
        const usuario = await context.env.DB.prepare(`
            SELECT id, email, nome, nome_completo, senha_hash, area, cargo,
                   is_admin, ativo, primeiro_acesso
            FROM usuarios
            WHERE email = ?
        `).bind(emailLower).first();

        if (!usuario) {
            await registrarAuditoria(context.env.DB, {
                acao: ACOES.LOGIN_FALHA,
                detalhes: { email: emailLower, motivo: 'usuario_nao_encontrado' },
                ip: getClientIP(context.request)
            });
            return errorResponse('Email ou senha incorretos', 401);
        }

        // Verificar se usuario esta ativo
        if (!usuario.ativo) {
            await registrarAuditoria(context.env.DB, {
                usuarioId: usuario.id,
                acao: ACOES.LOGIN_FALHA,
                entidade: ENTIDADES.USUARIO,
                entidadeId: String(usuario.id),
                detalhes: { motivo: 'usuario_inativo' },
                ip: getClientIP(context.request)
            });
            return errorResponse('Usuario desativado. Contate o administrador.', 403);
        }

        // Verificar senha
        const senhaHash = await hashPassword(senha);
        if (senhaHash !== usuario.senha_hash) {
            await registrarAuditoria(context.env.DB, {
                usuarioId: usuario.id,
                acao: ACOES.LOGIN_FALHA,
                entidade: ENTIDADES.USUARIO,
                entidadeId: String(usuario.id),
                detalhes: { motivo: 'senha_incorreta' },
                ip: getClientIP(context.request)
            });
            return errorResponse('Email ou senha incorretos', 401);
        }

        // Limpar sessoes antigas do usuario
        await context.env.DB.prepare('DELETE FROM sessoes WHERE usuario_id = ?')
            .bind(usuario.id).run();

        // Criar nova sessao
        const token = generateToken();
        const expiresAt = getSessionExpiry();

        await context.env.DB.prepare(`
            INSERT INTO sessoes (usuario_id, token, expires_at)
            VALUES (?, ?, ?)
        `).bind(usuario.id, token, expiresAt).run();

        // Buscar modulos do usuario
        const modulos = await getUserModules(context.env.DB, usuario.id);

        // Registrar login bem-sucedido
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.LOGIN,
            entidade: ENTIDADES.SESSAO,
            detalhes: { email: emailLower },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            token,
            expiresAt,
            usuario: {
                id: usuario.id,
                email: usuario.email,
                nome: usuario.nome,
                nomeCompleto: usuario.nome_completo,
                area: usuario.area,
                cargo: usuario.cargo,
                isAdmin: usuario.is_admin === 1,
                primeiroAcesso: usuario.primeiro_acesso === 1
            },
            modulos
        });

    } catch (error) {
        console.error('Erro no login:', error);
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
