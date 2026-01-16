-- =====================================================
-- Migration 021: Importar dados de Reuniões
-- Projeto 5 (GTM Clone) - Entidade ID 21 (reunioes)
-- Total: 9 reuniões documentadas com detalhes completos
-- =====================================================

-- Limpar dados existentes de reuniões do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 21 AND projeto_id = 5;

-- ===========================================
-- REUNIÃO 1: Kickoff e Alinhamento de Key Users
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R1",
    "data": "2025-12-04",
    "titulo": "Kickoff e Alinhamento de Key Users",
    "duracao": "2h",
    "tipo": "workshop",
    "resumo": "Reunião inaugural dos workshops AS-IS/TO-BE. Apresentada a visão geral do projeto GTM/CRM para os key users. Comunicada a transição de liderança com saída de Dani Tamerão e licença maternidade de Audrey. Estabelecido compromisso de dedicação de 2 horas semanais por key user para atividades de testes. Identificado problema crítico: vários key users não sabiam que haviam sido designados para este papel.",
    "participantes": "Leandro Cruz|Thalita Rhein|Leandro Gimenez|Vanessa Souza|Bruno Machado|Marcio Silva",
    "topicos_abordados": "Visão geral projeto GTM/CRM|Transição de liderança|Papel e responsabilidades dos key users|Cronograma de workshops",
    "decisoes": "Todos os gerentes devem identificar formalmente seus key users|Key users devem dedicar 2h semanais ao projeto",
    "problemas_identificados": "Key users não sabiam que eram key users|Usuários perguntando: O que preciso testar?",
    "jornadas_relacionadas": "cadastro-cliente|areas-vendas"
}');

-- ===========================================
-- REUNIÃO 2: Cadastro Cliente, Áreas de Vendas e Concorrentes
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R2",
    "data": "2025-12-10",
    "titulo": "Cadastro Cliente, Áreas de Vendas e Concorrentes",
    "duracao": "2h",
    "tipo": "workshop",
    "resumo": "Workshop detalhado sobre processos de cadastro de cliente utilizando SINTEGRA para consulta de dados. Explicados os tipos de conta (PJ, PF, Parceiro Agrupador). Mapeadas as áreas de vendas e canais de distribuição (20-Industrial, 30-Distribuidores, 40-Varejo). Discutido o módulo de documentos fiscais e gestão de contatos. Francine Gayer levantou questão importante sobre sazonalidade dos dados de concorrentes. Zero dúvidas registradas sobre o processo de cadastro.",
    "participantes": "Leandro Cruz|Thalita Rhein|Leandro Gimenez|Joao Endo|Francine Gayer|Bruno Machado|Daniel Goncalves|Jessica Vaz|Renata Mello",
    "topicos_abordados": "Cadastro de cliente via SINTEGRA|Tipos de conta (PJ/PF/Agrupador)|Áreas de vendas e canais|Documentos fiscais|Contatos|Concorrentes|ASCP (Crédito)",
    "decisoes": "Normalização de concorrentes será feita pela TI|Reunião específica com Edmundo sobre gestão de concorrentes",
    "problemas_identificados": "Dados de concorrentes são sazonais e dinâmicos|AMD não tem funcionalidades no Salesforce",
    "jornadas_relacionadas": "cadastro-cliente|areas-vendas|documentos-fiscais|contatos|concorrentes|financeiro"
}');

-- ===========================================
-- REUNIÃO 3: Regras de Clusterização e Apuração de Resultados
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R3",
    "data": "2025-12-12",
    "titulo": "Regras de Clusterização e Apuração de Resultados",
    "duracao": "53 min",
    "tipo": "workshop",
    "resumo": "Definição completa do modelo de clusterização de clientes. Estabelecidas 3 dimensões para classificação: setor do cliente, atratividade (baseada em volume potencial) e região geográfica. Definidos 4 clusters: Contas Corporativas, Contas Especiais, Contas Regionais e Contas Dispersas. Discutida a implementação do cálculo automático de cluster no CRM Salesforce e integração com relatórios BWA/Power BI. Identificada necessidade de higiene de dados para corrigir atribuições incorretas de clusters legados.",
    "participantes": "Maria Ciorlia|Leandro Cruz|Frederico Kinoshita|Fernanda Monteiro|Thalita Rhein|Jefferson Pinheiro|Marcelo Almeida|Luis Riqueti",
    "topicos_abordados": "Visão geral de clusterização|3 dimensões de clusterização|4 clusters de clientes|Cálculo automático no CRM|Custo de servir por cluster|Integração com relatórios",
    "decisoes": "Algoritmo de cluster será automático no CRM|Higiene de dados de clientes necessária|Reuniões de acompanhamento com DCPC e DCCI",
    "problemas_identificados": "Atribuições manuais de cluster incorretas|Necessidade de fonte de dados unificada para relatórios",
    "jornadas_relacionadas": "cadastro-cliente|hub-gestao|workflow-pricing"
}');

