// =====================================================
// BELGO BBP - API de Usuários do Projeto
// /api/projetos/:id/usuarios
// Retorna lista de usuários para @mention picker
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';

// GET - Listar usuários disponíveis para menção no projeto
export async function onRequestGet(context) {
    try {
        const usuario = context.data.usuario;
        const projetoId = context.params.id;

        if (!projetoId || isNaN(projetoId)) {
            return errorResponse('ID do projeto invalido', 400);
        }

        // Verificar se projeto existe
        const projeto = await context.env.DB.prepare(`
            SELECT id, nome FROM projetos WHERE id = ? AND ativo = 1
        `).bind(projetoId).first();

        if (!projeto) {
            return errorResponse('Projeto nao encontrado', 404);
        }

        // Verificar acesso (admin global ou membro do projeto)
        if (!usuario.isAdmin) {
            const temAcesso = await context.env.DB.prepare(`
                SELECT 1 FROM usuario_projeto_papel
                WHERE usuario_id = ? AND projeto_id = ? AND ativo = 1
            `).bind(usuario.id, projetoId).first();

            if (!temAcesso) {
                return errorResponse('Sem acesso a este projeto', 403);
            }
        }

        // Buscar todos os usuários ativos do projeto (membros)
        // Inclui nome, email e informações relevantes para o picker
        const usuarios = await context.env.DB.prepare(`
            SELECT DISTINCT u.id, u.email, u.nome, u.nome_completo, u.area, u.cargo
            FROM usuarios u
            INNER JOIN usuario_projeto_papel upp ON u.id = upp.usuario_id
            WHERE upp.projeto_id = ?
              AND upp.ativo = 1
              AND u.ativo = 1
            ORDER BY u.nome
        `).bind(projetoId).all();

        // Formatar para o mention picker (email como chave principal)
        const usuariosFormatados = (usuarios.results || []).map(u => ({
            id: u.id,
            email: u.email,
            nome: u.nome || u.nome_completo || u.email.split('@')[0],
            area: u.area || '',
            cargo: u.cargo || ''
        }));

        return jsonResponse(usuariosFormatados);

    } catch (error) {
        console.error('Erro ao listar usuarios do projeto:', error);
        return errorResponse('Erro interno no servidor', 500);
    }
}
