-- =====================================================
-- Migration 011: Config funcionalidades COMPLETAS
-- Todas as entidades do Projeto 5 (GTM Clone)
-- =====================================================

-- =====================================================
-- JORNADAS (ID 18) - Config completa com todas as seções
-- =====================================================
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "cards",
  "colunas": [
    { "campo": "nome", "label": "Processo", "largura": "auto" },
    { "campo": "status", "label": "Status", "largura": "120px", "tipo": "badge" },
    { "campo": "areas_impactadas", "label": "Áreas", "largura": "200px" }
  ],
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "status", "tipo": "select", "label": "Status", "opcoes_de": "campo", "opcao_todos": "Todos" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Nome ou área...", "campos_busca": ["nome", "as_is", "to_be", "areas_impactadas"] }
    ]
  },
  "filtros_botoes": [
    { "label": "Todos", "campo": null, "valor": null, "icone": "📋" },
    { "label": "Pendentes", "campo": "status", "valor": "Pendente", "icone": "⏳" },
    { "label": "Em Andamento", "campo": "status", "valor": "Em Andamento", "icone": "🔄" },
    { "label": "Concluídos", "campo": "status", "valor": "Concluido", "icone": "✅" }
  ],
  "ordenacao": { "campo_padrao": "ordem", "direcao_padrao": "asc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total", "icone": "🔄", "cor": "blue" },
      { "tipo": "contador", "campo": "status", "valor": "Concluido", "label": "Concluídos", "icone": "✅", "cor": "green" },
      { "tipo": "contador", "campo": "status", "valor": "Em Andamento", "label": "Em Andamento", "icone": "⏳", "cor": "yellow" },
      { "tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "📋", "cor": "gray" }
    ]
  },
  "card": {
    "header": ["icone", "nome", "status"],
    "expanded": true,
    "secoes": [
      {
        "tipo": "comparativo_detalhado",
        "as_is": {
          "subtitulo": "Processo Atual",
          "descricao": "as_is",
          "passos": "passos_as_is",
          "problemas": "problemas_as_is",
          "tempo": "tempo_medio_as_is"
        },
        "to_be": {
          "subtitulo": "Processo Futuro",
          "descricao": "to_be",
          "passos": "passos_to_be",
          "beneficios": "beneficios_to_be",
          "tempo": "tempo_medio_to_be"
        }
      },
      { "tipo": "badges", "campo": "areas_impactadas", "titulo": "Áreas Impactadas", "delimitador": "auto" },
      { "tipo": "info_grid", "titulo": "Detalhes Técnicos", "campos": [
        { "campo": "sistemas_tecnicos", "label": "Sistemas", "icone": "💻" },
        { "campo": "fonte_reuniao", "label": "Fonte", "icone": "📅" }
      ]},
      { "tipo": "badges", "campo": "pendencias", "titulo": "Pendências", "estilo": "tag-problema" },
      { "tipo": "badges", "campo": "prerequisitos", "titulo": "Pré-requisitos" },
      { "tipo": "json_table", "campo": "tipos_conta", "titulo": "Tipos de Conta", "colunas": ["tipo", "descricao"], "condicional": true },
      { "tipo": "json_table", "campo": "regras_negocio", "titulo": "Regras de Negócio", "colunas": ["regra", "descricao"], "condicional": true },
      { "tipo": "json_table", "campo": "integracoes", "titulo": "Integrações", "colunas": ["origem", "destino", "tipo"], "condicional": true },
      { "tipo": "json_table", "campo": "ciclos_teste", "titulo": "Ciclos de Teste", "colunas": ["documento", "titulo", "status"], "condicional": true }
    ],
    "acoes": ["editar", "teams", "expandir"]
  },
  "modal": true,
  "acoes": ["editar", "excluir", "exportar_csv"],
  "acoes_status": [
    { "icone": "✅", "label": "Concluído", "campo": "status", "valor": "Concluido" },
    { "icone": "🔄", "label": "Em Andamento", "campo": "status", "valor": "Em Andamento" },
    { "icone": "⏳", "label": "Pendente", "campo": "status", "valor": "Pendente" }
  ],
  "teams": { "habilitado": true, "tipo": "jornada", "titulo": "🔄 Jornada: {nome}", "facts": ["status", "as_is", "to_be", "areas_impactadas"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "cards", "metricas_grid": 4 }
  }
}' WHERE id = 18 AND projeto_id = 5;

