-- =====================================================
-- Migration 020: Importar dados de Jornadas AS-IS/TO-BE
-- Projeto 5 (GTM Clone) - Entidade ID 19 (jornadas)
-- Total: 14 jornadas mapeadas com detalhamento completo
-- =====================================================

-- Limpar dados existentes de jornadas do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 19 AND projeto_id = 5;

-- ===========================================
-- JORNADA 1: Cadastro de Cliente
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Cadastro de Cliente",
    "icone": "👤",
    "ordem": 1,
    "status": "Em Andamento",
    "as_is": "Processo manual e fragmentado onde o vendedor coleta dados do cliente via formulários em papel ou planilhas Excel, envia para o SmartCenter por e-mail, que então digita manualmente no SAP. Validações de CNPJ/CPF são feitas manualmente através de consultas em sites externos, sem verificação automática de duplicidades, resultando em cadastros duplicados frequentes e dados inconsistentes.",
    "passos_as_is": "Vendedor visita cliente ou recebe contato comercial|Coleta dados em formulário físico ou planilha Excel (Razão Social, CNPJ, Endereço, Contatos)|Envia formulário preenchido para SmartCenter via e-mail|SmartCenter recebe e analisa a solicitação (pode levar horas ou dias)|SmartCenter consulta CNPJ manualmente em sites externos (Receita Federal, SINTEGRA)|SmartCenter digita os dados manualmente no SAP|Realiza verificação manual de duplicados na base (sujeita a erros humanos)|Cadastro finalizado após múltiplas interações e correções",
    "problemas_as_is": "Tempo excessivo para conclusão (2 a 3 dias úteis)|Erros de digitação frequentes na entrada manual|Cadastros duplicados na base de dados|Ausência de validação automática de CNPJ/CPF|CNAE não preenchido ou preenchido incorretamente|Dependência total do SmartCenter (gargalo operacional)|Dados incompletos ou inconsistentes chegam ao SAP|Sem notificação automática de cadastros pendentes|Informações de contato mal preenchidas ou desatualizadas|Impacto negativo no autoatendimento e outras áreas dependentes",
    "tempo_medio_as_is": "2 a 3 dias úteis",
    "to_be": "Cadastro automatizado via integração SINTEGRA diretamente no Salesforce. O vendedor digita apenas o CNPJ, clica no botão Integrar SINTEGRA e o sistema preenche automaticamente todos os dados oficiais (Razão Social, Endereço, Inscrição Estadual, CNAE com descrição completa). O sistema valida duplicidades automaticamente pelo campo Termo de Pesquisa, impedindo cadastros duplicados. Após validação, ocorre integração automática com SAP via middleware.",
    "passos_to_be": "Vendedor acessa o Salesforce (aplicativo mobile ou desktop)|Clica em Criar Conta e seleciona o tipo: Pessoa Jurídica, Pessoa Física ou Parceiro Agrupador|Preenche o CNPJ do cliente|Sistema preenche automaticamente: Escritório de Vendas (conforme perfil) e Equipe de Vendas (conforme time)|Clica no botão Integrar SINTEGRA|Sistema consulta SINTEGRA e preenche automaticamente: Razão Social, Endereço, Inscrição Estadual (IE), CNAE com descrição completa|Sistema exibe mensagem de sucesso no canto superior da tela|Sistema valida Termo de Pesquisa contra base existente para evitar duplicidade|Se duplicado: exibe mensagem e bloqueia|Se único: vendedor complementa dados comerciais (Contatos, Área de Vendas, Canal)|Clica no botão Enviar SAP para sincronização|Sistema sincroniza dados com SAP e exibe mensagem de confirmação|Se cadastro incompleto: sistema envia notificação automática de pendência",
    "beneficios_to_be": "Cadastro concluído em aproximadamente 5 minutos|Eliminação de erros de digitação manual|Dados validados automaticamente via SINTEGRA (fonte oficial)|Deduplicação automática por Termo de Pesquisa|CNAE sempre correto e com descrição completa|Preenchimento automático de Escritório e Equipe de Vendas|Dados de contato padronizados e validados|Habilitação correta do autoatendimento|Redução significativa da carga operacional do SmartCenter|Rastreabilidade completa de todas as operações|Notificação automática de cadastros pendentes",
    "tempo_medio_to_be": "5 minutos",
    "areas_impactadas": "Comercial|SmartCenter|TI|Atendimento|Financeiro|Logística",
    "sistemas_tecnicos": "Salesforce|SAP ECC|SINTEGRA|Middleware",
    "fonte_reuniao": "10/12/2025"
}');

