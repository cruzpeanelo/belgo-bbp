-- =====================================================
-- Migration 057: Dashboard GTM Clone - Corrigir Widgets
-- Usar entidades reais do projeto
-- =====================================================

-- Limpar widgets existentes do projeto 5
DELETE FROM projeto_dashboard_widgets WHERE projeto_id = 5;

-- ===========================================
-- LINHA 1: MÉTRICAS PRINCIPAIS (4 widgets)
-- ===========================================

-- Widget 1: Total de Jornadas
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'total_jornadas', 'metrica', 'Jornadas',
'{
    "entidade": "jornadas",
    "tipo_calculo": "total",
    "icone": "🚀",
    "cor": "blue",
    "link": "/pages/entidade.html?e=jornadas"
}', 1, 1, 1);

-- Widget 2: Casos de Teste
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'total_testes', 'metrica', 'Casos de Teste',
'{
    "entidade": "testes",
    "tipo_calculo": "total",
    "icone": "✅",
    "cor": "green",
    "link": "/pages/entidade.html?e=testes"
}', 1, 2, 1);

-- Widget 3: Reuniões
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'total_reunioes', 'metrica', 'Reuniões',
'{
    "entidade": "reunioes",
    "tipo_calculo": "total",
    "icone": "📅",
    "cor": "purple",
    "link": "/pages/entidade.html?e=reunioes"
}', 1, 3, 1);

-- Widget 4: Pontos Críticos Pendentes
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'pontos_criticos', 'metrica', 'Pontos Críticos',
'{
    "entidade": "pontos-criticos",
    "tipo_calculo": "condicional",
    "filtro": {"status": "Pendente"},
    "icone": "⚠️",
    "cor": "red",
    "link": "/pages/entidade.html?e=pontos-criticos"
}', 1, 4, 1);

-- ===========================================
-- LINHA 2: GRÁFICOS DE DISTRIBUIÇÃO (2 widgets)
-- ===========================================

-- Widget 5: Progresso de Testes por Status
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'testes_por_status', 'grafico_pizza', 'Testes por Status',
'{
    "entidade": "testes",
    "agrupar_por": "status",
    "cores": {
        "Aprovado": "#10b981",
        "Pendente": "#f59e0b",
        "Falhou": "#ef4444",
        "Em Execução": "#3b82f6",
        "Bloqueado": "#6b7280"
    }
}', 2, 5, 1);

-- Widget 6: Jornadas por Área
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'jornadas_por_area', 'grafico_pizza', 'Jornadas por Área',
'{
    "entidade": "jornadas",
    "agrupar_por": "area",
    "cores": {
        "Cadastro": "#3b82f6",
        "Financeiro": "#10b981",
        "Logística": "#f59e0b",
        "Vendas": "#8b5cf6",
        "Marketing": "#ec4899",
        "Gestão": "#14b8a6",
        "Autoatendimento": "#f97316"
    }
}', 2, 6, 1);

-- ===========================================
-- LINHA 3: PROGRESSO E CRONOGRAMA (2 widgets)
-- ===========================================

-- Widget 7: Progresso de Testes
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'progresso_testes', 'progresso', 'Progresso dos Testes',
'{
    "entidade": "testes",
    "agrupar_por": "categoria",
    "campo_completo": "status",
    "valor_completo": "Aprovado",
    "mostrar_detalhes": true
}', 2, 7, 1);

-- Widget 8: Cronograma de Marcos
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'cronograma_marcos', 'timeline', 'Próximos Marcos',
'{
    "entidade": "cronograma",
    "campo_data": "data",
    "campo_titulo": "titulo",
    "campo_status": "status",
    "limite": 6,
    "filtro": {"tipo": "marco"}
}', 2, 8, 1);

-- ===========================================
-- LINHA 4: LISTAS RECENTES (2 widgets)
-- ===========================================

-- Widget 9: Últimas Reuniões
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'ultimas_reunioes', 'lista', 'Últimas Reuniões',
'{
    "entidade": "reunioes",
    "ordenar_por": "data",
    "direcao": "desc",
    "limite": 5,
    "campos_exibir": ["titulo", "data", "tipo"],
    "link": "/pages/entidade.html?e=reunioes"
}', 2, 9, 1);

-- Widget 10: Pontos Críticos Ativos
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'pontos_ativos', 'lista', 'Pontos Críticos Ativos',
'{
    "entidade": "pontos-criticos",
    "filtro": {"status": "!=Resolvido"},
    "ordenar_por": "severidade",
    "limite": 5,
    "campos_exibir": ["titulo", "severidade", "status"],
    "link": "/pages/entidade.html?e=pontos-criticos"
}', 2, 10, 1);

-- ===========================================
-- LINHA 5: DOCUMENTOS E GLOSSÁRIO (2 widgets)
-- ===========================================

-- Widget 11: Documentos por Categoria
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'docs_por_categoria', 'grafico_barras', 'Documentos por Categoria',
'{
    "entidade": "documentos",
    "agrupar_por": "categoria",
    "orientacao": "horizontal",
    "limite": 8
}', 2, 11, 1);

-- Widget 12: Termos do Glossário
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'glossario_categorias', 'grafico_barras', 'Glossário por Categoria',
'{
    "entidade": "glossario",
    "agrupar_por": "categoria",
    "orientacao": "horizontal",
    "limite": 10
}', 2, 12, 1);

-- ===========================================
-- ATUALIZAR CONFIGURAÇÃO DO DASHBOARD DO PROJETO
-- ===========================================

UPDATE projetos
SET dashboard_config = '{
    "titulo": "Dashboard GTM Clone",
    "subtitulo": "Projeto GTM Vendas - CRM Salesforce",
    "layout": "grid",
    "colunas": 4,
    "widgets_padrao": ["total_jornadas", "total_testes", "total_reunioes", "pontos_criticos", "testes_por_status", "jornadas_por_area", "progresso_testes", "cronograma_marcos"]
}'
WHERE id = 5;

-- ===========================================
-- FIM DA MIGRATION 057
-- ===========================================