-- ===========================================
-- REUNIÃO 4: Documentos Fiscais e Portal de Autoatendimento
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R4",
    "data": "2025-12-16",
    "titulo": "Documentos Fiscais e Portal de Autoatendimento",
    "duracao": "2h",
    "tipo": "workshop",
    "resumo": "Cobertura dos processos de documentos fiscais incluindo NF-e, XML, DANFE e boletos. Apresentadas as integrações com sistemas Daniel (certificados) e Spa (documentos). Destacada a criticidade de manter dados de contato atualizados para funcionamento do autoatendimento. Apresentadas funcionalidades do portal mobile. Identificada pendência crítica na integração do Portal Logístico com SAP, causando redundância de dados. Feedback positivo de Maria sobre didática das sessões.",
    "participantes": "Leandro Cruz|Thalita Rhein|Joao Endo|Francine Gayer|Vanessa Souza|Bruno Machado|Frank Silva",
    "topicos_abordados": "Download documentos fiscais|Integração Daniel/Spa|Dados de contato|Portal Autoatendimento|App Mobile",
    "decisoes": "Campanha de atualização de cadastros iniciada|Follow-up sobre integração Portal Logístico-SAP",
    "problemas_identificados": "Portal Logístico não integrado com SAP|Dados de contato incompletos",
    "jornadas_relacionadas": "documentos-fiscais|autoatendimento|contatos|logistica"
}');

-- ===========================================
-- REUNIÃO 5: Relatórios GTM e Segment Report
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R5",
    "data": "2025-12-17",
    "titulo": "Relatórios GTM e Segment Report",
    "duracao": "1h",
    "tipo": "workshop",
    "resumo": "Discussão focada em segmentação de dados de clientes para relatórios analíticos. Apresentada estrutura de hierarquia de dados para garantir consistência nos relatórios. Definidas responsabilidades de governança e ownership para manutenção das hierarquias. Demonstrada integração com Salesforce para visão unificada. Discutido impacto em relatórios financeiros de custo e receita.",
    "participantes": "Luis Riqueti|Fabricio França|Thalita Rhein|Fernanda Monteiro",
    "topicos_abordados": "Segmentação de dados|Programa de fidelidade|Hierarquia de relatórios|Governança e ownership|Integração Salesforce",
    "decisoes": "Validar campo agregador de parceiros|Definir descrição do campo cluster|Estabelecer governança para hierarquias",
    "problemas_identificados": "Necessidade de consistência entre CPV e segmentação",
    "jornadas_relacionadas": "hub-gestao|workflow-pricing|cadastro-cliente"
}');

-- ===========================================
-- REUNIÃO 6: URGENTE - Revisão GTM e Nova Estrutura Comercial
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R6",
    "data": "2025-12-22",
    "titulo": "URGENTE - Revisão GTM e Nova Estrutura Comercial",
    "duracao": "2h30",
    "tipo": "estratégico",
    "resumo": "Reunião estratégica urgente sobre reestruturação comercial. Apresentada nova estrutura organizacional com diretoria comercial e 4 macro setores: Alta Energia, Agricultura, Indústria e Construção Civil. Todos os 46 segmentos da empresa serão realocados dentro desses setores. Definidas mudanças na gestão regional (Ávila assume Sul, Leo gerencia Sudeste/Nordeste). Estruturada gestão de key accounts com 3 contas-chave para cada setor principal. Planejada migração de clientes para novos escritórios de vendas.",
    "participantes": "Leandro Gimenez|Leandro Cruz|Thalita Rhein|Maria Ciorlia|Luis Riqueti|Jefferson Pinheiro|Fabricio França",
    "topicos_abordados": "Nova estrutura organizacional|4 macro setores comerciais|Gestão regional|Key accounts|Workflow de aprovação pricing|Escritórios de vendas|Migração de clientes",
    "decisoes": "Finalizar hierarquia comercial no ECC|Montar lista de escritórios de vendas|Migrar clientes para nova estrutura|Ajustar workflow pricing por níveis",
    "acoes": "Gimenes/Ciorlia/Riqueti: Finalizar hierarquia comercial no ECC|Gimenes/Rhein/Ciorlia: Montar lista de escritórios de vendas|Pereira/Pinheiro/França: Extrair base de clientes para migração|Pinheiro/Victoria/Pereira: Ajustar workflow pricing por níveis",
    "jornadas_relacionadas": "hub-gestao|workflow-pricing|areas-vendas|cadastro-cliente"
}');

