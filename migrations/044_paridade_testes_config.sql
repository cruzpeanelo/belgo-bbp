-- =====================================================
-- Migration 044: Paridade Config Testes GTM Clone
-- Corrige config_funcionalidades para ficar igual ao GTM Original
-- =====================================================

-- Copiar exatamente a configuracao do GTM Original (projeto 1)
-- para o GTM Clone (projeto 5)

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
WHERE projeto_id = 5 AND codigo = 'testes';

-- Verificar resultado
SELECT id, codigo, nome
FROM projeto_entidades
WHERE projeto_id = 5 AND codigo = 'testes';