-- ===========================================
-- JORNADA 2: Áreas de Vendas
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Áreas de Vendas",
    "icone": "🏢",
    "ordem": 2,
    "status": "Em Andamento",
    "as_is": "Atribuição manual de canais e escritórios",
    "passos_as_is": "Identificar tipo de cliente|Definir canal manualmente|Atribuir escritório|Configurar no SAP",
    "problemas_as_is": "Erros de classificação|Canais incorretos|Retrabalho frequente",
    "tempo_medio_as_is": "1 dia",
    "to_be": "Canais 20, 30, 40, 25 automatizados com sugestão baseada em CNAE",
    "passos_to_be": "Sistema identifica tipo de cliente|Canal sugerido automaticamente|Usuário confirma ou ajusta|Integração automática",
    "beneficios_to_be": "Classificação correta|Redução de erros|Processo padronizado",
    "tempo_medio_to_be": "Imediato",
    "areas_impactadas": "Comercial|Operações",
    "sistemas_tecnicos": "Salesforce|SAP",
    "fonte_reuniao": "10/12/2025",
    "detalhes_canais": {"20": "Indústria", "25": "Casos Especiais", "30": "Distribuição", "40": "Consumo/Varejo"},
    "detalhes_clusters": {"Corporativas": "Grandes contas com volume alto", "Especiais": "Contas com tratamento diferenciado", "Regionais": "Contas de atuação regional", "Dispersas": "Contas menores e dispersas"}
}');

-- ===========================================
-- JORNADA 3: Documentos Fiscais
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Documentos Fiscais",
    "icone": "📄",
    "ordem": 3,
    "status": "Em Andamento",
    "as_is": "Emissão manual de XML e DANFE",
    "passos_as_is": "Faturamento no SAP|Colaborador gera XML manualmente|Gera DANFE manualmente|Envia por email ao cliente",
    "problemas_as_is": "Processo lento|Erros de digitação|Atrasos no envio|Dependência de pessoa",
    "tempo_medio_as_is": "30 minutos por nota",
    "to_be": "Emissão automática integrada via trigger SAP-Araujo",
    "passos_to_be": "Faturamento no SAP dispara trigger|XML gerado automaticamente|DANFE gerado automaticamente|Envio automático por email/portal",
    "beneficios_to_be": "Processo instantâneo|Sem erros manuais|Cliente recebe imediatamente|Rastreabilidade completa",
    "tempo_medio_to_be": "Automático",
    "areas_impactadas": "Fiscal|TI|Comercial",
    "sistemas_tecnicos": "SAP|Araujo|Salesforce|Portal Cliente",
    "fonte_reuniao": "16/12/2025",
    "documentos_gerados": ["XML da NF-e", "DANFE", "Certificado de Qualidade"]
}');

-- ===========================================
-- JORNADA 4: Gestão de Contatos
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Gestão de Contatos",
    "icone": "📞",
    "ordem": 4,
    "status": "Pendente",
    "as_is": "Cadastro manual de contatos sem validação",
    "passos_as_is": "Vendedor coleta dados|Digita manualmente no sistema|Sem validação de duplicados",
    "problemas_as_is": "Dados incompletos|Contatos duplicados|Informações desatualizadas",
    "tempo_medio_as_is": "15 minutos",
    "to_be": "Auto-preenchimento e validação com deduplicação automática",
    "passos_to_be": "Sistema sugere contatos existentes|Validação de email/telefone|Deduplicação automática|Histórico de interações",
    "beneficios_to_be": "Dados completos|Sem duplicações|Contatos sempre atualizados",
    "tempo_medio_to_be": "2 minutos",
    "areas_impactadas": "Comercial|Marketing",
    "sistemas_tecnicos": "Salesforce",
    "fonte_reuniao": "16/12/2025",
    "criticidade": "PRE-REQUISITO para Autoatendimento"
}');

-- ===========================================
-- JORNADA 5: Portal Logístico
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Portal Logístico",
    "icone": "🚚",
    "ordem": 5,
    "status": "Pendente",
    "as_is": "Portal separado do SAP com dados redundantes",
    "passos_as_is": "Dados digitados no portal|Replicação manual para SAP|Conferência manual",
    "problemas_as_is": "Redundância de dados|Inconsistências entre sistemas|Retrabalho",
    "tempo_medio_as_is": "Variável",
    "to_be": "Integração Portal-SAP em tempo real",
    "passos_to_be": "Dados inseridos uma vez|Sincronização automática|Visão única integrada",
    "beneficios_to_be": "Eliminação de redundância|Dados consistentes|Processo otimizado",
    "tempo_medio_to_be": "Automático",
    "areas_impactadas": "Logística|TI",
    "sistemas_tecnicos": "Portal Logístico|SAP ECC",
    "fonte_reuniao": "16/12/2025"
}');

