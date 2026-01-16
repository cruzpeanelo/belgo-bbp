-- ============================================
-- MIGRACAO 054: Configuracao das Entidades Faltantes
-- Projeto: GTM Clone (projeto_id = 5)
-- Data: 2026-01-16
-- ============================================

-- 1. CRONOGRAMA (id=24) - Timeline com workshops e marcos
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "timeline_vertical",
  "timeline": {
    "campo_data": "data",
    "campo_titulo": "titulo",
    "campo_status": "status",
    "campo_tipo": "tipo",
    "cores_tipo": {
      "workshop": "#003B4A",
      "marco": "#E67E22",
      "default": "#95A5A6"
    },
    "cores_status": {
      "Concluído": "#27AE60",
      "Pendente": "#F39C12",
      "Em Andamento": "#3498DB"
    }
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      {"campo": "tipo", "tipo": "select", "label": "Tipo", "opcoes": ["Todos", "Workshop", "Marco"]},
      {"campo": "status", "tipo": "select", "label": "Status", "opcoes": ["Todos", "Concluído", "Pendente", "Em Andamento"]}
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      {"tipo": "total", "label": "Total", "icone": "📅", "cor": "#003B4A"},
      {"tipo": "contador", "campo": "status", "valor": "Concluído", "label": "Concluídos", "icone": "✅", "cor": "#27AE60"},
      {"tipo": "contador", "campo": "tipo", "valor": "Workshop", "label": "Workshops", "icone": "🎯", "cor": "#E67E22"}
    ]
  },
  "card": {
    "campos": [
      {"campo": "data", "estilo": "data", "formato": "DD/MM/YYYY"},
      {"campo": "titulo", "estilo": "titulo"},
      {"campo": "foco", "estilo": "tags", "separador": "|"},
      {"campo": "participantes", "estilo": "contador", "label": "participantes"},
      {"campo": "status", "estilo": "badge"}
    ]
  }
}'
WHERE id = 24 AND projeto_id = 5;

-- 2. DOCUMENTOS (id=17) - Tabela com filtros
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "tabela",
  "filtros": {
    "habilitado": true,
    "campos": [
      {"campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Buscar documento...", "campos_busca": ["titulo", "arquivo", "resumo"]},
      {"campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "dados", "campo_opcoes": "categoria"}
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      {"tipo": "total", "label": "Documentos", "icone": "📄", "cor": "#003B4A"},
      {"tipo": "distinct", "campo": "categoria", "label": "Categorias", "icone": "📁", "cor": "#27AE60"}
    ]
  },
  "tabela": {
    "colunas": [
      {"campo": "id", "label": "ID", "largura": "80px", "negrito": true},
      {"campo": "arquivo", "label": "Documento", "largura": "auto"},
      {"campo": "categoria", "label": "Categoria", "largura": "150px", "tipo": "badge"},
      {"campo": "status", "label": "Status", "largura": "100px", "tipo": "badge"}
    ]
  },
  "paginacao": {
    "habilitado": true,
    "itens_por_pagina": 20
  },
  "modal_detalhe": {
    "titulo": "Documento {id}",
    "secoes": [
      {"tipo": "header", "campos": ["arquivo", "categoria", "status"]},
      {"tipo": "bloco", "campo": "resumo", "titulo": "Resumo"}
    ]
  }
}'
WHERE id = 17 AND projeto_id = 5;

