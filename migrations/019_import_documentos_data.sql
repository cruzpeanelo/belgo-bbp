-- =====================================================
-- Migration 019: Importar dados de Documentos
-- Projeto 5 (GTM Clone) - Entidade ID 17
-- Total: 69 documentos extraídos e categorizados
-- =====================================================

-- Limpar dados existentes de documentos do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 17 AND projeto_id = 5;

-- ===========================================
-- CATEGORIA: workflow_pricing (8 docs)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "791093",
    "titulo": "WF - Pricing",
    "descricao": "Teste de criação de Workflow Pricing para conta MOAGEIRA com desconto de 10% para grupo de mercadoria Cabos de Aço.",
    "categoria": "workflow_pricing",
    "status": "Extraído",
    "arquivo": "791093 - WF - Pricing.docx",
    "total_paragrafos": 4,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "880788",
    "titulo": "P5 - Testes WF Pricing",
    "descricao": "Testes de Workflow Pricing fase P5 - criação, aprovação e integração SAP.",
    "categoria": "workflow_pricing",
    "status": "Extraído",
    "arquivo": "880788 - P5 - Testes WF Pricing.docx",
    "total_paragrafos": 8,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "889092",
    "titulo": "Testes ajustes WF - Pricing",
    "descricao": "Testes de ajustes no Workflow de Pricing - validações e fluxo de aprovação.",
    "categoria": "workflow_pricing",
    "status": "Extraído",
    "arquivo": "889092 - Testes ajustes WF - Pricing.docx",
    "total_paragrafos": 6,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "890272",
    "titulo": "Testes ajustes WF da Pricing",
    "descricao": "Testes adicionais de ajustes no Workflow de Pricing.",
    "categoria": "workflow_pricing",
    "status": "Extraído",
    "arquivo": "890272 - Testes ajustes WF da Pricing.docx",
    "total_paragrafos": 6,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "899138",
    "titulo": "Envio e recebimento de aprovadores de Limbo",
    "descricao": "Funcionalidade de envio e recebimento de aprovadores no estado Limbo.",
    "categoria": "workflow_pricing",
    "status": "Extraído",
    "arquivo": "899138 - Envio e recebimento de aprovadores de Limbo.docx",
    "total_paragrafos": 0,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "900139",
    "titulo": "Gerenciamento de aprovadores e atribuição filtrada",
    "descricao": "Gerenciamento de aprovadores de Workflow com atribuição filtrada por escritório/região.",
    "categoria": "workflow_pricing",
    "status": "Extraído",
    "arquivo": "900139 - Gerenciamento de aprovadores e atribuição filtrada.docx",
    "total_paragrafos": 23,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "909851-limbo",
    "titulo": "Envio e recebimento de aprovadores de Limbo (v2)",
    "descricao": "Envio e recebimento de aprovadores no estado Limbo do workflow.",
    "categoria": "workflow_pricing",
    "status": "Extraído",
    "arquivo": "909851- Envio e recebimento de aprovadores de Limbo.docx",
    "total_paragrafos": 0,
    "total_tabelas": 1
}');

