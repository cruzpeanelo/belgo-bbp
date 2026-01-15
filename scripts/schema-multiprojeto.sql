-- =====================================================
-- BELGO BBP - Schema Multi-Projeto
-- Extensao do schema original para suporte multi-projeto
-- =====================================================

-- =====================================================
-- NOVAS TABELAS - SISTEMA MULTI-PROJETO
-- =====================================================

-- Projetos
CREATE TABLE IF NOT EXISTS projetos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo TEXT UNIQUE NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT,
    icone TEXT DEFAULT '📁',
    cor TEXT DEFAULT '#003B4A',
    ativo INTEGER DEFAULT 1,
    visibilidade TEXT DEFAULT 'privado',
    template_origem_id INTEGER,
    criado_por INTEGER NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (criado_por) REFERENCES usuarios(id),
    FOREIGN KEY (template_origem_id) REFERENCES projetos(id)
);

-- Papeis (Admin, Gestor, Key User, Executor, Visualizador)
CREATE TABLE IF NOT EXISTS papeis (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo TEXT UNIQUE NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT,
    nivel INTEGER DEFAULT 0,
    cor TEXT
);

-- Permissoes granulares por modulo/entidade
CREATE TABLE IF NOT EXISTS permissoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo TEXT UNIQUE NOT NULL,
    nome TEXT NOT NULL,
    descricao TEXT,
    modulo_id INTEGER,
    entidade TEXT NOT NULL,
    acao TEXT NOT NULL,
    FOREIGN KEY (modulo_id) REFERENCES modulos(id)
);

-- Mapeamento Papel -> Permissoes (template de permissoes por papel)
CREATE TABLE IF NOT EXISTS papel_permissoes (
    papel_id INTEGER NOT NULL,
    permissao_id INTEGER NOT NULL,
    PRIMARY KEY (papel_id, permissao_id),
    FOREIGN KEY (papel_id) REFERENCES papeis(id),
    FOREIGN KEY (permissao_id) REFERENCES permissoes(id)
);