-- ===========================================
-- JORNADA 6: Financeiro/Crédito
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Financeiro/Crédito",
    "icone": "💰",
    "ordem": 6,
    "status": "Em Andamento",
    "as_is": "Ficha de crédito manual em Excel/físico",
    "passos_as_is": "Análise manual de crédito|Ficha física/Excel|Aprovação por email",
    "problemas_as_is": "Processo lento|Sem visibilidade|Risco de erros",
    "tempo_medio_as_is": "2-3 dias",
    "to_be": "FSCM integrado com workflow digital de aprovação",
    "passos_to_be": "Análise automática via FSCM|Limite calculado pelo sistema|Aprovação digital com workflow",
    "beneficios_to_be": "Análise em tempo real|Visibilidade total|Processo auditável",
    "tempo_medio_to_be": "Horas",
    "areas_impactadas": "Financeiro|Comercial",
    "sistemas_tecnicos": "Salesforce|SAP FSCM|ASCP|Bureaus de Crédito",
    "fonte_reuniao": "04/12/2025",
    "areas_credito": {"BBA": "Limite Interno Belgo", "CSP": "Supply/Belgo Cash", "DBA": "Distribuição (gerenciada pela Rede)", "ALPE": "Aços Longos PE"}
}');

-- ===========================================
-- JORNADA 7: Rastreamento de Concorrentes
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Rastreamento de Concorrentes",
    "icone": "🎯",
    "ordem": 7,
    "status": "Pendente",
    "as_is": "Registro manual e esporádico em planilhas individuais",
    "passos_as_is": "Vendedor anota informações|Planilhas individuais|Sem consolidação",
    "problemas_as_is": "Dados fragmentados|Informações desatualizadas|Sem análise",
    "tempo_medio_as_is": "N/A",
    "to_be": "Gestão sistemática no CRM com vinculação a oportunidades",
    "passos_to_be": "Registro estruturado no Salesforce|Vinculação com oportunidades|Relatórios automáticos",
    "beneficios_to_be": "Visão consolidada|Análise de mercado|Decisões baseadas em dados",
    "tempo_medio_to_be": "5 minutos",
    "areas_impactadas": "Comercial|Marketing|Estratégia",
    "sistemas_tecnicos": "Salesforce",
    "fonte_reuniao": "10/12/2025"
}');

-- ===========================================
-- JORNADA 8: Autoatendimento
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Autoatendimento",
    "icone": "🖥️",
    "ordem": 8,
    "status": "Em Desenvolvimento",
    "as_is": "Inexistente - Cliente depende totalmente do vendedor ou Smart Center para qualquer consulta",
    "passos_as_is": "Cliente liga para vendedor ou Smart Center|Vendedor consulta múltiplos sistemas manualmente|Retorna informação por telefone ou email|Cliente aguarda resposta sem previsão",
    "problemas_as_is": "Dependência total do vendedor para qualquer informação|Demora no atendimento (horas ou dias)|Sem autonomia do cliente|Smart Center sobrecarregado com consultas simples|Horário limitado de atendimento",
    "tempo_medio_as_is": "Horas/Dias",
    "to_be": "Portal self-service e Bot Einstein via WhatsApp para atendimento 24/7",
    "passos_to_be": "Cliente acessa portal web ou WhatsApp|Bot Einstein faz autenticação via CNPJ/CPF|Cliente consulta status de pedidos em tempo real|Download de documentos fiscais (XML, DANFE, Certificados)|Rastreamento de entregas|Solicitação de 2ª via de boletos|Transbordo automático para Smart Center se necessário",
    "beneficios_to_be": "Autonomia total do cliente|Atendimento 24/7 via WhatsApp|Redução de chamados ao Smart Center|Consultas instantâneas|Integração com Salesforce Service Cloud",
    "tempo_medio_to_be": "Imediato",
    "areas_impactadas": "Comercial|Atendimento|TI|Smart Center",
    "sistemas_tecnicos": "Salesforce Service Cloud|Bot Einstein|WhatsApp",
    "fonte_reuniao": "16/12/2025",
    "prerequisito": "Depende de dados de contato corretos",
    "orcamento_bot_2026": "400.000 BRL"
}');

