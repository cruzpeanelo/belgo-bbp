-- =====================================================
-- Migration 015: Importar dados completos do Glossario
-- Projeto 5 (GTM Clone) - Entidade ID 21
-- =====================================================

-- Limpar dados existentes do glossario do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 21 AND projeto_id = 5;

-- Sistemas
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"ASCP","nome_completo":"Advanced Supply Chain Planning","termo":"ASCP","definicao":"Módulo SAP para gestão de áreas de crédito","contexto":"Integração principal para limites de crédito","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"FSCM","nome_completo":"Financial Supply Chain Management","termo":"FSCM","definicao":"Solução SAP para gestão financeira da cadeia de suprimentos","contexto":"Integrado com áreas de crédito","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"BRO","nome_completo":"Business Role Objects","termo":"BRO","definicao":"Sistema legado de cadastro de clientes","contexto":"Sendo substituído pelo novo modelo Salesforce","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"SINTEGRA","nome_completo":"Sistema Integrado de Informações sobre Operações Interestaduais","termo":"SINTEGRA","definicao":"Base de dados fiscais estaduais","contexto":"Integração para validação de dados cadastrais","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"ALPE","nome_completo":"Área Crédito Aços Longos PE","termo":"ALPE","definicao":"Sistema e área de crédito para Aços Longos","contexto":"Uma das 4 áreas de crédito do projeto","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"GTM","nome_completo":"Go-To-Market","termo":"GTM","definicao":"Estratégia de entrada no mercado","contexto":"Projeto GTM Vendas - Salesforce","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Salesforce","nome_completo":"Salesforce CRM","termo":"Salesforce","definicao":"Plataforma CRM central do projeto GTM","contexto":"Sistema central do projeto","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Dow Jones","nome_completo":"Dow Jones Risk & Compliance","termo":"Dow Jones","definicao":"Sistema de compliance para due diligence de clientes","contexto":"Integração pendente para validação de novos clientes","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Araujo","nome_completo":"Sistema Araujo","termo":"Araujo","definicao":"Sistema de automação de documentos fiscais (XML, NF-e, certificados)","contexto":"Trigger disparado pelo SAP para emissão automática","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Portal Logístico","nome_completo":"Portal de Logística","termo":"Portal Logístico","definicao":"Portal separado para gestão de restrições de entrega e agendamentos","contexto":"Integração com SAP pendente - redundância de dados","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Belgo Cash","nome_completo":"Belgo Cash","termo":"Belgo Cash","definicao":"Produto de crédito/financiamento para clientes","contexto":"Vinculado à área de crédito CSP","categoria":"sistemas"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"On Based","nome_completo":"On Based","termo":"On Based","definicao":"Sistema de arquivamento de documentos financeiros (Serasa, DRE, balanços)","contexto":"Usado pela equipe financeira para análise de crédito","categoria":"sistemas"}');

-- Transações SAP
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"XD01","nome_completo":"Criar Cliente","termo":"XD01","definicao":"Transação SAP para criação de cliente no dado mestre","contexto":"Substituída pelo cadastro via Salesforce no TO-BE","categoria":"transacoes_sap"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"XD02","nome_completo":"Alterar Cliente","termo":"XD02","definicao":"Transação SAP para alteração de dados do cliente","contexto":"SmartCenter usa para complemento de dados","categoria":"transacoes_sap"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"XD03","nome_completo":"Exibir Cliente","termo":"XD03","definicao":"Transação SAP para visualização de dados do cliente","contexto":"Restrições logísticas aparecem aqui","categoria":"transacoes_sap"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"FMBL5N","nome_completo":"Consulta de Partidas","termo":"FMBL5N","definicao":"Transação SAP para consulta de partidas financeiras","contexto":"Base para tela de consulta de partidas no Salesforce","categoria":"transacoes_sap"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"FBL50","nome_completo":"Consulta Partidas Cliente","termo":"FBL50","definicao":"Transação SAP para consulta de partidas do cliente","contexto":"Usado para verificar títulos em aberto e pagos","categoria":"transacoes_sap"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"KM_BP","nome_completo":"Gestão de Crédito BP","termo":"KM_BP","definicao":"Nova transação SAP para gestão de crédito de business partners","contexto":"Substituiu transação antiga de gestão de limites","categoria":"transacoes_sap"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"ZW_SSD_145","nome_completo":"Ficha Comercial","termo":"ZW_SSD_145","definicao":"Transação customizada para ficha comercial do cliente","contexto":"Usado para negociação de preços e condições","categoria":"transacoes_sap"}');

