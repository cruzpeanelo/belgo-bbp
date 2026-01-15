-- =====================================================
-- BELGO BBP - Migration 007: Dashboard Dinamico
-- Sistema de dashboard configuravel por projeto
-- =====================================================

-- 1. Adicionar campo dashboard_config na tabela de projetos
-- Verifica se a coluna existe antes de adicionar
-- (SQLite nao suporta IF NOT EXISTS para ALTER TABLE, entao usamos PRAGMA)
ALTER TABLE projetos ADD COLUMN dashboard_config TEXT;

-- 2. Tabela de widgets de dashboard para configuracao granular
CREATE TABLE IF NOT EXISTS projeto_dashboard_widgets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    projeto_id INTEGER NOT NULL,
    codigo TEXT NOT NULL,
    tipo TEXT NOT NULL,  -- 'metrica', 'grafico_pizza', 'grafico_barras', 'lista', 'progresso', 'timeline', 'tabela'
    titulo TEXT NOT NULL,
    config TEXT,         -- JSON com configuracao especifica do tipo
    posicao_x INTEGER DEFAULT 0,
    posicao_y INTEGER DEFAULT 0,
    largura INTEGER DEFAULT 1,  -- 1 = 1/4 do grid, 2 = 1/2, 4 = full
    altura INTEGER DEFAULT 1,
    ordem INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE
);

-- 3. Indice para busca rapida
CREATE INDEX IF NOT EXISTS idx_dashboard_widgets_projeto ON projeto_dashboard_widgets(projeto_id, ativo);

-- =====================================================
-- Estrutura esperada do campo config por tipo de widget:
-- =====================================================
--
-- tipo: 'metrica'
-- config: {
--   "entidade": "testes",
--   "tipo_calculo": "total",        -- 'total', 'contador', 'soma', 'media', 'distinct'
--   "campo": null,                   -- campo para soma/media/distinct
--   "filtro": {"status": "Concluido"}, -- filtro opcional
--   "icone": "check",
--   "cor": "green",
--   "link": "/pages/entidade.html?e=testes&status=Concluido"
-- }
--
-- tipo: 'grafico_pizza'
-- config: {
--   "entidade": "testes",
--   "agrupar_por": "status",        -- campo para agrupar
--   "cores": {"Concluido": "#10b981", "Pendente": "#f59e0b", "Falhou": "#ef4444"}
-- }
--
-- tipo: 'grafico_barras'
-- config: {
--   "entidade": "testes",
--   "agrupar_por": "categoria",
--   "empilhar_por": "status",       -- opcional, para barras empilhadas
--   "orientacao": "horizontal"      -- 'horizontal' ou 'vertical'
-- }
--
-- tipo: 'lista'
-- config: {
--   "entidade": "pontos_criticos",
--   "filtro": {"status": "!=Resolvido"},
--   "ordenar_por": "severidade",
--   "limite": 5,
--   "campos_exibir": ["titulo", "severidade", "responsavel"],
--   "link": "/pages/entidade.html?e=pontos_criticos"
-- }
--
-- tipo: 'progresso'
-- config: {
--   "entidade": "testes",
--   "agrupar_por": "categoria",
--   "campo_completo": "status",
--   "valor_completo": "Concluido",
--   "mostrar_detalhes": true
-- }
--
-- tipo: 'timeline'
-- config: {
--   "entidade": "cronograma",
--   "campo_data": "data",
--   "campo_titulo": "titulo",
--   "campo_status": "status",
--   "limite": 10
-- }
--
-- tipo: 'tabela'
-- config: {
--   "entidade": "testes",
--   "filtro": {"status": "Pendente"},
--   "colunas": ["codigo", "nome", "responsavel", "prazo"],
--   "limite": 10,
--   "link": "/pages/entidade.html?e=testes"
-- }
-- =====================================================

-- 4. Exemplo de configuracao de dashboard (comentado para referencia)
-- UPDATE projetos SET dashboard_config = '{
--   "titulo": "Dashboard GTM",
--   "subtitulo": "Acompanhamento do projeto",
--   "layout": "grid",
--   "colunas": 4,
--   "widgets_padrao": ["metricas_testes", "progresso_categorias", "pontos_criticos", "timeline"]
-- }' WHERE id = 1;

-- 5. Widgets de exemplo para GTM (comentado)
-- INSERT INTO projeto_dashboard_widgets (projeto_id, codigo, tipo, titulo, config, largura, ordem) VALUES
-- (1, 'total_testes', 'metrica', 'Total de Testes', '{"entidade": "testes", "tipo_calculo": "total", "icone": "chart", "cor": "blue"}', 1, 1),
-- (1, 'testes_ok', 'metrica', 'Concluidos', '{"entidade": "testes", "tipo_calculo": "contador", "filtro": {"status": "Concluido"}, "icone": "check", "cor": "green"}', 1, 2),
-- (1, 'testes_pendentes', 'metrica', 'Pendentes', '{"entidade": "testes", "tipo_calculo": "contador", "filtro": {"status": "Pendente"}, "icone": "clock", "cor": "yellow"}', 1, 3),
-- (1, 'testes_falhou', 'metrica', 'Falharam', '{"entidade": "testes", "tipo_calculo": "contador", "filtro": {"status": "Falhou"}, "icone": "x", "cor": "red"}', 1, 4),
-- (1, 'progresso_cat', 'progresso', 'Progresso por Categoria', '{"entidade": "testes", "agrupar_por": "categoria", "campo_completo": "status", "valor_completo": "Concluido"}', 3, 5),
-- (1, 'pontos_criticos', 'lista', 'Pontos Criticos', '{"entidade": "pontos_criticos", "filtro": {"status": "!=Resolvido"}, "limite": 4, "campos_exibir": ["titulo", "severidade"]}', 1, 6);
