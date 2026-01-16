-- =====================================================
-- Migration 035: Configurar Dashboard Widgets GTM Clone
-- Projeto 5 (GTM Clone) - Widgets completos para paridade
-- =====================================================

-- Limpar widgets existentes do projeto 5
DELETE FROM projeto_dashboard_widgets WHERE projeto_id = 5;

-- ===========================================
-- LINHA 1: MÉTRICAS PRINCIPAIS (4 widgets)
-- ===========================================

-- Widget 1: Total de Jornadas
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'total_jornadas', 'metrica', 'Total de Jornadas',
'{
    "entidade": "jornadas",
    "tipo_calculo": "total",
    "icone": "route",
    "cor": "blue",
    "link": "/pages/entidade.html?e=jornadas"
}', 1, 1, 1);

-- Widget 2: Documentos
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'total_documentos', 'metrica', 'Documentos',
'{
    "entidade": "documentos",
    "tipo_calculo": "total",
    "icone": "file-text",
    "cor": "purple",
    "link": "/pages/entidade.html?e=documentos"
}', 1, 2, 1);

-- Widget 3: Casos de Teste
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'total_testes', 'metrica', 'Casos de Teste',
'{
    "entidade": "testes",
    "tipo_calculo": "total",
    "icone": "check-square",
    "cor": "green",
    "link": "/pages/entidade.html?e=testes"
}', 1, 3, 1);

-- Widget 4: Participantes
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'total_participantes', 'metrica', 'Participantes',
'{
    "entidade": "participantes",
    "tipo_calculo": "total",
    "icone": "users",
    "cor": "indigo",
    "link": "/pages/entidade.html?e=participantes"
}', 1, 4, 1);

-- ===========================================
-- LINHA 2: GRÁFICOS DE DISTRIBUIÇÃO (2 widgets largos)
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
        "Em Execução": "#3b82f6"
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
        "Marketing": "#ec4899"
    }
}', 2, 6, 1);

-- ===========================================
-- LINHA 3: PROGRESSO E TIMELINE (2 widgets largos)
-- ===========================================

-- Widget 7: Progresso de Testes por Categoria
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'progresso_testes', 'progresso', 'Progresso por Categoria',
'{
    "entidade": "testes",
    "agrupar_por": "categoria",
    "campo_completo": "status",
    "valor_completo": "Aprovado",
    "mostrar_detalhes": true
}', 2, 7, 1);

-- Widget 8: Próximos Marcos
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'proximos_marcos', 'timeline', 'Cronograma',
'{
    "entidade": "cronograma",
    "campo_data": "data",
    "campo_titulo": "titulo",
    "campo_status": "status",
    "limite": 6,
    "filtro": {"tipo": "marco"}
}', 2, 8, 1);

-- ===========================================
-- LINHA 4: LISTAS E TABELAS (3 widgets)
-- ===========================================

-- Widget 9: Últimas Reuniões
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'ultimas_reunioes', 'lista', 'Últimas Reuniões',
'{
    "entidade": "reunioes",
    "ordenar_por": "data",
    "direcao": "desc",
    "limite": 5,
    "campos_exibir": ["titulo", "data", "participantes"],
    "link": "/pages/entidade.html?e=reunioes"
}', 2, 9, 1);

-- Widget 10: Termos do Glossário por Categoria
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'glossario_categorias', 'grafico_barras', 'Glossário por Categoria',
'{
    "entidade": "glossario",
    "agrupar_por": "categoria",
    "orientacao": "horizontal",
    "limite": 10
}', 2, 10, 1);

-- ===========================================
-- LINHA 5: RISCOS E DOCUMENTOS (2 widgets)
-- ===========================================

-- Widget 11: Riscos Ativos
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'riscos_ativos', 'lista', 'Riscos Identificados',
'{
    "entidade": "riscos",
    "filtro": {"status": "!=Fechado"},
    "ordenar_por": "impacto",
    "limite": 5,
    "campos_exibir": ["titulo", "probabilidade", "impacto", "status"],
    "link": "/pages/entidade.html?e=riscos"
}', 2, 11, 1);

-- Widget 12: Documentos por Categoria
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'docs_por_categoria', 'grafico_barras', 'Documentos por Categoria',
'{
    "entidade": "documentos",
    "agrupar_por": "categoria",
    "orientacao": "horizontal",
    "limite": 7
}', 2, 12, 1);

-- ===========================================
-- ATUALIZAR CONFIGURAÇÃO DO DASHBOARD DO PROJETO
-- ===========================================

UPDATE projetos
SET dashboard_config = '{
    "titulo": "Dashboard GTM Clone",
    "subtitulo": "Acompanhamento do projeto GTM Vendas - Salesforce",
    "layout": "grid",
    "colunas": 4,
    "widgets_padrao": ["total_jornadas", "total_documentos", "total_testes", "total_participantes", "testes_por_status", "jornadas_por_area", "progresso_testes", "proximos_marcos"]
}'
WHERE id = 5;