-- Áreas de Crédito
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"BBA","nome_completo":"Limite Interno Belgo","termo":"BBA","definicao":"Área de crédito interna da Belgo","contexto":"Também conhecida como ABBA","categoria":"areas_credito"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"CSP","nome_completo":"Supply/Belgo Cash","termo":"CSP","definicao":"Área de crédito para supply e Belgo Cash","contexto":"Gerencia crédito para operações de financiamento","categoria":"areas_credito"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"DBA","nome_completo":"Distribuição","termo":"DBA","definicao":"Área de crédito para canal de distribuição","contexto":"Gerenciada pela própria Rede, também conhecida como ADBA","categoria":"areas_credito"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"ALPE","nome_completo":"Aços Longos PE","termo":"ALPE","definicao":"Área de crédito para Aços Longos Pernambuco","contexto":"Também conhecida como BTC ou ABPE","categoria":"areas_credito"}');

-- Canais de Venda
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Canal 20","nome_completo":"Canal Indústria","termo":"Canal 20","definicao":"Canal de vendas para clientes industriais","contexto":"Empresas com CNAE de atividade industrial (transformação, fabricação)","categoria":"canais"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Canal 25","nome_completo":"Canal Casos Especiais","termo":"Canal 25","definicao":"Canal para exceções e casos especiais","contexto":"Requer aprovação da diretoria comercial","categoria":"canais"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Canal 30","nome_completo":"Canal Distribuição","termo":"Canal 30","definicao":"Canal para distribuidores e revendas","contexto":"Empresas com CNAE de comércio atacadista ou varejista","categoria":"canais"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Canal 40","nome_completo":"Canal Consumidor Final","termo":"Canal 40","definicao":"Canal para varejo e consumidor final","contexto":"Pessoa Física ou pequenas empresas sem fins de revenda","categoria":"canais"}');

-- Clusters
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Corporativas","nome_completo":"Contas Corporativas","termo":"Corporativas","definicao":"Grandes contas com alto volume de compras","contexto":"Cluster para clientes estratégicos de alto potencial","categoria":"clusters"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Especiais","nome_completo":"Contas Especiais","termo":"Especiais","definicao":"Contas com tratamento diferenciado","contexto":"Cluster para clientes com condições especiais aprovadas","categoria":"clusters"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Regionais","nome_completo":"Contas Regionais","termo":"Regionais","definicao":"Contas de atuação regional","contexto":"Cluster para clientes com presença regional significativa","categoria":"clusters"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"Dispersas","nome_completo":"Contas Dispersas","termo":"Dispersas","definicao":"Contas menores e dispersas geograficamente","contexto":"Cluster para clientes de menor volume","categoria":"clusters"}');

-- Termos Gerais
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"CNAE","nome_completo":"Classificação Nacional de Atividades Econômicas","termo":"CNAE","definicao":"Código que classifica a atividade econômica da empresa","contexto":"Preenchido automaticamente via SINTEGRA","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"IE","nome_completo":"Inscrição Estadual","termo":"IE","definicao":"Registro estadual do contribuinte","contexto":"Obtido via integração SINTEGRA","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"YDCF","nome_completo":"Desconto de Cliente","termo":"YDCF","definicao":"Condition type SAP para descontos de cliente","contexto":"Criada automaticamente após aprovação do Workflow Pricing","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"ATP","nome_completo":"Available to Promise","termo":"ATP","definicao":"Disponibilidade prometida - verificação de estoque em tempo real","contexto":"Usado em cotações para garantir disponibilidade","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"LWC","nome_completo":"Lightning Web Components","termo":"LWC","definicao":"Framework Salesforce para desenvolvimento de componentes web","contexto":"Usado no Hub de Gestão OC","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"SOX","nome_completo":"Sarbanes-Oxley Act","termo":"SOX","definicao":"Lei americana de compliance para controles financeiros","contexto":"Impacta aprovações e auditorias do projeto","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"NF-e","nome_completo":"Nota Fiscal Eletrônica","termo":"NF-e","definicao":"Documento fiscal eletrônico de venda","contexto":"Gerado automaticamente pelo sistema Araujo","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"DANFE","nome_completo":"Documento Auxiliar da NF-e","termo":"DANFE","definicao":"Documento impresso que acompanha a mercadoria","contexto":"Gerado automaticamente com a NF-e","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"PJ","nome_completo":"Pessoa Jurídica","termo":"PJ","definicao":"Tipo de conta para empresas com CNPJ","contexto":"Record Type PJ_Standard no Salesforce","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"PF","nome_completo":"Pessoa Física","termo":"PF","definicao":"Tipo de conta para clientes individuais com CPF","contexto":"Record Type PF_Standard no Salesforce","categoria":"termos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{"sigla":"AMD","nome_completo":"ArcelorMittal Distribuição","termo":"AMD","definicao":"Empresa do grupo para distribuição de produtos","contexto":"Processo cross company pendente de implementação","categoria":"termos"}');
