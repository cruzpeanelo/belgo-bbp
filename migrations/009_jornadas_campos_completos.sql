-- =====================================================
-- Migration 009: Adicionar campos completos para Jornadas
-- Projeto 5 (GTM Clone) - Entidade ID 18
-- =====================================================

-- Campos adicionais para dados ricos do JSON original
-- Ordem a partir de 18 (após os campos existentes)

-- Fontes de Reunião (múltiplas sessões)
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'fontes_reuniao', 'Fontes de Reunião', 'Lista de sessões e datas das reuniões', 'textarea', 18, 0, 1);

-- Tipos de Conta (PJ, PF, Parceiro Agrupador)
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'tipos_conta', 'Tipos de Conta', 'Tipos de conta aplicáveis (PJ, PF, Parceiro)', 'json', 19, 0, 1);

-- Campos do Processo
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'campos_processo', 'Campos do Processo', 'Campos utilizados no processo com validações', 'json', 20, 0, 1);

-- Regras de Negócio
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'regras_negocio', 'Regras de Negócio', 'Regras de negócio e validações do processo', 'json', 21, 0, 1);

-- Integrações
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'integracoes', 'Integrações', 'Integrações entre sistemas (SF, SAP, etc)', 'json', 22, 0, 1);

-- Ciclos de Teste
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'ciclos_teste', 'Ciclos de Teste', 'Ciclos de teste relacionados ao processo', 'json', 23, 0, 1);

-- Abas de Interface
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'abas_interface', 'Abas de Interface', 'Abas da interface do Salesforce', 'json', 24, 0, 1);

-- Mensagens do Sistema
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'mensagens_sistema', 'Mensagens do Sistema', 'Mensagens de erro, sucesso e alerta', 'json', 25, 0, 1);

-- Participantes da Reunião
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'participantes_reuniao', 'Participantes', 'Participantes das reuniões de levantamento', 'json', 26, 0, 1);

-- Detalhes Gerais
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'detalhes', 'Detalhes', 'Detalhes adicionais do processo', 'json', 27, 0, 1);

-- Detalhes Técnicos
INSERT INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (18, 'detalhes_tecnicos', 'Detalhes Técnicos', 'Detalhes técnicos e configurações', 'json', 28, 0, 1);
