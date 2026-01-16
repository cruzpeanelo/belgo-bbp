-- Atualizar Jornadas com config completa incluindo todas as secoes
UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "cards",
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "status", "tipo": "select", "label": "Status", "opcoes_de": "campo" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Nome do processo...", "campos_busca": ["nome", "as_is", "to_be"] }
    ]
  },
  "paginacao": { "habilitado": false },
  "ordenacao": { "campo_padrao": "ordem", "direcao_padrao": "asc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total Processos", "icone": "🔄", "cor": "blue" },
      { "tipo": "contador", "campo": "status", "valor": "Concluido", "label": "Concluidos", "icone": "✅", "cor": "green" },
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
          "titulo": "passos_as_is",
          "descricao": "as_is",
          "subtitulo": "tempo_medio_as_is",
          "problemas": "problemas_as_is"
        },
        "to_be": {
          "titulo": "passos_to_be",
          "descricao": "to_be",
          "subtitulo": "tempo_medio_to_be",
          "beneficios": "beneficios_to_be"
        }
      },
      { "tipo": "badges", "campo": "areas_impactadas", "titulo": "Areas Impactadas" },
      { "tipo": "info_grid", "titulo": "Detalhes Tecnicos", "campos": [
        { "campo": "sistemas_tecnicos", "label": "Sistemas" },
        { "campo": "fonte_reuniao", "label": "Fonte" }
      ]},
      { "tipo": "info_grid", "titulo": "Pendencias e Pre-requisitos", "campos": [
        { "campo": "pendencias", "label": "Pendencias" },
        { "campo": "prerequisitos", "label": "Pre-requisitos" }
      ]}
    ],
    "acoes": ["editar", "teams", "expandir"]
  },
  "modal": true,
  "acoes": ["editar", "excluir"],
  "teams": { "habilitado": true, "tipo": "jornada", "titulo": "🔄 Jornada: {nome}", "facts": ["status", "as_is", "to_be", "areas_impactadas"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "cards", "metricas_grid": 4 }
  }
}' WHERE id = 18 AND projeto_id = 5;