-- =====================================================
-- TESTES (ID 22) - Config completa tabela com modal detalhado
-- =====================================================
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "tabela",
  "colunas": [
    { "campo": "codigo", "label": "ID", "largura": "80px", "negrito": true },
    { "campo": "nome", "label": "Caso de Teste", "largura": "auto" },
    { "campo": "categoria", "label": "Categoria", "largura": "150px" },
    { "campo": "sistema", "label": "Sistema", "largura": "120px" },
    { "campo": "prioridade", "label": "Prioridade", "largura": "100px", "tipo": "badge" },
    { "campo": "status", "label": "Status", "largura": "100px", "tipo": "badge" }
  ],
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "dados" },
      { "campo": "status", "tipo": "select", "label": "Status", "opcoes_de": "campo" },
      { "campo": "sistema", "tipo": "select", "label": "Sistema", "opcoes_de": "dados" },
      { "campo": "prioridade", "tipo": "select", "label": "Prioridade", "opcoes_de": "campo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "CT-XX ou nome...", "campos_busca": ["codigo", "nome", "passos"] }
    ]
  },
  "filtros_botoes": [
    { "label": "Todos", "campo": null, "valor": null, "icone": "📋" },
    { "label": "Pendentes", "campo": "status", "valor": "Pendente", "icone": "⏳" },
    { "label": "Concluídos", "campo": "status", "valor": "Concluido", "icone": "✅" },
    { "label": "Falhou", "campo": "status", "valor": "Falhou", "icone": "❌" }
  ],
  "paginacao": { "habilitado": true, "itens_por_pagina": 20 },
  "ordenacao": { "campo_padrao": "codigo", "direcao_padrao": "asc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total", "icone": "📊", "cor": "blue" },
      { "tipo": "contador", "campo": "status", "valor": "Concluido", "label": "Concluídos", "icone": "✅", "cor": "green" },
      { "tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "⏳", "cor": "yellow" },
      { "tipo": "contador", "campo": "status", "valor": "Falhou", "label": "Falharam", "icone": "❌", "cor": "red" }
    ]
  },
  "modal": true,
  "modal_detalhe": {
    "titulo": "{codigo}: {nome}",
    "secoes": [
      { "tipo": "header_status", "campos": ["status", "categoria", "sistema", "prioridade"] },
      { "tipo": "passos_numerados", "campo": "passos", "titulo": "Passos do Teste" },
      { "tipo": "bloco", "campo": "resultadoEsperado", "titulo": "Resultado Esperado", "icone": "🎯" },
      { "tipo": "bloco", "campo": "resultadoObtido", "titulo": "Resultado Obtido", "condicional": true, "icone": "📝" },
      { "tipo": "info_grid", "titulo": "Execução", "campos": [
        { "campo": "executor", "label": "Executor", "icone": "👤" },
        { "campo": "data_execucao", "label": "Data", "icone": "📅" }
      ], "condicional": true },
      { "tipo": "bloco", "campo": "observacoes", "titulo": "Observações", "condicional": true, "icone": "💬" }
    ]
  },
  "acoes": ["editar", "excluir", "exportar_csv", "importar_csv"],
  "acoes_status": [
    { "icone": "✅", "label": "Concluído", "campo": "status", "valor": "Concluido" },
    { "icone": "❌", "label": "Falhou", "campo": "status", "valor": "Falhou" },
    { "icone": "⏳", "label": "Pendente", "campo": "status", "valor": "Pendente" }
  ],
  "teams": { "habilitado": true, "tipo": "teste", "titulo": "📋 Teste: {codigo}", "facts": ["nome", "status", "categoria", "resultadoEsperado"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "tabela", "metricas_grid": 4 }
  }
}' WHERE id = 22 AND projeto_id = 5;