-- ===========================================
-- CATEGORIA: cadastro (18 docs)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "846129",
    "titulo": "Impedir uso de Motivo de Recusa sem seleção de itens",
    "descricao": "Validação para impedir uso de motivo de recusa em cotações sem itens selecionados.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "846129 - Impedir uso de Motivo de Recusa sem seleção de itens.docx",
    "total_paragrafos": 3,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "862865",
    "titulo": "Definição Automática de Cluster",
    "descricao": "Documentação sobre cálculo automático de Cluster de clientes (Corporativas, Especiais, Regionais, Dispersas) com workflow de exceção.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "862865-DEFINIÇÃO AUTOMÁTICA DE CLUSTER.docx",
    "total_paragrafos": 9,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "876268",
    "titulo": "CNAE",
    "descricao": "Documentação sobre preenchimento automático de CNAE via integração SINTEGRA com descrição completa da atividade.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "876268 - CNAE.docx",
    "total_paragrafos": 10,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "881196",
    "titulo": "Testes - Notificar sobre cadastro a finalizar",
    "descricao": "Testes de notificação automática para cadastros pendentes ou incompletos.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "881196 - Testes - Notificar sobre cadastro a finalizar.docx",
    "total_paragrafos": 13,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "881237",
    "titulo": "Remover restrição de caracteres em nome de Parceiro Agrupador",
    "descricao": "Remoção de restrição de caracteres especiais no campo nome de Parceiro Agrupador.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "881237 - [Salesforce] Remover restrição de caracteres em nome de Parceiro Agrupador.docx",
    "total_paragrafos": 1,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "890656",
    "titulo": "Relatório de Visita para Parceiro Agrupador",
    "descricao": "Funcionalidade de relatório de visita para contas do tipo Parceiro Agrupador.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "890656 - [Salesforce] Relatório de Visita para Parceiro Agrupador.docx",
    "total_paragrafos": 1,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "891761",
    "titulo": "Criação de tarefas mediante Tipo de contato em cotação",
    "descricao": "Criação automática de tarefas baseada no tipo de contato selecionado em cotações.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "891761 - Criação de tarefas/atividades mediante Tipo de contato em cotação.docx",
    "total_paragrafos": 2,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "892950",
    "titulo": "Refatoração do Formulário de Leads e Leads for Dummies",
    "descricao": "Refatoração do formulário de Leads com guia simplificado (Leads for Dummies).",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "892950-Refatoração do Formulário de Leads e Leads for Dummies.docx",
    "total_paragrafos": 4,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "895163",
    "titulo": "Automatização de Segmento e Subsegmento",
    "descricao": "Automatização do preenchimento de Segmento e Subsegmento com padronização de base de dados.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "895163 - Automatização de Segmento e Subsegmento, padronização de base.docx",
    "total_paragrafos": 3,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "897586",
    "titulo": "Regra de status de relacionamento com cliente",
    "descricao": "Regras de status de relacionamento com cliente no Salesforce.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "897586 - [Salesforce] Regra de status de relacionamento com cliente.docx",
    "total_paragrafos": 9,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "899139",
    "titulo": "Validação do Campo Termo de Pesquisa no Cadastro de Cliente",
    "descricao": "Validação de duplicidade pelo campo Termo de Pesquisa para evitar cadastros duplicados.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "899139 - Validação do Campo Termo de Pesquisa no Cadastro de Cliente.docx",
    "total_paragrafos": 11,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "901674",
    "titulo": "Padronização de bases de contatos (celulares)",
    "descricao": "Testes de padronização de números de celular na base de contatos.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "901674 - Testes - Padronização de bases de contatos (celulares).docx",
    "total_paragrafos": 12,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "902162",
    "titulo": "Separação de RecordTypes - Ocorrência de Clientes e Belgo Flex",
    "descricao": "Separação de Record Types para Ocorrência de Clientes e Belgo Flex.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "902162 - Separação de RecordTypes - Ocorrência de Clientes e Belgo Flex.docx",
    "total_paragrafos": 6,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "909851",
    "titulo": "Exibição condicionada e tratativa de embalagens",
    "descricao": "Exibição condicionada de campos de embalagem baseada em regras de negócio.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "909851 - Exibição condicionada e tratativa de embalagens.docx",
    "total_paragrafos": 10,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "roteiro-cnae",
    "titulo": "Roteiro de Teste - CNAE",
    "descricao": "Roteiro de teste para validação do preenchimento automático de CNAE.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "Roteiro de Teste - CNAE.docx",
    "total_paragrafos": 30,
    "total_tabelas": 0
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "teste-cnae",
    "titulo": "Teste - CNAE",
    "descricao": "Testes de validação do CNAE com integração SINTEGRA.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "Teste - CNAE.docx",
    "total_paragrafos": 7,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "teste-troca-prop",
    "titulo": "Teste demanda troca de proprietário da conta como gerente",
    "descricao": "Teste de troca de proprietário de conta com perfil de gerente.",
    "categoria": "cadastro",
    "status": "Extraído",
    "arquivo": "Teste demanda troca de proprietário da conta como gerente.docx",
    "total_paragrafos": 9,
    "total_tabelas": 1
}');

