-- =====================================================
-- BELGO BBP - Migration 006: Acoes Dinamicas
-- Sistema de acoes configuraveis por entidade
-- =====================================================

-- 1. Tabela de acoes por entidade
CREATE TABLE IF NOT EXISTS projeto_entidade_acoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entidade_id INTEGER NOT NULL,
    codigo TEXT NOT NULL,
    nome TEXT NOT NULL,
    icone TEXT,
    tipo TEXT NOT NULL,  -- 'status_change', 'api_call', 'modal', 'teams', 'link', 'custom'
    config TEXT,         -- JSON com configuracao especifica do tipo
    posicao TEXT DEFAULT 'linha',  -- 'linha', 'header', 'modal', 'bulk', 'menu'
    condicao TEXT,       -- JSON com condicao para exibir (ex: {"campo": "status", "valor": "Pendente"})
    permissao_minima TEXT,  -- codigo do papel minimo (visualizador, executor, key_user, gestor, admin)
    ordem INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (entidade_id) REFERENCES projeto_entidades(id) ON DELETE CASCADE
);

-- 2. Indice para busca rapida
CREATE INDEX IF NOT EXISTS idx_acoes_entidade ON projeto_entidade_acoes(entidade_id, ativo);

-- =====================================================
-- Estrutura esperada do campo config por tipo:
-- =====================================================
--
-- tipo: 'status_change'
-- config: {
--   "campo": "status",
--   "novo_valor": "Concluido",
--   "confirmar": true,
--   "mensagem_confirmacao": "Deseja marcar como concluido?"
-- }
--
-- tipo: 'api_call'
-- config: {
--   "metodo": "POST",
--   "endpoint": "/api/custom/action",
--   "body": {"acao": "processar"},
--   "sucesso_msg": "Processado com sucesso!"
-- }
--
-- tipo: 'teams'
-- config: {
--   "titulo": "{icone} {nome}",
--   "facts": ["status", "categoria", "responsavel"],
--   "cor_tema": "003B4A"
-- }
--
-- tipo: 'link'
-- config: {
--   "url": "/pages/detalhe.html?id={_id}",
--   "nova_aba": true
-- }
--
-- tipo: 'modal'
-- config: {
--   "titulo": "Detalhes de {nome}",
--   "secoes": [...]
-- }
--
-- tipo: 'custom'
-- config: {
--   "funcao": "minhaFuncaoCustom",
--   "parametros": ["_id", "nome"]
-- }
-- =====================================================

-- 3. Migrar acoes existentes do GTM para o banco
-- Nota: Estas insercoes sao exemplos baseados no config atual do GTM
-- Devem ser ajustadas conforme os IDs reais das entidades

-- Exemplo: Acao "Marcar Concluido" para entidade de testes (ajustar entidade_id)
-- INSERT INTO projeto_entidade_acoes (entidade_id, codigo, nome, icone, tipo, config, posicao, condicao, ordem)
-- VALUES (
--     1, -- ID da entidade testes
--     'marcar_concluido',
--     'Marcar Concluido',
--     '✅',
--     'status_change',
--     '{"campo": "status", "novo_valor": "Concluido", "confirmar": false}',
--     'linha',
--     '{"campo": "status", "operador": "!=", "valor": "Concluido"}',
--     1
-- );

-- Exemplo: Acao "Compartilhar Teams"
-- INSERT INTO projeto_entidade_acoes (entidade_id, codigo, nome, icone, tipo, config, posicao, ordem)
-- VALUES (
--     1, -- ID da entidade
--     'teams',
--     'Compartilhar',
--     '📤',
--     'teams',
--     '{"titulo": "{icone} {nome}", "facts": ["status", "categoria"]}',
--     'linha',
--     2
-- );

-- Exemplo: Acao "Ver Detalhes"
-- INSERT INTO projeto_entidade_acoes (entidade_id, codigo, nome, icone, tipo, config, posicao, ordem)
-- VALUES (
--     1, -- ID da entidade
--     'ver_detalhes',
--     'Ver',
--     '👁️',
--     'modal',
--     '{"titulo": "{nome}"}',
--     'linha',
--     0
-- );