-- =====================================================
-- REUNIOES (ID 20) - Config completa timeline expandível
-- =====================================================
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "timeline",
  "colunas": [
    { "campo": "data", "label": "Data", "largura": "100px" },
    { "campo": "titulo", "label": "Título", "largura": "auto" },
    { "campo": "tipo", "label": "Tipo", "largura": "100px", "tipo": "badge" },
    { "campo": "duracao", "label": "Duração", "largura": "80px" }
  ],
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "tipo", "tipo": "select", "label": "Tipo", "opcoes_de": "dados" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Título ou tópico...", "campos_busca": ["titulo", "topicos", "resumo"] }
    ]
  },
  "filtros_botoes": [
    { "label": "Todas", "campo": null, "valor": null, "icone": "📅" },
    { "label": "Workshops", "campo": "tipo", "valor": "workshop", "icone": "🎯" },
    { "label": "Estratégico", "campo": "tipo", "valor": "estrategico", "icone": "📊" },
    { "label": "Técnico", "campo": "tipo", "valor": "tecnico", "icone": "⚙️" }
  ],
  "ordenacao": { "campo_padrao": "data", "direcao_padrao": "desc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Reuniões", "icone": "📅", "cor": "blue" },
      { "tipo": "distinct", "campo": "participantes", "label": "Participantes", "icone": "👥", "cor": "green" },
      { "tipo": "soma_array", "campo": "decisoes", "label": "Decisões", "icone": "✅", "cor": "yellow" },
      { "tipo": "soma_array", "campo": "acoes", "label": "Ações", "icone": "📋", "cor": "red" }
    ]
  },
  "card": {
    "header": ["data", "titulo", "duracao"],
    "campos": [{ "campo": "tipo", "estilo": "badge" }],
    "contadores": ["participantes", "topicos", "decisoes", "acoes"],
    "expansivel": true,
    "secoes_expandidas": [
      { "tipo": "texto_longo", "campo": "resumo", "titulo": "Resumo" },
      { "tipo": "grid_avatares", "campo": "participantes", "titulo": "Participantes" },
      { "tipo": "badges", "campo": "topicos", "titulo": "Tópicos Abordados" },
      { "tipo": "lista", "campo": "decisoes", "titulo": "Decisões", "icone": "✅" },
      { "tipo": "lista", "campo": "acoes", "titulo": "Ações Pendentes", "icone": "📋" },
      { "tipo": "lista", "campo": "problemas", "titulo": "Problemas", "icone": "⚠️", "condicional": true },
      { "tipo": "badges", "campo": "jornadas_relacionadas", "titulo": "Jornadas Relacionadas", "condicional": true }
    ],
    "acoes": ["editar", "teams", "expandir"]
  },
  "modal": true,
  "acoes": ["editar", "excluir", "exportar_csv"],
  "teams": { "habilitado": true, "tipo": "reuniao", "titulo": "📅 Reunião: {titulo}", "facts": ["data", "duracao", "tipo", "decisoes"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "timeline", "metricas_grid": 2 },
    "desktop": { "layout": "timeline", "metricas_grid": 4 }
  }
}' WHERE id = 20 AND projeto_id = 5;

-- =====================================================
-- PARTICIPANTES (ID 19) - Config completa cards_grid com avatar
-- =====================================================
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "cards_grid",
  "agrupamento": { "campo": "tipo", "ordem": ["keyuser", "equipe", "stakeholder"], "titulos": { "keyuser": "Key Users", "equipe": "Equipe do Projeto", "stakeholder": "Stakeholders" } },
  "colunas": [
    { "campo": "nome", "label": "Nome", "largura": "auto" },
    { "campo": "papel", "label": "Papel", "largura": "150px" },
    { "campo": "area", "label": "Área", "largura": "120px" },
    { "campo": "tipo", "label": "Tipo", "largura": "100px", "tipo": "badge" }
  ],
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "tipo", "tipo": "select", "label": "Tipo", "opcoes_de": "campo" },
      { "campo": "area", "tipo": "select", "label": "Área", "opcoes_de": "dados" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Nome ou papel...", "campos_busca": ["nome", "nomeCompleto", "papel", "area"] }
    ]
  },
  "ordenacao": { "campo_padrao": "nome", "direcao_padrao": "asc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "contador", "campo": "tipo", "valor": "keyuser", "label": "Key Users", "icone": "👤", "cor": "blue" },
      { "tipo": "contador", "campo": "tipo", "valor": "equipe", "label": "Equipe", "icone": "👥", "cor": "green" },
      { "tipo": "contador", "campo": "tipo", "valor": "stakeholder", "label": "Stakeholders", "icone": "🎯", "cor": "yellow" },
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
      { "campo": "responsabilidade", "estilo": "descricao", "condicional": true },
      { "campo": "status", "estilo": "badge", "condicional": true }
    ],
    "acoes": ["editar", "teams"]
  },
  "modal": true,
  "acoes": ["editar", "excluir", "exportar_csv"],
  "teams": { "habilitado": true, "tipo": "participante", "titulo": "👤 {nome}", "facts": ["papel", "area", "expertise", "responsabilidade"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards_grid", "metricas_grid": 2, "cards_por_linha": 1 },
    "desktop": { "layout": "cards_grid", "metricas_grid": 4, "cards_por_linha": 3 }
  }
}' WHERE id = 19 AND projeto_id = 5;

