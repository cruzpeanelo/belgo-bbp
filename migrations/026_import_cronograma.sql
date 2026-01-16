-- =====================================================
-- Migration 026: Importar dados do Cronograma
-- Projeto 5 (GTM Clone) - Entidade: cronograma
-- Total: 66 registros (5 workshops + 6 marcos + 55 atividades)
-- =====================================================

-- Primeiro precisamos saber o ID da entidade cronograma no projeto 5
-- Se não existir, criar a entidade

-- Verificar/criar entidade cronograma para projeto 5
INSERT OR IGNORE INTO projeto_entidades (projeto_id, codigo, nome, descricao, icone, permite_criar, permite_editar, permite_excluir)
VALUES (5, 'cronograma', 'Cronograma', 'Cronograma do projeto GTM', '📅', 0, 0, 0);

-- Limpar dados existentes de cronograma do projeto 5
DELETE FROM projeto_dados
WHERE projeto_id = 5
AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5);

-- ===========================================
-- WORKSHOPS (5 registros)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "workshop",
    "id": "W1",
    "data": "2025-12-04",
    "titulo": "Kickoff e Alinhamento",
    "foco": ["Visão geral do projeto GTM/CRM", "Transição liderança (Dani->Thalita, Audrey em licença)", "Importância da participação - projeto de todos", "Compromisso 2h semanais para key users"],
    "status": "Concluído",
    "participantes": 15,
    "problemas_identificados": ["Key users não sabiam que eram key users", "Usuários perguntando: O que preciso testar?"]
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "workshop",
    "id": "W2",
    "data": "2025-12-10",
    "titulo": "Cadastro, Áreas de Vendas e Concorrentes",
    "foco": ["Cadastro de cliente (SINTEGRA)", "Tipos de conta (PJ/PF/Agrupador)", "Áreas de vendas e Canais", "Documentos fiscais", "Contatos", "Concorrentes (discussão Francine - sazonalidade)", "Financeiro/Crédito (ASCP)"],
    "status": "Concluído",
    "participantes": 12,
    "destaques": ["Zero dúvidas sobre cadastro", "Francine levantou questão de concorrentes sazonais"]
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "workshop",
    "id": "W3",
    "data": "2025-12-16",
    "titulo": "Documentos Fiscais e Autoatendimento",
    "foco": ["Download documentos fiscais (Daniel/Spa)", "Criticidade dados de contato", "Portal Autoatendimento", "Pendência Portal Logístico identificada"],
    "status": "Concluído",
    "participantes": 10,
    "feedback_maria": "Sessões muito didáticas - aprendi muita coisa de outros processos"
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "workshop",
    "id": "W4",
    "data": "2025-12-17",
    "horario": "16:00-17:30",
    "titulo": "Workflow Pricing",
    "foco": ["Fluxo de aprovação", "Níveis de desconto", "Início cotação"],
    "status": "Concluído",
    "participantes": ["Rodrigo", "Leandro", "Thalita"],
    "destaques": ["Definido 4 níveis de aprovação", "Regras de desconto confirmadas"]
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "workshop",
    "id": "W5",
    "data": "2025-12-22",
    "horario": "14:00-16:00",
    "titulo": "Revisão GTM e Ajustes Finais",
    "foco": ["Nova estrutura organizacional", "4 macro setores", "Ajustes de hierarquia", "Escritórios de vendas"],
    "status": "Concluído",
    "participantes": ["Leandro", "Thalita", "Gimenes", "Ciorlia", "Riqueti"],
    "destaques": ["Reorganização comercial em 4 macro setores", "7 ações definidas para ajustes GTM"]
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- ===========================================
-- MARCOS DO PROJETO (6 registros)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "marco",
    "data": "2025-01-15",
    "titulo": "Kickoff Projeto",
    "status": "Concluído",
    "descricao": "Início oficial do projeto GTM Vendas"
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "marco",
    "data": "2025-09-01",
    "titulo": "GO Live Fase I",
    "status": "Concluído",
    "descricao": "Entrada em produção da primeira fase"
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "marco",
    "data": "2025-12-22",
    "titulo": "Fim Workshops AS IS/TO BE",
    "status": "Concluído",
    "descricao": "Conclusão dos workshops de mapeamento AS-IS e TO-BE"
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "marco",
    "data": "2026-01-13",
    "titulo": "Estruturação BBP Completo",
    "status": "Concluído",
    "descricao": "Documentação completa do Business Blueprint"
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "marco",
    "data": "2026-01-20",
    "titulo": "UAT - Testes de Aceitação",
    "status": "Pendente",
    "descricao": "Início dos testes de aceitação do usuário"
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "marco",
    "data": "2026-03-15",
    "titulo": "GO Live Fase II",
    "status": "Pendente",
    "descricao": "Entrada em produção da segunda fase - GTM Vendas completo"
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- ===========================================
-- ATIVIDADES POR FASE (55 registros)
-- ===========================================

