-- =====================================================
-- Migration 002: Plataforma Dinamica e Configuravel
-- Data: 2026-01-15
-- Descricao: Cria estrutura para projetos 100% dinamicos
-- =====================================================

-- =====================================================
-- 1. TABELA: projeto_entidades
-- Define estruturas de dados por projeto
-- =====================================================
CREATE TABLE IF NOT EXISTS projeto_entidades (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    projeto_id INTEGER NOT NULL,

    -- Identificacao
    codigo TEXT NOT NULL,
    nome TEXT NOT NULL,
    nome_plural TEXT,
    descricao TEXT,

    -- Visual
    icone TEXT DEFAULT '📋',

    -- Tipo de dados
    tipo TEXT DEFAULT 'tabela',

    -- Configuracoes
    permite_criar INTEGER DEFAULT 1,
    permite_editar INTEGER DEFAULT 1,
    permite_excluir INTEGER DEFAULT 1,
    permite_importar INTEGER DEFAULT 1,
    permite_exportar INTEGER DEFAULT 1,

    -- Metadados
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE,
    UNIQUE(projeto_id, codigo)
);

CREATE INDEX IF NOT EXISTS idx_projeto_entidades_projeto ON projeto_entidades(projeto_id);

-- =====================================================
-- 2. TABELA: projeto_entidade_campos
-- Define campos de cada entidade
-- =====================================================
CREATE TABLE IF NOT EXISTS projeto_entidade_campos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entidade_id INTEGER NOT NULL,

    -- Identificacao
    codigo TEXT NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT,

    -- Tipo de dado
    tipo TEXT NOT NULL,
    subtipo TEXT,

    -- Validacao
    obrigatorio INTEGER DEFAULT 0,
    unico INTEGER DEFAULT 0,
    valor_padrao TEXT,
    regex_validacao TEXT,
    min_valor TEXT,
    max_valor TEXT,

    -- Exibicao
    ordem INTEGER DEFAULT 0,
    visivel_listagem INTEGER DEFAULT 1,
    visivel_formulario INTEGER DEFAULT 1,
    visivel_mobile INTEGER DEFAULT 1,
    largura_coluna TEXT,

    -- Para campos tipo 'select'
    opcoes_config TEXT,

    -- Para campos tipo 'relation'
    relacao_entidade_id INTEGER,
    relacao_campo_exibir TEXT,

    -- Metadados
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (entidade_id) REFERENCES projeto_entidades(id) ON DELETE CASCADE,
    FOREIGN KEY (relacao_entidade_id) REFERENCES projeto_entidades(id) ON DELETE SET NULL,
    UNIQUE(entidade_id, codigo)
);

CREATE INDEX IF NOT EXISTS idx_projeto_campos_entidade ON projeto_entidade_campos(entidade_id);

