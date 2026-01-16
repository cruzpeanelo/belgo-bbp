-- =====================================================
-- Migration 056: Corrigir Layouts para Paridade Visual
-- Data: Janeiro 2026
-- =====================================================

-- ===========================================
-- PARTE 1: CORRIGIR LAYOUT REUNIÕES
-- O layout 'cards_expandable_rico' não existe
-- Usar 'timeline' que é o layout correto para reuniões
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "timeline",
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
  "card": {
    "header": ["data", "titulo", "duracao", "tipo"],
    "contadores": ["participantes", "topicos", "decisoes"],
    "expansivel": true,
    "secoes_expandidas": [
      { "titulo": "Participantes", "campo": "participantes", "tipo": "grid_avatares", "icone": "👥" },
      { "titulo": "Tópicos Abordados", "campo": "topicos", "tipo": "lista", "icone": "📌" },
      { "titulo": "Decisões Tomadas", "campo": "decisoes", "tipo": "lista", "icone": "✅" },
      { "titulo": "Problemas Identificados", "campo": "problemas", "tipo": "lista", "icone": "⚠️" },
      { "titulo": "Resumo", "campo": "resumo", "tipo": "texto_longo", "truncar": 300, "icone": "📝" }
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
-- PARTE 2: CORRIGIR LAYOUT TIMELINE
-- Usar timeline_fases para mostrar fases do projeto
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "timeline_fases",
  "timeline_fases": {
    "campo_titulo": "nome",
    "campo_status": "status",
    "campo_data_inicio": "data_inicio",
    "campo_data_fim": "data_fim",
    "campo_marcos": "marcos",
    "campo_descricao": "descricao"
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "tipo", "tipo": "select", "label": "Tipo", "opcoes_de": "campo" },
      { "campo": "status", "tipo": "select", "label": "Status", "opcoes_de": "campo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "campos_busca": ["nome", "periodo", "descricao"] }
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
  "paginacao": { "habilitado": false },
  "responsivo": {
    "mobile": { "breakpoint": 768, "metricas_grid": 2 },
    "desktop": { "metricas_grid": 4 }
  }
}'
WHERE codigo = 'timeline' AND projeto_id = 5;

-- ===========================================
-- PARTE 3: CORRIGIR LAYOUT CRONOGRAMA
-- Usar timeline_vertical para eventos cronológicos
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "timeline_vertical",
  "timeline_vertical": {
    "campo_data": "data",
    "campo_titulo": "titulo",
    "campo_tipo": "tipo",
    "campo_status": "status",
    "cores_tipo": {
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
      { "tipo": "total", "label": "Eventos", "icone": "📅", "cor": "blue" },
      { "tipo": "contador", "campo": "status", "valor": "Concluído", "label": "Concluídos", "icone": "✅", "cor": "green" },
      { "tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "⏳", "cor": "yellow" },
      { "tipo": "contador", "campo": "tipo", "valor": "workshop", "label": "Workshops", "icone": "👥", "cor": "purple" }
    ]
  },
  "card": {
    "header": ["data", "titulo", "status"],
    "campos": [
      { "campo": "foco", "tipo": "tags_pipe", "condicional": true },
      { "campo": "destaques", "tipo": "texto", "condicional": true },
      { "campo": "problemas", "tipo": "lista_pipe", "condicional": true }
    ]
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo_campo": "titulo",
    "secoes": [
      { "tipo": "header_status", "campos": ["tipo", "status", "data"] },
      { "tipo": "tags", "campo": "foco", "titulo": "Foco", "condicional": true },
      { "tipo": "texto", "campo": "destaques", "titulo": "Destaques", "condicional": true },
      { "tipo": "lista", "campo": "problemas", "titulo": "Problemas", "condicional": true },
      { "tipo": "info", "campo": "participantes", "label": "Participantes", "icone": "👥", "condicional": true }
    ]
  },
  "paginacao": { "habilitado": false }
}'
WHERE codigo = 'cronograma' AND projeto_id = 5;

-- ===========================================
-- PARTE 4: GARANTIR MENUS CORRETOS
-- ===========================================

-- Atualizar menu Timeline para página dinâmica
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=timeline',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'timeline' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Timeline%' OR nome LIKE '%timeline%');

-- Atualizar menu Cronograma para página dinâmica
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=cronograma',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Cronograma%' OR nome LIKE '%cronograma%');

-- Atualizar menu Reuniões para página dinâmica
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=reunioes',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'reunioes' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Reuni%' OR nome LIKE '%reuni%');

-- Atualizar menu Pontos Críticos para página dinâmica
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=pontos-criticos',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Pontos%' OR nome LIKE '%pontos%');

-- ===========================================
-- FIM DA MIGRATION 056
-- ===========================================