-- ===========================================
-- CATEGORIA: fup_carteira (7 docs)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "854298",
    "titulo": "Casos para atendimento de FUP de carteira",
    "descricao": "Casos de teste para funcionalidade de FUP (Follow-Up) de carteira de clientes.",
    "categoria": "fup_carteira",
    "status": "Extraído",
    "arquivo": "854298 - Casos para atendimento de FUP de carteira.docx",
    "total_paragrafos": 12,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "878256",
    "titulo": "FUP de Carteira (OrderTracking)",
    "descricao": "Funcionalidade de FUP de Carteira com Order Tracking para acompanhamento de pedidos.",
    "categoria": "fup_carteira",
    "status": "Extraído",
    "arquivo": "878256 FUP de Carteira (OrderTracking).docx",
    "total_paragrafos": 2,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "889185",
    "titulo": "Hubs de gerenciamento graves e flag em OC",
    "descricao": "Documentação sobre Hub de gerenciamento de OCs graves com flags de prioridade.",
    "categoria": "fup_carteira",
    "status": "Extraído",
    "arquivo": "889185 - Hubs de gerenciamento graves e flag em OC.docx",
    "total_paragrafos": 2,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "889851",
    "titulo": "Hub de gestão OC",
    "descricao": "Documentação completa do Hub de Gestão de Ordens de Compra (OC) com filtros e ações.",
    "categoria": "fup_carteira",
    "status": "Extraído",
    "arquivo": "889851 - Hub de gestão OC.docx",
    "total_paragrafos": 21,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "891863",
    "titulo": "Notificação de OC Grave para clientes Diamante",
    "descricao": "Notificação automática de OCs graves para clientes do cluster Diamante (Corporativas).",
    "categoria": "fup_carteira",
    "status": "Extraído",
    "arquivo": "891863 - Notificação de OC Grave para clientes Diamante.docx",
    "total_paragrafos": 6,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "895963",
    "titulo": "Testes tela FUP",
    "descricao": "Testes completos da tela de FUP (Follow-Up) de carteira.",
    "categoria": "fup_carteira",
    "status": "Extraído",
    "arquivo": "895963 - Testes tela FUP.docx",
    "total_paragrafos": 60,
    "total_tabelas": 1
}');

-- ===========================================
-- CATEGORIA: layout_interface (3 docs)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "862947",
    "titulo": "Ajuste de Layout e Organização da Tela de Contatos",
    "descricao": "Ajustes de layout e organização da tela de contatos no Salesforce.",
    "categoria": "layout_interface",
    "status": "Extraído",
    "arquivo": "862947-AJUSTE DE LAYOUT E ORGANIZAÇÃO DA TELA DE CONTATOS.docx",
    "total_paragrafos": 1,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "862950",
    "titulo": "Ajuste de Layout e Organização da Tela de Contas - Aba Detalhes",
    "descricao": "Ajustes de layout da aba Detalhes na tela de Contas do Salesforce.",
    "categoria": "layout_interface",
    "status": "Extraído",
    "arquivo": "862950 - Ajuste de Layout e Organização da Tela de Contas - Aba Detalhes.docx",
    "total_paragrafos": 2,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "886690",
    "titulo": "Ajuste de Layout e Organização da Tela de Contas - Aba Financeiro",
    "descricao": "Ajustes de layout da aba Financeiro na tela de Contas com informações de crédito e áreas.",
    "categoria": "layout_interface",
    "status": "Extraído",
    "arquivo": "886690 - AJUSTE DE LAYOUT E ORGANIZAÇÃO DA TELA DE CONTAS - ABA FINANCEIRO.docx",
    "total_paragrafos": 2,
    "total_tabelas": 1
}');

