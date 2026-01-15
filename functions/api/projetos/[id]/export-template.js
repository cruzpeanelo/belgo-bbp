// =====================================================
// API: Exportar Projeto como Template
// POST /api/projetos/:id/export-template
// =====================================================

import { verificarAuth } from '../../../lib/auth.js';
import { verificarPermissao } from '../../../lib/permissions.js';

export async function onRequestPost(context) {
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

        // Verificar permissao (apenas admin pode exportar templates)
        const temPermissao = await verificarPermissao(env.DB, usuario.id, projetoId, 'admin');
        if (!temPermissao) {
            return new Response(JSON.stringify({ success: false, error: 'Sem permissao para exportar template' }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Obter dados do request
        const body = await request.json().catch(() => ({}));
        const { codigo, nome, descricao, publico = 0 } = body;

        if (!codigo || !nome) {
            return new Response(JSON.stringify({ success: false, error: 'Codigo e nome sao obrigatorios' }), {
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

        // Buscar projeto com todos os dados
        const projeto = await env.DB.prepare(`
            SELECT id, codigo, nome, descricao, icone, cor
            FROM projetos
            WHERE id = ? AND ativo = 1
        `).bind(projetoId).first();

        if (!projeto) {
            return new Response(JSON.stringify({ success: false, error: 'Projeto nao encontrado' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Buscar entidades do projeto
        const entidadesResult = await env.DB.prepare(`
            SELECT id, codigo, nome, nome_plural, descricao, icone, tipo,
                   permite_criar, permite_editar, permite_excluir,
                   permite_importar, permite_exportar, config_funcionalidades
            FROM projeto_entidades
            WHERE projeto_id = ? AND ativo = 1
            ORDER BY ordem, nome
        `).bind(projetoId).all();

        const entidades = [];

        // Para cada entidade, buscar campos e opcoes
        for (const entidade of entidadesResult.results || []) {
            // Buscar campos da entidade
            const camposResult = await env.DB.prepare(`
                SELECT id, codigo, nome, tipo, obrigatorio, ordem, config,
                       placeholder, ajuda, valor_padrao, visivel_listagem,
                       visivel_formulario, visivel_detalhe
                FROM projeto_entidade_campos
                WHERE entidade_id = ?
                ORDER BY ordem
            `).bind(entidade.id).all();

            const campos = [];

            // Para cada campo, buscar opcoes (se for select)
            for (const campo of camposResult.results || []) {
                let opcoes = [];

                if (campo.tipo === 'select' || campo.tipo === 'multiselect') {
                    const opcoesResult = await env.DB.prepare(`
                        SELECT valor, label, cor, icone, ordem
                        FROM projeto_entidade_opcoes
                        WHERE campo_id = ?
                        ORDER BY ordem
                    `).bind(campo.id).all();

                    opcoes = opcoesResult.results || [];
                }

                campos.push({
                    codigo: campo.codigo,
                    nome: campo.nome,
                    tipo: campo.tipo,
                    obrigatorio: campo.obrigatorio,
                    ordem: campo.ordem,
                    config: campo.config ? JSON.parse(campo.config) : null,
                    placeholder: campo.placeholder,
                    ajuda: campo.ajuda,
                    valor_padrao: campo.valor_padrao,
                    visivel_listagem: campo.visivel_listagem,
                    visivel_formulario: campo.visivel_formulario,
                    visivel_detalhe: campo.visivel_detalhe,
                    opcoes: opcoes.map(o => ({
                        valor: o.valor,
                        label: o.label,
                        cor: o.cor,
                        icone: o.icone,
                        ordem: o.ordem
                    }))
                });
            }

            entidades.push({
                codigo: entidade.codigo,
                nome: entidade.nome,
                nome_plural: entidade.nome_plural,
                descricao: entidade.descricao,
                icone: entidade.icone,
                tipo: entidade.tipo,
                permite_criar: entidade.permite_criar,
                permite_editar: entidade.permite_editar,
                permite_excluir: entidade.permite_excluir,
                permite_importar: entidade.permite_importar,
                permite_exportar: entidade.permite_exportar,
                config_funcionalidades: entidade.config_funcionalidades ? JSON.parse(entidade.config_funcionalidades) : null,
                campos
            });
        }

        // Buscar menus do projeto
        const menusResult = await env.DB.prepare(`
            SELECT m.codigo, m.nome, m.url, m.icone, m.ordem,
                   m.pagina_dinamica, m.entidade_id, m.tipo_conteudo,
                   e.codigo as entidade_codigo
            FROM projeto_menus m
            LEFT JOIN projeto_entidades e ON m.entidade_id = e.id
            WHERE m.projeto_id = ? AND m.ativo = 1
            ORDER BY m.ordem
        `).bind(projetoId).all();

        const menus = (menusResult.results || []).map(m => ({
            codigo: m.codigo,
            nome: m.nome,
            url: m.url,
            icone: m.icone,
            ordem: m.ordem,
            pagina_dinamica: m.pagina_dinamica,
            entidade_codigo: m.entidade_codigo,
            tipo_conteudo: m.tipo_conteudo
        }));

        // Montar config_completo
        const configCompleto = {
            versao: '1.0',
            exportado_em: new Date().toISOString(),
            projeto_origem: {
                id: projeto.id,
                codigo: projeto.codigo,
                nome: projeto.nome
            },
            entidades,
            menus,
            dashboard: {
                widgets: []  // TODO: implementar quando dashboard dinamico estiver pronto
            },
            integracao: {
                teams_habilitado: true,
                sharepoint_habilitado: false
            }
        };

        // Verificar se ja existe template com esse codigo
        const templateExistente = await env.DB.prepare(`
            SELECT id FROM projeto_templates WHERE codigo = ?
        `).bind(codigo).first();

        let templateId;

        if (templateExistente) {
            // Atualizar template existente
            await env.DB.prepare(`
                UPDATE projeto_templates
                SET nome = ?, descricao = ?, icone = ?, cor = ?,
                    config_completo = ?, projeto_origem_id = ?,
                    versao = ?, updated_at = CURRENT_TIMESTAMP,
                    publico = ?
                WHERE codigo = ?
            `).bind(
                nome,
                descricao || `Template baseado no projeto ${projeto.nome}`,
                projeto.icone,
                projeto.cor,
                JSON.stringify(configCompleto),
                projetoId,
                '1.0',
                publico,
                codigo
            ).run();

            templateId = templateExistente.id;
        } else {
            // Criar novo template
            const result = await env.DB.prepare(`
                INSERT INTO projeto_templates (
                    codigo, nome, descricao, icone, cor,
                    config_completo, projeto_origem_id, versao,
                    criado_por, publico, ativo
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
            `).bind(
                codigo,
                nome,
                descricao || `Template baseado no projeto ${projeto.nome}`,
                projeto.icone,
                projeto.cor,
                JSON.stringify(configCompleto),
                projetoId,
                '1.0',
                usuario.id,
                publico
            ).run();

            templateId = result.meta.last_row_id;
        }

        return new Response(JSON.stringify({
            success: true,
            message: templateExistente ? 'Template atualizado com sucesso!' : 'Template criado com sucesso!',
            template: {
                id: templateId,
                codigo,
                nome,
                entidades_count: entidades.length,
                menus_count: menus.length,
                campos_count: entidades.reduce((sum, e) => sum + e.campos.length, 0)
            }
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Erro ao exportar template:', error);
        return new Response(JSON.stringify({
            success: false,
            error: 'Erro interno ao exportar template',
            details: error.message
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
