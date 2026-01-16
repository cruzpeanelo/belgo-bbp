-- =====================================================
-- Migration 010: Campos completos para TODAS as entidades
-- Projeto 5 (GTM Clone)
-- =====================================================

-- =====================================================
-- TESTES (ID 22) - Campos adicionais
-- =====================================================
-- dataExecucao já existe como data_execucao? Vamos verificar e adicionar os faltantes

INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (22, 'data_execucao', 'Data de Execução', 'Data em que o teste foi executado', 'date', 13, 0, 1);

-- =====================================================
-- REUNIOES (ID 20) - Campos adicionais do JSON
-- =====================================================

-- topicosAbordados (array de strings -> textarea com delimitador)
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (20, 'topicos', 'Tópicos Abordados', 'Lista de tópicos discutidos na reunião', 'textarea', 11, 0, 1);

-- problemas (array de strings)
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (20, 'problemas', 'Problemas Identificados', 'Problemas levantados durante a reunião', 'textarea', 12, 0, 1);

-- jornadasRelacionadas (array de strings -> relacionamento)
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (20, 'jornadas_relacionadas', 'Jornadas Relacionadas', 'Jornadas do projeto relacionadas à reunião', 'textarea', 13, 0, 1);

-- =====================================================
-- PARTICIPANTES (ID 19) - Campos adicionais do JSON
-- =====================================================

-- status (licença, desligado, ativo)
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (19, 'status', 'Status', 'Status do participante no projeto', 'select', 9, 1, 1);

-- Opções para o campo status
INSERT OR IGNORE INTO projeto_entidade_opcoes (entidade_id, campo_codigo, valor, label, ordem, ativo)
VALUES
(19, 'status', 'ativo', 'Ativo', 1, 1),
(19, 'status', 'licenca', 'Licença', 2, 1),
(19, 'status', 'desligado', 'Desligado', 3, 1);

-- observacao
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (19, 'observacao', 'Observação', 'Observações adicionais sobre o participante', 'textarea', 10, 0, 1);

-- setor (equipeProjeto, stakeholders, keyUsers)
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (19, 'setor', 'Setor', 'Setor do participante no projeto', 'select', 11, 0, 1);

-- Opções para o campo setor
INSERT OR IGNORE INTO projeto_entidade_opcoes (entidade_id, campo_codigo, valor, label, ordem, ativo)
VALUES
(19, 'setor', 'equipe_projeto', 'Equipe do Projeto', 1, 1),
(19, 'setor', 'stakeholder', 'Stakeholder', 2, 1),
(19, 'setor', 'keyuser', 'Key User', 3, 1);

-- =====================================================
-- GLOSSARIO (ID 21) - Campos adicionais do JSON
-- =====================================================

-- contexto
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (21, 'contexto', 'Contexto', 'Contexto de uso do termo no projeto', 'textarea', 5, 0, 1);

-- nome_completo (para siglas)
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (21, 'nome_completo', 'Nome Completo', 'Nome completo do termo ou sigla', 'text', 6, 0, 1);

-- =====================================================
-- RISCOS (ID 23) - Campos adicionais
-- =====================================================

-- descricao
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (23, 'descricao', 'Descrição', 'Descrição detalhada do risco', 'textarea', 5, 0, 1);

-- mitigacao
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (23, 'mitigacao', 'Plano de Mitigação', 'Ações para mitigar o risco', 'textarea', 6, 0, 1);

-- contingencia
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (23, 'contingencia', 'Plano de Contingência', 'Ações caso o risco se concretize', 'textarea', 7, 0, 1);

-- responsavel
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (23, 'responsavel', 'Responsável', 'Responsável pelo acompanhamento do risco', 'text', 8, 0, 1);

-- data_identificacao
INSERT OR IGNORE INTO projeto_entidade_campos (entidade_id, codigo, nome, descricao, tipo, ordem, visivel_listagem, visivel_formulario)
VALUES (23, 'data_identificacao', 'Data Identificação', 'Data em que o risco foi identificado', 'date', 9, 0, 1);
