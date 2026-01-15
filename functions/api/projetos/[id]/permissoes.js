// =====================================================
// API: Buscar Permissoes do Usuario no Projeto
// GET /api/projetos/:id/permissoes
// =====================================================

import { verificarAuth } from '../../../lib/auth.js';
import { buscarPapelUsuario, buscarPermissoesUsuario } from '../../../lib/permissions.js';

export async function onRequestGet(context) {
    const { request, env, params } = context;
    const projetoId = parseInt(params.id);

    try {
        // Verificar autenticacao
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Admin global tem todas as permissoes
        if (usuario.admin) {
            // Buscar todas as permissoes para retornar
            const todasPermissoes = await env.DB.prepare(`
                SELECT codigo FROM permissoes
            `).all();

            return new Response(JSON.stringify({
                success: true,
                papel: {
                    codigo: 'admin',
                    nome: 'Administrador Global',
                    nivel: 999
                },
                permissoes: (todasPermissoes.results || []).map(p => p.codigo),
                isAdmin: true,
                isAdminGlobal: true
            }), {
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Buscar papel do usuario no projeto
        const papel = await buscarPapelUsuario(env.DB, usuario.id, projetoId);

        if (!papel) {
            return new Response(JSON.stringify({
                success: false,
                error: 'Sem acesso a este projeto'
            }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Buscar permissoes
        const permissoes = await buscarPermissoesUsuario(env.DB, usuario.id, projetoId);

        // Determinar permissoes de entidade baseado no papel
        const isAdmin = papel.nivel >= 100;

        return new Response(JSON.stringify({
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
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao buscar permissoes:', error);
        return new Response(JSON.stringify({
            success: false,
            error: 'Erro interno',
            details: error.message
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
