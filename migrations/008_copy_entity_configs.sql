-- =====================================================
-- Migration 008: Copiar config_funcionalidades do GTM Original para GTM Clone
-- Projeto 1 (Original) -> Projeto 5 (Clone)
-- =====================================================

-- Testes (id=22) - Layout tabela com filtros, metricas, paginacao
UPDATE projeto_entidades SET config_funcionalidades = '{
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
}' WHERE id = 22 AND projeto_id = 5;

-- Jornadas (id=18) - Layout cards com comparativo AS-IS/TO-BE
UPDATE projeto_entidades SET config_funcionalidades = '{
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
}' WHERE id = 18 AND projeto_id = 5;

-- Reunioes (id=20) - Layout timeline com metricas
UPDATE projeto_entidades SET config_funcionalidades = '{
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
}' WHERE id = 20 AND projeto_id = 5;

-- Glossario (id=21) - Layout cards agrupados por categoria
UPDATE projeto_entidades SET config_funcionalidades = '{
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
}' WHERE id = 21 AND projeto_id = 5;

-- Participantes (id=19) - Layout cards_grid com avatar e agrupamento
UPDATE projeto_entidades SET config_funcionalidades = '{
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
}' WHERE id = 19 AND projeto_id = 5;

-- Riscos (id=23) - Layout kanban com metricas e status
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "kanban",
  "kanban": {
    "campo_coluna": "status",
    "campo_titulo": "nome",
    "campo_descricao": "descricao",
    "campo_prioridade": "probabilidade"
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "probabilidade", "tipo": "select", "label": "Probabilidade", "opcoes": ["Todos", "Alta", "Media", "Baixa"] },
      { "campo": "impacto", "tipo": "select", "label": "Impacto", "opcoes": ["Todos", "Alto", "Medio", "Baixo"] },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Nome ou descricao...", "campos_busca": ["nome", "descricao"] }
    ]
  },
  "paginacao": { "habilitado": false },
  "ordenacao": { "campo_padrao": "probabilidade", "direcao_padrao": "desc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total Riscos", "icone": "⚠️", "cor": "blue" },
      { "tipo": "contador", "campo": "probabilidade", "valor": "Alta", "label": "Alta Prob.", "icone": "🔴", "cor": "red" },
      { "tipo": "contador", "campo": "status", "valor": "Identificado", "label": "Identificados", "icone": "🔍", "cor": "yellow" },
      { "tipo": "contador", "campo": "status", "valor": "Mitigado", "label": "Mitigados", "icone": "✅", "cor": "green" }
    ]
  },
  "card": {
    "campos": [
      { "campo": "nome", "estilo": "titulo" },
      { "campo": "descricao", "estilo": "descricao" },
      { "campo": "probabilidade", "estilo": "badge" },
      { "campo": "impacto", "estilo": "badge" }
    ],
    "acoes": ["editar", "teams"]
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo": "Risco: {nome}",
    "secoes": [
      { "tipo": "header_status", "campos": ["status", "probabilidade", "impacto"] },
      { "tipo": "bloco", "campo": "descricao", "titulo": "Descricao" },
      { "tipo": "bloco", "campo": "mitigacao", "titulo": "Plano de Mitigacao", "condicional": true },
      { "tipo": "bloco", "campo": "contingencia", "titulo": "Plano de Contingencia", "condicional": true }
    ]
  },
  "teams": { "habilitado": true, "tipo": "risco", "titulo": "⚠️ Risco: {nome}", "facts": ["status", "probabilidade", "impacto", "descricao"] },
  "status_editavel": { "campo": "status" },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "kanban", "metricas_grid": 4 }
  }
}' WHERE id = 23 AND projeto_id = 5;