-- ===========================================
-- JORNADA 9: Workflow Pricing
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Workflow Pricing",
    "icone": "💲",
    "ordem": 9,
    "status": "Em Andamento",
    "as_is": "Descontos sem controle centralizado, aprovações informais",
    "passos_as_is": "Vendedor negocia desconto|Aprovação informal|Desconto manual no pedido|Sem registro",
    "problemas_as_is": "Sem controle|Aprovações informais|Sem vigência|Margens corroídas",
    "tempo_medio_as_is": "Variável",
    "to_be": "Workflow de aprovação em 2 níveis com condition YDCF no SAP",
    "passos_to_be": "Acessa Pricing no Salesforce|Navega hierarquia de materiais (6 níveis)|Define % desconto e vigência|Nível 1: Time Pricing aprova|Nível 2: Gerente aprova|YDCF criada no SAP",
    "beneficios_to_be": "Controle total|Rastreabilidade|Workflow 2 níveis|Vigência automática|Integração SAP",
    "tempo_medio_to_be": "1-2 dias",
    "areas_impactadas": "Comercial|Marketing|Pricing|TI",
    "sistemas_tecnicos": "Salesforce|SAP",
    "fonte_reuniao": "16/12/2025",
    "hierarquia_materiais": ["Unidades", "Macro Segmentos", "Macro Detalhado", "Segmento", "Grupo Mercadoria", "Material"],
    "condition_sap": "YDCF - Desconto de Cliente"
}');

-- ===========================================
-- JORNADA 10: Cotação e Ordem de Vendas
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Cotação e Ordem de Vendas",
    "icone": "📋",
    "ordem": 10,
    "status": "Em Andamento",
    "as_is": "Processo manual de cotação com consultas em múltiplos sistemas",
    "passos_as_is": "Consulta preço no SAP|Verifica estoque manualmente|Monta cotação em Excel|Digita pedido no SAP",
    "problemas_as_is": "Processo lento|Preços desatualizados|Sem ATP|Retrabalho",
    "tempo_medio_as_is": "Horas",
    "to_be": "Cotação integrada com ATP e conversão automática para OV",
    "passos_to_be": "Cria cotação no Salesforce|Sistema busca preços do SAP|ATP verifica disponibilidade|Descontos YDCF automáticos|Conversão para OV",
    "beneficios_to_be": "Processo ágil|Preços atualizados|ATP em tempo real|Visibilidade completa",
    "tempo_medio_to_be": "Minutos",
    "areas_impactadas": "Comercial|Logística|Financeiro",
    "sistemas_tecnicos": "Salesforce|SAP",
    "fonte_reuniao": "10/12/2025",
    "atp": "Available to Promise - disponibilidade em tempo real",
    "farol_ov": "Status OV (verde/amarelo/vermelho)"
}');

-- ===========================================
-- JORNADA 11: Hub de Gestão OC
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Hub de Gestão OC",
    "icone": "⚙️",
    "ordem": 11,
    "status": "Em Andamento",
    "as_is": "Gestão descentralizada de grupos via solicitações por email à TI",
    "passos_as_is": "Solicitações por email|TI configura manualmente|Sem visibilidade de grupos|Logs separados",
    "problemas_as_is": "Processo manual|Sem self-service|Difícil auditar|Logs dispersos",
    "tempo_medio_as_is": "Dias",
    "to_be": "Hub centralizado com gestão via LWC self-service",
    "passos_to_be": "Gestor acessa Gerenciar Grupos|Visualiza grupos|Adiciona/remove membros|Busca por email/nome|Visualiza logs",
    "beneficios_to_be": "Self-service|Visibilidade de membros|Controle de perfis|Logs centralizados",
    "tempo_medio_to_be": "Minutos",
    "areas_impactadas": "TI|Todas as áreas",
    "sistemas_tecnicos": "Salesforce (LWC)",
    "fonte_reuniao": "Documentos de teste",
    "grupos": ["Comercial", "Qualidade", "Sistemas"]
}');

