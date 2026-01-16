-- =====================================================
-- Migration 053: Configuração Completa das 6 Entidades
-- FASE 26 - Paridade total com GTM Clone
-- Data: Janeiro 2026
-- =====================================================

-- ===========================================
-- PARTE 1: GARANTIR ENTIDADE TIMELINE
-- ===========================================

-- Criar entidade timeline se não existir
INSERT OR IGNORE INTO projeto_entidades (
    projeto_id,
    codigo,
    nome,
    descricao,
    icone,
    permite_criar,
    permite_editar,
    permite_excluir,
    permite_exportar
)
VALUES (
    5,
    'timeline',
    'Timeline',
    'Linha do tempo do projeto GTM com fases e marcos',
    '📈',
    1,
    1,
    1,
    1
);

-- Atualizar config_funcionalidades da timeline
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards_agrupados",
  "agrupamento": {
    "campo": "tipo",
    "ordem": ["fase", "stakeholder", "proximo_passo"],
    "titulos": {
      "fase": "Fases do Projeto",
      "stakeholder": "Stakeholders",
      "proximo_passo": "Próximos Passos"
    }
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "tipo", "tipo": "select", "label": "Tipo" },
      { "campo": "status", "tipo": "select", "label": "Status" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "campos_busca": ["nome", "periodo"] }
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "contador", "campo": "tipo", "valor": "fase", "label": "Fases", "icone": "📅", "cor": "blue" },
      { "tipo": "contador", "campo": "status", "valor": "concluido", "label": "Concluídas", "icone": "✅", "cor": "green" },
      { "tipo": "contador", "campo": "status", "valor": "em_andamento", "label": "Em Andamento", "icone": "🔄", "cor": "yellow" },
      { "tipo": "contador", "campo": "tipo", "valor": "stakeholder", "label": "Stakeholders", "icone": "👥", "cor": "purple" }
    ]
  },
  "card": {
    "campos": [
      { "campo": "nome", "estilo": "titulo" },
      { "campo": "periodo", "estilo": "subtitulo", "condicional": true },
      { "campo": "status", "estilo": "badge" },
      { "campo": "papel", "estilo": "info", "condicional": true },
      { "campo": "area", "estilo": "badge", "condicional": true }
    ]
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo_campo": "nome",
    "secoes": [
      { "tipo": "info_grid", "campos": ["tipo", "status", "periodo", "papel", "area", "prioridade", "prazo"] },
      { "tipo": "json_timeline", "campo": "marcos", "titulo": "Marcos", "condicional": true }
    ]
  },
  "paginacao": { "habilitado": false },
  "responsivo": {
    "mobile": { "breakpoint": 768, "cards_por_linha": 1, "metricas_grid": 2 },
    "desktop": { "cards_por_linha": 3, "metricas_grid": 4 }
  }
}'
WHERE codigo = 'timeline' AND projeto_id = 5;

-- ===========================================
-- PARTE 2: ATUALIZAR CONFIG REUNIÕES
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards_expandable_rico",
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "tipo", "tipo": "botoes", "label": "Tipo", "opcoes": [
        { "valor": "all", "label": "Todas", "default": true },
        { "valor": "workshop", "label": "Workshops" },
        { "valor": "estrategico", "label": "Estratégico" },
        { "valor": "tecnico", "label": "Técnico" },
        { "valor": "operacional", "label": "Operacional" },
        { "valor": "produto", "label": "Produto" }
      ]},
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Buscar reunião...", "campos_busca": ["titulo", "data", "resumo"] }
    ]
  },
  "ordenacao": { "campo_padrao": "data", "direcao_padrao": "desc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Reuniões", "icone": "📅", "cor": "blue" },
      { "tipo": "soma_pipe", "campo": "decisoes", "label": "Decisões", "icone": "✅", "cor": "green" },
      { "tipo": "soma_pipe", "campo": "participantes", "label": "Participações", "icone": "👥", "cor": "purple" },
      { "tipo": "distinct", "campo": "tipo", "label": "Tipos", "icone": "📋", "cor": "gray" }
    ]
  },
  "card_expandable": {
    "expanded": false,
    "header": [
      { "campo": "data", "estilo": "badge_data", "formato": "data" },
      { "campo": "titulo", "estilo": "titulo" },
      { "campo": "duracao", "estilo": "info", "icone": "⏱️" },
      { "campo": "tipo", "estilo": "badge" },
      { "campo": "participantes", "estilo": "count_pipe", "icone": "👥", "sufixo": " participantes" }
    ],
    "secoes": [
      { "titulo": "Participantes", "campo": "participantes", "tipo": "avatares_pipe", "icone": "👥" },
      { "titulo": "Tópicos Abordados", "campo": "topicos", "tipo": "tags_pipe", "icone": "📌" },
      { "titulo": "Decisões Tomadas", "campo": "decisoes", "tipo": "lista_check_pipe", "icone": "✅" },
      { "titulo": "Problemas Identificados", "campo": "problemas", "tipo": "lista_warning_pipe", "icone": "⚠️" },
      { "titulo": "Resumo", "campo": "resumo", "tipo": "texto", "icone": "📝" },
      { "titulo": "Jornadas Relacionadas", "campo": "jornadas_relacionadas", "tipo": "tags_pipe", "icone": "🔗" }
    ]
  },
  "paginacao": { "habilitado": false },
  "responsivo": {
    "mobile": { "breakpoint": 768, "metricas_grid": 2 },
    "desktop": { "metricas_grid": 4 }
  }
}'
WHERE codigo = 'reunioes' AND projeto_id = 5;

