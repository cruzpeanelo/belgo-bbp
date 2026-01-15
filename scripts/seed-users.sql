-- =====================================================
-- BELGO BBP - Seed de Usuarios Iniciais
-- Senha padrao: BelgoGTM2024 (hash SHA-256)
-- =====================================================

-- Hash SHA-256 de "BelgoGTM2024": 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
-- Nota: Em producao, usar bcrypt ou argon2

-- =====================
-- ADMINS (3)
-- =====================

INSERT OR IGNORE INTO usuarios (email, nome, nome_completo, senha_hash, area, cargo, is_admin, primeiro_acesso) VALUES
  ('leandro.pereira@belgo.com.br', 'Leandro Cruz', 'Leandro da Cruz Pereira', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'TI', 'Gerente de TI', 1, 0),
  ('leandro.gimenes@belgo.com.br', 'Leandro Gimenes', 'Leandro Augusto Gimenes', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Comercial', 'PO GTM', 1, 1),
  ('thalita.rhein@belgo.com.br', 'Thalita Rhein', 'Thalita Merisio Rhein', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Comercial', 'Gerente de Negocio GTM', 1, 1);

-- =====================
-- EQUIPE PROJETO (5)
-- =====================

INSERT OR IGNORE INTO usuarios (email, nome, nome_completo, senha_hash, area, cargo, is_admin, primeiro_acesso) VALUES
  ('ronildo.souza@belgo.com.br', 'Ronildo Souza', 'Ronildo Rodrigues De Souza', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Pricing', 'PO Pricing', 0, 1),
  ('kathleen.almeida@belgo.com.br', 'Kathleen Carmona', 'Kathleen Pfeifeer Carmona De Almeida', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'TI', 'Analista TI Salesforce', 0, 1),
  ('lucas.pinheiro@belgo.com.br', 'Lucas Pinheiro', 'Lucas Lemos Pinheiro', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'TI', 'Desenvolvedor TI', 0, 1),
  ('renato.araujo@belgo.com.br', 'Renato Araujo', 'Renato Fernandes De Araujo', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Controladoria', 'Gerente Controladoria', 0, 1),
  ('ivano.araujo@belgo.com.br', 'Ivano Araujo', 'Ivano Oliveira Araujo', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Financeiro', 'Gerente Financeiro', 0, 1);

-- =====================
-- KEY USERS (20)
-- =====================

INSERT OR IGNORE INTO usuarios (email, nome, nome_completo, senha_hash, area, cargo, is_admin, primeiro_acesso) VALUES
  ('vanessa.souza@belgo.com.br', 'Vanessa Souza', 'Vanessa Torres Xavier De Souza', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Credito', 'Key User Credito', 0, 1),
  ('jefferson.pinheiro@belgo.com.br', 'Jefferson Pinheiro', 'Jefferson Pinheiro', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'TI', 'Key User Sistemas', 0, 1),
  ('maria.ciorlia@belgo.com.br', 'Maria Ciorlia', 'Maria L Ciorlia', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Comercial', 'Key User Clusterizacao', 0, 1),
  ('luis.riqueti@belgo.com.br', 'Luis Riqueti', 'Luis Eustaquio Riqueti', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'BI', 'Key User Relatorios', 0, 1),
  ('fernanda.monteiro@belgo.com.br', 'Fernanda Monteiro', 'Fernanda Chaves Monteiro', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Controladoria', 'Key User Controladoria', 0, 1),
  ('marcelo.almeida@belgo.com.br', 'Marcelo Almeida', 'Marcelo Almeida', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Pedidos', 'Key User Pedidos', 0, 1),
  ('fabiana.silva@belgo.com.br', 'Fabiana Silva', 'Fabiana Oliveira Silva', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Pricing', 'Key User Pricing', 0, 1),
  ('fabricio.franca@belgo.com.br', 'Fabricio Franca', 'Fabricio Franca', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Projetos', 'Key User Projetos', 0, 1),
  ('joao.endo@belgo.com.br', 'Joao Endo', 'Joao Vitor Yuji Endo', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Construcao Civil', 'Key User Construcao Civil', 0, 1),
  ('francine.gayer@belgo.com.br', 'Francine Gayer', 'Francine Gayer', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Protec', 'Key User Protec', 0, 1),
  ('bruno.machado@belgo.com.br', 'Bruno Machado', 'Bruno Nolasco Machado', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Agro', 'Key User Agro', 0, 1),
  ('marcio.silva@belgo.com.br', 'Marcio Silva', 'Marcio Antonio Do Espirito Santo Silva', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'SmartCenter', 'Key User SmartCenter', 0, 1),
  ('daniel.goncalves@belgo.com.br', 'Daniel Goncalves', 'Daniel Pedrosa Goncalves', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Marketing', 'Key User Marketing', 0, 1),
  ('maria.albuquerque@belgo.com.br', 'Maria Victoria', 'Maria Victoria Cabral De Albuquerque', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Comercial', 'Key User Comercial', 0, 1),
  ('renata.mello@arcelormittal.com.br', 'Renata Mello', 'Renata Drumond Amorim Conrado De Mello', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'AMD', 'Key User AMD', 0, 1),
  ('jessica.vaz@belgo.com.br', 'Jessica Vaz', 'Jessica De Assis Vaz', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Energia', 'Key User Energia', 0, 1),
  ('frank.silva@belgo.com.br', 'Frank Silva', 'Frank Hermogenes Da Silva', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Tributario', 'Key User Tributario', 0, 1),
  ('claudio.oliveira@belgo.com.br', 'Claudio Oliveira', 'Claudio Fernandes De Oliveira', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Fiscal', 'Gerente Fiscal', 0, 1),
  ('carla.venancio@belgo.com.br', 'Carla Venancio', 'Carla Venancio', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Controladoria', 'Analista Controladoria', 0, 1),
  ('frederico.kinoshita@belgo.com.br', 'Frederico Takeshi', 'Frederico Takeshi Kinoshita Rocha', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Controladoria', 'Analista Controladoria', 0, 1);

-- =====================
-- PERMISSOES DE MODULOS
-- Todos os admins tem acesso a todos os modulos
-- Key Users tem acesso apenas ao GTM por padrao
-- =====================

-- Admins - acesso total
INSERT OR IGNORE INTO usuario_modulos (usuario_id, modulo_id)
SELECT u.id, m.id FROM usuarios u, modulos m WHERE u.is_admin = 1;

-- Key Users - acesso ao GTM
INSERT OR IGNORE INTO usuario_modulos (usuario_id, modulo_id)
SELECT u.id, m.id FROM usuarios u, modulos m WHERE u.is_admin = 0 AND m.codigo = 'gtm';
