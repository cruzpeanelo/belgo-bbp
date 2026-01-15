-- =====================================================
-- BELGO BBP - Schema do Banco de Dados D1
-- =====================================================

-- =====================
-- SISTEMA DE USUARIOS
-- =====================

CREATE TABLE IF NOT EXISTS usuarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  nome TEXT NOT NULL,
  nome_completo TEXT,
  senha_hash TEXT NOT NULL,
  area TEXT,
  cargo TEXT,
  is_admin INTEGER DEFAULT 0,
  ativo INTEGER DEFAULT 1,
  primeiro_acesso INTEGER DEFAULT 1,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS modulos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  codigo TEXT UNIQUE NOT NULL,
  nome TEXT NOT NULL,
  icone TEXT,
  cor TEXT,
  ativo INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS usuario_modulos (
  usuario_id INTEGER,
  modulo_id INTEGER,
  PRIMARY KEY (usuario_id, modulo_id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (modulo_id) REFERENCES modulos(id)
);

CREATE TABLE IF NOT EXISTS sessoes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER NOT NULL,
  token TEXT UNIQUE NOT NULL,
  expires_at TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE IF NOT EXISTS auditoria (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER,
  acao TEXT NOT NULL,
  entidade TEXT,
  entidade_id TEXT,
  detalhes TEXT,
  ip TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE IF NOT EXISTS convites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL,
  token TEXT UNIQUE NOT NULL,
  criado_por INTEGER NOT NULL,
  usado INTEGER DEFAULT 0,
  expires_at TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (criado_por) REFERENCES usuarios(id)
);

-- =====================
-- DADOS DO PROJETO GTM
-- =====================

CREATE TABLE IF NOT EXISTS reunioes (
  id TEXT PRIMARY KEY,
  data TEXT NOT NULL,
  titulo TEXT NOT NULL,
  duracao TEXT,
  tipo TEXT,
  resumo TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reuniao_participantes (
  reuniao_id TEXT,
  participante_nome TEXT,
  PRIMARY KEY (reuniao_id, participante_nome),
  FOREIGN KEY (reuniao_id) REFERENCES reunioes(id)
);

CREATE TABLE IF NOT EXISTS reuniao_topicos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reuniao_id TEXT,
  topico TEXT,
  FOREIGN KEY (reuniao_id) REFERENCES reunioes(id)
);

CREATE TABLE IF NOT EXISTS reuniao_decisoes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reuniao_id TEXT,
  decisao TEXT,
  FOREIGN KEY (reuniao_id) REFERENCES reunioes(id)
);

CREATE TABLE IF NOT EXISTS reuniao_acoes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reuniao_id TEXT,
  responsavel TEXT,
  acao TEXT,
  FOREIGN KEY (reuniao_id) REFERENCES reunioes(id)
);

CREATE TABLE IF NOT EXISTS jornadas (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  icone TEXT,
  ordem INTEGER,
  status TEXT,
  as_is_descricao TEXT,
  as_is_tempo_medio TEXT,
  to_be_descricao TEXT,
  to_be_tempo_medio TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS jornada_passos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jornada_id TEXT,
  tipo TEXT,
  ordem INTEGER,
  passo TEXT,
  FOREIGN KEY (jornada_id) REFERENCES jornadas(id)
);

CREATE TABLE IF NOT EXISTS jornada_problemas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jornada_id TEXT,
  problema TEXT,
  FOREIGN KEY (jornada_id) REFERENCES jornadas(id)
);

CREATE TABLE IF NOT EXISTS jornada_beneficios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jornada_id TEXT,
  beneficio TEXT,
  FOREIGN KEY (jornada_id) REFERENCES jornadas(id)
);

CREATE TABLE IF NOT EXISTS jornada_areas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  jornada_id TEXT,
  area TEXT,
  FOREIGN KEY (jornada_id) REFERENCES jornadas(id)
);

CREATE TABLE IF NOT EXISTS participantes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  nome_completo TEXT,
  papel TEXT,
  area TEXT,
  email TEXT,
  tipo TEXT,
  status TEXT,
  responsabilidade TEXT
);

CREATE TABLE IF NOT EXISTS glossario (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  termo TEXT NOT NULL,
  sigla TEXT,
  definicao TEXT,
  categoria TEXT,
  exemplo TEXT
);

CREATE TABLE IF NOT EXISTS testes (
  id TEXT PRIMARY KEY,
  codigo TEXT,
  nome TEXT NOT NULL,
  descricao TEXT,
  categoria TEXT,
  jornada_id TEXT,
  pre_condicoes TEXT,
  resultado_esperado TEXT,
  status TEXT DEFAULT 'Pendente',
  executado_por INTEGER,
  executado_em TEXT,
  observacoes TEXT,
  FOREIGN KEY (jornada_id) REFERENCES jornadas(id),
  FOREIGN KEY (executado_por) REFERENCES usuarios(id)
);

CREATE TABLE IF NOT EXISTS teste_passos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  teste_id TEXT,
  ordem INTEGER,
  passo TEXT,
  FOREIGN KEY (teste_id) REFERENCES testes(id)
);

-- =====================
-- CONFIGURACOES
-- =====================

CREATE TABLE IF NOT EXISTS areas_credito (
  codigo TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  descricao TEXT,
  nome_alternativo TEXT,
  sistema_relacionado TEXT,
  status TEXT
);

CREATE TABLE IF NOT EXISTS canais (
  codigo TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  descricao TEXT,
  tipo_cliente TEXT,
  area_credito TEXT,
  status TEXT
);

CREATE TABLE IF NOT EXISTS record_types (
  developer_name TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  descricao TEXT,
  status TEXT
);

CREATE TABLE IF NOT EXISTS sistemas_integrados (
  id TEXT PRIMARY KEY,
  nome TEXT NOT NULL,
  tipo TEXT,
  descricao TEXT,
  status TEXT
);

-- =====================
-- INDICES
-- =====================

CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);
CREATE INDEX IF NOT EXISTS idx_auditoria_usuario ON auditoria(usuario_id);
CREATE INDEX IF NOT EXISTS idx_auditoria_data ON auditoria(created_at);
CREATE INDEX IF NOT EXISTS idx_sessoes_token ON sessoes(token);
CREATE INDEX IF NOT EXISTS idx_testes_status ON testes(status);
CREATE INDEX IF NOT EXISTS idx_testes_categoria ON testes(categoria);

-- =====================
-- DADOS INICIAIS
-- =====================

-- Modulos
INSERT OR IGNORE INTO modulos (codigo, nome, icone, cor) VALUES
  ('gtm', 'GTM', '🚀', '#003B4A'),
  ('rede-ativa', 'Rede Ativa', '🌐', '#00A799'),
  ('roadmap', 'Roadmap 2026', '📅', '#ED1C24');
