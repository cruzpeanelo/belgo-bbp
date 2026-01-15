// =====================================================
// API: Buscar Permissoes do Usuario no Projeto
// GET /api/projetos/:id/permissoes
// =====================================================

import { jsonResponse, errorResponse } from '../../../lib/auth.js';
import { buscarPapelUsuario, buscarPermissoesUsuario } from '../../../lib/permissions.js';

export async function onRequestGet(context) {
    const projetoId = parseInt(context.params.id);
    const usuario = context.data.usuario;

    try {
        // Admin global tem todas as permissoes
        if (usuario.isAdmin) {
            // Buscar todas as permissoes para retornar
            const todasPermissoes = await context.env.DB.prepare(`
                SELECT codigo FROM permissoes
            `).all();

            return jsonResponse({
                success: true,
                papel: {
                    codigo: 'admin',
                    nome: 'Administrador Global',
                    nivel: 999
                },
                permissoes: (todasPermissoes.results || []).map(p => p.codigo),
                isAdmin: true,
                isAdminGlobal: true
            });
        }

        // Buscar papel do usuario no projeto
        const papel = await buscarPapelUsuario(context.env.DB, usuario.id, projetoId);

        if (!papel) {
            return errorResponse('Sem acesso a este projeto', 403);
        }

        // Buscar permissoes
        const permissoes = await buscarPermissoesUsuario(context.env.DB, usuario.id, projetoId);

        // Determinar permissoes de entidade baseado no papel
        const isAdmin = papel.nivel >= 100;

        return jsonResponse({
            success: true,
            papel: {
                codigo: papel.codigo,
                nome: papel.nome,
                nivel: papel.nivel,
                cor: papel.cor
            },
            permissoes,
            isAdmin,
            isAdminGlobal: false,
            // Helpers para verificacao rapida no frontend
            pode: {
                criar: isAdmin || permissoes.some(p => p.endsWith('.criar')),
                editar: isAdmin || permissoes.some(p => p.endsWith('.editar')),
                excluir: isAdmin || permissoes.some(p => p.endsWith('.excluir')),
                importar: isAdmin || permissoes.some(p => p.endsWith('.importar')),
                exportar: isAdmin || permissoes.some(p => p.endsWith('.exportar')),
                gerenciar: isAdmin
            }
        });

    } catch (error) {
        console.error('Erro ao buscar permissoes:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
    }
}
