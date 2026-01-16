-- =====================================================
-- Migration 037: Paridade 100% GTM Clone vs GTM Original
-- Projeto 5 - Correções para métricas e dashboard
-- =====================================================

-- ===========================================
-- PARTE 1: CORRIGIR CONFIG PARTICIPANTES
-- Valores corretos: key_user, equipe_projeto, stakeholder
-- ===========================================

-- Nota: Os dados usam campo "setor" com valores: key_user, equipe_projeto, stakeholder
UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards_grid",
  "agrupamento": {
    "campo": "setor",
    "ordem": ["keyuser", "equipe_projeto", "stakeholder"],
    "titulos": {
      "keyuser": "Key Users",
      "equipe_projeto": "Equipe do Projeto",
      "stakeholder": "Stakeholders"
    }
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "setor", "tipo": "select", "label": "Tipo" },
      { "campo": "area", "tipo": "select", "label": "Área" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Nome ou papel...", "campos_busca": ["nome", "papel"] }
    ]
  },
  "paginacao": { "habilitado": false },
  "ordenacao": { "campo_padrao": "nome", "direcao_padrao": "asc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "contador", "campo": "setor", "valor": "keyuser", "label": "Key Users", "icone": "👤", "cor": "blue" },
      { "tipo": "contador", "campo": "setor", "valor": "equipe_projeto", "label": "Equipe Projeto", "icone": "👥", "cor": "green" },
      { "tipo": "contador", "campo": "setor", "valor": "stakeholder", "label": "Stakeholders", "icone": "🎯", "cor": "purple" },
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
WHERE codigo = 'participantes' AND projeto_id = 5;

-- ===========================================
-- PARTE 2: CORRIGIR CONFIG REUNIOES
-- Adicionar métricas com suporte a pipe-delimited
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
  "layout": "cards_expandable_rico",
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Buscar reunião...", "campos_busca": ["titulo", "data"] },
      { "campo": "tipo", "tipo": "select", "label": "Tipo" }
    ]
  },
  "paginacao": { "habilitado": false },
  "ordenacao": { "campo_padrao": "data", "direcao_padrao": "desc" },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Reuniões", "icone": "📅", "cor": "blue" },
      { "tipo": "soma_pipe", "campo": "decisoes", "label": "Decisões", "icone": "✅", "cor": "green" },
      { "tipo": "soma_pipe", "campo": "acoes", "label": "Ações", "icone": "⚡", "cor": "yellow" },
      { "tipo": "distinct", "campo": "tipo", "label": "Tipos", "icone": "📋", "cor": "purple" }
    ]
  },
  "card_expandable": {
    "expanded": false,
    "header": [
      { "campo": "data", "estilo": "badge_data", "formato": "data" },
      { "campo": "titulo", "estilo": "titulo" },
      { "campo": "duracao", "estilo": "info", "icone": "⏱️" },
      { "campo": "participantes", "estilo": "count_pipe", "icone": "👥", "sufixo": " participantes" }
    ],
    "secoes": [
      { "titulo": "Participantes", "campo": "participantes", "tipo": "avatares_pipe", "icone": "👥" },
      { "titulo": "Tópicos", "campo": "topicos", "tipo": "tags_pipe", "icone": "📌" },
      { "titulo": "Decisões Tomadas", "campo": "decisoes", "tipo": "lista_check_pipe", "icone": "✅" },
      { "titulo": "Ações Pendentes", "campo": "acoes", "tipo": "lista_warning_pipe", "icone": "⚡" },
      { "titulo": "Resumo", "campo": "resumo", "tipo": "texto", "icone": "📝" }
    ],
    "acoes": ["teams"]
  },
  "teams": { "habilitado": true, "tipo": "reuniao", "titulo": "📅 Reunião: {titulo}", "facts": ["data", "duracao", "participantes", "decisoes", "acoes"] },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards_expandable_rico", "metricas_grid": 2 },
    "desktop": { "layout": "cards_expandable_rico", "metricas_grid": 4 }
  }
}'
WHERE codigo = 'reunioes' AND projeto_id = 5;

-- ===========================================
-- PARTE 3: ADICIONAR WIDGETS KPI DE TESTES
-- Executados, Pendentes, Falharam (como no GTM Original)
-- ===========================================

-- Widget: Testes Executados
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'testes_executados', 'metrica', 'Executados',
'{
    "entidade": "testes",
    "tipo_calculo": "contador",
    "filtro": {"status": "Aprovado"},
    "icone": "check",
    "cor": "green",
    "link": "/pages/entidade.html?e=testes"
}', 1, 13, 1)
ON CONFLICT (projeto_id, codigo) DO UPDATE SET
    config = excluded.config,
    ativo = 1;

-- Widget: Testes Pendentes
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'testes_pendentes', 'metrica', 'Pendentes',
'{
    "entidade": "testes",
    "tipo_calculo": "contador",
    "filtro": {"status": "Pendente"},
    "icone": "clock",
    "cor": "yellow",
    "link": "/pages/entidade.html?e=testes"
}', 1, 14, 1)
ON CONFLICT (projeto_id, codigo) DO UPDATE SET
    config = excluded.config,
    ativo = 1;

-- Widget: Testes Falharam
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'testes_falharam', 'metrica', 'Falharam',
'{
    "entidade": "testes",
    "tipo_calculo": "contador",
    "filtro": {"status": "Falhou"},
    "icone": "x",
    "cor": "red",
    "link": "/pages/entidade.html?e=testes"
}', 1, 15, 1)
ON CONFLICT (projeto_id, codigo) DO UPDATE SET
    config = excluded.config,
    ativo = 1;

-- ===========================================
-- PARTE 4: VERIFICAR TESTES (152 registros)
-- Contar e logar para verificação
-- ===========================================

-- Criar tabela temporária para diagnóstico (opcional, apenas para verificação)
-- SELECT COUNT(*) as total_testes FROM projeto_dados
-- WHERE projeto_id = 5
-- AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5);

-- ===========================================
-- FIM DA MIGRATION 037
-- ===========================================