-- Vinculo Usuario -> Projeto -> Papel (com ajustes individuais)
CREATE TABLE IF NOT EXISTS usuario_projeto_papel (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    projeto_id INTEGER NOT NULL,
    papel_id INTEGER NOT NULL,
    permissoes_extras TEXT,
    permissoes_removidas TEXT,
    ativo INTEGER DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(usuario_id, projeto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (projeto_id) REFERENCES projetos(id),
    FOREIGN KEY (papel_id) REFERENCES papeis(id)
);

-- Modulos habilitados por projeto
CREATE TABLE IF NOT EXISTS projeto_modulos (
    projeto_id INTEGER NOT NULL,
    modulo_id INTEGER NOT NULL,
    config TEXT,
    ativo INTEGER DEFAULT 1,
    ordem INTEGER DEFAULT 0,
    PRIMARY KEY (projeto_id, modulo_id),
    FOREIGN KEY (projeto_id) REFERENCES projetos(id),
    FOREIGN KEY (modulo_id) REFERENCES modulos(id)
);

-- =====================================================
-- INDICES PARA NOVAS TABELAS
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_projetos_codigo ON projetos(codigo);
CREATE INDEX IF NOT EXISTS idx_projetos_ativo ON projetos(ativo);
CREATE INDEX IF NOT EXISTS idx_usuario_projeto ON usuario_projeto_papel(usuario_id, projeto_id);
CREATE INDEX IF NOT EXISTS idx_projeto_papel ON usuario_projeto_papel(projeto_id, papel_id);
CREATE INDEX IF NOT EXISTS idx_projeto_modulos ON projeto_modulos(projeto_id);
CREATE INDEX IF NOT EXISTS idx_permissoes_entidade ON permissoes(entidade, acao);

-- =====================================================
-- DADOS INICIAIS - PAPEIS PADRAO
-- =====================================================

INSERT OR IGNORE INTO papeis (codigo, nome, descricao, nivel, cor) VALUES
    ('admin', 'Administrador', 'Acesso total ao projeto', 100, '#DC2626'),
    ('gestor', 'Gestor', 'Gerencia equipe e aprova entregas', 50, '#2563EB'),
    ('key_user', 'Key User', 'Usuario-chave com permissoes expandidas', 30, '#059669'),
    ('executor', 'Executor', 'Executa testes e tarefas', 10, '#7C3AED'),
    ('visualizador', 'Visualizador', 'Apenas visualizacao', 0, '#6B7280');

-- =====================================================
-- DADOS INICIAIS - PERMISSOES PADRAO
-- =====================================================

-- Permissoes para Testes
INSERT OR IGNORE INTO permissoes (codigo, nome, descricao, entidade, acao) VALUES
    ('teste.ver', 'Ver Testes', 'Visualizar lista e detalhes de testes', 'teste', 'ver'),
    ('teste.criar', 'Criar Testes', 'Criar novos casos de teste', 'teste', 'criar'),
    ('teste.editar', 'Editar Testes', 'Editar casos de teste existentes', 'teste', 'editar'),
    ('teste.excluir', 'Excluir Testes', 'Excluir casos de teste', 'teste', 'excluir'),
    ('teste.executar', 'Executar Testes', 'Executar e atualizar status de testes', 'teste', 'executar');

-- Permissoes para Jornadas
INSERT OR IGNORE INTO permissoes (codigo, nome, descricao, entidade, acao) VALUES
    ('jornada.ver', 'Ver Jornadas', 'Visualizar jornadas do cliente', 'jornada', 'ver'),
    ('jornada.criar', 'Criar Jornadas', 'Criar novas jornadas', 'jornada', 'criar'),
    ('jornada.editar', 'Editar Jornadas', 'Editar jornadas existentes', 'jornada', 'editar'),
    ('jornada.excluir', 'Excluir Jornadas', 'Excluir jornadas', 'jornada', 'excluir');

-- Permissoes para Reunioes
INSERT OR IGNORE INTO permissoes (codigo, nome, descricao, entidade, acao) VALUES
    ('reuniao.ver', 'Ver Reunioes', 'Visualizar atas de reuniao', 'reuniao', 'ver'),
    ('reuniao.criar', 'Criar Reunioes', 'Criar novas atas de reuniao', 'reuniao', 'criar'),
    ('reuniao.editar', 'Editar Reunioes', 'Editar atas de reuniao', 'reuniao', 'editar'),
    ('reuniao.excluir', 'Excluir Reunioes', 'Excluir atas de reuniao', 'reuniao', 'excluir');

-- Permissoes para Glossario
INSERT OR IGNORE INTO permissoes (codigo, nome, descricao, entidade, acao) VALUES
    ('glossario.ver', 'Ver Glossario', 'Visualizar termos do glossario', 'glossario', 'ver'),
    ('glossario.criar', 'Criar Termos', 'Adicionar termos ao glossario', 'glossario', 'criar'),
    ('glossario.editar', 'Editar Termos', 'Editar termos do glossario', 'glossario', 'editar'),
    ('glossario.excluir', 'Excluir Termos', 'Excluir termos do glossario', 'glossario', 'excluir');

-- Permissoes para Participantes
INSERT OR IGNORE INTO permissoes (codigo, nome, descricao, entidade, acao) VALUES
    ('participante.ver', 'Ver Participantes', 'Visualizar participantes', 'participante', 'ver'),
    ('participante.criar', 'Criar Participantes', 'Adicionar participantes', 'participante', 'criar'),
    ('participante.editar', 'Editar Participantes', 'Editar participantes', 'participante', 'editar'),
    ('participante.excluir', 'Excluir Participantes', 'Excluir participantes', 'participante', 'excluir');

-- Permissoes para Projeto (administracao)
INSERT OR IGNORE INTO permissoes (codigo, nome, descricao, entidade, acao) VALUES
    ('projeto.ver', 'Ver Projeto', 'Ver detalhes do projeto', 'projeto', 'ver'),
    ('projeto.editar', 'Editar Projeto', 'Editar configuracoes do projeto', 'projeto', 'editar'),
    ('projeto.membros', 'Gerenciar Membros', 'Adicionar/remover membros do projeto', 'projeto', 'membros');

-- =====================================================
-- MAPEAMENTO PAPEL -> PERMISSOES
-- =====================================================

-- Admin: todas as permissoes (nivel 100 garante acesso total)

-- Gestor: ver tudo + editar + executar + gerenciar membros
INSERT OR IGNORE INTO papel_permissoes (papel_id, permissao_id)
SELECT p.id, perm.id FROM papeis p, permissoes perm
WHERE p.codigo = 'gestor' AND perm.acao IN ('ver', 'editar', 'executar', 'membros');

-- Key User: ver tudo + criar + editar + executar
INSERT OR IGNORE INTO papel_permissoes (papel_id, permissao_id)
SELECT p.id, perm.id FROM papeis p, permissoes perm
WHERE p.codigo = 'key_user' AND perm.acao IN ('ver', 'criar', 'editar', 'executar');

-- Executor: ver tudo + executar testes
INSERT OR IGNORE INTO papel_permissoes (papel_id, permissao_id)
SELECT p.id, perm.id FROM papeis p, permissoes perm
WHERE p.codigo = 'executor' AND (perm.acao = 'ver' OR (perm.entidade = 'teste' AND perm.acao = 'executar'));

-- Visualizador: apenas ver
INSERT OR IGNORE INTO papel_permissoes (papel_id, permissao_id)
SELECT p.id, perm.id FROM papeis p, permissoes perm
WHERE p.codigo = 'visualizador' AND perm.acao = 'ver';