-- ===========================================
-- PARTE 3: ATUALIZAR CONFIG DOCUMENTOS
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "tabela",
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "campo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "ID ou nome do documento...", "campos_busca": ["id", "nome", "arquivo", "resumo"] }
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Documentos", "icone": "📄", "cor": "blue" },
      { "tipo": "distinct", "campo": "categoria", "label": "Categorias", "icone": "📁", "cor": "green" },
      { "tipo": "contador", "campo": "categoria", "valor": "workflow_pricing", "label": "WF Pricing", "icone": "💰", "cor": "purple" },
      { "tipo": "contador", "campo": "categoria", "valor": "cadastro", "label": "Cadastro", "icone": "📋", "cor": "yellow" }
    ]
  },
  "tabela": {
    "colunas": [
      { "campo": "id", "label": "ID", "largura": "80px" },
      { "campo": "nome", "label": "Documento", "largura": "auto" },
      { "campo": "categoria", "label": "Categoria", "largura": "150px", "tipo": "badge" },
      { "campo": "status", "label": "Status", "largura": "100px", "tipo": "badge" },
      { "campo": "total_paragrafos", "label": "Parágrafos", "largura": "100px", "alinhamento": "center" }
    ],
    "ordenacao_padrao": { "campo": "id", "direcao": "asc" },
    "hover_expandir": true
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo_campo": "nome",
    "secoes": [
      { "tipo": "header_status", "campos": ["categoria", "status"] },
      { "tipo": "bloco", "campo": "resumo", "titulo": "Resumo" },
      { "tipo": "info_grid", "campos": [
        { "campo": "id", "label": "ID", "icone": "🔢" },
        { "campo": "total_paragrafos", "label": "Parágrafos", "icone": "📝" },
        { "campo": "total_tabelas", "label": "Tabelas", "icone": "📊" }
      ]}
    ]
  },
  "paginacao": {
    "habilitado": true,
    "itens_por_pagina": 20
  },
  "responsivo": {
    "mobile": { "breakpoint": 768, "metricas_grid": 2, "colunas_visiveis": ["nome", "categoria"] },
    "desktop": { "metricas_grid": 4 }
  }
}'
WHERE codigo = 'documentos' AND projeto_id = 5;

