-- =====================================================
-- Migration 003: Configuracoes de Funcionalidades por Entidade
-- Data: 2026-01-15
-- Descricao: Adiciona config_funcionalidades para renderizacao dinamica
-- SEGURO: Apenas adiciona coluna, NAO altera dados existentes
-- =====================================================

-- =====================================================
-- 1. ADICIONAR COLUNA (nao afeta dados existentes)
-- =====================================================
ALTER TABLE projeto_entidades ADD COLUMN config_funcionalidades TEXT;

-- =====================================================
-- 2. CONFIGURAR ENTIDADE: TESTES (id=2)
-- =====================================================
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "tabela",
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "dados", "campo_opcoes": "categoria" },
      { "campo": "status", "tipo": "select", "label": "Status", "opcoes": ["Todos", "Pendente", "Concluido", "Falhou"] },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "CT-XX ou nome...", "campos_busca": ["codigo", "nome"] }
    ],
    "filtro_url": true
  },
  "paginacao": { "habilitado": true, "itens_por_pagina": 20, "max_botoes": 5 },
  "ordenacao": { "campo_padrao": "codigo", "direcao_padrao": "asc" },
  "tabela": {
    "colunas": [
      { "campo": "codigo", "label": "ID", "largura": "80px", "negrito": true },
      { "campo": "nome", "label": "Caso de Teste", "largura": "auto" },
      { "campo": "categoria", "label": "Categoria", "largura": "150px", "estilo": "secundario" },
      { "campo": "status", "label": "Status", "largura": "100px", "tipo": "badge" }
    ],
    "acoes": ["ver", "marcar_concluido", "teams"]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total Filtrado", "icone": "📊", "cor": "blue" },
      { "tipo": "contador", "campo": "status", "valor": "Concluido", "label": "Concluidos", "icone": "✅", "cor": "green" },
      { "tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "⏳", "cor": "yellow" },
      { "tipo": "contador", "campo": "status", "valor": "Falhou", "label": "Falharam", "icone": "❌", "cor": "red" }
    ]
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo": "{codigo}: {nome}",
    "secoes": [
      { "tipo": "header_status", "campos": ["status", "categoria"] },
      { "tipo": "lista", "campo": "passos", "titulo": "Passo a Passo", "ordenada": true },
      { "tipo": "bloco", "campo": "resultadoEsperado", "titulo": "Resultado Esperado" },
      { "tipo": "bloco", "campo": "resultadoObtido", "titulo": "Resultado Obtido", "condicional": true, "cor_status": true },
      { "tipo": "bloco", "campo": "observacoes", "titulo": "Observacoes", "condicional": true, "cor": "warning" }
    ],
    "acoes_rodape": ["marcar_concluido", "marcar_falhou", "marcar_pendente", "teams"]
  },
  "acoes_lote": {
    "exportar_csv": { "habilitado": true, "campos": ["codigo", "nome", "categoria", "status", "sistema", "prioridade"] }
  },
  "teams": { "habilitado": true, "tipo": "teste", "titulo": "📋 Teste: {codigo} - {nome}", "facts": ["status", "categoria", "sistema", "prioridade", "resultadoEsperado"] },
  "persistencia": { "localStorage": true, "kvSync": true, "campo": "status", "endpoint": "/api/testes-status" },
  "status_editavel": { "campo": "status", "confirmar_falhou": true },
  "skeleton": { "metricas": 4, "tabela_linhas": 10 },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "colunas_ocultas": ["categoria"], "metricas_grid": 2, "acoes_menu": true },
    "tablet": { "breakpoint": 1024, "metricas_grid": 4 },
    "desktop": { "layout": "tabela", "metricas_grid": 4 }
  }
}'
WHERE codigo = 'testes' AND projeto_id = 1;

-- =====================================================
-- 3. CONFIGURAR ENTIDADE: JORNADAS (id=3)
-- =====================================================
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards",
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "id", "tipo": "select", "label": "Processo", "opcoes_de": "dados", "campo_opcoes": "id", "campo_label": "nome", "opcao_todos": "Todos os processos" }
    ]
  },
  "paginacao": { "habilitado": false },
  "ordenacao": { "campo_padrao": "ordem", "direcao_padrao": "asc" },
  "card": {
    "header": ["icone", "nome", "status"],
    "secoes": [
      { "tipo": "comparativo", "campos": ["as_is", "to_be"], "titulos": ["AS-IS (Atual)", "TO-BE (Futuro)"] }
    ],
    "acoes": ["teams", "expandir"]
  },
  "metricas": { "habilitado": false },
  "teams": { "habilitado": true, "tipo": "jornada", "titulo": "🔄 Jornada: {nome}", "facts": ["status", "as_is", "to_be"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "cards", "metricas_grid": 4 }
  }
}'
WHERE codigo = 'jornadas' AND projeto_id = 1;

