-- =====================================================
-- Migration 014: Importar dados completos de Participantes
-- Projeto 5 (GTM Clone) - Entidade ID 19
-- =====================================================

-- Limpar dados existentes de participantes do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 19 AND projeto_id = 5;

-- Equipe de Projeto
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Leandro Cruz","nome_completo":"Leandro da Cruz Pereira","papel":"Gerente de TI","responsabilidade":"Coordenação técnica, integração de sistemas e gestão de equipe de TI","area":"TI","email":"leandro.cruz@belgo.com.br","setor":"equipe_projeto","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Leandro Gimenez","nome_completo":"Leandro Augusto Gimenes","papel":"PO GTM","responsabilidade":"Product Owner do projeto GTM Vendas, definição de requisitos comerciais e priorização de backlog","area":"Comercial","setor":"equipe_projeto","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Ronildo","nome_completo":"Ronildo Rodrigues De Souza","papel":"PO Pricing","responsabilidade":"Product Owner de Pricing, definição de regras de precificação e aprovação de descontos","area":"Pricing","setor":"equipe_projeto","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Thalita Rhein","nome_completo":"Thalita Merisio Rhein","papel":"Gerente de Negócio GTM","responsabilidade":"Gestão do projeto pelo lado do negócio, definição de requisitos e validação de entregas","area":"Comercial/Marketing","setor":"equipe_projeto","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Audrey","papel":"Analista de Negócio","responsabilidade":"Documentação e análise de requisitos","setor":"equipe_projeto","status":"licenca","observacao":"Licença maternidade"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Dani Tamerão","papel":"Analista de Negócio","responsabilidade":"Documentação e análise de requisitos","setor":"equipe_projeto","status":"desligado","observacao":"Desligada do projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Kathleen Almeida","nome_completo":"Kathleen Pfeifeer Carmona De Almeida","papel":"Analista TI Salesforce","responsabilidade":"Desenvolvimento e configuração Salesforce, integrações com SAP","area":"TI","setor":"equipe_projeto","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Lucas Pinheiro","nome_completo":"Lucas Lemos Pinheiro","papel":"Desenvolvedor TI","responsabilidade":"Desenvolvimento de integrações e customizações","area":"TI","setor":"equipe_projeto","status":"ativo"}');

-- Stakeholders
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Renato Araujo","nome_completo":"Renato Fernandes De Araujo","papel":"Gerente Controladoria","area":"Controladoria/RC","expertise":"Compliance SOX|Controles internos|Auditoria","observacao":"Responsável por avaliar impacto SOX antes do go-live","setor":"stakeholder","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Ivano Araujo","nome_completo":"Ivano Oliveira Araujo","papel":"Gerente Financeiro","area":"Financeiro","expertise":"FSCM|Belgo Cash|ALPE|Gestão de crédito","setor":"stakeholder","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Claudio Oliveira","nome_completo":"Claudio Fernandes De Oliveira","papel":"Gerente Fiscal","area":"Fiscal/Tributário","expertise":"Tributário|Configurações fiscais|NF-e","setor":"stakeholder","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Carla Venâncio","papel":"Analista Controladoria","area":"Controladoria","expertise":"Segment Report|Relatórios gerenciais","setor":"stakeholder","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Frederico Takeshi","papel":"Analista Controladoria","area":"Controladoria","expertise":"Controles SOX|Relatórios financeiros","setor":"stakeholder","status":"ativo"}');

-- Key Users
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Vanessa Souza","papel":"Key User - Crédito","area":"Financeiro/Crédito","expertise":"Áreas de crédito|BBA|CSP|DBA|ALPE|Limites de crédito","reunioes":"04/12/2025|16/12/2025","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Rafael","papel":"Key User - Cadastro","area":"Cadastro/Dados Mestres","expertise":"Record Types|Cadastro de clientes|SINTEGRA","reunioes":"03/12/2025|04/12/2025|16/12/2025","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Talita","papel":"Key User - Fiscal","area":"Fiscal/Tributário","expertise":"NF-e|DANFE|Documentos fiscais|XML","reunioes":"04/12/2025|16/12/2025","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Jefferson Pinheiro","papel":"Key User - Sistemas","area":"TI/Sistemas","expertise":"Integrações|ASCP|Salesforce|SAP ECC","reunioes":"04/12/2025|12/12/2025|22/12/2025","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Leonardo","papel":"Key User - Controladoria","area":"Financeiro/Controladoria","expertise":"FSCM|Controles financeiros|Compliance SOX","reunioes":"03/12/2025","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Maria Ciorlia","papel":"Key User - Clusterização","area":"Comercial/Marketing","expertise":"Clusterização de clientes|Segmentação|Relatórios","reunioes":"12/12/2025|22/12/2025","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Luis Riqueti","papel":"Key User - Relatórios","area":"TI/BI","expertise":"Power BI|BWA|Hierarquias de dados|Segment Report","reunioes":"12/12/2025|17/12/2025|22/12/2025|23/12/2025","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Fernanda Monteiro","papel":"Key User - Governança","area":"Governança/Marketing","expertise":"Governança de dados|Ownership|Hierarquias","reunioes":"12/12/2025|17/12/2025|23/12/2025","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Fabricio França","papel":"Key User - Autoatendimento","area":"TI/Autoatendimento","expertise":"Chatbot|WhatsApp|Einstein|Integrações","reunioes":"17/12/2025|22/12/2025|29/12/2025|07/01/2026","setor":"keyuser","status":"ativo"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{"nome":"Marcelo Almeida","papel":"Key User - Escritórios","area":"TI/Configuração","expertise":"Escritórios de vendas|Configurações|Migrações","reunioes":"12/12/2025|29/12/2025|07/01/2026","setor":"keyuser","status":"ativo"}');