-- =====================================================
-- 3. TABELA: projeto_entidade_opcoes
-- Opcoes para campos do tipo select
-- =====================================================
CREATE TABLE IF NOT EXISTS projeto_entidade_opcoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entidade_id INTEGER NOT NULL,
    campo_codigo TEXT NOT NULL,

    valor TEXT NOT NULL,
    label TEXT NOT NULL,
    cor TEXT,
    icone TEXT,
    ordem INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,

    created_at TEXT DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (entidade_id) REFERENCES projeto_entidades(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_projeto_opcoes_entidade ON projeto_entidade_opcoes(entidade_id, campo_codigo);

-- =====================================================
-- 4. TABELA: projeto_dados
-- Armazena dados genericos de qualquer entidade
-- =====================================================
CREATE TABLE IF NOT EXISTS projeto_dados (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    projeto_id INTEGER NOT NULL,
    entidade_id INTEGER NOT NULL,

    -- Dados em JSON
    dados TEXT NOT NULL,

    -- Controle
    criado_por INTEGER,
    atualizado_por INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE,
    FOREIGN KEY (entidade_id) REFERENCES projeto_entidades(id) ON DELETE CASCADE,
    FOREIGN KEY (criado_por) REFERENCES usuarios(id) ON DELETE SET NULL,
    FOREIGN KEY (atualizado_por) REFERENCES usuarios(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_projeto_dados_projeto ON projeto_dados(projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_dados_entidade ON projeto_dados(entidade_id);
CREATE INDEX IF NOT EXISTS idx_projeto_dados_projeto_entidade ON projeto_dados(projeto_id, entidade_id);

-- =====================================================
-- 5. TABELA: projeto_arquivos
-- Gerencia uploads de arquivos
-- =====================================================
CREATE TABLE IF NOT EXISTS projeto_arquivos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    projeto_id INTEGER NOT NULL,
    entidade_id INTEGER,
    registro_id INTEGER,

    -- Arquivo
    nome_original TEXT NOT NULL,
    nome_armazenado TEXT NOT NULL,
    tipo_mime TEXT,
    tamanho INTEGER,
    url TEXT NOT NULL,

    -- Metadados
    descricao TEXT,
    categoria TEXT,

    -- Controle
    enviado_por INTEGER NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE,
    FOREIGN KEY (entidade_id) REFERENCES projeto_entidades(id) ON DELETE SET NULL,
    FOREIGN KEY (enviado_por) REFERENCES usuarios(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_projeto_arquivos_projeto ON projeto_arquivos(projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_arquivos_entidade ON projeto_arquivos(entidade_id);

-- =====================================================
-- 6. TABELA: projeto_templates
-- Templates para criar novos projetos
-- =====================================================
CREATE TABLE IF NOT EXISTS projeto_templates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo TEXT UNIQUE NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT,
    icone TEXT,
    cor TEXT,

    -- Configuracao em JSON
    menus_config TEXT,
    entidades_config TEXT,
    campos_config TEXT,

    -- Estado
    ativo INTEGER DEFAULT 1,
    publico INTEGER DEFAULT 0,

    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 7. ATUALIZAR TABELA: projeto_menus
-- Adicionar novos campos para plataforma dinamica
-- =====================================================

-- Adicionar campo codigo (identificador unico)
ALTER TABLE projeto_menus ADD COLUMN codigo TEXT;

-- Adicionar campo para pagina dinamica
ALTER TABLE projeto_menus ADD COLUMN pagina_dinamica INTEGER DEFAULT 1;

-- Adicionar campo objetivo
ALTER TABLE projeto_menus ADD COLUMN objetivo TEXT;

-- Adicionar campo tipo_conteudo
ALTER TABLE projeto_menus ADD COLUMN tipo_conteudo TEXT;

-- Adicionar campo entidade_id
ALTER TABLE projeto_menus ADD COLUMN entidade_id INTEGER REFERENCES projeto_entidades(id);

-- Adicionar permissoes CRUD
ALTER TABLE projeto_menus ADD COLUMN permissao_criar TEXT DEFAULT 'executor';
ALTER TABLE projeto_menus ADD COLUMN permissao_editar TEXT DEFAULT 'gestor';
ALTER TABLE projeto_menus ADD COLUMN permissao_excluir TEXT DEFAULT 'admin';

-- Adicionar configuracao de upload
ALTER TABLE projeto_menus ADD COLUMN permite_upload INTEGER DEFAULT 0;
ALTER TABLE projeto_menus ADD COLUMN formatos_upload TEXT;

-- Adicionar layout_config
ALTER TABLE projeto_menus ADD COLUMN layout_config TEXT;

-- Adicionar updated_at
ALTER TABLE projeto_menus ADD COLUMN updated_at TEXT DEFAULT CURRENT_TIMESTAMP;

-- Renomear campo existente para padronizar
-- permissao_minima -> permissao_visualizar (se existir)

-- =====================================================
-- 8. DADOS INICIAIS: Templates
-- =====================================================
INSERT OR IGNORE INTO projeto_templates (codigo, nome, descricao, icone, cor, publico) VALUES
('em_branco', 'Projeto em Branco', 'Projeto vazio para configuracao manual', '📝', '#6B7280', 1),
('implementacao_sistema', 'Implementacao de Sistema', 'Template para projetos de implementacao com testes, jornadas e documentos', '🚀', '#003B4A', 1),
('rede_distribuicao', 'Rede de Distribuicao', 'Template para gestao de redes com revendas, mapa e metricas', '🌐', '#00A799', 1),
('roadmap_estrategico', 'Roadmap Estrategico', 'Template para planejamento com iniciativas, OKRs e financeiro', '📅', '#ED1C24', 1),
('gestao_projetos', 'Gestao de Projetos', 'Template para PMO com cronograma, riscos e entregaveis', '📊', '#7C3AED', 1);

-- =====================================================
-- 9. DADOS INICIAIS: Opcoes de UF (Estados do Brasil)
-- Serao usadas por qualquer entidade que tenha campo UF
-- =====================================================
CREATE TABLE IF NOT EXISTS opcoes_uf (
    codigo TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    regiao TEXT NOT NULL
);

INSERT OR IGNORE INTO opcoes_uf (codigo, nome, regiao) VALUES
('AC', 'Acre', 'Norte'),
('AL', 'Alagoas', 'Nordeste'),
('AP', 'Amapa', 'Norte'),
('AM', 'Amazonas', 'Norte'),
('BA', 'Bahia', 'Nordeste'),
('CE', 'Ceara', 'Nordeste'),
('DF', 'Distrito Federal', 'Centro-Oeste'),
('ES', 'Espirito Santo', 'Sudeste'),
('GO', 'Goias', 'Centro-Oeste'),
('MA', 'Maranhao', 'Nordeste'),
('MT', 'Mato Grosso', 'Centro-Oeste'),
('MS', 'Mato Grosso do Sul', 'Centro-Oeste'),
('MG', 'Minas Gerais', 'Sudeste'),
('PA', 'Para', 'Norte'),
('PB', 'Paraiba', 'Nordeste'),
('PR', 'Parana', 'Sul'),
('PE', 'Pernambuco', 'Nordeste'),
('PI', 'Piaui', 'Nordeste'),
('RJ', 'Rio de Janeiro', 'Sudeste'),
('RN', 'Rio Grande do Norte', 'Nordeste'),
('RS', 'Rio Grande do Sul', 'Sul'),
('RO', 'Rondonia', 'Norte'),
('RR', 'Roraima', 'Norte'),
('SC', 'Santa Catarina', 'Sul'),
('SP', 'Sao Paulo', 'Sudeste'),
('SE', 'Sergipe', 'Nordeste'),
('TO', 'Tocantins', 'Norte');

-- =====================================================
-- FIM DA MIGRATION
-- =====================================================
