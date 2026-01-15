// =====================================================
// BELGO BBP - API de Convites (Admin)
// /api/admin/convites
// =====================================================

import { generateToken, isValidDomain, jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../../lib/audit.js';

// Duracao do convite em dias
const CONVITE_DURACAO_DIAS = 7;

// GET - Listar convites
export async function onRequestGet(context) {
    try {
        const convites = await context.env.DB.prepare(`
            SELECT c.id, c.email, c.token, c.usado, c.expires_at, c.created_at,
                   u.nome as criado_por_nome, u.email as criado_por_email
            FROM convites c
            JOIN usuarios u ON c.criado_por = u.id
            ORDER BY c.created_at DESC
            LIMIT 100
        `).all();

        return jsonResponse({
            success: true,
            convites: convites.results || []
        });

    } catch (error) {
        console.error('Erro ao listar convites:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// POST - Criar convite
export async function onRequestPost(context) {
    try {
        const admin = context.data.usuario;
        const body = await context.request.json();
        const { email } = body;

        if (!email) {
            return errorResponse('Email e obrigatorio', 400);
        }

        const emailLower = email.toLowerCase().trim();

        if (!isValidDomain(emailLower)) {
            return errorResponse('Dominio de email nao permitido', 400);
        }

        // Verificar se usuario existe
        const usuarioExiste = await context.env.DB.prepare(`
            SELECT id, nome, ativo FROM usuarios WHERE email = ?
        `).bind(emailLower).first();

        if (!usuarioExiste) {
            return errorResponse('Usuario nao encontrado. Cadastre o usuario primeiro.', 404);
        }

        if (usuarioExiste.ativo === 0) {
            return errorResponse('Usuario esta desativado', 400);
        }

        // Invalidar convites anteriores para este email
        await context.env.DB.prepare(`
            DELETE FROM convites WHERE email = ? AND usado = 0
        `).bind(emailLower).run();

        // Gerar token e data de expiracao
        const token = generateToken();
        const expiresAt = new Date();
        expiresAt.setDate(expiresAt.getDate() + CONVITE_DURACAO_DIAS);

        // Criar convite
        const result = await context.env.DB.prepare(`
            INSERT INTO convites (email, token, criado_por, expires_at)
            VALUES (?, ?, ?, ?)
        `).bind(emailLower, token, admin.id, expiresAt.toISOString()).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: admin.id,
            acao: ACOES.CRIAR_CONVITE,
            entidade: ENTIDADES.CONVITE,
            entidadeId: String(result.meta.last_row_id),
            detalhes: { email: emailLower, criadoPor: admin.email },
            ip: getClientIP(context.request)
        });

        // Gerar URL de ativacao
        const baseUrl = new URL(context.request.url).origin;
        const activationUrl = `${baseUrl}/ativar.html?token=${token}`;

        // Gerar link do Teams
        const mensagemTeams = encodeURIComponent(
            `Ola ${usuarioExiste.nome}!\n\n` +
            `Voce foi cadastrado na plataforma Belgo BBP.\n\n` +
            `Clique no link abaixo para ativar sua conta:\n${activationUrl}\n\n` +
            `Este link expira em ${CONVITE_DURACAO_DIAS} dias.\n\n` +
            `Qualquer duvida, entre em contato com o time de TI.`
        );
        const teamsUrl = `https://teams.microsoft.com/l/chat/0/0?users=${emailLower}&message=${mensagemTeams}`;

        return jsonResponse({
            success: true,
            message: 'Convite criado com sucesso',
            convite: {
                email: emailLower,
                nome: usuarioExiste.nome,
                activationUrl,
                teamsUrl,
                expiresAt: expiresAt.toISOString()
            }
        }, 201);

    } catch (error) {
        console.error('Erro ao criar convite:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Cancelar convite
export async function onRequestDelete(context) {
    try {
        const admin = context.data.usuario;
        const url = new URL(context.request.url);
        const id = url.pathname.split('/').pop();

        if (!id || isNaN(id)) {
            return errorResponse('ID do convite nao fornecido', 400);
        }

        const convite = await context.env.DB.prepare(`
            SELECT id, email FROM convites WHERE id = ?
        `).bind(id).first();

        if (!convite) {
            return errorResponse('Convite nao encontrado', 404);
        }

        await context.env.DB.prepare(`
            DELETE FROM convites WHERE id = ?
        `).bind(id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: admin.id,
            acao: ACOES.EXCLUIR,
            entidade: ENTIDADES.CONVITE,
            entidadeId: id,
            detalhes: { email: convite.email, canceladoPor: admin.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Convite cancelado com sucesso'
        });

    } catch (error) {
        console.error('Erro ao cancelar convite:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