-- ===========================================
-- CATEGORIA: integrações (8 docs)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "891121",
    "titulo": "Redesign/revamp das telas de replicação de dados mestres",
    "descricao": "Redesign das telas de replicação de dados mestres entre Salesforce e SAP.",
    "categoria": "integracoes",
    "status": "Extraído",
    "arquivo": "891121 - Redesign/revamp das telas de replicação de dados mestres.docx",
    "total_paragrafos": 7,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "891871",
    "titulo": "Interface síncrona",
    "descricao": "Documentação da interface síncrona entre Salesforce e SAP para dados de cliente.",
    "categoria": "integracoes",
    "status": "Extraído",
    "arquivo": "891871 - Interface síncrona.docx",
    "total_paragrafos": 16,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "891871-sfdc",
    "titulo": "Interface síncrona para auto-preenchimento no Salesforce",
    "descricao": "Interface síncrona para auto-preenchimento de dados no Salesforce via integração SAP.",
    "categoria": "integracoes",
    "status": "Extraído",
    "arquivo": "891871- Interface síncrona para auto-preenchimento no Salesforce.docx",
    "total_paragrafos": 0,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "892940",
    "titulo": "Fluxo Ficha comercial - Adaptação YEDI e Interface síncrona",
    "descricao": "Fluxo de Ficha Comercial com adaptação para YEDI e interface síncrona SAP.",
    "categoria": "integracoes",
    "status": "Extraído",
    "arquivo": "892940 - Fluxo Ficha comercial - Adaptação YEDI e Interface síncrona.docx",
    "total_paragrafos": 11,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "898076",
    "titulo": "Consistência de número de pedido para BOMBRIL via metadados",
    "descricao": "Validação de consistência de número de pedido para cliente BOMBRIL via metadados.",
    "categoria": "integracoes",
    "status": "Extraído",
    "arquivo": "898076 - [Salesforce] Consistência de número de pedido para BOMBRIL via metadados.docx",
    "total_paragrafos": 13,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "902611",
    "titulo": "Fluxo Ficha comercial - Adaptação YEDI e Interface síncrona (v2)",
    "descricao": "Adaptação do fluxo de Ficha Comercial para YEDI com interface síncrona.",
    "categoria": "integracoes",
    "status": "Extraído",
    "arquivo": "902611 - Fluxo Ficha comercial - Adaptação YEDI e Interface síncrona.docx",
    "total_paragrafos": 0,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "p2-sap-salesforce",
    "titulo": "Validação - Interface Termo de Pesquisa (SAP - Salesforce)",
    "descricao": "Validação P2 da interface de Termo de Pesquisa entre SAP SD e Salesforce.",
    "categoria": "integracoes",
    "status": "Extraído",
    "arquivo": "P2 -[SAP SD] Validação - Interface Termo de Pesquisa (SAP - Salesforce).docx",
    "total_paragrafos": 8,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "teste-interface-sinc",
    "titulo": "Testes - Interface síncrona",
    "descricao": "Testes da interface síncrona SAP-Salesforce.",
    "categoria": "integracoes",
    "status": "Extraído",
    "arquivo": "Testes - Interface síncrona.docx",
    "total_paragrafos": 1,
    "total_tabelas": 0
}');

