// =====================================================
// API: Criar Projeto a partir de Template
// POST /api/projetos/from-template
// =====================================================

import { verificarAuth } from '../../lib/auth.js';

export async function onRequestPost(context) {
    const { request, env } = context;

    try {
        // Verificar autenticacao
        const usuario = await verificarAuth(request, env);
        if (!usuario) {
            return new Response(JSON.stringify({ success: false, error: 'Nao autorizado' }), {
                status: 401,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Verificar se usuario eh admin global
        if (!usuario.admin) {
            return new Response(JSON.stringify({ success: false, error: 'Apenas administradores podem criar projetos' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Obter dados do request
        const body = await request.json();
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
            return new Response(JSON.stringify({ success: false, error: 'template_id eh obrigatorio' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        if (!codigo || !nome) {
            return new Response(JSON.stringify({ success: false, error: 'codigo e nome sao obrigatorios' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Validar codigo (apenas letras minusculas, numeros e hifens)
        if (!/^[a-z0-9-]+$/.test(codigo)) {
            return new Response(JSON.stringify({ success: false, error: 'Codigo deve conter apenas letras minusculas, numeros e hifens' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Verificar se codigo ja existe
        const projetoExistente = await env.DB.prepare(`
            SELECT id FROM projetos WHERE codigo = ?
        `).bind(codigo).first();

        if (projetoExistente) {
            return new Response(JSON.stringify({ success: false, error: 'Ja existe um projeto com este codigo' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Buscar template
        const template = await env.DB.prepare(`
            SELECT id, codigo, nome, icone, cor, config_completo
            FROM projeto_templates
            WHERE id = ? AND ativo = 1
        `).bind(template_id).first();

        if (!template) {
            return new Response(JSON.stringify({ success: false, error: 'Template nao encontrado' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Parse do config_completo
        let config;
        try {
            config = template.config_completo ? JSON.parse(template.config_completo) : { entidades: [], menus: [] };
        } catch (e) {
            config = { entidades: [], menus: [] };
        }

        // Criar projeto
        const projetoResult = await env.DB.prepare(`
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
            const entidadeResult = await env.DB.prepare(`
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
                const campoResult = await env.DB.prepare(`
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
                    await env.DB.prepare(`
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

            await env.DB.prepare(`
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
        const papelAdmin = await env.DB.prepare(`
            SELECT id FROM papeis WHERE codigo = 'admin'
        `).first();

        if (papelAdmin) {
            await env.DB.prepare(`
                INSERT INTO usuario_projeto_papel (usuario_id, projeto_id, papel_id, ativo)
                VALUES (?, ?, ?, 1)
            `).bind(usuario.id, projetoId, papelAdmin.id).run();
        }

        // Se responsavel_id for diferente do criador, adiciona tambem
        if (responsavel_id && responsavel_id !== usuario.id) {
            const papelGestor = await env.DB.prepare(`
                SELECT id FROM papeis WHERE codigo = 'gestor'
            `).first();

            if (papelGestor) {
                await env.DB.prepare(`
                    INSERT OR IGNORE INTO usuario_projeto_papel (usuario_id, projeto_id, papel_id, ativo)
                    VALUES (?, ?, ?, 1)
                `).bind(responsavel_id, projetoId, papelGestor.id).run();
            }
        }

        // Retornar sucesso
        return new Response(JSON.stringify({
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
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao criar projeto de template:', error);
        return new Response(JSON.stringify({
            success: false,
            error: 'Erro interno ao criar projeto',
            details: error.message
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
