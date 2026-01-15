// =====================================================
// BELGO BBP - API de Gestão de Usuários (Admin)
// /api/admin/usuarios
// =====================================================

import { hashPassword, isValidDomain, jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES, ENTIDADES } from '../../lib/audit.js';

// Senha padrão para novos usuários
const SENHA_PADRAO = 'BelgoGTM2024';

// GET - Listar usuários
export async function onRequestGet(context) {
    try {
        const url = new URL(context.request.url);
        const id = url.pathname.split('/').pop();

        // Se tiver ID, buscar usuário específico
        if (id && id !== 'usuarios' && !isNaN(id)) {
            const usuario = await context.env.DB.prepare(`
                SELECT u.id, u.email, u.nome, u.nome_completo, u.area, u.cargo,
                       u.is_admin, u.ativo, u.primeiro_acesso, u.created_at
                FROM usuarios u
                WHERE u.id = ?
            `).bind(id).first();

            if (!usuario) {
                return errorResponse('Usuário não encontrado', 404);
            }

            // Buscar módulos
            const modulos = await context.env.DB.prepare(`
                SELECT m.id, m.codigo, m.nome
                FROM usuario_modulos um
                JOIN modulos m ON um.modulo_id = m.id
                WHERE um.usuario_id = ?
            `).bind(id).all();

            return jsonResponse({
                success: true,
                usuario: {
                    ...usuario,
                    modulos: modulos.results || []
                }
            });
        }

        // Listar todos
        const usuarios = await context.env.DB.prepare(`
            SELECT id, email, nome, nome_completo, area, cargo, is_admin, ativo,
                   primeiro_acesso, created_at
            FROM usuarios
            ORDER BY nome
        `).all();

        return jsonResponse({
            success: true,
            usuarios: usuarios.results || [],
            total: usuarios.results?.length || 0
        });

    } catch (error) {
        console.error('Erro ao listar usuários:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// POST - Criar usuário
export async function onRequestPost(context) {
    try {
        const admin = context.data.usuario;
        const body = await context.request.json();

        const { email, nome, nomeCompleto, area, cargo, isAdmin, modulos } = body;

        // Validações
        if (!email || !nome) {
            return errorResponse('Email e nome são obrigatórios', 400);
        }

        const emailLower = email.toLowerCase().trim();

        if (!isValidDomain(emailLower)) {
            return errorResponse('Domínio de email não permitido', 400);
        }

        // Verificar se email já existe
        const existe = await context.env.DB.prepare(`
            SELECT id FROM usuarios WHERE email = ?
        `).bind(emailLower).first();

        if (existe) {
            return errorResponse('Email já cadastrado', 409);
        }

        // Hash da senha padrão
        const senhaHash = await hashPassword(SENHA_PADRAO);

        // Inserir usuário
        const result = await context.env.DB.prepare(`
            INSERT INTO usuarios (email, nome, nome_completo, senha_hash, area, cargo, is_admin, primeiro_acesso)
            VALUES (?, ?, ?, ?, ?, ?, ?, 1)
        `).bind(
            emailLower,
            nome,
            nomeCompleto || null,
            senhaHash,
            area || null,
            cargo || null,
            isAdmin ? 1 : 0
        ).run();

        const userId = result.meta.last_row_id;

        // Associar módulos
        if (modulos && modulos.length > 0) {
            for (const moduloId of modulos) {
                await context.env.DB.prepare(`
                    INSERT OR IGNORE INTO usuario_modulos (usuario_id, modulo_id)
                    VALUES (?, ?)
                `).bind(userId, moduloId).run();
            }
        }

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: admin.id,
            acao: ACOES.CRIAR,
            entidade: ENTIDADES.USUARIO,
            entidadeId: String(userId),
            detalhes: { email: emailLower, nome, criadoPor: admin.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Usuário criado com sucesso',
            usuario: {
                id: userId,
                email: emailLower,
                nome,
                senhaPadrao: SENHA_PADRAO
            }
        }, 201);

    } catch (error) {
        console.error('Erro ao criar usuário:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// PUT - Atualizar usuário
export async function onRequestPut(context) {
    try {
        const admin = context.data.usuario;
        const url = new URL(context.request.url);
        const id = url.pathname.split('/').pop();

        if (!id || isNaN(id)) {
            return errorResponse('ID do usuário não fornecido', 400);
        }

        // Verificar se usuário existe
        const usuarioExiste = await context.env.DB.prepare(`
            SELECT id, email FROM usuarios WHERE id = ?
        `).bind(id).first();

        if (!usuarioExiste) {
            return errorResponse('Usuário não encontrado', 404);
        }

        const body = await context.request.json();
        const { nome, nomeCompleto, area, cargo, isAdmin, ativo, modulos } = body;

        // Atualizar dados básicos
        await context.env.DB.prepare(`
            UPDATE usuarios
            SET nome = COALESCE(?, nome),
                nome_completo = COALESCE(?, nome_completo),
                area = COALESCE(?, area),
                cargo = COALESCE(?, cargo),
                is_admin = COALESCE(?, is_admin),
                ativo = COALESCE(?, ativo),
                updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        `).bind(
            nome || null,
            nomeCompleto || null,
            area || null,
            cargo || null,
            isAdmin !== undefined ? (isAdmin ? 1 : 0) : null,
            ativo !== undefined ? (ativo ? 1 : 0) : null,
            id
        ).run();

        // Atualizar módulos se fornecidos
        if (modulos !== undefined) {
            // Remover módulos antigos
            await context.env.DB.prepare(`
                DELETE FROM usuario_modulos WHERE usuario_id = ?
            `).bind(id).run();

            // Adicionar novos
            if (modulos && modulos.length > 0) {
                for (const moduloId of modulos) {
                    await context.env.DB.prepare(`
                        INSERT OR IGNORE INTO usuario_modulos (usuario_id, modulo_id)
                        VALUES (?, ?)
                    `).bind(id, moduloId).run();
                }
            }
        }

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: admin.id,
            acao: ACOES.EDITAR,
            entidade: ENTIDADES.USUARIO,
            entidadeId: id,
            detalhes: { alteracoes: body, editadoPor: admin.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Usuário atualizado com sucesso'
        });

    } catch (error) {
        console.error('Erro ao atualizar usuário:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// DELETE - Desativar usuário (soft delete)
export async function onRequestDelete(context) {
    try {
        const admin = context.data.usuario;
        const url = new URL(context.request.url);
        const id = url.pathname.split('/').pop();

        if (!id || isNaN(id)) {
            return errorResponse('ID do usuário não fornecido', 400);
        }

        // Não permitir auto-exclusão
        if (parseInt(id) === admin.id) {
            return errorResponse('Você não pode desativar sua própria conta', 400);
        }

        // Verificar se usuário existe
        const usuario = await context.env.DB.prepare(`
            SELECT id, email FROM usuarios WHERE id = ?
        `).bind(id).first();

        if (!usuario) {
            return errorResponse('Usuário não encontrado', 404);
        }

        // Desativar (soft delete)
        await context.env.DB.prepare(`
            UPDATE usuarios SET ativo = 0, updated_at = CURRENT_TIMESTAMP WHERE id = ?
        `).bind(id).run();

        // Remover sessões ativas
        await context.env.DB.prepare(`
            DELETE FROM sessoes WHERE usuario_id = ?
        `).bind(id).run();

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: admin.id,
            acao: ACOES.EXCLUIR,
            entidade: ENTIDADES.USUARIO,
            entidadeId: id,
            detalhes: { email: usuario.email, desativadoPor: admin.email },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Usuário desativado com sucesso'
        });

    } catch (error) {
        console.error('Erro ao desativar usuário:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400'
        }
    });
}