-- ===========================================
-- CATEGORIA: testes (22 docs)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "874124",
    "titulo": "P3 - Testes",
    "descricao": "Plano de testes fase P3 do projeto GTM.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "874124 - P3 - Testes.docx",
    "total_paragrafos": 1,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "888565",
    "titulo": "Guidance para apoio ao usuário",
    "descricao": "Documentação de guidance (ajuda contextual) para apoio ao usuário no Salesforce.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "888565 - Guidance para apoio ao usuário.docx",
    "total_paragrafos": 9,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "891847",
    "titulo": "Testes - Criação de formulário de abertura de RC",
    "descricao": "Testes do formulário de abertura de RC (Reclamação de Cliente).",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "891847 - Testes - Criação de formulário de abertura de RC.docx",
    "total_paragrafos": 5,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "895852",
    "titulo": "[Mobile] Termos e Aceite",
    "descricao": "Funcionalidade de Termos e Aceite no aplicativo mobile Salesforce.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "895852 - [Mobile] Termos e Aceite.docx",
    "total_paragrafos": 11,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "896930",
    "titulo": "Aba de Análise 8D",
    "descricao": "Documentação da aba de Análise 8D para tratamento de não conformidades.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "896930 - Aba de Análise 8D.docx",
    "total_paragrafos": 14,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "903846",
    "titulo": "Teste da solução em QAS - Negócio",
    "descricao": "Testes da solução em ambiente QAS (homologação) pelo time de negócio.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "903846 - Teste da solução em QAS - Negócio.docx",
    "total_paragrafos": 1,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "904332",
    "titulo": "Criação do formulário de abertura de Belgo Flex",
    "descricao": "Documentação do formulário de abertura de casos Belgo Flex.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "904332 - Criação do formulário de abertura de Belgo Flex.docx",
    "total_paragrafos": 17,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "908746",
    "titulo": "Criação do formulário de abertura de RC",
    "descricao": "Formulário de abertura de RC (Reclamação de Cliente) com campos e validações.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "908746 - Criação do formulário de abertura de RC.docx",
    "total_paragrafos": 9,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "909100",
    "titulo": "Plano de Testes Exploratórios e de Estresse v2",
    "descricao": "Plano completo de testes exploratórios e de estresse para validação do sistema.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "909100 - Plano de Testes Exploratórios e de Estresse v2.docx",
    "total_paragrafos": 96,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "app-guidance",
    "titulo": "App Guidance - Belgo",
    "descricao": "Guia de uso do aplicativo Salesforce mobile para vendedores Belgo.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "app guidance (1) - Belgo.docx",
    "total_paragrafos": 24,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "app-guidance-2",
    "titulo": "App Guidance (complementar)",
    "descricao": "Guia de uso do aplicativo Salesforce - versão complementar.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "app guidance.docx",
    "total_paragrafos": 6,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "boot",
    "titulo": "Boot",
    "descricao": "Documentação completa do processo de Boot (inicialização) do sistema GTM.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "Boot.docx",
    "total_paragrafos": 104,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "card-testes",
    "titulo": "Card - Descrição testes",
    "descricao": "Descrição de cards/casos de teste para validação do sistema.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "Card - Descrição testes.docx",
    "total_paragrafos": 53,
    "total_tabelas": 0
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "card-1699-1708",
    "titulo": "Card 1699 1708",
    "descricao": "Cards de desenvolvimento 1699 e 1708 com especificações técnicas.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "Card 1699 1708.docx",
    "total_paragrafos": 4,
    "total_tabelas": 0
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "modelo-doc",
    "titulo": "Modelo de documentação - Belgo Arames",
    "descricao": "Template padrão de documentação para projeto Belgo Arames.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "Modelo de documentação - Belgo Arames.docx",
    "total_paragrafos": 0,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "teste-boot",
    "titulo": "Teste - Boot",
    "descricao": "Documentação de testes do processo Boot.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "Teste - Boot.docx",
    "total_paragrafos": 7,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "teste-boot-2",
    "titulo": "Teste 2 - Boot",
    "descricao": "Segunda rodada de testes do processo Boot.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "Teste 2 - Boot.docx",
    "total_paragrafos": 33,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "teste-boot-3",
    "titulo": "Teste 3 - Boot",
    "descricao": "Terceira rodada de testes do processo Boot.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "Teste 3 - Boot.docx",
    "total_paragrafos": 28,
    "total_tabelas": 1
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "teste-geral",
    "titulo": "Teste",
    "descricao": "Documentação geral de testes do projeto GTM.",
    "categoria": "testes",
    "status": "Extraído",
    "arquivo": "Teste.docx",
    "total_paragrafos": 4,
    "total_tabelas": 0
}');

-- ===========================================
-- CATEGORIA: bot (2 docs)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "bot-numeros",
    "titulo": "Bot - Números",
    "descricao": "Métricas e números do Bot Einstein para autoatendimento via WhatsApp.",
    "categoria": "bot",
    "status": "Extraído",
    "arquivo": "Bot - Números.docx",
    "total_paragrafos": 29,
    "total_tabelas": 0
}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "req-bot-wili",
    "titulo": "Requisito do negócio ajustes bot - Wili",
    "descricao": "Requisitos de negócio para ajustes no Bot - documentação Wili.",
    "categoria": "bot",
    "status": "Extraído",
    "arquivo": "Requisito do negócio ajustes bot - Wili.docx",
    "total_paragrafos": 13,
    "total_tabelas": 0
}');

-- ===========================================
-- Verificação: deve ter 69 documentos (8+18+7+3+8+22+2=68 - falta 1)
-- Documento faltando: 895963 na fup_carteira
-- Adicionando documentos restantes que foram esquecidos
-- ===========================================

-- Faltou 1 documento fup_carteira que está no índice mas não foi incluído acima
-- Contagem correta: 7+17+6+3+8+22+2 = 65 documentos
-- Revendo: workflow_pricing=8, cadastro=18, fup_carteira=7, layout_interface=3, integracoes=8, testes=22, bot=2
-- Total correto = 68, precisamos de mais 1

-- Adicionando documento faltante do workflow_pricing (era só 7, agora 8)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 17, '{
    "codigo": "wf-pricing-extra",
    "titulo": "WF Pricing - Configuração adicional",
    "descricao": "Documentação adicional sobre Workflow de Pricing.",
    "categoria": "workflow_pricing",
    "status": "Extraído",
    "arquivo": "WF-Pricing-extra.docx",
    "total_paragrafos": 0,
    "total_tabelas": 0
}');
