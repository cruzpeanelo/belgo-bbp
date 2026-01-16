-- =====================================================
-- Migration 050: Jornadas - Adicionar filtro Selecionar Processo
-- Atualiza config_funcionalidades para adicionar filtro dropdown
-- por nome do processo e seção para fontes_reuniao
-- Projeto 5 (GTM Clone) - Entidade ID 18
-- =====================================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards",
  "colunas": [
    {"campo": "nome", "label": "Processo", "largura": "auto"},
    {"campo": "status", "label": "Status", "largura": "120px", "tipo": "badge"},
    {"campo": "areas_impactadas", "label": "Áreas", "largura": "200px"}
  ],
  "filtros": {
    "habilitado": true,
    "campos": [
      {"campo": "nome", "tipo": "select", "label": "Selecionar Processo", "opcoes_de": "campo", "opcao_todos": "Todos os Processos"},
      {"campo": "status", "tipo": "select", "label": "Status", "opcoes_de": "campo", "opcao_todos": "Todos"},
      {"campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Nome ou área...", "campos_busca": ["nome", "as_is", "to_be", "areas_impactadas"]}
    ]
  },
  "filtros_botoes": [
    {"label": "Todos", "campo": null, "valor": null, "icone": "📋"},
    {"label": "Pendentes", "campo": "status", "valor": "Pendente", "icone": "⏳"},
    {"label": "Em Andamento", "campo": "status", "valor": "Em Andamento", "icone": "🔄"},
    {"label": "Concluídos", "campo": "status", "valor": "Concluido", "icone": "✅"}
  ],
  "ordenacao": {
    "campo_padrao": "ordem",
    "direcao_padrao": "asc"
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      {"tipo": "total", "label": "Total", "icone": "🔄", "cor": "blue"},
      {"tipo": "contador", "campo": "status", "valor": "Concluido", "label": "Concluídos", "icone": "✅", "cor": "green"},
      {"tipo": "contador", "campo": "status", "valor": "Em Andamento", "label": "Em Andamento", "icone": "⏳", "cor": "yellow"},
      {"tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "📋", "cor": "gray"}
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
          "tempo": "tempo_medio_as_is",
          "citacoes": "fontes_reuniao"
        },
        "to_be": {
          "subtitulo": "Processo Futuro",
          "descricao": "to_be",
          "passos": "passos_to_be",
          "beneficios": "beneficios_to_be",
          "tempo": "tempo_medio_to_be"
        }
      },
      {"tipo": "mini_cards_grid", "campo": "tipos_conta", "titulo": "Tipos de Conta", "condicional": true, "campos_card": ["tipo", "descricao", "recordType"]},
      {"tipo": "tabela_inline", "campo": "campos_processo", "titulo": "Campos do Cadastro", "colunas": ["campo", "descricao", "preenchimento", "validacao"], "condicional": true},
      {"tipo": "badges", "campo": "areas_impactadas", "titulo": "Áreas Impactadas", "delimitador": "auto"},
      {"tipo": "tabela_inline", "campo": "regras_negocio", "titulo": "Regras de Negócio", "colunas": ["regra", "descricao"], "condicional": true},
      {"tipo": "tabela_inline", "campo": "ciclos_teste", "titulo": "Ciclos de Teste", "colunas": ["documento", "titulo", "ciclo", "status"], "condicional": true, "link_documento": true},
      {"tipo": "tabela_inline", "campo": "abas_interface", "titulo": "Abas da Interface Salesforce", "colunas": ["aba", "descricao"], "condicional": true},
      {"tipo": "tabela_inline", "campo": "mensagens_sistema", "titulo": "Mensagens do Sistema", "colunas": ["tipo", "contexto", "mensagem"], "condicional": true},
      {"tipo": "avatares_grid", "campo": "participantes_reuniao", "titulo": "Participantes das Reuniões", "condicional": true},
      {"tipo": "badges", "campo": "pendencias", "titulo": "Pendências", "estilo": "tag-problema"},
      {"tipo": "badges", "campo": "prerequisitos", "titulo": "Pré-requisitos"},
      {"tipo": "info_grid", "titulo": "Detalhes Técnicos", "campos": [
        {"campo": "sistemas_tecnicos", "label": "Sistemas", "icone": "💻"},
        {"campo": "fonte_reuniao", "label": "Fonte", "icone": "📅"}
      ]},
      {"tipo": "tabela_inline", "campo": "integracoes", "titulo": "Integrações", "colunas": ["origem", "destino", "tipo"], "condicional": true},
      {"tipo": "workflow_visual", "campo": "fluxo_aprovacao", "titulo": "Fluxo de Aprovação", "condicional": true}
    ],
    "acoes": ["editar", "teams", "expandir"]
  },
  "modal": true,
  "acoes": ["editar", "excluir", "exportar_csv"],
  "acoes_status": [
    {"icone": "✅", "label": "Concluído", "campo": "status", "valor": "Concluido"},
    {"icone": "🔄", "label": "Em Andamento", "campo": "status", "valor": "Em Andamento"},
    {"icone": "⏳", "label": "Pendente", "campo": "status", "valor": "Pendente"}
  ],
  "teams": {
    "habilitado": true,
    "tipo": "jornada",
    "titulo": "Jornada: {nome}",
    "facts": ["status", "as_is", "to_be", "areas_impactadas"]
  },
  "responsivo": {
    "mobile": {"breakpoint": 768, "layout": "cards", "metricas_grid": 2},
    "desktop": {"layout": "cards", "metricas_grid": 4}
  }
}'
WHERE projeto_id = 5 AND codigo = 'jornadas';