-- ===========================================
-- PARTE 4: ATUALIZAR CONFIG CRONOGRAMA
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "timeline",
  "timeline": {
    "campo_data": "data",
    "campo_titulo": "titulo",
    "campo_tipo": "tipo",
    "tipos_cores": {
      "workshop": "#8B5CF6",
      "marco": "#3B82F6"
    }
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "tipo", "tipo": "botoes", "label": "Tipo", "opcoes": [
        { "valor": "all", "label": "Todos", "default": true },
        { "valor": "workshop", "label": "Workshops" },
        { "valor": "marco", "label": "Marcos" }
      ]},
      { "campo": "status", "tipo": "select", "label": "Status", "opcoes_de": "campo" }
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total", "icone": "📅", "cor": "blue" },
      { "tipo": "contador", "campo": "status", "valor": "Concluído", "label": "Concluídos", "icone": "✅", "cor": "green" },
      { "tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "⏳", "cor": "yellow" },
      { "tipo": "contador", "campo": "tipo", "valor": "workshop", "label": "Workshops", "icone": "👥", "cor": "purple" }
    ]
  },
  "card": {
    "header": ["data", "titulo", "status"],
    "campos": [
      { "campo": "foco", "estilo": "tags_pipe", "condicional": true },
      { "campo": "destaques", "estilo": "texto", "condicional": true },
      { "campo": "problemas", "estilo": "lista_warning_pipe", "condicional": true },
      { "campo": "feedback", "estilo": "citacao", "condicional": true }
    ]
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo_campo": "titulo",
    "secoes": [
      { "tipo": "header_status", "campos": ["tipo", "status", "data"] },
      { "tipo": "tags_pipe", "campo": "foco", "titulo": "Foco", "condicional": true },
      { "tipo": "texto", "campo": "destaques", "titulo": "Destaques", "condicional": true },
      { "tipo": "lista_warning_pipe", "campo": "problemas", "titulo": "Problemas Identificados", "condicional": true },
      { "tipo": "citacao", "campo": "feedback", "titulo": "Feedback", "condicional": true },
      { "tipo": "info", "campo": "participantes", "label": "Participantes", "icone": "👥", "condicional": true }
    ]
  },
  "paginacao": { "habilitado": false },
  "responsivo": {
    "mobile": { "breakpoint": 768, "metricas_grid": 2 },
    "desktop": { "metricas_grid": 4 }
  }
}'
WHERE codigo = 'cronograma' AND projeto_id = 5;

-- ===========================================
-- PARTE 5: ATUALIZAR CONFIG GLOSSÁRIO
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards_agrupados",
  "agrupamento": {
    "campo": "categoria",
    "titulo_campo": "categoria",
    "ordem_alfabetica": true
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "campo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar termo", "placeholder": "Sigla, nome ou descrição...", "campos_busca": ["sigla", "nome", "descricao", "contexto"] }
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Termos", "icone": "📚", "cor": "blue" },
      { "tipo": "distinct", "campo": "categoria", "label": "Categorias", "icone": "📁", "cor": "green" },
      { "tipo": "contador", "campo": "categoria", "valor": "Sistemas", "label": "Sistemas", "icone": "💻", "cor": "purple" },
      { "tipo": "contador", "campo": "categoria", "valor": "Processos", "label": "Processos", "icone": "⚙️", "cor": "yellow" }
    ]
  },
  "card": {
    "campos": [
      { "campo": "sigla", "estilo": "titulo", "cor": "#003B4A" },
      { "campo": "nome", "estilo": "subtitulo" },
      { "campo": "descricao", "estilo": "descricao" },
      { "campo": "contexto", "estilo": "info_small", "condicional": true },
      { "campo": "alternativo", "estilo": "badge", "prefixo": "Também: ", "condicional": true }
    ]
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo_campo": "sigla",
    "subtitulo_campo": "nome",
    "secoes": [
      { "tipo": "badge", "campo": "categoria" },
      { "tipo": "bloco", "campo": "descricao", "titulo": "Descrição" },
      { "tipo": "bloco", "campo": "contexto", "titulo": "Contexto de Uso", "condicional": true },
      { "tipo": "info", "campo": "alternativo", "label": "Nome Alternativo", "condicional": true },
      { "tipo": "info", "campo": "status", "label": "Status", "condicional": true }
    ]
  },
  "paginacao": { "habilitado": false },
  "responsivo": {
    "mobile": { "breakpoint": 768, "cards_por_linha": 1, "metricas_grid": 2 },
    "tablet": { "breakpoint": 1024, "cards_por_linha": 2 },
    "desktop": { "cards_por_linha": 3, "metricas_grid": 4 }
  }
}'
WHERE codigo = 'glossario' AND projeto_id = 5;

-- ===========================================
-- PARTE 6: CRIAR ENTIDADE PONTOS CRÍTICOS
-- ===========================================

-- Criar entidade pontos-criticos se não existir
INSERT OR IGNORE INTO projeto_entidades (
    projeto_id,
    codigo,
    nome,
    descricao,
    icone,
    permite_criar,
    permite_editar,
    permite_excluir,
    permite_exportar
)
VALUES (
    5,
    'pontos-criticos',
    'Pontos Críticos',
    'Riscos, problemas e pontos de atenção do projeto',
    '⚠️',
    1,
    1,
    1,
    1
);