-- =====================================================
-- 4. CONFIGURAR ENTIDADE: REUNIOES (id=5)
-- =====================================================
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "timeline",
  "filtros": {
    "habilitado": true,
    "tipo": "botoes",
    "opcoes": [
      { "valor": "all", "label": "Todas", "default": true },
      { "valor": "workshop", "label": "Workshops", "filtro_campo": "tipo", "contem": true },
      { "valor": "alinhamento", "label": "Alinhamentos", "filtro_campo": "tipo", "contem": true },
      { "valor": "urgente", "label": "Urgentes", "filtro_campo": "titulo", "contem": true }
    ]
  },
  "paginacao": { "habilitado": false },
  "ordenacao": { "campo_padrao": "data", "direcao_padrao": "desc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Reunioes", "icone": "📅", "cor": "blue" },
      { "tipo": "distinct", "campo": "participantes", "label": "Participantes Unicos", "icone": "👥", "cor": "green" },
      { "tipo": "soma_array", "campo": "decisoes", "label": "Decisoes", "icone": "✅", "cor": "yellow" },
      { "tipo": "soma_array", "campo": "acoes", "label": "Acoes", "icone": "📋", "cor": "red" }
    ]
  },
  "card": {
    "header": ["data", "titulo", "duracao"],
    "contadores": ["participantes", "topicos", "decisoes", "acoes"],
    "expansivel": true,
    "secoes_expandidas": [
      { "tipo": "grid_avatares", "campo": "participantes", "titulo": "Participantes" },
      { "tipo": "lista", "campo": "decisoes", "titulo": "Decisoes", "icone": "✅" },
      { "tipo": "lista", "campo": "acoes", "titulo": "Acoes Pendentes", "icone": "📋" },
      { "tipo": "texto_longo", "campo": "resumo", "titulo": "Resumo", "truncar": 180 }
    ],
    "acoes": ["teams", "expandir"]
  },
  "teams": { "habilitado": true, "tipo": "reuniao", "titulo": "📅 Reuniao: {titulo}", "facts": ["data", "duracao", "participantes", "decisoes"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "timeline", "metricas_grid": 2 },
    "desktop": { "layout": "timeline", "metricas_grid": 4 }
  }
}'
WHERE codigo = 'reunioes' AND projeto_id = 1;

-- =====================================================
-- 5. CONFIGURAR ENTIDADE: GLOSSARIO (id=6)
-- =====================================================
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards_agrupados",
  "agrupamento": { "campo": "categoria", "titulo_campo": "categoria" },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "busca", "tipo": "text", "label": "Buscar termo", "placeholder": "Sigla ou nome...", "campos_busca": ["sigla", "termo", "definicao"] }
    ]
  },
  "paginacao": { "habilitado": false },
  "ordenacao": { "campo_padrao": "sigla", "direcao_padrao": "asc" },
  "metricas": { "habilitado": false },
  "card": {
    "campos": [
      { "campo": "sigla", "estilo": "titulo", "cor": "#003B4A" },
      { "campo": "termo", "estilo": "subtitulo" },
      { "campo": "definicao", "estilo": "descricao" }
    ],
    "acoes": ["teams"]
  },
  "teams": { "habilitado": true, "tipo": "termo", "titulo": "📖 Termo: {sigla}", "facts": ["sigla", "termo", "definicao", "categoria"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards_agrupados", "metricas_grid": 2 },
    "desktop": { "layout": "cards_agrupados", "metricas_grid": 4 }
  }
}'
WHERE codigo = 'glossario' AND projeto_id = 1;

-- =====================================================
-- 6. CONFIGURAR ENTIDADE: PARTICIPANTES (id=7)
-- =====================================================
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards_grid",
  "agrupamento": { "campo": "tipo", "ordem": ["keyuser", "equipe", "stakeholder"], "titulos": { "keyuser": "Key Users", "equipe": "Equipe do Projeto", "stakeholder": "Stakeholders" } },
  "filtros": { "habilitado": false },
  "paginacao": { "habilitado": false },
  "ordenacao": { "campo_padrao": "nome", "direcao_padrao": "asc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "contador", "campo": "tipo", "valor": "keyuser", "label": "Key Users", "icone": "👤", "cor": "blue" },
      { "tipo": "contador", "campo": "tipo", "valor": "equipe", "label": "Equipe", "icone": "👥", "cor": "green" },
      { "tipo": "distinct", "campo": "area", "label": "Areas", "icone": "🏢", "cor": "yellow" },
      { "tipo": "total", "label": "Total", "icone": "📊", "cor": "gray" }
    ]
  },
  "card": {
    "avatar": { "campo": "nome", "tipo": "iniciais", "cor_por": "tipo" },
    "campos": [
      { "campo": "nome", "estilo": "titulo" },
      { "campo": "papel", "estilo": "subtitulo" },
      { "campo": "area", "estilo": "badge" },
      { "campo": "expertise", "estilo": "tags", "condicional": true },
      { "campo": "responsabilidade", "estilo": "descricao", "condicional": true }
    ],
    "acoes": ["teams"]
  },
  "teams": { "habilitado": true, "tipo": "participante", "titulo": "👤 Participante: {nome}", "facts": ["nome", "papel", "area", "expertise", "responsabilidade"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards_grid", "metricas_grid": 2, "cards_por_linha": 1 },
    "tablet": { "breakpoint": 1024, "cards_por_linha": 2 },
    "desktop": { "layout": "cards_grid", "metricas_grid": 4, "cards_por_linha": 3 }
  }
}'
WHERE codigo = 'participantes' AND projeto_id = 1;

-- =====================================================
-- 7. VINCULAR MENUS AS ENTIDADES
-- =====================================================
UPDATE projeto_menus SET entidade_id = 2 WHERE nome = 'Testes' AND projeto_id = 1;
UPDATE projeto_menus SET entidade_id = 3 WHERE nome = 'Jornadas' AND projeto_id = 1;
UPDATE projeto_menus SET entidade_id = 5 WHERE nome = 'Reunioes' AND projeto_id = 1;
UPDATE projeto_menus SET entidade_id = 6 WHERE nome = 'Glossario' AND projeto_id = 1;
UPDATE projeto_menus SET entidade_id = 7 WHERE nome = 'Participantes' AND projeto_id = 1;

-- =====================================================
-- FIM DA MIGRATION 003
-- =====================================================