-- 3. PONTOS CRITICOS (id=26) - Kanban por status
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "kanban",
  "kanban": {
    "campo_coluna": "status",
    "colunas": [
      {"valor": "Pendente", "label": "Pendente", "cor": "#F39C12"},
      {"valor": "Em Andamento", "label": "Em Andamento", "cor": "#3498DB"},
      {"valor": "Resolvido", "label": "Resolvido", "cor": "#27AE60"}
    ],
    "campo_titulo": "titulo",
    "campo_descricao": "descricao",
    "campo_prioridade": "severidade"
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      {"campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Buscar issue...", "campos_busca": ["titulo", "descricao"]},
      {"campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "dados"},
      {"campo": "severidade", "tipo": "select", "label": "Severidade", "opcoes": ["Todas", "Crítica", "Bloqueador", "Alta", "Média"]}
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      {"tipo": "total", "label": "Total Issues", "icone": "⚠️", "cor": "#003B4A"},
      {"tipo": "contador", "campo": "severidade", "valor": "Crítica", "label": "Críticos", "icone": "🔴", "cor": "#E74C3C"},
      {"tipo": "contador", "campo": "status", "valor": "Resolvido", "label": "Resolvidos", "icone": "✅", "cor": "#27AE60"},
      {"tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "⏳", "cor": "#F39C12"}
    ]
  },
  "card": {
    "campos": [
      {"campo": "id", "estilo": "badge", "prefixo": ""},
      {"campo": "titulo", "estilo": "titulo"},
      {"campo": "descricao", "estilo": "descricao", "truncar": 100},
      {"campo": "severidade", "estilo": "badge"},
      {"campo": "categoria", "estilo": "badge_secundario"},
      {"campo": "responsavel", "estilo": "avatar", "icone": "👤"}
    ]
  },
  "modal_detalhe": {
    "titulo": "{id}: {titulo}",
    "secoes": [
      {"tipo": "header_status", "campos": ["status", "severidade", "categoria"]},
      {"tipo": "bloco", "campo": "descricao", "titulo": "Descrição"},
      {"tipo": "bloco", "campo": "acao_tomada", "titulo": "Ação Tomada", "condicional": true},
      {"tipo": "info_grid", "campos": [
        {"campo": "responsavel", "label": "Responsável", "icone": "👤"},
        {"campo": "data_identificacao", "label": "Identificado em", "icone": "📅", "formato": "DD/MM/YYYY"},
        {"campo": "data_resolucao", "label": "Resolvido em", "icone": "✅", "formato": "DD/MM/YYYY", "condicional": true},
        {"campo": "fonte_reuniao", "label": "Fonte", "icone": "📋"}
      ]}
    ]
  }
}'
WHERE id = 26 AND projeto_id = 5;

-- 4. TIMELINE (id=25) - Timeline visual do projeto
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "timeline_fases",
  "timeline": {
    "campo_data": "data",
    "campo_evento": "evento",
    "campo_tipo": "tipo",
    "campo_fase": "fase",
    "campo_status": "status",
    "cores_tipo": {
      "go_live": "#E74C3C",
      "marco": "#E67E22",
      "reunião": "#3498DB",
      "documento": "#9B59B6",
      "default": "#95A5A6"
    },
    "cores_status": {
      "concluido": "#27AE60",
      "em_andamento": "#F39C12",
      "planejado": "#95A5A6"
    }
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      {"campo": "fase", "tipo": "select", "label": "Fase", "opcoes_de": "dados"},
      {"campo": "tipo", "tipo": "select", "label": "Tipo", "opcoes": ["Todos", "Marco", "Reunião", "Documento", "Go Live"]},
      {"campo": "status", "tipo": "select", "label": "Status", "opcoes_de": "dados"}
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      {"tipo": "total", "label": "Eventos", "icone": "📅", "cor": "#003B4A"},
      {"tipo": "contador", "campo": "status", "valor": "concluido", "label": "Concluídos", "icone": "✅", "cor": "#27AE60"},
      {"tipo": "contador", "campo": "tipo", "valor": "marco", "label": "Marcos", "icone": "🎯", "cor": "#E67E22"}
    ]
  },
  "card": {
    "campos": [
      {"campo": "data", "estilo": "data", "formato": "DD/MM/YYYY"},
      {"campo": "evento", "estilo": "titulo"},
      {"campo": "fase", "estilo": "badge"},
      {"campo": "tipo", "estilo": "badge_secundario"},
      {"campo": "participantes", "estilo": "avatares_mini", "max": 3}
    ]
  },
  "agrupamento": {
    "campo": "fase",
    "ordem_personalizada": ["Fase 1 - Discovery", "Fase 2 - Workshops AS-IS/TO-BE", "Fase 3 - Desenvolvimento/Testes", "Fase 4 - UAT e Validação", "Fase 5 - Treinamento e Preparação GO LIVE"]
  }
}'
WHERE id = 25 AND projeto_id = 5;

-- Verificar atualizacoes
SELECT id, codigo,
       CASE WHEN config_funcionalidades IS NOT NULL THEN 'OK' ELSE 'NULL' END as config_status
FROM projeto_entidades
WHERE projeto_id = 5
ORDER BY codigo;
