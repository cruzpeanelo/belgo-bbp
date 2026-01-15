-- =====================================================
-- Migration: Criar tabela projeto_menus
-- =====================================================

-- Tabela de menus por projeto
CREATE TABLE IF NOT EXISTS projeto_menus (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    projeto_id INTEGER NOT NULL,
    nome TEXT NOT NULL,
    url TEXT NOT NULL,
    icone TEXT DEFAULT '📄',
    ordem INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (projeto_id) REFERENCES projetos(id)
);

-- Indice para busca por projeto
CREATE INDEX IF NOT EXISTS idx_projeto_menus_projeto ON projeto_menus(projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_menus_ordem ON projeto_menus(projeto_id, ordem);

-- =====================================================
-- Dados iniciais - Menus do projeto GTM (id=1)
-- =====================================================

INSERT OR IGNORE INTO projeto_menus (projeto_id, nome, url, icone, ordem) VALUES
(1, 'Dashboard', 'dashboard.html', '📊', 1),
(1, 'Jornadas', 'jornadas.html', '🗺️', 2),
(1, 'Testes', 'testes.html', '✅', 3),
(1, 'Reunioes', 'reunioes.html', '📅', 4),
(1, 'Pontos Criticos', 'pontos-criticos.html', '⚠️', 5),
(1, 'Participantes', 'participantes.html', '👥', 6),
(1, 'Glossario', 'glossario.html', '📖', 7);

-- =====================================================
-- Dados iniciais - Menus do projeto Rede Ativa (id=2)
-- =====================================================

INSERT OR IGNORE INTO projeto_menus (projeto_id, nome, url, icone, ordem) VALUES
(2, 'Dashboard', 'index.html', '📊', 1),
(2, 'Revendas', 'revendas.html', '🏪', 2),
(2, 'Mapa', 'mapa.html', '🗺️', 3);

-- =====================================================
-- Dados iniciais - Menus do projeto Roadmap (id=3)
-- =====================================================

INSERT OR IGNORE INTO projeto_menus (projeto_id, nome, url, icone, ordem) VALUES
(3, 'Timeline', 'index.html', '📅', 1),
(3, 'Projetos', 'projetos.html', '📁', 2),
(3, 'Iniciativas', 'iniciativas.html', '🎯', 3);
