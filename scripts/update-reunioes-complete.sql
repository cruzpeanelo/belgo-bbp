-- =====================================================
-- Configuracao COMPLETA de Reunioes - GTM Clone (Projeto 5)
-- Campos: data, titulo, duracao, tipo, resumo, participantes, decisoes, acoes, problemas, topicos
-- =====================================================

UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "timeline",
  "colunas": [
    { "campo": "data", "label": "Data", "largura": "120px", "tipo": "date" },
    { "campo": "titulo", "label": "Titulo", "largura": "auto" },
    { "campo": "tipo", "label": "Tipo", "largura": "120px", "tipo": "badge" },
    { "campo": "duracao", "label": "Duracao", "largura": "80px" }
  ],
  "filtros": {
    "habilitado": true,
    "tipo": "botoes",
    "opcoes": [
      { "valor": "all", "label": "Todas", "default": true },
      { "valor": "workshop", "label": "Workshops", "filtro_campo": "tipo", "contem": true },
      { "valor": "alinhamento", "label": "Alinhamentos", "filtro_campo": "tipo", "contem": true },
      { "valor": "urgente", "label": "Urgentes", "filtro_campo": "titulo", "contem": true }
    ],
    "campos": [
      { "campo": "tipo", "tipo": "select", "label": "Tipo", "opcoes_de": "dados", "campo_opcoes": "tipo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Titulo ou topico...", "campos_busca": ["titulo", "topicos", "resumo"] }
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
      { "tipo": "soma_array", "campo": "acoes", "label": "Acoes Pendentes", "icone": "📋", "cor": "red" }
    ]
  },
  "card": {
    "header": ["data", "titulo", "duracao"],
    "campos": [
      { "campo": "tipo", "estilo": "badge" }
    ],
    "contadores": ["participantes", "topicos", "decisoes", "acoes"],
    "expansivel": true,
    "secoes_expandidas": [
      { "tipo": "grid_avatares", "campo": "participantes", "titulo": "Participantes" },
      { "tipo": "lista", "campo": "topicos", "titulo": "Topicos Discutidos", "icone": "💬" },
      { "tipo": "lista", "campo": "decisoes", "titulo": "Decisoes", "icone": "✅" },
      { "tipo": "lista", "campo": "acoes", "titulo": "Acoes Pendentes", "icone": "📋" },
      { "tipo": "lista", "campo": "problemas", "titulo": "Problemas Levantados", "icone": "⚠️", "condicional": true },
      { "tipo": "texto_longo", "campo": "resumo", "titulo": "Resumo", "truncar": 250 }
    ],
    "acoes": ["editar", "teams", "expandir"]
  },
  "modal": true,
  "acoes": ["editar", "excluir", "exportar_csv"],
  "teams": {
    "habilitado": true,
    "tipo": "reuniao",
    "titulo": "📅 Reuniao: {titulo}",
    "facts": ["data", "duracao", "tipo", "participantes", "decisoes", "acoes"]
  },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "timeline", "metricas_grid": 2 },
    "tablet": { "breakpoint": 1024, "metricas_grid": 4 },
    "desktop": { "layout": "timeline", "metricas_grid": 4 }
  }
}' WHERE id = 20 AND projeto_id = 5;
