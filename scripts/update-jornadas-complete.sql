-- =====================================================
-- Configuracao COMPLETA de Jornadas - GTM Clone (Projeto 5)
-- Inclui: filtros, metricas, secoes comparativo_detalhado, badges, info_grid
-- =====================================================

UPDATE projeto_entidades SET config_funcionalidades = '{
  "layout": "cards",
  "colunas": [
    { "campo": "nome", "label": "Processo", "largura": "auto" },
    { "campo": "status", "label": "Status", "largura": "120px", "tipo": "badge" },
    { "campo": "areas_impactadas", "label": "Areas", "largura": "200px" }
  ],
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "status", "tipo": "select", "label": "Status", "opcoes_de": "campo", "opcao_todos": "Todos os Status" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Nome do processo...", "campos_busca": ["nome", "as_is", "to_be", "areas_impactadas"] }
    ]
  },
  "filtros_botoes": [
    { "label": "Todos", "campo": null, "valor": null, "icone": "📋" },
    { "label": "Pendentes", "campo": "status", "valor": "Pendente", "icone": "⏳" },
    { "label": "Em Andamento", "campo": "status", "valor": "Em Andamento", "icone": "🔄" },
    { "label": "Concluidos", "campo": "status", "valor": "Concluido", "icone": "✅" }
  ],
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
    "campos": [
      { "campo": "nome", "estilo": "titulo" },
      { "campo": "status", "estilo": "badge" }
    ],
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
      {
        "tipo": "badges",
        "campo": "areas_impactadas",
        "titulo": "Areas Impactadas",
        "delimitador": "auto"
      },
      {
        "tipo": "info_grid",
        "titulo": "Detalhes Tecnicos",
        "campos": [
          { "campo": "sistemas_tecnicos", "label": "Sistemas Tecnicos", "icone": "💻" },
          { "campo": "fonte_reuniao", "label": "Fonte/Reuniao", "icone": "📅" }
        ]
      },
      {
        "tipo": "badges",
        "campo": "pendencias",
        "titulo": "Pendencias",
        "delimitador": "auto",
        "estilo": "tag-problema"
      },
      {
        "tipo": "badges",
        "campo": "prerequisitos",
        "titulo": "Pre-requisitos",
        "delimitador": "auto"
      }
    ],
    "acoes": ["editar", "teams", "expandir"]
  },
  "modal": true,
  "acoes": ["editar", "excluir", "exportar_csv"],
  "acoes_status": [
    { "icone": "✅", "label": "Marcar Concluido", "campo": "status", "valor": "Concluido" },
    { "icone": "🔄", "label": "Em Andamento", "campo": "status", "valor": "Em Andamento" },
    { "icone": "⏳", "label": "Marcar Pendente", "campo": "status", "valor": "Pendente" }
  ],
  "teams": {
    "habilitado": true,
    "tipo": "jornada",
    "titulo": "🔄 Jornada: {nome}",
    "facts": ["status", "as_is", "to_be", "areas_impactadas", "sistemas_tecnicos", "pendencias"]
  },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "tablet": { "breakpoint": 1024, "metricas_grid": 4 },
    "desktop": { "layout": "cards", "metricas_grid": 4 }
  }
}' WHERE id = 18 AND projeto_id = 5;
