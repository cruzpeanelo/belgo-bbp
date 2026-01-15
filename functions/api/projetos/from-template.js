// =====================================================
// API: Criar Projeto a partir de Template
// POST /api/projetos/from-template
// =====================================================

import { jsonResponse, errorResponse } from '../../lib/auth.js';
import { registrarAuditoria, getClientIP, ACOES } from '../../lib/audit.js';

export async function onRequestPost(context) {
    const usuario = context.data.usuario;

    try {
        // Verificar se usuario eh admin global
        if (!usuario.isAdmin) {
            return errorResponse('Apenas administradores podem criar projetos', 403);
        }

        // Obter dados do request
        const body = await context.request.json();
        const {
            template_id,
            codigo,
            nome,
            descricao,
            cor,
            icone,
            responsavel_id
        } = body;

        // Validacoes
        if (!template_id) {
            return errorResponse('template_id eh obrigatorio', 400);
        }

        if (!codigo || !nome) {
            return errorResponse('codigo e nome sao obrigatorios', 400);
        }

        // Validar codigo (apenas letras minusculas, numeros e hifens)
        if (!/^[a-z0-9-]+$/.test(codigo)) {
            return errorResponse('Codigo deve conter apenas letras minusculas, numeros e hifens', 400);
        }

        // Verificar se codigo ja existe
        const projetoExistente = await context.env.DB.prepare(`
            SELECT id FROM projetos WHERE codigo = ?
        `).bind(codigo).first();

        if (projetoExistente) {
            return errorResponse('Ja existe um projeto com este codigo', 400);
        }

        // Buscar template
        const template = await context.env.DB.prepare(`
            SELECT id, codigo, nome, icone, cor, config_completo
            FROM projeto_templates
            WHERE id = ? AND ativo = 1
        `).bind(template_id).first();

        if (!template) {
            return errorResponse('Template nao encontrado', 404);
        }

        // Parse do config_completo
        let config;
        try {
            config = template.config_completo ? JSON.parse(template.config_completo) : { entidades: [], menus: [] };
        } catch (e) {
            config = { entidades: [], menus: [] };
        }

        // Criar projeto
        const projetoResult = await context.env.DB.prepare(`
            INSERT INTO projetos (codigo, nome, descricao, icone, cor, template_origem_id, criado_por, ativo)
            VALUES (?, ?, ?, ?, ?, ?, ?, 1)
        `).bind(
            codigo,
            nome,
            descricao || `Projeto criado a partir do template ${template.nome}`,
            icone || template.icone || '📁',
            cor || template.cor || '#003B4A',
            template_id,
            usuario.id
        ).run();

        const projetoId = projetoResult.meta.last_row_id;

        // Mapear IDs antigos para novos (para referencias)
        const entidadeMap = {};  // codigo_antigo -> id_novo

        // Criar entidades do template
        for (const entidade of config.entidades || []) {
            const entidadeResult = await context.env.DB.prepare(`
                INSERT INTO projeto_entidades (
                    projeto_id, codigo, nome, nome_plural, descricao, icone, tipo,
                    permite_criar, permite_editar, permite_excluir,
                    permite_importar, permite_exportar, config_funcionalidades,
                    ativo
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
            `).bind(
                projetoId,
                entidade.codigo,
                entidade.nome,
                entidade.nome_plural,
                entidade.descricao,
                entidade.icone,
                entidade.tipo || 'tabela',
                entidade.permite_criar ?? 1,
                entidade.permite_editar ?? 1,
                entidade.permite_excluir ?? 0,
                entidade.permite_importar ?? 0,
                entidade.permite_exportar ?? 1,
                entidade.config_funcionalidades ? JSON.stringify(entidade.config_funcionalidades) : null
            ).run();

            const entidadeId = entidadeResult.meta.last_row_id;
            entidadeMap[entidade.codigo] = entidadeId;

            // Criar campos da entidade
            for (const campo of entidade.campos || []) {
                const campoResult = await context.env.DB.prepare(`
                    INSERT INTO projeto_entidade_campos (
                        entidade_id, codigo, nome, tipo, obrigatorio, ordem, config,
                        placeholder, ajuda, valor_padrao,
                        visivel_listagem, visivel_formulario, visivel_detalhe
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                `).bind(
                    entidadeId,
                    campo.codigo,
                    campo.nome,
                    campo.tipo,
                    campo.obrigatorio ?? 0,
                    campo.ordem ?? 0,
                    campo.config ? JSON.stringify(campo.config) : null,
                    campo.placeholder,
                    campo.ajuda,
                    campo.valor_padrao,
                    campo.visivel_listagem ?? 1,
                    campo.visivel_formulario ?? 1,
                    campo.visivel_detalhe ?? 1
                ).run();

                const campoId = campoResult.meta.last_row_id;

                // Criar opcoes do campo (se houver)
                for (const opcao of campo.opcoes || []) {
                    await context.env.DB.prepare(`
                        INSERT INTO projeto_entidade_opcoes (campo_id, valor, label, cor, icone, ordem)
                        VALUES (?, ?, ?, ?, ?, ?)
                    `).bind(
                        campoId,
                        opcao.valor,
                        opcao.label,
                        opcao.cor,
                        opcao.icone,
                        opcao.ordem ?? 0
                    ).run();
                }
            }
        }

        // Criar menus do template
        for (const menu of config.menus || []) {
            // Encontrar entidade_id correspondente
            let entidadeId = null;
            if (menu.entidade_codigo && entidadeMap[menu.entidade_codigo]) {
                entidadeId = entidadeMap[menu.entidade_codigo];
            }

            // Ajustar URL se for pagina dinamica vinculada a entidade
            let url = menu.url;
            if (menu.pagina_dinamica && menu.entidade_codigo) {
                url = `pages/entidade.html?e=${menu.entidade_codigo}`;
            }

            await context.env.DB.prepare(`
                INSERT INTO projeto_menus (
                    projeto_id, codigo, nome, url, icone, ordem,
                    pagina_dinamica, entidade_id, tipo_conteudo, ativo
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
            `).bind(
                projetoId,
                menu.codigo,
                menu.nome,
                url,
                menu.icone,
                menu.ordem ?? 0,
                menu.pagina_dinamica ?? 1,
                entidadeId,
                menu.tipo_conteudo
            ).run();
        }

        // Adicionar usuario criador como admin do projeto
        const papelAdmin = await context.env.DB.prepare(`
            SELECT id FROM papeis WHERE codigo = 'admin'
        `).first();

        if (papelAdmin) {
            await context.env.DB.prepare(`
                INSERT INTO usuario_projeto_papel (usuario_id, projeto_id, papel_id, ativo)
                VALUES (?, ?, ?, 1)
            `).bind(usuario.id, projetoId, papelAdmin.id).run();
        }

        // Se responsavel_id for diferente do criador, adiciona tambem
        if (responsavel_id && responsavel_id !== usuario.id) {
            const papelGestor = await context.env.DB.prepare(`
                SELECT id FROM papeis WHERE codigo = 'gestor'
            `).first();

            if (papelGestor) {
                await context.env.DB.prepare(`
                    INSERT OR IGNORE INTO usuario_projeto_papel (usuario_id, projeto_id, papel_id, ativo)
                    VALUES (?, ?, ?, 1)
                `).bind(responsavel_id, projetoId, papelGestor.id).run();
            }
        }

        // Registrar auditoria
        await registrarAuditoria(context.env.DB, {
            usuarioId: usuario.id,
            acao: ACOES.CRIAR,
            entidade: 'projeto',
            entidadeId: projetoId,
            detalhes: { codigo, nome, templateId: template_id, templateNome: template.nome },
            ip: getClientIP(context.request)
        });

        return jsonResponse({
            success: true,
            message: 'Projeto criado com sucesso a partir do template!',
            projeto: {
                id: projetoId,
                codigo,
                nome,
                url: `/pages/entidade.html?projeto=${projetoId}`,
                entidades_criadas: Object.keys(entidadeMap).length,
                menus_criados: (config.menus || []).length
            }
        });

    } catch (error) {
        console.error('Erro ao criar projeto de template:', error);
        return errorResponse('Erro interno: ' + error.message, 500);
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