-- FASE 1: Preparação (Jan-Mar 2025)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 1 - Preparação", "titulo": "Levantamento de requisitos", "responsavel": "TI/Negócio", "status": "Concluído", "data_inicio": "2025-01-15", "data_fim": "2025-02-15"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 1 - Preparação", "titulo": "Definição de escopo GTM", "responsavel": "Leandro Gimenes", "status": "Concluído", "data_inicio": "2025-01-20", "data_fim": "2025-02-28"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 1 - Preparação", "titulo": "Mapeamento de integrações SAP", "responsavel": "Equipe Integration", "status": "Concluído", "data_inicio": "2025-02-01", "data_fim": "2025-03-15"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 1 - Preparação", "titulo": "Configuração ambiente Salesforce", "responsavel": "TI", "status": "Concluído", "data_inicio": "2025-02-15", "data_fim": "2025-03-30"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 1 - Preparação", "titulo": "Definição de key users", "responsavel": "Thalita Rhein", "status": "Concluído", "data_inicio": "2025-03-01", "data_fim": "2025-03-20"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- FASE 2: Desenvolvimento (Abr-Jul 2025)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 2 - Desenvolvimento", "titulo": "Desenvolvimento módulo Cadastro", "responsavel": "Integration", "status": "Concluído", "data_inicio": "2025-04-01", "data_fim": "2025-05-31"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 2 - Desenvolvimento", "titulo": "Integração SINTEGRA", "responsavel": "Integration", "status": "Concluído", "data_inicio": "2025-04-15", "data_fim": "2025-06-15"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 2 - Desenvolvimento", "titulo": "Integração ASCP (Crédito)", "responsavel": "Integration", "status": "Concluído", "data_inicio": "2025-05-01", "data_fim": "2025-07-15"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 2 - Desenvolvimento", "titulo": "Desenvolvimento Workflow Pricing", "responsavel": "Integration", "status": "Concluído", "data_inicio": "2025-05-15", "data_fim": "2025-07-31"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 2 - Desenvolvimento", "titulo": "Configuração áreas de crédito (BBA, CSP, DBA, ALPE)", "responsavel": "TI/Financeiro", "status": "Concluído", "data_inicio": "2025-06-01", "data_fim": "2025-07-30"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- FASE 3: Testes Fase I (Ago-Set 2025)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 3 - Testes", "titulo": "Testes unitários módulo Cadastro", "responsavel": "QA", "status": "Concluído", "data_inicio": "2025-08-01", "data_fim": "2025-08-15"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 3 - Testes", "titulo": "Testes integração SAP", "responsavel": "QA/Integration", "status": "Concluído", "data_inicio": "2025-08-10", "data_fim": "2025-08-25"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 3 - Testes", "titulo": "UAT Fase I", "responsavel": "Key Users", "status": "Concluído", "data_inicio": "2025-08-20", "data_fim": "2025-08-30"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 3 - Testes", "titulo": "Correções pós-UAT", "responsavel": "Integration", "status": "Concluído", "data_inicio": "2025-08-25", "data_fim": "2025-08-31"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 3 - Testes", "titulo": "GO Live Fase I", "responsavel": "TI", "status": "Concluído", "data_inicio": "2025-09-01", "data_fim": "2025-09-01"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- FASE 4: Workshops AS-IS/TO-BE (Dez 2025)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 4 - Workshops", "titulo": "Workshop 1: Kickoff e Alinhamento", "responsavel": "Leandro Cruz", "status": "Concluído", "data_inicio": "2025-12-04", "data_fim": "2025-12-04"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 4 - Workshops", "titulo": "Workshop 2: Cadastro e Crédito", "responsavel": "Leandro Cruz", "status": "Concluído", "data_inicio": "2025-12-10", "data_fim": "2025-12-10"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 4 - Workshops", "titulo": "Workshop 3: Documentos Fiscais", "responsavel": "Leandro Cruz", "status": "Concluído", "data_inicio": "2025-12-16", "data_fim": "2025-12-16"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 4 - Workshops", "titulo": "Workshop 4: Workflow Pricing", "responsavel": "Leandro Cruz", "status": "Concluído", "data_inicio": "2025-12-17", "data_fim": "2025-12-17"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 4 - Workshops", "titulo": "Workshop 5: Revisão GTM", "responsavel": "Leandro Cruz", "status": "Concluído", "data_inicio": "2025-12-22", "data_fim": "2025-12-22"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- FASE 5: Estruturação BBP (Jan 2026)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 5 - BBP", "titulo": "Documentação jornadas AS-IS", "responsavel": "TI", "status": "Concluído", "data_inicio": "2026-01-02", "data_fim": "2026-01-06"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 5 - BBP", "titulo": "Documentação jornadas TO-BE", "responsavel": "TI", "status": "Concluído", "data_inicio": "2026-01-06", "data_fim": "2026-01-10"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 5 - BBP", "titulo": "Criação caderno de testes", "responsavel": "TI/QA", "status": "Concluído", "data_inicio": "2026-01-08", "data_fim": "2026-01-13"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 5 - BBP", "titulo": "Revisão glossário", "responsavel": "TI", "status": "Concluído", "data_inicio": "2026-01-10", "data_fim": "2026-01-13"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 5 - BBP", "titulo": "Consolidação BBP completo", "responsavel": "Leandro Cruz", "status": "Concluído", "data_inicio": "2026-01-12", "data_fim": "2026-01-13"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- FASE 6: UAT Fase II (Jan-Fev 2026)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 6 - UAT", "titulo": "Preparação ambiente UAT", "responsavel": "TI", "status": "Pendente", "data_inicio": "2026-01-15", "data_fim": "2026-01-17"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 6 - UAT", "titulo": "Treinamento key users", "responsavel": "Integration", "status": "Pendente", "data_inicio": "2026-01-18", "data_fim": "2026-01-19"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 6 - UAT", "titulo": "Execução testes CT-01 a CT-50", "responsavel": "Key Users", "status": "Pendente", "data_inicio": "2026-01-20", "data_fim": "2026-01-31"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 6 - UAT", "titulo": "Execução testes CT-51 a CT-100", "responsavel": "Key Users", "status": "Pendente", "data_inicio": "2026-02-01", "data_fim": "2026-02-14"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 6 - UAT", "titulo": "Execução testes CT-101 a CT-152", "responsavel": "Key Users", "status": "Pendente", "data_inicio": "2026-02-15", "data_fim": "2026-02-28"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 6 - UAT", "titulo": "Registro e triagem de bugs", "responsavel": "QA", "status": "Pendente", "data_inicio": "2026-01-20", "data_fim": "2026-02-28"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- FASE 7: Correções e Ajustes (Mar 2026)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 7 - Correções", "titulo": "Correção bugs críticos", "responsavel": "Integration", "status": "Pendente", "data_inicio": "2026-03-01", "data_fim": "2026-03-07"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 7 - Correções", "titulo": "Reteste funcionalidades corrigidas", "responsavel": "Key Users", "status": "Pendente", "data_inicio": "2026-03-08", "data_fim": "2026-03-10"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 7 - Correções", "titulo": "Ajustes de performance", "responsavel": "TI", "status": "Pendente", "data_inicio": "2026-03-08", "data_fim": "2026-03-12"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 7 - Correções", "titulo": "Validação final integrações", "responsavel": "Integration", "status": "Pendente", "data_inicio": "2026-03-10", "data_fim": "2026-03-13"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 7 - Correções", "titulo": "Aprovação final stakeholders", "responsavel": "Thalita/Gimenes", "status": "Pendente", "data_inicio": "2026-03-13", "data_fim": "2026-03-14"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- FASE 8: GO Live (Mar 2026)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 8 - GO Live", "titulo": "Preparação ambiente produção", "responsavel": "TI", "status": "Pendente", "data_inicio": "2026-03-14", "data_fim": "2026-03-14"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 8 - GO Live", "titulo": "Deploy produção", "responsavel": "TI", "status": "Pendente", "data_inicio": "2026-03-15", "data_fim": "2026-03-15"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 8 - GO Live", "titulo": "Monitoramento pós-deploy", "responsavel": "TI/Integration", "status": "Pendente", "data_inicio": "2026-03-15", "data_fim": "2026-03-22"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "atividade", "fase": "Fase 8 - GO Live", "titulo": "Suporte pós-implantação", "responsavel": "TI/Integration", "status": "Pendente", "data_inicio": "2026-03-15", "data_fim": "2026-04-15"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- ===========================================
-- RESUMO DO PROJETO
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "resumo",
    "projeto": "GTM Vendas - Belgo Arames",
    "inicio": "2025-01-01",
    "go_live_fase_i": "2025-09-01",
    "go_live_fase_ii": "2026-03-15",
    "fase_atual": "Fase II - Testes e Validação",
    "total_workshops": 5,
    "total_marcos": 6,
    "total_atividades": 44,
    "progresso_geral": "75%"
}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;
