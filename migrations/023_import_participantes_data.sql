-- =====================================================
-- Migration 023: Importar dados de Participantes
-- Projeto 5 (GTM Clone) - Entidade ID 20 (participantes)
-- Total: 28 participantes (equipe + stakeholders + key users)
-- =====================================================

-- Limpar dados existentes de participantes do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 20 AND projeto_id = 5;

-- ===========================================
-- EQUIPE DO PROJETO (8 pessoas)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Leandro Cruz",
    "nome_completo": "Leandro da Cruz Pereira",
    "papel": "Gerente de TI",
    "tipo": "equipe_projeto",
    "area": "TI",
    "responsabilidade": "Coordenação técnica, integração de sistemas e gestão de equipe de TI",
    "email": "leandro.cruz@belgo.com.br",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Leandro Gimenez",
    "nome_completo": "Leandro Augusto Gimenes",
    "papel": "PO GTM",
    "tipo": "equipe_projeto",
    "area": "Comercial",
    "responsabilidade": "Product Owner do projeto GTM Vendas, definição de requisitos comerciais e priorização de backlog",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Ronildo",
    "nome_completo": "Ronildo Rodrigues De Souza",
    "papel": "PO Pricing",
    "tipo": "equipe_projeto",
    "area": "Pricing",
    "responsabilidade": "Product Owner de Pricing, definição de regras de precificação e aprovação de descontos",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Thalita Rhein",
    "nome_completo": "Thalita Merisio Rhein",
    "papel": "Gerente de Negócio GTM",
    "tipo": "equipe_projeto",
    "area": "Comercial/Marketing",
    "responsabilidade": "Gestão do projeto pelo lado do negócio, definição de requisitos e validação de entregas",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Audrey",
    "papel": "Analista de Negócio",
    "tipo": "equipe_projeto",
    "responsabilidade": "Documentação e análise de requisitos",
    "status": "Licença maternidade"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Dani Tamerão",
    "papel": "Analista de Negócio",
    "tipo": "equipe_projeto",
    "responsabilidade": "Documentação e análise de requisitos",
    "status": "Desligada do projeto"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Kathleen Almeida",
    "nome_completo": "Kathleen Pfeifeer Carmona De Almeida",
    "papel": "Analista TI Salesforce",
    "tipo": "equipe_projeto",
    "area": "TI",
    "responsabilidade": "Desenvolvimento e configuração Salesforce, integrações com SAP",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Lucas Pinheiro",
    "nome_completo": "Lucas Lemos Pinheiro",
    "papel": "Desenvolvedor TI",
    "tipo": "equipe_projeto",
    "area": "TI",
    "responsabilidade": "Desenvolvimento de integrações e customizações",
    "status": "Ativo"
}');

-- ===========================================
-- STAKEHOLDERS (5 pessoas)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Renato Araujo",
    "nome_completo": "Renato Fernandes De Araujo",
    "papel": "Gerente Controladoria",
    "tipo": "stakeholder",
    "area": "Controladoria/RC",
    "expertise": "Compliance SOX|Controles internos|Auditoria",
    "observacao": "Responsável por avaliar impacto SOX antes do go-live",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Ivano Araujo",
    "nome_completo": "Ivano Oliveira Araujo",
    "papel": "Gerente Financeiro",
    "tipo": "stakeholder",
    "area": "Financeiro",
    "expertise": "FSCM|Belgo Cash|ALPE|Gestão de crédito",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Claudio Oliveira",
    "nome_completo": "Claudio Fernandes De Oliveira",
    "papel": "Gerente Fiscal",
    "tipo": "stakeholder",
    "area": "Fiscal/Tributário",
    "expertise": "Tributário|Configurações fiscais|NF-e",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Carla Venâncio",
    "papel": "Analista Controladoria",
    "tipo": "stakeholder",
    "area": "Controladoria",
    "expertise": "Segment Report|Relatórios gerenciais",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Frederico Takeshi",
    "papel": "Analista Controladoria",
    "tipo": "stakeholder",
    "area": "Controladoria",
    "expertise": "Controles SOX|Relatórios financeiros",
    "status": "Ativo"
}');