-- Atualizar config_funcionalidades dos pontos criticos
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "kanban",
  "kanban": {
    "campo_coluna": "status",
    "colunas": [
      { "valor": "Pendente", "label": "Pendente", "cor": "#EAB308" },
      { "valor": "Em Andamento", "label": "Em Andamento", "cor": "#3B82F6" },
      { "valor": "Resolvido", "label": "Resolvido", "cor": "#22C55E" }
    ],
    "permite_arrastar": true
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "campo" },
      { "campo": "severidade", "tipo": "select", "label": "Severidade", "opcoes": [
        { "valor": "all", "label": "Todas" },
        { "valor": "Crítica", "label": "Crítica" },
        { "valor": "Bloqueador", "label": "Bloqueador" },
        { "valor": "Alta", "label": "Alta" },
        { "valor": "Média", "label": "Média" }
      ]},
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Buscar problema...", "campos_busca": ["titulo", "descricao", "responsavel"] }
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total", "icone": "⚠️", "cor": "blue" },
      { "tipo": "contador", "campo": "severidade", "valor": "Crítica", "label": "Críticos", "icone": "🔴", "cor": "red" },
      { "tipo": "contador", "campo": "status", "valor": "Resolvido", "label": "Resolvidos", "icone": "✅", "cor": "green" },
      { "tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "⏳", "cor": "yellow" }
    ]
  },
  "card": {
    "campos": [
      { "campo": "id", "estilo": "badge_id" },
      { "campo": "titulo", "estilo": "titulo" },
      { "campo": "descricao", "estilo": "descricao", "truncar": 100 },
      { "campo": "severidade", "estilo": "badge", "cores": {
        "Crítica": "red",
        "Bloqueador": "red",
        "Alta": "orange",
        "Média": "yellow"
      }},
      { "campo": "categoria", "estilo": "badge", "cor": "gray" },
      { "campo": "responsavel", "estilo": "avatar_nome", "icone": "👤" }
    ]
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo": "{id}: {titulo}",
    "secoes": [
      { "tipo": "header_status", "campos": ["status", "severidade", "categoria"] },
      { "tipo": "bloco", "campo": "descricao", "titulo": "Descrição" },
      { "tipo": "bloco", "campo": "acao_tomada", "titulo": "Ação Tomada", "condicional": true },
      { "tipo": "bloco", "campo": "impacto", "titulo": "Impacto", "condicional": true },
      { "tipo": "info_grid", "campos": [
        { "campo": "responsavel", "label": "Responsável", "icone": "👤" },
        { "campo": "data_identificacao", "label": "Identificado em", "icone": "📅", "formato": "data" },
        { "campo": "data_resolucao", "label": "Resolvido em", "icone": "✅", "formato": "data", "condicional": true },
        { "campo": "fonte_reuniao", "label": "Fonte", "icone": "📋" }
      ]}
    ]
  },
  "paginacao": { "habilitado": false },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "kanban", "metricas_grid": 4 }
  }
}'
WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

-- ===========================================
-- PARTE 7: CRIAR MENUS PARA NOVAS ENTIDADES
-- ===========================================

-- Menu Timeline (se não existir)
INSERT OR IGNORE INTO projeto_menus (
    projeto_id,
    nome,
    url,
    icone,
    ordem,
    ativo,
    entidade_id
)
SELECT
    5,
    'Timeline',
    '/pages/entidade.html?e=timeline',
    '📈',
    15,
    1,
    id
FROM projeto_entidades WHERE codigo = 'timeline' AND projeto_id = 5;

-- Menu Pontos Críticos (se não existir)
INSERT OR IGNORE INTO projeto_menus (
    projeto_id,
    nome,
    url,
    icone,
    ordem,
    ativo,
    entidade_id
)
SELECT
    5,
    'Pontos Críticos',
    '/pages/entidade.html?e=pontos-criticos',
    '⚠️',
    16,
    1,
    id
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

-- ===========================================
-- PARTE 8: ATUALIZAR MENUS EXISTENTES
-- ===========================================

-- Garantir que os menus existentes apontam para as páginas dinâmicas
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=reunioes',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'reunioes' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Reuniões%' OR nome LIKE '%reunioes%' OR nome LIKE '%Reunioes%');

UPDATE projeto_menus
SET url = '/pages/entidade.html?e=documentos',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'documentos' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Documentos%' OR nome LIKE '%documentos%');

UPDATE projeto_menus
SET url = '/pages/entidade.html?e=cronograma',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Cronograma%' OR nome LIKE '%cronograma%');

UPDATE projeto_menus
SET url = '/pages/entidade.html?e=glossario',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'glossario' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Glossário%' OR nome LIKE '%glossario%' OR nome LIKE '%Glossario%');

-- ===========================================
-- FIM DA MIGRATION 053
-- ===========================================
