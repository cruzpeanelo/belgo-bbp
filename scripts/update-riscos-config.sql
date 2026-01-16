-- Atualizar Riscos com campos corretos (titulo, probabilidade, impacto, status)
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "kanban",
  "kanban": {
    "campo_coluna": "status",
    "campo_titulo": "titulo",
    "campo_prioridade": "probabilidade"
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "probabilidade", "tipo": "select", "label": "Probabilidade", "opcoes_de": "campo" },
      { "campo": "impacto", "tipo": "select", "label": "Impacto", "opcoes_de": "campo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Titulo do risco...", "campos_busca": ["titulo"] }
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
      { "campo": "titulo", "estilo": "titulo" },
      { "campo": "probabilidade", "estilo": "badge" },
      { "campo": "impacto", "estilo": "badge" }
    ],
    "acoes": ["editar", "teams"]
  },
  "modal": true,
  "acoes": ["editar", "excluir"],
  "teams": { "habilitado": true, "tipo": "risco", "titulo": "⚠️ Risco: {titulo}", "facts": ["status", "probabilidade", "impacto"] },
  "status_editavel": { "campo": "status" },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "kanban", "metricas_grid": 4 }
  }
}' WHERE id = 23 AND projeto_id = 5;