-- ===========================================
-- KEY USERS (15 pessoas)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Vanessa Souza",
    "papel": "Key User - Crédito",
    "tipo": "key_user",
    "area": "Financeiro/Crédito",
    "expertise": "Áreas de crédito|BBA|CSP|DBA|ALPE|Limites de crédito",
    "reunioes_participou": "04/12/2025|16/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Rafael",
    "papel": "Key User - Cadastro",
    "tipo": "key_user",
    "area": "Cadastro/Dados Mestres",
    "expertise": "Record Types|Cadastro de clientes|SINTEGRA",
    "reunioes_participou": "03/12/2025|04/12/2025|16/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Talita",
    "papel": "Key User - Fiscal",
    "tipo": "key_user",
    "area": "Fiscal/Tributário",
    "expertise": "NF-e|DANFE|Documentos fiscais|XML",
    "reunioes_participou": "04/12/2025|16/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Jefferson Pinheiro",
    "papel": "Key User - Sistemas",
    "tipo": "key_user",
    "area": "TI/Sistemas",
    "expertise": "Integrações|ASCP|Salesforce|SAP ECC",
    "reunioes_participou": "04/12/2025|12/12/2025|22/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Leonardo",
    "papel": "Key User - Controladoria",
    "tipo": "key_user",
    "area": "Financeiro/Controladoria",
    "expertise": "FSCM|Controles financeiros|Compliance SOX",
    "reunioes_participou": "03/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Maria Ciorlia",
    "papel": "Key User - Clusterização",
    "tipo": "key_user",
    "area": "Comercial/Marketing",
    "expertise": "Clusterização de clientes|Segmentação|Relatórios",
    "reunioes_participou": "12/12/2025|22/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Luis Riqueti",
    "papel": "Key User - Relatórios",
    "tipo": "key_user",
    "area": "TI/BI",
    "expertise": "Power BI|BWA|Hierarquias de dados|Segment Report",
    "reunioes_participou": "12/12/2025|17/12/2025|22/12/2025|23/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Fernanda Monteiro",
    "papel": "Key User - Controladoria",
    "tipo": "key_user",
    "area": "Financeiro/Controladoria",
    "expertise": "Relatórios financeiros|CPV|Custo de servir",
    "reunioes_participou": "12/12/2025|17/12/2025|23/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Marcelo Almeida",
    "papel": "Key User - Pedidos",
    "tipo": "key_user",
    "area": "Comercial/Pedidos",
    "expertise": "Hub de gestão OC|Pedidos|Cotações",
    "reunioes_participou": "12/12/2025|22/12/2025|29/12/2025|07/01/2026",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Fabiana Silva",
    "papel": "Key User - Pricing",
    "tipo": "key_user",
    "area": "Comercial/Pricing",
    "expertise": "Tabelas de preço|Segmentação por canal|Clusterização",
    "reunioes_participou": "23/12/2025|07/01/2026",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Fabricio França",
    "papel": "Key User - Projetos",
    "tipo": "key_user",
    "area": "TI/Projetos",
    "expertise": "Gestão de projetos|Chatbot WhatsApp|Autoatendimento",
    "reunioes_participou": "17/12/2025|22/12/2025|29/12/2025|07/01/2026",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "João Endo",
    "nome_completo": "João Vitor Yuji Endo",
    "papel": "Key User - Construção Civil",
    "tipo": "key_user",
    "area": "Comercial/Construção Civil",
    "expertise": "Vendas construção civil|Processos comerciais|SAP",
    "reunioes_participou": "04/12/2025|16/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Francine Gayer",
    "papel": "Key User - Protec",
    "tipo": "key_user",
    "area": "Comercial/Protec",
    "expertise": "Proteção agrícola|Concorrentes|Market share",
    "reunioes_participou": "04/12/2025|10/12/2025|16/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Bruno Machado",
    "nome_completo": "Bruno Nolasco Machado",
    "papel": "Key User - Agro/DCPC",
    "tipo": "key_user",
    "area": "Comercial/Agro",
    "expertise": "Agricultura|DCPC|Processos comerciais",
    "reunioes_participou": "04/12/2025|10/12/2025|16/12/2025",
    "status": "Ativo"
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 20, '{
    "nome": "Renata Mello",
    "nome_completo": "Renata Drumond Amorim Conrado De Mello",
    "papel": "Key User - AMD",
    "tipo": "key_user",
    "area": "AMD/ArcelorMittal Distribuição",
    "expertise": "Processo cross company|AMD|Distribuição",
    "reunioes_participou": "10/12/2025|16/12/2025",
    "status": "Ativo"
}');
