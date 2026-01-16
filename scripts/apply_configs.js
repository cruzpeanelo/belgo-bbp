/**
 * Script para aplicar config_funcionalidades das 4 entidades
 * Usando Node.js para evitar problemas de escaping SQL
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

function escapeSQL(str) {
    if (!str) return '';
    return str.replace(/'/g, "''");
}

function updateConfig(entidadeId, config, entidadeName) {
    console.log(`\nAtualizando ${entidadeName} (id=${entidadeId})...`);

    const configJson = JSON.stringify(config);
    const escapedConfig = escapeSQL(configJson);

    const sql = `UPDATE projeto_entidades SET config_funcionalidades = '${escapedConfig}' WHERE id = ${entidadeId} AND projeto_id = 5;`;

    const tempFile = path.join(__dirname, '..', `temp_config_${entidadeId}.sql`);
    fs.writeFileSync(tempFile, sql);

    try {
        execSync(`npx wrangler d1 execute belgo-bbp-db --remote --file="${tempFile}"`, {
            encoding: 'utf8',
            maxBuffer: 1024 * 1024 * 50,
            cwd: path.join(__dirname, '..'),
            stdio: ['pipe', 'pipe', 'pipe']
        });
        console.log(`   OK - ${entidadeName} atualizado`);
        fs.unlinkSync(tempFile);
        return true;
    } catch (error) {
        console.error(`   ERRO: ${error.message}`);
        return false;
    }
}

// ============================================
// CONFIGURAÇÕES DAS ENTIDADES
// ============================================

// 1. PONTOS CRITICOS (id=26) - Kanban Board
const configPontosCriticos = {
    layout: "kanban",
    kanban: {
        campo_coluna: "status",
        campo_titulo: "titulo",
        campo_id: "id",
        campo_prioridade: "severidade",
        campo_categoria: "categoria",
        colunas: [
            {valor: "pendente", titulo: "Pendente", cor: "#FEF3C7", corTexto: "#92400E", classe: "pendente", icone: "⏳"},
            {valor: "em_andamento", titulo: "Em Andamento", cor: "#DBEAFE", corTexto: "#1E40AF", classe: "andamento", icone: "🔄"},
            {valor: "resolvido", titulo: "Resolvido", cor: "#D1FAE5", corTexto: "#065F46", classe: "resolvido", icone: "✅"}
        ]
    },
    filtros: {
        habilitado: true,
        campos: [
            {campo: "severidade", tipo: "select", label: "Severidade", opcoes: ["Todas", "Bloqueador", "Crítica", "Alta", "Média", "Baixa"], opcao_todos: "Todas"},
            {campo: "categoria", tipo: "select", label: "Categoria", opcoes_de: "campo", opcao_todos: "Todas"}
        ]
    },
    metricas: {
        habilitado: true,
        cards: [
            {tipo: "total", label: "Total Issues", icone: "⚠️", cor: "blue"},
            {tipo: "contador", campo: "status", valor: "Pendente", label: "Pendentes", icone: "⏳", cor: "yellow"},
            {tipo: "contador", campo: "status", valor: "Em Andamento", label: "Em Andamento", icone: "🔄", cor: "cyan"},
            {tipo: "contador", campo: "status", valor: "Resolvido", label: "Resolvidos", icone: "✅", cor: "green"},
            {tipo: "contador", campo: "severidade", valor: "Bloqueador", label: "Bloqueadores", icone: "🔴", cor: "red"}
        ]
    },
    card: {
        campos: [
            {campo: "id", estilo: "badge_id"},
            {campo: "titulo", estilo: "titulo"},
            {campo: "categoria", estilo: "badge_secundario"},
            {campo: "severidade", estilo: "badge"}
        ],
        acoes: ["editar", "teams"]
    },
    modal_detalhe: {
        habilitado: true,
        titulo: "{id}: {titulo}",
        secoes: [
            {tipo: "header_status", campos: ["severidade", "status", "categoria"]},
            {tipo: "bloco", campo: "descricao", titulo: "Descrição"},
            {tipo: "bloco", campo: "acao_tomada", titulo: "Ação Tomada", condicional: true},
            {tipo: "info_grid", campos: [
                {campo: "responsavel", label: "Responsável", icone: "👤"},
                {campo: "data_identificacao", label: "Identificado em", icone: "📅", formato: "DD/MM/YYYY"},
                {campo: "data_resolucao", label: "Resolvido em", icone: "✅", formato: "DD/MM/YYYY", condicional: true},
                {campo: "fonte_reuniao", label: "Fonte", icone: "📋"}
            ]}
        ]
    },
    teams: {
        habilitado: true,
        tipo: "ponto-critico",
        titulo: "⚠️ {id}: {titulo}",
        facts: ["severidade", "status", "categoria", "descricao", "acao_tomada", "responsavel"]
    },
    acoes: ["editar", "excluir"]
};

// 2. CRONOGRAMA (id=24) - Timeline Zigzag
const configCronograma = {
    layout: "timeline_zigzag",
    timeline_zigzag: {
        campo_titulo: "titulo",
        campo_data: "data",
        campo_descricao: "descricao",
        campo_status: "status",
        campo_tags: "foco"
    },
    filtros: {
        habilitado: true,
        campos: [
            {campo: "tipo", tipo: "select", label: "Tipo", opcoes: ["Todos", "workshop", "marco"], opcao_todos: "Todos"},
            {campo: "status", tipo: "select", label: "Status", opcoes_de: "campo", opcao_todos: "Todos"}
        ]
    },
    metricas: {
        habilitado: true,
        cards: [
            {tipo: "total", label: "Total Itens", icone: "📅", cor: "blue"},
            {tipo: "contador", campo: "tipo", valor: "workshop", label: "Workshops", icone: "🎯", cor: "purple"},
            {tipo: "contador", campo: "tipo", valor: "marco", label: "Marcos", icone: "🏁", cor: "green"},
            {tipo: "contador", campo: "status", valor: "Concluído", label: "Concluídos", icone: "✅", cor: "green"}
        ]
    },
    modal_detalhe: {
        habilitado: true,
        titulo: "{id} - {titulo}",
        secoes: [
            {tipo: "header_status", campos: ["data", "status", "tipo"]},
            {tipo: "bloco", campo: "foco", titulo: "Foco", estilo: "tags", separador: "|"},
            {tipo: "bloco", campo: "problemas", titulo: "Problemas Identificados", estilo: "lista", separador: "|", condicional: true},
            {tipo: "bloco", campo: "destaques", titulo: "Destaques", estilo: "lista", separador: "|", condicional: true},
            {tipo: "info_grid", campos: [
                {campo: "participantes", label: "Participantes", icone: "👥"},
                {campo: "horario", label: "Horário", icone: "🕐", condicional: true}
            ]}
        ]
    },
    teams: {
        habilitado: true,
        tipo: "reuniao",
        titulo: "🗓️ {tipo}: {titulo}",
        facts: ["data", "status", "participantes", "foco"]
    },
    acoes: ["editar", "excluir"]
};

// 3. DOCUMENTOS (id=17) - Card Grid
const configDocumentos = {
    layout: "cards_grid",
    filtros: {
        habilitado: true,
        campos: [
            {campo: "busca", tipo: "text", label: "Buscar", placeholder: "Buscar documentos...", campos_busca: ["arquivo", "titulo", "resumo", "id"]},
            {campo: "categoria", tipo: "select", label: "Categoria", opcoes_de: "campo", opcao_todos: "Todas as Categorias"}
        ]
    },
    metricas: {
        habilitado: true,
        estilo: "stats_bar",
        cards: [
            {tipo: "total", label: "Documentos DOCX", icone: "📄", cor: "purple"},
            {tipo: "distinct", campo: "categoria", label: "Categorias", icone: "📁", cor: "blue"},
            {tipo: "contador", campo: "categoria", valor: "workflow_pricing", label: "Workflow Pricing", icone: "💰", cor: "yellow"}
        ]
    },
    card: {
        estilo: "documento",
        campos: [
            {campo: "id", estilo: "badge_id", prefixo: "#"},
            {campo: "titulo", estilo: "titulo"},
            {campo: "arquivo", estilo: "subtitulo", truncar: 50},
            {campo: "categoria", estilo: "badge_categoria"},
            {tipo: "meta_info", campos: [
                {campo: "total_paragrafos", label: "parágrafos", icone: "📊"},
                {campo: "total_tabelas", label: "tabelas", icone: "📋"}
            ]}
        ],
        icone_tipo: {
            campo: "categoria",
            icones: {
                workflow_pricing: "💰",
                cadastro: "👤",
                fup_carteira: "📦",
                layout_interface: "🎨",
                integracoes: "🔗",
                testes: "✅",
                bot: "🤖",
                "default": "📄"
            }
        },
        acoes: ["editar", "teams"]
    },
    paginacao: {
        habilitado: true,
        itens_por_pagina: 20
    },
    modal_detalhe: {
        habilitado: true,
        titulo: "Documento #{id}",
        secoes: [
            {tipo: "header", campos: ["arquivo", "categoria", "status"]},
            {tipo: "bloco", campo: "resumo", titulo: "Resumo"},
            {tipo: "info_grid", campos: [
                {campo: "total_paragrafos", label: "Parágrafos", icone: "📊"},
                {campo: "total_tabelas", label: "Tabelas", icone: "📋"}
            ]}
        ]
    },
    teams: {
        habilitado: true,
        tipo: "documento",
        titulo: "📄 Documento: {titulo}",
        facts: ["id", "arquivo", "categoria", "resumo"]
    },
    acoes: ["editar", "excluir"]
};

// 4. TIMELINE (id=25) - Fases do Projeto
// NOTA: Os dados estão estruturados como fases com arrays de marcos
const configTimeline = {
    layout: "timeline_fases",
    timeline_fases: {
        campo_titulo: "nome",
        campo_status: "status",
        campo_periodo: "periodo",
        campo_marcos: "marcos",
        campo_descricao: "descricao",
        go_live: {
            habilitado: true,
            data: "2026-03-15",
            label: "GO LIVE - Entrada em Produção"
        }
    },
    filtros: {
        habilitado: true,
        campos: [
            {campo: "status", tipo: "select", label: "Status", opcoes: ["Todos", "concluido", "em_andamento", "planejado"], opcao_todos: "Todos"}
        ]
    },
    metricas: {
        habilitado: true,
        cards: [
            {tipo: "total", label: "Fases", icone: "📅", cor: "blue"},
            {tipo: "contador", campo: "status", valor: "concluido", label: "Concluídas", icone: "✅", cor: "green"},
            {tipo: "contador", campo: "status", valor: "em_andamento", label: "Em Andamento", icone: "🔄", cor: "cyan"},
            {tipo: "contador", campo: "status", valor: "planejado", label: "Planejadas", icone: "📋", cor: "yellow"}
        ]
    },
    modal_detalhe: {
        habilitado: true,
        titulo: "{nome}",
        secoes: [
            {tipo: "header_status", campos: ["status", "periodo"]},
            {tipo: "bloco", campo: "descricao", titulo: "Descrição", condicional: true}
        ]
    },
    teams: {
        habilitado: true,
        tipo: "timeline",
        titulo: "📅 {nome}",
        facts: ["periodo", "status"]
    },
    acoes: ["editar", "excluir"]
};

// ============================================
// EXECUTAR ATUALIZAÇÕES
// ============================================

console.log('=============================================');
console.log('APLICANDO CONFIG_FUNCIONALIDADES');
console.log('=============================================');

let success = true;

success = updateConfig(26, configPontosCriticos, 'pontoscriticos') && success;
success = updateConfig(24, configCronograma, 'cronograma') && success;
success = updateConfig(17, configDocumentos, 'documentos') && success;
success = updateConfig(25, configTimeline, 'timeline') && success;

console.log('\n=============================================');
if (success) {
    console.log('TODAS AS CONFIGS APLICADAS COM SUCESSO!');
} else {
    console.log('ALGUMAS CONFIGS FALHARAM - VERIFICAR ERROS ACIMA');
}
console.log('=============================================');