-- =====================================================
-- GLOSSARIO (ID 21) - Config completa cards_agrupados
-- =====================================================
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "cards_agrupados",
  "agrupamento": { "campo": "categoria", "titulo_campo": "categoria" },
  "colunas": [
    { "campo": "sigla", "label": "Sigla", "largura": "100px", "negrito": true },
    { "campo": "termo", "label": "Termo", "largura": "auto" },
    { "campo": "categoria", "label": "Categoria", "largura": "150px" }
  ],
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "campo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Sigla ou termo...", "campos_busca": ["sigla", "termo", "definicao", "contexto"] }
    ]
  },
  "ordenacao": { "campo_padrao": "sigla", "direcao_padrao": "asc" },
  "metricas": { "habilitado": false },
  "card": {
    "campos": [
      { "campo": "sigla", "estilo": "titulo", "cor": "#003B4A" },
      { "campo": "termo", "estilo": "subtitulo" },
      { "campo": "definicao", "estilo": "descricao" },
      { "campo": "contexto", "estilo": "info", "condicional": true, "icone": "💡" }
    ],
    "acoes": ["editar", "teams"]
  },
  "modal": true,
  "acoes": ["editar", "excluir", "exportar_csv"],
  "teams": { "habilitado": true, "tipo": "termo", "titulo": "📖 {sigla}", "facts": ["termo", "definicao", "categoria", "contexto"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards_agrupados", "metricas_grid": 2 },
    "desktop": { "layout": "cards_agrupados", "metricas_grid": 4 }
  }
}' WHERE id = 21 AND projeto_id = 5;

-- =====================================================
-- RISCOS (ID 23) - Config completa kanban
-- =====================================================
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "kanban",
  "kanban": {
    "campo_coluna": "status",
    "campo_titulo": "titulo",
    "campo_descricao": "descricao",
    "campo_prioridade": "probabilidade"
  },
  "colunas": [
    { "campo": "titulo", "label": "Risco", "largura": "auto" },
    { "campo": "probabilidade", "label": "Probabilidade", "largura": "120px", "tipo": "badge" },
    { "campo": "impacto", "label": "Impacto", "largura": "100px", "tipo": "badge" },
    { "campo": "status", "label": "Status", "largura": "120px", "tipo": "badge" }
  ],
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "probabilidade", "tipo": "select", "label": "Probabilidade", "opcoes_de": "campo" },
      { "campo": "impacto", "tipo": "select", "label": "Impacto", "opcoes_de": "campo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Título ou descrição...", "campos_busca": ["titulo", "descricao", "mitigacao"] }
    ]
  },
  "ordenacao": { "campo_padrao": "probabilidade", "direcao_padrao": "desc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total", "icone": "⚠️", "cor": "blue" },
      { "tipo": "contador", "campo": "probabilidade", "valor": "Alta", "label": "Alta Prob.", "icone": "🔴", "cor": "red" },
      { "tipo": "contador", "campo": "status", "valor": "Identificado", "label": "Identificados", "icone": "🔍", "cor": "yellow" },
      { "tipo": "contador", "campo": "status", "valor": "Mitigado", "label": "Mitigados", "icone": "✅", "cor": "green" }
    ]
  },
  "card": {
    "campos": [
      { "campo": "titulo", "estilo": "titulo" },
      { "campo": "descricao", "estilo": "descricao", "condicional": true },
      { "campo": "probabilidade", "estilo": "badge" },
      { "campo": "impacto", "estilo": "badge" }
    ],
    "acoes": ["editar", "teams"]
  },
  "modal": true,
  "modal_detalhe": {
    "titulo": "Risco: {titulo}",
    "secoes": [
      { "tipo": "header_status", "campos": ["status", "probabilidade", "impacto"] },
      { "tipo": "bloco", "campo": "descricao", "titulo": "Descrição" },
      { "tipo": "bloco", "campo": "mitigacao", "titulo": "Plano de Mitigação", "condicional": true, "icone": "🛡️" },
      { "tipo": "bloco", "campo": "contingencia", "titulo": "Plano de Contingência", "condicional": true, "icone": "🆘" },
      { "tipo": "info_grid", "titulo": "Informações", "campos": [
        { "campo": "responsavel", "label": "Responsável", "icone": "👤" },
        { "campo": "data_identificacao", "label": "Data Identificação", "icone": "📅" }
      ]}
    ]
  },
  "acoes": ["editar", "excluir", "exportar_csv"],
  "acoes_status": [
    { "icone": "🔍", "label": "Identificado", "campo": "status", "valor": "Identificado" },
    { "icone": "🔄", "label": "Em Tratamento", "campo": "status", "valor": "Em Tratamento" },
    { "icone": "✅", "label": "Mitigado", "campo": "status", "valor": "Mitigado" },
    { "icone": "❌", "label": "Ocorreu", "campo": "status", "valor": "Ocorreu" }
  ],
  "teams": { "habilitado": true, "tipo": "risco", "titulo": "⚠️ Risco: {titulo}", "facts": ["status", "probabilidade", "impacto", "descricao"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "kanban", "metricas_grid": 4 }
  }
}' WHERE id = 23 AND projeto_id = 5;