-- ===========================================
-- JORNADA 12: Restrições Logísticas
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Restrições Logísticas",
    "icone": "🚛",
    "ordem": 12,
    "status": "Pendente",
    "as_is": "Restrições de entrega gerenciadas em sistemas separados sem integração, causando problemas de comunicação entre áreas",
    "passos_as_is": "Informações de restrição registradas no Portal Logístico|Dados duplicados manualmente no SAP|Vendedor consulta XD03 para ver restrições|Sem visibilidade em tempo real para o cliente|Agendamentos feitos por telefone ou email",
    "problemas_as_is": "Redundância de dados entre Portal Logístico e SAP|Inconsistências nas informações de restrição|Cliente não tem visibilidade das restrições|Agendamentos manuais sujeitos a erros|Sem integração em tempo real",
    "tempo_medio_as_is": "Variável",
    "to_be": "Integração Salesforce → SAP → Portal Logístico em tempo real para gestão centralizada de restrições de entrega",
    "passos_to_be": "Vendedor registra restrições no Salesforce|Sistema sincroniza automaticamente com SAP|Integração em tempo real com Portal Logístico|Cliente visualiza restrições no autoatendimento|Agendamentos online com confirmação automática",
    "beneficios_to_be": "Dados unificados em todos os sistemas|Visibilidade em tempo real|Cliente com autonomia para consultar restrições|Eliminação de redundância de dados|Processo de agendamento otimizado",
    "tempo_medio_to_be": "Imediato",
    "areas_impactadas": "Logística|Comercial|TI|Atendimento",
    "sistemas_tecnicos": "Salesforce|SAP ECC|Portal Logístico",
    "fonte_reuniao": "10/12/2025",
    "tipos_restricao": ["Veículo (3/4, Truque, Sider, Carreta)", "Janela de Entrega", "Agendamento", "Descarga"],
    "transacao_sap": "XD03 - Exibir Cliente (Restrições na ordem de embarque)"
}');

-- ===========================================
-- JORNADA 13: Market Share e Concorrentes
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "Market Share e Concorrentes",
    "icone": "📊",
    "ordem": 13,
    "status": "Pendente",
    "as_is": "Informações de concorrentes e market share dispersas, sem gestão centralizada ou análise sistemática",
    "passos_as_is": "Vendedor coleta informações de concorrentes informalmente|Dados registrados em planilhas individuais|Projetos perdidos não vinculados a concorrentes|Sem histórico de market share por cliente|Análise de mercado feita manualmente",
    "problemas_as_is": "Informações de concorrentes sazonais e dinâmicas|Dificuldade em vincular projetos perdidos a concorrentes específicos|Sem visão consolidada de share of wallet|Dados fragmentados e inconsistentes|Impossível rastrear tendências de mercado",
    "tempo_medio_as_is": "N/A",
    "to_be": "Gestão centralizada de concorrentes e market share no Salesforce com análise automatizada",
    "passos_to_be": "Cadastro normalizado de concorrentes no Salesforce|Registro de share of wallet por cliente|Vinculação de oportunidades perdidas a concorrentes|Dashboard de análise de mercado automático|Histórico de evolução de market share",
    "beneficios_to_be": "Visão consolidada de concorrentes por região/segmento|Análise de share of wallet por cliente|Identificação de tendências de mercado|Decisões estratégicas baseadas em dados|Rastreamento de projetos perdidos para concorrência",
    "tempo_medio_to_be": "5 minutos por registro",
    "areas_impactadas": "Comercial|Marketing|Estratégia|Inteligência de Mercado",
    "sistemas_tecnicos": "Salesforce|Power BI",
    "fonte_reuniao": "10/12/2025",
    "share_of_wallet": "Percentual de compra do cliente na Belgo versus concorrentes"
}');

-- ===========================================
-- JORNADA 14: AMD Cross Company
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 19, '{
    "nome": "AMD Cross Company",
    "icone": "🔄",
    "ordem": 14,
    "status": "Pendente",
    "as_is": "Processo de vendas entre empresas do grupo ArcelorMittal não contemplado no Salesforce atual",
    "passos_as_is": "AMD (ArcelorMittal Distribuição) gerencia vendas em sistema próprio|Transações cross company processadas manualmente|Sem integração com Salesforce|Visibilidade limitada para equipe comercial",
    "problemas_as_is": "Processo AMD não tem funcionalidades no Salesforce|Processo Cross Company não contemplado|Falta de rastreabilidade de vendas intercompany|Dificuldade de consolidação de resultados",
    "tempo_medio_as_is": "Variável",
    "to_be": "Integração do processo AMD Cross Company no Salesforce para gestão unificada de vendas intercompany",
    "passos_to_be": "Registro de transações AMD no Salesforce|Workflow de aprovação para vendas cross company|Integração com SAP para contabilização|Relatórios consolidados de vendas intercompany|Visibilidade completa para equipe comercial",
    "beneficios_to_be": "Gestão unificada de vendas do grupo|Rastreabilidade completa de transações intercompany|Consolidação de resultados facilitada|Visibilidade para todas as áreas|Processo padronizado e auditável",
    "tempo_medio_to_be": "A definir",
    "areas_impactadas": "Comercial|Financeiro|Controladoria|AMD",
    "sistemas_tecnicos": "Salesforce|SAP ECC|Sistema AMD",
    "fonte_reuniao": "10/12/2025",
    "amd": "ArcelorMittal Distribuição - Empresa do grupo para distribuição de produtos",
    "responsavel": "Renata Mello e Victoria"
}');
