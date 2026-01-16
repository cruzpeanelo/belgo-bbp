-- =====================================================
-- Migration 040: Dashboard KPIs Testes para Paridade
-- Adiciona KPIs especificos de Testes igual GTM Original
-- =====================================================

-- ===========================================
-- ADICIONAR KPIs ESPECÍFICOS DE TESTES
-- Como no dashboard do GTM Original:
-- Total Testes | Executados | Pendentes | Falharam
-- ===========================================

-- Remover widgets antigos de testes para reorganizar
DELETE FROM projeto_dashboard_widgets
WHERE projeto_id = 5
AND codigo IN ('total_testes', 'testes_executados', 'testes_pendentes', 'testes_falharam');

-- Widget: Total de Testes (atualizado)
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'total_testes', 'metrica', 'Total Testes',
'{
    "entidade": "testes",
    "tipo_calculo": "total",
    "icone": "chart",
    "cor": "blue",
    "link": "/pages/entidade.html?e=testes"
}', 1, 1, 1);

-- Widget: Testes Executados (Concluídos)
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'testes_executados', 'metrica', 'Executados',
'{
    "entidade": "testes",
    "tipo_calculo": "contador",
    "filtro": {"status": "Concluido"},
    "icone": "check",
    "cor": "green",
    "link": "/pages/entidade.html?e=testes"
}', 1, 2, 1);

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
}', 1, 3, 1);

-- Widget: Testes que Falharam
INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem, ativo)
VALUES (5, 'testes_falharam', 'metrica', 'Falharam',
'{
    "entidade": "testes",
    "tipo_calculo": "contador",
    "filtro": {"status": "Falhou"},
    "icone": "x",
    "cor": "red",
    "link": "/pages/entidade.html?e=testes"
}', 1, 4, 1);

-- ===========================================
-- REORGANIZAR ORDEM DOS WIDGETS EXISTENTES
-- Para acomodar os 4 KPIs de testes no topo
-- ===========================================

-- Ajustar ordem dos outros widgets
UPDATE projeto_dashboard_widgets SET ordem = 5 WHERE projeto_id = 5 AND codigo = 'total_jornadas';
UPDATE projeto_dashboard_widgets SET ordem = 6 WHERE projeto_id = 5 AND codigo = 'total_documentos';
UPDATE projeto_dashboard_widgets SET ordem = 7 WHERE projeto_id = 5 AND codigo = 'total_participantes';
UPDATE projeto_dashboard_widgets SET ordem = 8 WHERE projeto_id = 5 AND codigo = 'progresso_testes';
UPDATE projeto_dashboard_widgets SET ordem = 9 WHERE projeto_id = 5 AND codigo = 'testes_por_status';
UPDATE projeto_dashboard_widgets SET ordem = 10 WHERE projeto_id = 5 AND codigo = 'jornadas_por_area';
UPDATE projeto_dashboard_widgets SET ordem = 11 WHERE projeto_id = 5 AND codigo = 'proximos_marcos';
UPDATE projeto_dashboard_widgets SET ordem = 12 WHERE projeto_id = 5 AND codigo = 'ultimas_reunioes';
UPDATE projeto_dashboard_widgets SET ordem = 13 WHERE projeto_id = 5 AND codigo = 'glossario_categorias';
UPDATE projeto_dashboard_widgets SET ordem = 14 WHERE projeto_id = 5 AND codigo = 'riscos_ativos';
UPDATE projeto_dashboard_widgets SET ordem = 15 WHERE projeto_id = 5 AND codigo = 'docs_por_categoria';

-- ===========================================
-- ATUALIZAR CONFIGURAÇÃO DO DASHBOARD
-- Para mostrar KPIs de testes primeiro
-- ===========================================

UPDATE projetos
SET dashboard_config = '{
    "titulo": "Dashboard GTM Clone",
    "subtitulo": "Cockpit de Gestao do Projeto GTM",
    "layout": "grid",
    "colunas": 4,
    "widgets_padrao": [
        "total_testes", "testes_executados", "testes_pendentes", "testes_falharam",
        "total_jornadas", "total_documentos", "total_participantes",
        "progresso_testes", "testes_por_status"
    ]
}'
WHERE id = 5;

-- ===========================================
-- VERIFICAR RESULTADO
-- ===========================================
SELECT codigo, titulo, tipo, ordem, ativo
FROM projeto_dashboard_widgets
WHERE projeto_id = 5
ORDER BY ordem;
