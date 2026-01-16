-- =====================================================
-- Migration 022: Importar dados do Glossário
-- Projeto 5 (GTM Clone) - Entidade ID 24 (glossario)
-- Total: 72 termos em 11 categorias
-- =====================================================

-- Limpar dados existentes de glossário do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 24 AND projeto_id = 5;

-- ===========================================
-- CATEGORIA: sistemas (12 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "ASCP", "nome": "Advanced Supply Chain Planning", "descricao": "Modulo SAP para gestão de áreas de crédito", "categoria": "sistemas", "contexto": "Integração principal para limites de crédito"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "FSCM", "nome": "Financial Supply Chain Management", "descricao": "Solução SAP para gestão financeira da cadeia de suprimentos", "categoria": "sistemas", "contexto": "Integrado com áreas de crédito"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "BRO", "nome": "Business Role Objects", "descricao": "Sistema legado de cadastro de clientes", "categoria": "sistemas", "contexto": "Sendo substituído pelo novo modelo Salesforce"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "SINTEGRA", "nome": "Sistema Integrado de Informações sobre Operações Interestaduais", "descricao": "Base de dados fiscais estaduais", "categoria": "sistemas", "contexto": "Integração para validação de dados cadastrais"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "ALPE", "nome": "Área Crédito Aços Longos PE", "descricao": "Sistema e área de crédito para Aços Longos", "categoria": "sistemas", "contexto": "Uma das 4 áreas de crédito do projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "GTM", "nome": "Go-To-Market", "descricao": "Estratégia de entrada no mercado", "categoria": "sistemas", "contexto": "Projeto GTM Vendas - Salesforce"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Salesforce", "nome": "Salesforce CRM", "descricao": "Plataforma CRM central do projeto GTM", "categoria": "sistemas", "contexto": "Sistema central do projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Dow Jones", "nome": "Dow Jones Risk & Compliance", "descricao": "Sistema de compliance para due diligence de clientes", "categoria": "sistemas", "contexto": "Integração pendente para validação de novos clientes"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Araujo", "nome": "Sistema Araujo", "descricao": "Sistema de automação de documentos fiscais (XML, NF-e, certificados)", "categoria": "sistemas", "contexto": "Trigger disparado pelo SAP para emissão automática"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Portal Logístico", "nome": "Portal de Logística", "descricao": "Portal separado para gestão de restrições de entrega e agendamentos", "categoria": "sistemas", "contexto": "Integração com SAP pendente - redundância de dados"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Belgo Cash", "nome": "Belgo Cash", "descricao": "Produto de crédito/financiamento para clientes", "categoria": "sistemas", "contexto": "Vinculado à área de crédito CSP"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "On Based", "nome": "On Based", "descricao": "Sistema de arquivamento de documentos financeiros (Serasa, DRE, balanços)", "categoria": "sistemas", "contexto": "Usado pela equipe financeira para análise de crédito"}');

-- ===========================================
-- CATEGORIA: transacoesSAP (7 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "XD01", "nome": "Criar Cliente", "descricao": "Transação SAP para criação de cliente no dado mestre", "categoria": "transacoes_sap", "contexto": "Substituída pelo cadastro via Salesforce no TO-BE"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "XD02", "nome": "Alterar Cliente", "descricao": "Transação SAP para alteração de dados do cliente", "categoria": "transacoes_sap", "contexto": "SmartCenter usa para complemento de dados"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "XD03", "nome": "Exibir Cliente", "descricao": "Transação SAP para visualização de dados do cliente", "categoria": "transacoes_sap", "contexto": "Restrições logísticas aparecem aqui"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "FMBL5N", "nome": "Consulta de Partidas", "descricao": "Transação SAP para consulta de partidas financeiras", "categoria": "transacoes_sap", "contexto": "Base para tela de consulta de partidas no Salesforce"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "FBL50", "nome": "Consulta Partidas Cliente", "descricao": "Transação SAP para consulta de partidas do cliente", "categoria": "transacoes_sap", "contexto": "Usado para verificar títulos em aberto e pagos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "KM_BP", "nome": "Gestão de Crédito BP", "descricao": "Nova transação SAP para gestão de crédito de business partners", "categoria": "transacoes_sap", "contexto": "Substituiu transação antiga de gestão de limites"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "ZW_SSD_145", "nome": "Ficha Comercial", "descricao": "Transação customizada para ficha comercial do cliente", "categoria": "transacoes_sap", "contexto": "Usado para negociação de preços e condições"}');

-- ===========================================
-- CATEGORIA: áreas de crédito (4 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "BBA", "nome": "Limite Interno Belgo", "descricao": "Área de crédito interna", "categoria": "areas_credito", "alternativo": "ABBA", "status": "confirmado"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "CSP", "nome": "Supply/Belgo Cash", "descricao": "Área de crédito supplier", "categoria": "areas_credito", "status": "confirmado"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "DBA", "nome": "Distribuição", "descricao": "Área de crédito distribuidor - gerenciada pela própria Rede", "categoria": "areas_credito", "alternativo": "ADBA", "status": "confirmado"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "ALPE_CREDITO", "nome": "Aços Longos PE", "descricao": "Área de crédito Aços Longos Pernambuco", "categoria": "areas_credito", "alternativo": "ABPE", "status": "confirmado"}');

-- ===========================================
-- CATEGORIA: canais (4 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Canal 20", "nome": "Indústria", "descricao": "Canal de vendas industriais", "categoria": "canais"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Canal 25", "nome": "Casos Especiais", "descricao": "Exceções e casos especiais", "categoria": "canais"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Canal 30", "nome": "Distribuição", "descricao": "Canal de distribuidores", "categoria": "canais"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Canal 40", "nome": "Consumo", "descricao": "Canal de varejo/consumo", "categoria": "canais"}');

-- ===========================================
-- CATEGORIA: tipos de registro (3 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "PJ", "nome": "Pessoa Jurídica", "descricao": "Cliente empresa", "categoria": "tipos_registro"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "PF", "nome": "Pessoa Física", "descricao": "Cliente individual", "categoria": "tipos_registro"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Agrupador", "nome": "Conta Agrupadora", "descricao": "Conta que agrupa outras contas (matriz/filiais)", "categoria": "tipos_registro"}');

-- ===========================================
-- CATEGORIA: processos (5 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "FUP", "nome": "Follow-Up", "descricao": "Acompanhamento de carteira de clientes", "categoria": "processos", "contexto": "Jornada FUP de Carteira"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "OC", "nome": "Ordem de Compra", "descricao": "Pedido de venda", "categoria": "processos", "contexto": "Hub de Gestão de OC"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "WF", "nome": "Workflow", "descricao": "Fluxo de trabalho automatizado", "categoria": "processos", "contexto": "Workflow Pricing"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "CNAE", "nome": "Classificação Nacional de Atividades Econômicas", "descricao": "Código de atividade empresarial", "categoria": "processos", "contexto": "Define canal e tratamento fiscal"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "CT", "nome": "Caso de Teste", "descricao": "Cenário de teste no caderno de testes", "categoria": "processos", "contexto": "CT-01, CT-02, etc."}');

-- ===========================================
-- CATEGORIA: conceitos de negócio (10 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "AMD", "nome": "ArcelorMittal Distribuição", "descricao": "Processo cross company para vendas entre empresas do grupo ArcelorMittal", "categoria": "conceitos_negocio", "contexto": "Pendente inclusão no Salesforce"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Ficha Comercial", "nome": "Ficha Comercial do Cliente", "descricao": "Documento de negociação de preços e condições comerciais por cliente", "categoria": "conceitos_negocio", "contexto": "Acessada via transação ZW_SSD_145"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Hard Reboot", "nome": "Hard Reboot de Clientes", "descricao": "Processo de migração massiva de clientes para nova estrutura organizacional", "categoria": "conceitos_negocio", "contexto": "Base de 24 meses de clientes sendo associada aos novos escritórios"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "NPS", "nome": "Net Promoter Score", "descricao": "Métrica de satisfação de clientes baseada em recomendação", "categoria": "conceitos_negocio", "contexto": "Usado para medir qualidade do atendimento"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Share of Wallet", "nome": "Participação de Carteira", "descricao": "Percentual de compra do cliente na Belgo versus concorrentes", "categoria": "conceitos_negocio", "contexto": "Funcionalidade de market share no Salesforce"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Custo de Servir", "nome": "Cost to Serve", "descricao": "Métrica de margem de serviço - meta de 36.2M definida pela Integration", "categoria": "conceitos_negocio", "contexto": "Impacta cálculo de EBITDA e Segment Report"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Termo de Pesquisa", "nome": "Termo de Pesquisa", "descricao": "Identificador único do cliente para evitar duplicidade de cadastro", "categoria": "conceitos_negocio", "contexto": "Validação automática no Salesforce contra base existente"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Parceiro Agrupador", "nome": "Parceiro Agrupador", "descricao": "Tipo de conta para grupos empresariais ou holdings que agrupam múltiplas contas", "categoria": "conceitos_negocio", "contexto": "Um dos 3 tipos de conta: PJ, PF ou Parceiro Agrupador"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Segment Report", "nome": "Segment Report", "descricao": "Relatório de margem e EBITDA por segmento de cliente", "categoria": "conceitos_negocio", "contexto": "Gerenciado pela Controladoria - precisa reestruturação"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "Cluster", "nome": "Cluster de Cliente", "descricao": "Classificação automática de clientes baseada em volume, frequência e potencial", "categoria": "conceitos_negocio", "contexto": "Virada estratégica de segmento de produto para segmento de cliente"}');

-- ===========================================
-- CATEGORIA: caixas de email (2 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "cobranca.limite", "nome": "Caixa Cobrança Limite", "descricao": "Caixa compartilhada para solicitações de limite de crédito", "categoria": "caixas_email", "contexto": "Usado há anos pelos vendedores para solicitar limites"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "cadastro.clientes", "nome": "Caixa Cadastro Clientes", "descricao": "Caixa do SmartCenter para solicitações de alteração de cadastro", "categoria": "caixas_email", "contexto": "Alternativa ao Teams para solicitações rápidas"}');

-- ===========================================
-- CATEGORIA: projeto (7 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "BBP", "nome": "Business Blueprint", "descricao": "Documentação de processos de negócio", "categoria": "projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "HML", "nome": "Homologação", "descricao": "Ambiente de testes de homologação", "categoria": "projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "PRD", "nome": "Produção", "descricao": "Ambiente de produção", "categoria": "projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "AS-IS", "nome": "Estado Atual", "descricao": "Situação atual antes da implementação", "categoria": "projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "TO-BE", "nome": "Estado Futuro", "descricao": "Situação desejada após implementação", "categoria": "projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "GO Live", "nome": "Go Live", "descricao": "Data de entrada em produção", "categoria": "projeto", "data": "15/03/2026"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "UAT", "nome": "User Acceptance Test", "descricao": "Testes de aceitação do usuário", "categoria": "projeto"}');

-- ===========================================
-- CATEGORIA: documentos (4 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "NF", "nome": "Nota Fiscal", "descricao": "Documento fiscal de venda", "categoria": "documentos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "DANFE", "nome": "Documento Auxiliar da NF-e", "descricao": "Representação impressa da NF-e", "categoria": "documentos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "NF-e", "nome": "Nota Fiscal Eletrônica", "descricao": "Nota fiscal em formato eletrônico", "categoria": "documentos"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "XML", "nome": "Extensible Markup Language", "descricao": "Formato de arquivo da NF-e", "categoria": "documentos"}');

-- ===========================================
-- CATEGORIA: participantes (3 termos)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "KU", "nome": "Key User", "descricao": "Usuário-chave do negócio", "categoria": "papeis_projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "PO", "nome": "Product Owner", "descricao": "Dono do produto", "categoria": "papeis_projeto"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 24, '{"sigla": "DTI", "nome": "Diretoria de TI", "descricao": "Área de tecnologia da informação", "categoria": "papeis_projeto"}');