-- ===========================================
-- REUNIÃO 7: Alinhamento Cadastro de Materiais e Hierarquias
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R7",
    "data": "2025-12-23",
    "titulo": "Alinhamento Cadastro de Materiais e Hierarquias",
    "duracao": "30 min",
    "tipo": "técnico",
    "resumo": "Discussão técnica sobre hierarquia de grupo de mercadoria no SAP. Explicado que segmentos serão definidos pela hierarquia de grupo de mercadoria (atributo do material). GPS (Product Groups) será a base para segmentação, substituindo tabela de depara manual. Discutida precificação diferenciada por tipo de cliente (AMD, atacado, revenda, cooperativa). Clarificado que mudança afeta apenas relatórios, não o SAP diretamente. Destaque para atenção com organização de vendas entre Monlevade e outras unidades.",
    "participantes": "Thalita Rhein|Luis Riqueti|Carla Barbosa|Fabiana Silva|Fernanda Monteiro|Hudson Silva|Ronildo",
    "topicos_abordados": "Hierarquia de grupo de mercadoria|GPS como base de segmentação|Precificação por segmento|Clusterização|Impacto em relatórios",
    "decisoes": "Segmento será agrupamento de GP|Precificação diferenciada por canal ficará para próximo ano|Hudson avaliará aderência do cadastro de produtos",
    "problemas_identificados": "GP pode ser diferente entre Monlevade e outras unidades",
    "jornadas_relacionadas": "cadastro-cliente|workflow-pricing"
}');

-- ===========================================
-- REUNIÃO 8: Construção Planilha DE/PARA para Migração
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R8",
    "data": "2025-12-29",
    "titulo": "Construção Planilha DE/PARA para Migração",
    "duracao": "50 min",
    "tipo": "operacional",
    "resumo": "Planejamento detalhado para migração de dados de clientes. Definido hard reboot da lista de clientes, removendo todos os agentes e reatribuindo. Estabelecida segmentação por ID e segmento para categorização correta. Definido processo de alocação de clientes para escritórios regionais baseado em histórico de compras. Criação de novo campo Segmentos de Produto com 46 valores. Deadline crítico: não modificar estrutura de escritórios até finalização do segment report em 30/01.",
    "participantes": "Leandro Gimenez|Thalita Rhein|Marcelo Almeida|Leandro Cruz|Fabricio França",
    "topicos_abordados": "Hard reboot de clientes|Segmentação de clientes|Alocação por regional|46 segmentos de produto|Listas suspensas dependentes|EVC para clientes sem regional",
    "decisoes": "Hard reboot em 1-2 meses|Não criar escritórios até 30/01|Campo segmentos de produto no próximo sprint|EVC como escritório padrão para sem regional",
    "acoes": "Gimenes: Hard reboot da lista de clientes|Almeida: Criar Service Requests para novos escritórios|Gimenes: Finalizar segment report até 30/01|Victoria: Criar campo segmentos de produto",
    "jornadas_relacionadas": "cadastro-cliente|areas-vendas|hub-gestao"
}');

-- ===========================================
-- REUNIÃO 9: Bot Einstein - Autoatendimento WhatsApp e Logística
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 21, '{
    "codigo": "R9",
    "data": "2026-01-07",
    "titulo": "Bot Einstein - Autoatendimento WhatsApp e Logística",
    "duracao": "52 min",
    "tipo": "produto",
    "resumo": "Apresentação do chatbot WhatsApp MVP desenvolvido para autoatendimento. Sistema oferece conversa guiada para consultas de conta, status de pedidos e documentos fiscais. Autenticação feita por validação de email cadastrado no Salesforce. Quando chatbot não resolve, cria caso para Smart Center (transbordo inteligente). Canal unificado com número único de WhatsApp para todas as interações Belgo. Histórico completo de conversas armazenado no CRM. Orçamento de R$ 400.000 aprovado para 2026.",
    "participantes": "Fabricio França|Ricardo Accioly|Fabiana Silva|Ronildo|Jefferson Pinheiro|Patricia Miranda|Leandro Cruz|Marcelo Almeida|Gustavo Teixeira",
    "topicos_abordados": "Chatbot WhatsApp MVP|Autenticação de clientes|Transbordo para Smart Center|Canal unificado|Integração Salesforce|Orçamento 2026",
    "decisoes": "Mapear e priorizar fluxos do chatbot|Integrar Smart Center e SAC|Planejamento de licenças Salesforce",
    "acoes": "França/Accioly/Silva: Mapeamento e priorização de fluxos|Miranda/Accioly: Integração Smart Center e SAC|Ronildo/Silva/Victoria: Testes e resolução de erros|Pereira/Pinheiro: Planejamento de licenças Salesforce",
    "jornadas_relacionadas": "autoatendimento|hub-gestao|contatos",
    "orcamento": "400000"
}');
