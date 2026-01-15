-- =====================================================
-- BELGO BBP - Migracao para Multi-Projeto
-- Este script adiciona projeto_id nas tabelas existentes
-- e migra dados para o projeto GTM (id=1)
-- =====================================================

-- =====================================================
-- PASSO 1: ADICIONAR COLUNA projeto_id NAS TABELAS
-- =====================================================

-- Testes
ALTER TABLE testes ADD COLUMN projeto_id INTEGER DEFAULT 1 REFERENCES projetos(id);

-- Jornadas
ALTER TABLE jornadas ADD COLUMN projeto_id INTEGER DEFAULT 1 REFERENCES projetos(id);

-- Reunioes
ALTER TABLE reunioes ADD COLUMN projeto_id INTEGER DEFAULT 1 REFERENCES projetos(id);

-- Glossario
ALTER TABLE glossario ADD COLUMN projeto_id INTEGER DEFAULT 1 REFERENCES projetos(id);

-- Participantes
ALTER TABLE participantes ADD COLUMN projeto_id INTEGER DEFAULT 1 REFERENCES projetos(id);

-- Auditoria
ALTER TABLE auditoria ADD COLUMN projeto_id INTEGER REFERENCES projetos(id);

-- =====================================================
-- PASSO 2: CRIAR INDICES PARA FILTRO POR PROJETO
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_testes_projeto ON testes(projeto_id);
CREATE INDEX IF NOT EXISTS idx_jornadas_projeto ON jornadas(projeto_id);
CREATE INDEX IF NOT EXISTS idx_reunioes_projeto ON reunioes(projeto_id);
CREATE INDEX IF NOT EXISTS idx_glossario_projeto ON glossario(projeto_id);
CREATE INDEX IF NOT EXISTS idx_participantes_projeto ON participantes(projeto_id);
CREATE INDEX IF NOT EXISTS idx_auditoria_projeto ON auditoria(projeto_id);

-- =====================================================
-- PASSO 3: CRIAR PROJETO GTM COMO PROJETO INICIAL
-- =====================================================

INSERT OR IGNORE INTO projetos (id, codigo, nome, descricao, icone, cor, ativo, visibilidade, criado_por)
VALUES (1, 'gtm', 'GTM - Go To Market', 'Projeto piloto de transformacao comercial Belgo', '🚀', '#003B4A', 1, 'privado', 1);

-- =====================================================
-- PASSO 4: VINCULAR MODULO GTM AO PROJETO
-- =====================================================

INSERT OR IGNORE INTO projeto_modulos (projeto_id, modulo_id, ativo, ordem)
SELECT 1, id, 1, 0 FROM modulos WHERE codigo = 'gtm';

-- =====================================================
-- PASSO 5: MIGRAR USUARIOS EXISTENTES PARA O PROJETO GTM
-- =====================================================

-- Usuarios com acesso ao modulo GTM sao migrados para o projeto GTM
-- Admins recebem papel 'admin', demais recebem papel 'executor'
INSERT OR IGNORE INTO usuario_projeto_papel (usuario_id, projeto_id, papel_id, ativo)
SELECT
    um.usuario_id,
    1,
    CASE
        WHEN u.is_admin = 1 THEN (SELECT id FROM papeis WHERE codigo = 'admin')
        ELSE (SELECT id FROM papeis WHERE codigo = 'executor')
    END,
    1
FROM usuario_modulos um
JOIN usuarios u ON um.usuario_id = u.id
JOIN modulos m ON um.modulo_id = m.id
WHERE m.codigo = 'gtm';

-- =====================================================
-- PASSO 6: ATUALIZAR REGISTROS EXISTENTES COM projeto_id = 1
-- =====================================================

-- Garantir que todos os dados existentes estejam vinculados ao projeto GTM
UPDATE testes SET projeto_id = 1 WHERE projeto_id IS NULL;
UPDATE jornadas SET projeto_id = 1 WHERE projeto_id IS NULL;
UPDATE reunioes SET projeto_id = 1 WHERE projeto_id IS NULL;
UPDATE glossario SET projeto_id = 1 WHERE projeto_id IS NULL;
UPDATE participantes SET projeto_id = 1 WHERE projeto_id IS NULL;

-- =====================================================
-- VERIFICACAO: Contagem de registros migrados
-- =====================================================

-- Executar apos migracao para verificar:
-- SELECT 'projetos' as tabela, COUNT(*) as total FROM projetos
-- UNION ALL SELECT 'papeis', COUNT(*) FROM papeis
-- UNION ALL SELECT 'permissoes', COUNT(*) FROM permissoes
-- UNION ALL SELECT 'usuario_projeto_papel', COUNT(*) FROM usuario_projeto_papel
-- UNION ALL SELECT 'projeto_modulos', COUNT(*) FROM projeto_modulos
-- UNION ALL SELECT 'testes com projeto', COUNT(*) FROM testes WHERE projeto_id IS NOT NULL
-- UNION ALL SELECT 'jornadas com projeto', COUNT(*) FROM jornadas WHERE projeto_id IS NOT NULL;
