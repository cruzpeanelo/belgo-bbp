-- =====================================================
-- Migration 049: Jornadas - Dados Completos Paridade 100%
-- Atualiza dados de Jornadas com todos os campos da
-- versão estática original para paridade total
-- Projeto 5 (GTM Clone) - Entidade ID 18
-- =====================================================

-- Limpar dados existentes de jornadas do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 18 AND projeto_id = 5;

-- =============================================================================
-- Jornada 1: Cadastro de Cliente (COMPLETO com todos os dados do original)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Cadastro de Cliente",
  "icone": "👤",
  "ordem": 1,
  "status": "Em Andamento",
  "as_is": "Processo manual e fragmentado onde o vendedor coleta dados do cliente via formulários em papel ou planilhas Excel, envia para o SmartCenter por e-mail, que então digita manualmente no SAP. Validações de CNPJ/CPF são feitas manualmente através de consultas em sites externos, sem verificação automática de duplicidades, resultando em cadastros duplicados frequentes e dados inconsistentes.",
  "passos_as_is": "Vendedor visita cliente ou recebe contato comercial|Coleta dados em formulário físico ou planilha Excel|Envia formulário preenchido para SmartCenter via e-mail|SmartCenter recebe e analisa a solicitação|SmartCenter consulta CNPJ manualmente em sites externos|SmartCenter digita os dados manualmente no SAP|Realiza verificação manual de duplicados na base|Cadastro finalizado após múltiplas interações e correções",
  "problemas_as_is": "Tempo excessivo para conclusão (2 a 3 dias úteis)|Erros de digitação frequentes na entrada manual|Cadastros duplicados na base de dados|Ausência de validação automática de CNPJ/CPF|CNAE não preenchido ou preenchido incorretamente|Dependência total do SmartCenter (gargalo operacional)|Dados incompletos ou inconsistentes chegam ao SAP|Sem notificação automática de cadastros pendentes|Informações de contato mal preenchidas|Impacto negativo no autoatendimento",
  "tempo_medio_as_is": "2 a 3 dias úteis",
  "to_be": "Cadastro automatizado via integração SINTEGRA diretamente no Salesforce. O vendedor digita apenas o CNPJ, clica no botão Integrar SINTEGRA e o sistema preenche automaticamente todos os dados oficiais (Razão Social, Endereço, Inscrição Estadual, CNAE com descrição completa). O sistema valida duplicidades automaticamente pelo campo Termo de Pesquisa, impedindo cadastros duplicados. Após validação, ocorre integração automática com SAP via middleware.",
  "passos_to_be": "Vendedor acessa o Salesforce (aplicativo mobile ou desktop)|Clica em Criar Conta e seleciona o tipo: PJ, PF ou Parceiro|Preenche o CNPJ do cliente|Sistema preenche automaticamente Escritório e Equipe de Vendas|Clica no botão Integrar SINTEGRA|Sistema preenche: Razão Social, Endereço, IE, CNAE|Sistema valida Termo de Pesquisa contra base existente|Se duplicado: exibe mensagem e bloqueia|Se único: complementa dados comerciais|Clica em Enviar SAP para sincronização|Sistema sincroniza dados com SAP",
  "beneficios_to_be": "Cadastro concluído em aproximadamente 5 minutos|Eliminação de erros de digitação manual|Dados validados automaticamente via SINTEGRA|Deduplicação automática por Termo de Pesquisa|CNAE sempre correto e com descrição completa|Preenchimento automático de Escritório e Equipe|Dados de contato padronizados e validados|Habilitação correta do autoatendimento|Redução da carga operacional do SmartCenter|Rastreabilidade completa de todas as operações|Notificação automática de cadastros pendentes",
  "tempo_medio_to_be": "5 minutos",
  "areas_impactadas": "Comercial|SmartCenter|TI|Atendimento|Financeiro|Logística",
  "sistemas_tecnicos": "Salesforce|SAP ECC|SINTEGRA|Middleware",
  "fonte_reuniao": "10/12/2025",
  "fontes_reuniao": "10/12/2025 - Sessão dedicada a Cadastro de Cliente|16/12/2025 - Revisão de Cadastro e Documentos Fiscais",
  "pendencias": "Integração com Portal Logístico pendente de definição|Padronização de celulares e bases de contatos (documento 901674)|Definição de regras para concorrentes sazonais|Critérios automáticos para seleção de Canal baseado em CNAE|Validação de formato de telefone celular|Integração com bureau de crédito para análise automática",
  "prerequisitos": "Acesso à API SINTEGRA configurado e operacional|Middleware Salesforce-SAP configurado e testado|Perfis de usuário configurados com escritório e time corretos|Usuários treinados no novo fluxo de cadastro",
  "tipos_conta": [
    {"tipo": "Pessoa Jurídica (PJ)", "descricao": "Empresas com CNPJ - Business Account", "recordType": "PJ_Standard"},
    {"tipo": "Pessoa Física (PF)", "descricao": "Clientes individuais com CPF", "recordType": "PF_Standard"},
    {"tipo": "Parceiro Agrupador", "descricao": "Grupos empresariais ou holdings", "recordType": "Agrupador"}
  ],
  "campos_processo": [
    {"campo": "CNPJ", "descricao": "Cadastro Nacional de Pessoa Jurídica", "preenchimento": "Manual", "validacao": "SINTEGRA"},
    {"campo": "CPF", "descricao": "Cadastro de Pessoa Física", "preenchimento": "Manual", "validacao": "Algoritmo"},
    {"campo": "Razão Social", "descricao": "Nome oficial da empresa", "preenchimento": "Automático (SINTEGRA)", "validacao": "-"},
    {"campo": "Nome Fantasia", "descricao": "Nome comercial da empresa", "preenchimento": "Manual", "validacao": "-"},
    {"campo": "Endereço", "descricao": "Endereço completo", "preenchimento": "Automático (SINTEGRA)", "validacao": "-"},
    {"campo": "IE", "descricao": "Inscrição Estadual", "preenchimento": "Automático (SINTEGRA)", "validacao": "-"},
    {"campo": "CNAE", "descricao": "Classificação Nacional de Atividades", "preenchimento": "Automático (SINTEGRA)", "validacao": "-"},
    {"campo": "Termo de Pesquisa", "descricao": "Identificador único para evitar duplicidade", "preenchimento": "Manual", "validacao": "Duplicidade"},
    {"campo": "Tipo de Conta", "descricao": "PJ, PF ou Parceiro Agrupador", "preenchimento": "Manual", "validacao": "Obrigatório"},
    {"campo": "Escritório de Vendas", "descricao": "Escritório responsável pela conta", "preenchimento": "Automático (Perfil)", "validacao": "-"},
    {"campo": "Equipe de Vendas", "descricao": "Time comercial responsável", "preenchimento": "Automático (Time)", "validacao": "-"},
    {"campo": "Canal", "descricao": "Canal de venda: 20, 25, 30 ou 40", "preenchimento": "Manual", "validacao": "-"},
    {"campo": "Cluster", "descricao": "Classificação automática do cliente", "preenchimento": "Automático", "validacao": "Workflow para exceção"}
  ],
  "regras_negocio": [
    {"regra": "Validação de Duplicidade por Termo de Pesquisa", "descricao": "O sistema verifica se já existe outro cliente cadastrado com o mesmo Termo de Pesquisa. Caso exista, a criação é bloqueada."},
    {"regra": "Preenchimento Automático via SINTEGRA", "descricao": "Após inserir o CNPJ e clicar no botão Integrar SINTEGRA, o sistema preenche automaticamente: IE, CNAE com descrição, Endereço."},
    {"regra": "Preenchimento Automático de Escritório e Equipe", "descricao": "O campo Escritório de Vendas é preenchido automaticamente conforme o perfil do usuário. Equipe de Vendas conforme o time."},
    {"regra": "Canais de Venda", "descricao": "Canal 20: Indústria | Canal 25: Casos Especiais | Canal 30: Distribuidores | Canal 40: Consumidor Final"},
    {"regra": "Cluster Automático com Exceção", "descricao": "O sistema calcula automaticamente o Cluster. Para exceções, existe workflow de aprovação."},
    {"regra": "Notificação de Cadastro Pendente", "descricao": "O sistema identifica cadastros incompletos e envia notificações aos responsáveis."},
    {"regra": "Sincronização com SAP", "descricao": "Após conclusão, o botão Enviar SAP sincroniza os dados. Sistema exibe confirmação."}
  ],
  "integracoes": [
    {"origem": "Salesforce", "destino": "SINTEGRA", "tipo": "API"},
    {"origem": "Salesforce", "destino": "SAP", "tipo": "Middleware"},
    {"origem": "SAP", "destino": "Salesforce", "tipo": "Middleware"}
  ],
  "ciclos_teste": [
    {"documento": "876268", "titulo": "CNAE - Classificação Nacional de Atividades Econômicas", "status": "Pendente", "ciclo": "P1"},
    {"documento": "899139", "titulo": "Validação do Campo Termo de Pesquisa no Cadastro de Cliente", "status": "Pendente", "ciclo": "P2"},
    {"documento": "895163", "titulo": "Automatização de Segmento e Subsegmento", "status": "Pendente", "ciclo": "P2"},
    {"documento": "881196", "titulo": "Notificar sobre Cadastro a Finalizar - Pendente", "status": "Pendente", "ciclo": "P2"},
    {"documento": "862865", "titulo": "Definição Automática de Cluster", "status": "Pendente", "ciclo": "P2"}
  ],
  "abas_interface": [
    {"aba": "Detalhes", "descricao": "Exibe informações básicas da conta, dados do SINTEGRA (endereço, IE, CNAE)"},
    {"aba": "Relatório de Visitas", "descricao": "Permite criar e visualizar relatórios de visitas comerciais"},
    {"aba": "Financeiro", "descricao": "Exibe informações de crédito, partidas e ficha de crédito do cliente"}
  ],
  "mensagens_sistema": [
    {"tipo": "Sucesso", "contexto": "Integração SINTEGRA", "mensagem": "Mensagem de sucesso exibida no canto superior da tela"},
    {"tipo": "Sucesso", "contexto": "Sincronização SAP", "mensagem": "A conta está em sincronização com o SAP"},
    {"tipo": "Erro", "contexto": "Duplicidade de Termo de Pesquisa", "mensagem": "Já existe um cliente com o mesmo termo de pesquisa"},
    {"tipo": "Erro", "contexto": "SINTEGRA - CNPJ Inválido", "mensagem": "CNPJ informado não é válido"},
    {"tipo": "Erro", "contexto": "SINTEGRA - CNPJ Não Encontrado", "mensagem": "CNPJ não encontrado na base SINTEGRA"},
    {"tipo": "Alerta", "contexto": "Contato Obrigatório", "mensagem": "É necessário informar pelo menos um contato"},
    {"tipo": "Alerta", "contexto": "Cadastro Incompleto", "mensagem": "O cadastro está incompleto. Verifique os campos obrigatórios."}
  ],
  "participantes_reuniao": [
    {"nome": "Leandro Da Cruz", "papel": "Facilitador do workshop, apresentou fluxo de cadastro"},
    {"nome": "Francine Gayer", "papel": "Participante, questionamentos sobre concorrentes"},
    {"nome": "Maria Luiza Gomes Chaves", "papel": "Participante, dúvidas sobre tabela de preços"},
    {"nome": "Bruno Machado", "papel": "Representante do segmento Agro"}
  ],
  "fluxo_aprovacao": ["Usuário solicita exceção", "Status muda para Enviado", "Aprovador recebe e-mail", "Aprovador aprova no Salesforce", "Sistema envia confirmação"],
  "detalhes": {
    "sintegra": "Integração automática para consulta de CNPJ, IE, CNAE e endereço",
    "deduplicacao": "Validação automática por Termo de Pesquisa",
    "integracao": "Salesforce → SAP via middleware",
    "notificacoes": "Sistema notifica automaticamente cadastros pendentes"
  }
}');

-- =============================================================================
-- Jornada 2: Áreas de Vendas (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Áreas de Vendas",
  "icone": "🏢",
  "ordem": 2,
  "status": "Em Andamento",
  "as_is": "Atribuição manual de canais e escritórios com alta taxa de erros",
  "passos_as_is": "Identificar tipo de cliente|Definir canal manualmente|Atribuir escritório|Configurar no SAP",
  "problemas_as_is": "Erros de classificação|Canais incorretos|Retrabalho frequente",
  "tempo_medio_as_is": "1 dia",
  "to_be": "Canais 20, 30, 40, 25 automatizados com base no CNAE e perfil",
  "passos_to_be": "Sistema identifica tipo de cliente|Canal sugerido automaticamente|Usuário confirma ou ajusta|Integração automática",
  "beneficios_to_be": "Classificação correta|Redução de erros|Processo padronizado",
  "tempo_medio_to_be": "Imediato",
  "areas_impactadas": "Comercial|Operações",
  "fonte_reuniao": "10/12/2025",
  "regras_negocio": [
    {"regra": "Canal definido pelo CNAE", "descricao": "O canal de vendas é sugerido automaticamente com base na atividade econômica da empresa"},
    {"regra": "Cluster calculado por algoritmo", "descricao": "Corporativas, Especiais, Regionais e Dispersas são calculados automaticamente"},
    {"regra": "Exceções via workflow de 2 níveis", "descricao": "Alterações de cluster requerem aprovação em dois níveis"},
    {"regra": "Segmento de Produto", "descricao": "46 valores possíveis para segmentação"}
  ],
  "detalhes": {
    "canais": "20: Indústria | 25: Casos Especiais | 30: Distribuição | 40: Consumo/Varejo",
    "clusters": "Corporativas, Especiais, Regionais, Dispersas"
  }
}');

-- =============================================================================
-- Jornada 3: Documentos Fiscais (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Documentos Fiscais",
  "icone": "📄",
  "ordem": 3,
  "status": "Em Andamento",
  "as_is": "Emissão manual de XML e DANFE com dependência de pessoa específica",
  "passos_as_is": "Faturamento no SAP|Colaborador gera XML manualmente|Gera DANFE manualmente|Envia por email ao cliente",
  "problemas_as_is": "Processo lento|Erros de digitação|Atrasos no envio|Dependência de pessoa",
  "tempo_medio_as_is": "30 minutos por nota",
  "to_be": "Emissão automática integrada com trigger do SAP",
  "passos_to_be": "Faturamento no SAP dispara trigger|XML gerado automaticamente|DANFE gerado automaticamente|Envio automático por email/portal",
  "beneficios_to_be": "Processo instantâneo|Sem erros manuais|Cliente recebe imediatamente|Rastreabilidade completa",
  "tempo_medio_to_be": "Automático",
  "areas_impactadas": "Fiscal|TI|Comercial",
  "sistemas_tecnicos": "SAP|Araujo|Salesforce|Portal Cliente",
  "fonte_reuniao": "16/12/2025",
  "detalhes": {
    "trigger": "SAP dispara processo no Araujo",
    "documentos": "XML da NF-e, DANFE, Certificado de Qualidade",
    "envio": "Email automático + portal"
  }
}');

-- =============================================================================
-- Jornada 4: Gestão de Contatos (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Gestão de Contatos",
  "icone": "📞",
  "ordem": 4,
  "status": "Pendente",
  "as_is": "Cadastro manual de contatos sem validação de duplicados",
  "passos_as_is": "Vendedor coleta dados|Digita manualmente no sistema|Sem validação de duplicados",
  "problemas_as_is": "Dados incompletos|Contatos duplicados|Informações desatualizadas",
  "tempo_medio_as_is": "15 minutos",
  "to_be": "Auto-preenchimento e validação com deduplicação",
  "passos_to_be": "Sistema sugere contatos existentes|Validação de email/telefone|Deduplicação automática|Histórico de interações",
  "beneficios_to_be": "Dados completos|Sem duplicações|Contatos sempre atualizados",
  "tempo_medio_to_be": "2 minutos",
  "areas_impactadas": "Comercial|Marketing",
  "fonte_reuniao": "16/12/2025",
  "pendencias": "PRE-REQUISITO para Autoatendimento|Padronização de formato de telefone",
  "detalhes": {
    "criticidade": "PRE-REQUISITO para Autoatendimento",
    "validacoes": "Formato de email, telefone, CPF/CNPJ",
    "deduplicacao": "Matching por email, telefone e nome"
  }
}');

-- =============================================================================
-- Jornada 5: Portal Logístico (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Portal Logístico",
  "icone": "🚚",
  "ordem": 5,
  "status": "Pendente",
  "as_is": "Portal separado do SAP com dados redundantes",
  "passos_as_is": "Dados digitados no portal|Replicação manual para SAP|Conferência manual",
  "problemas_as_is": "Redundância de dados|Inconsistências entre sistemas|Retrabalho",
  "tempo_medio_as_is": "Variável",
  "to_be": "Integração Portal-SAP com sincronização automática",
  "passos_to_be": "Dados inseridos uma vez|Sincronização automática|Visão única integrada",
  "beneficios_to_be": "Eliminação de redundância|Dados consistentes|Processo otimizado",
  "tempo_medio_to_be": "Automático",
  "areas_impactadas": "Logística|TI",
  "fonte_reuniao": "16/12/2025"
}');

-- =============================================================================
-- Jornada 6: Financeiro/Crédito (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Financeiro/Crédito",
  "icone": "💰",
  "ordem": 6,
  "status": "Em Andamento",
  "as_is": "Ficha de crédito manual com processo lento de aprovação",
  "passos_as_is": "Análise manual de crédito|Ficha física/Excel|Aprovação por email",
  "problemas_as_is": "Processo lento|Sem visibilidade|Risco de erros",
  "tempo_medio_as_is": "2-3 dias",
  "to_be": "FSCM integrado com análise automática e workflow digital",
  "passos_to_be": "Análise automática via FSCM|Limite calculado pelo sistema|Aprovação digital com workflow",
  "beneficios_to_be": "Análise em tempo real|Visibilidade total|Processo auditável",
  "tempo_medio_to_be": "Horas",
  "areas_impactadas": "Financeiro|Comercial",
  "sistemas_tecnicos": "Salesforce|SAP FSCM|ASCP|Bureaus de Crédito",
  "fonte_reuniao": "04/12/2025",
  "fluxo_aprovacao": ["Analista", "Gestor", "Diretoria"],
  "detalhes": {
    "areasCrédito": "BBA: Limite Interno Belgo | CSP: Supply/Belgo Cash | DBA: Distribuição | ALPE: Aços Longos PE",
    "fscm": "Financial Supply Chain Management",
    "workflow": "Analista -> Gestor -> Diretoria"
  }
}');

-- =============================================================================
-- Jornada 7: Rastreamento de Concorrentes (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Rastreamento de Concorrentes",
  "icone": "🎯",
  "ordem": 7,
  "status": "Pendente",
  "as_is": "Registro manual e esporádico em planilhas individuais",
  "passos_as_is": "Vendedor anota informações|Planilhas individuais|Sem consolidação",
  "problemas_as_is": "Dados fragmentados|Informações desatualizadas|Sem análise",
  "tempo_medio_as_is": "N/A",
  "to_be": "Gestão sistemática no CRM com relatórios automáticos",
  "passos_to_be": "Registro estruturado no Salesforce|Vinculação com oportunidades|Relatórios automáticos",
  "beneficios_to_be": "Visão consolidada|Análise de mercado|Decisões baseadas em dados",
  "tempo_medio_to_be": "5 minutos",
  "areas_impactadas": "Comercial|Marketing|Estratégia",
  "fonte_reuniao": "10/12/2025"
}');

-- =============================================================================
-- Jornada 8: Autoatendimento (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Autoatendimento",
  "icone": "🖥️",
  "ordem": 8,
  "status": "Em Desenvolvimento",
  "as_is": "Inexistente - Cliente depende totalmente do vendedor ou Smart Center para qualquer consulta",
  "passos_as_is": "Cliente liga para vendedor ou Smart Center|Vendedor consulta múltiplos sistemas manualmente|Retorna informação por telefone ou email|Cliente aguarda resposta sem previsão",
  "problemas_as_is": "Dependência total do vendedor|Demora no atendimento (horas ou dias)|Sem autonomia do cliente|Smart Center sobrecarregado|Horário limitado de atendimento",
  "tempo_medio_as_is": "Horas/Dias",
  "to_be": "Portal self-service e Bot Einstein via WhatsApp para atendimento 24/7",
  "passos_to_be": "Cliente acessa portal web ou WhatsApp|Bot Einstein faz autenticação via CNPJ/CPF|Cliente consulta status de pedidos em tempo real|Download de documentos fiscais (XML, DANFE)|Rastreamento de entregas|2ª via de boletos|Transbordo automático para Smart Center se necessário",
  "beneficios_to_be": "Autonomia total do cliente|Atendimento 24/7 via WhatsApp|Redução de chamados ao Smart Center|Consultas instantâneas|Integração com Salesforce Service Cloud",
  "tempo_medio_to_be": "Imediato",
  "areas_impactadas": "Comercial|Atendimento|TI|Smart Center",
  "fonte_reuniao": "16/12/2025",
  "fontes_reuniao": "16/12/2025 - Documentos Fiscais e Autoatendimento|07/01/2026 - Bot Einstein Planejamento e Logística",
  "prerequisitos": "Dados de contato corretos (Gestão de Contatos)",
  "detalhes": {
    "prerequisito": "Depende de dados de contato corretos",
    "funcionalidades": "Status pedidos, Download XML/DANFE, Rastreamento, 2ª via boleto, Certificados, Bot WhatsApp",
    "botEinstein": "MVP em desenvolvimento - Orçamento 2026: 400.000 BRL"
  }
}');

-- =============================================================================
-- Jornada 9: Workflow Pricing (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Workflow Pricing",
  "icone": "💲",
  "ordem": 9,
  "status": "Em Andamento",
  "as_is": "Descontos sem controle centralizado e aprovações informais",
  "passos_as_is": "Vendedor negocia desconto|Aprovação informal|Desconto manual no pedido|Sem registro",
  "problemas_as_is": "Sem controle|Aprovações informais|Sem vigência|Margens corroídas",
  "tempo_medio_as_is": "Variável",
  "to_be": "Workflow de aprovação com condition YDCF no SAP",
  "passos_to_be": "Acessa Pricing no Salesforce|Navega hierarquia de materiais (6 níveis)|Define % desconto e vigência|Nível 1: Time Pricing aprova|Nível 2: Gerente aprova|YDCF criada no SAP",
  "beneficios_to_be": "Controle total|Rastreabilidade|Workflow 2 níveis|Vigência automática|Integração SAP",
  "tempo_medio_to_be": "1-2 dias",
  "areas_impactadas": "Comercial|Marketing|Pricing|TI",
  "sistemas_tecnicos": "Salesforce|SAP",
  "fonte_reuniao": "16/12/2025",
  "fluxo_aprovacao": ["Time Pricing", "Gerente Escritório"],
  "detalhes": {
    "hierarquiaMateriais": "Unidades, Macro Segmentos, Macro Detalhado, Segmento, Grupo Mercadoria, Material",
    "conditionSAP": "YDCF - Desconto de Cliente"
  }
}');

-- =============================================================================
-- Jornada 10: Cotação e Ordem de Vendas (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Cotação e Ordem de Vendas",
  "icone": "📋",
  "ordem": 10,
  "status": "Em Andamento",
  "as_is": "Processo manual de cotação com preços desatualizados",
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
  "detalhes": {
    "atp": "Available to Promise - disponibilidade em tempo real",
    "farol": "Status OV (verde/amarelo/vermelho)"
  }
}');

-- =============================================================================
-- Jornada 11: Hub de Gestão OC (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Hub de Gestão OC",
  "icone": "⚙️",
  "ordem": 11,
  "status": "Em Andamento",
  "as_is": "Gestão descentralizada de grupos com solicitações por email",
  "passos_as_is": "Solicitações por email|TI configura manualmente|Sem visibilidade de grupos|Logs separados",
  "problemas_as_is": "Processo manual|Sem self-service|Difícil auditar|Logs dispersos",
  "tempo_medio_as_is": "Dias",
  "to_be": "Hub centralizado com gestão via LWC (Lightning Web Component)",
  "passos_to_be": "Gestor acessa Gerenciar Grupos|Visualiza grupos|Adiciona/remove membros|Busca por email/nome|Visualiza logs",
  "beneficios_to_be": "Self-service|Visibilidade de membros|Controle de perfis|Logs centralizados",
  "tempo_medio_to_be": "Minutos",
  "areas_impactadas": "TI|Todas as áreas",
  "sistemas_tecnicos": "Salesforce (LWC)",
  "fonte_reuniao": "Documentos de teste",
  "detalhes": {
    "lwc": "Lightning Web Component",
    "grupos": "Comercial, Qualidade, Sistemas"
  }
}');

-- =============================================================================
-- Jornada 12: Restrições Logísticas (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Restrições Logísticas",
  "icone": "🚛",
  "ordem": 12,
  "status": "Pendente",
  "as_is": "Restrições de entrega gerenciadas em sistemas separados sem integração, causando problemas de comunicação",
  "passos_as_is": "Informações de restrição no Portal Logístico|Dados duplicados no SAP|Vendedor consulta XD03|Sem visibilidade cliente|Agendamentos por telefone",
  "problemas_as_is": "Redundância de dados|Inconsistências|Cliente sem visibilidade|Agendamentos manuais|Sem integração",
  "tempo_medio_as_is": "Variável",
  "to_be": "Integração Salesforce → SAP → Portal Logístico em tempo real",
  "passos_to_be": "Vendedor registra restrições no Salesforce|Sincroniza automaticamente com SAP|Integração com Portal Logístico|Cliente visualiza no autoatendimento|Agendamentos online",
  "beneficios_to_be": "Dados unificados|Visibilidade em tempo real|Cliente com autonomia|Eliminação de redundância|Processo otimizado",
  "tempo_medio_to_be": "Imediato",
  "areas_impactadas": "Logística|Comercial|TI|Atendimento",
  "sistemas_tecnicos": "Salesforce|SAP ECC|Portal Logístico",
  "fonte_reuniao": "10/12/2025",
  "pendencias": "Integração Portal Logístico com SAP pendente|Definição de campos obrigatórios|Reunião com equipe logística",
  "detalhes": {
    "tiposRestricao": "Veículo, Janela de Entrega, Agendamento, Descarga",
    "transacaoSAP": "XD03 - Exibir Cliente",
    "integracao": "Portal Logístico ↔ SAP ↔ Salesforce"
  }
}');

-- =============================================================================
-- Jornada 13: Market Share e Concorrentes (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Market Share e Concorrentes",
  "icone": "📊",
  "ordem": 13,
  "status": "Pendente",
  "as_is": "Informações de concorrentes e market share dispersas, sem gestão centralizada ou análise sistemática",
  "passos_as_is": "Vendedor coleta informações informalmente|Dados em planilhas individuais|Projetos perdidos não vinculados|Sem histórico de market share|Análise manual",
  "problemas_as_is": "Concorrentes sazonais e dinâmicos|Difícil vincular projetos perdidos|Sem visão de share of wallet|Dados fragmentados|Impossível rastrear tendências",
  "tempo_medio_as_is": "N/A",
  "to_be": "Gestão centralizada de concorrentes e market share no Salesforce com análise automatizada",
  "passos_to_be": "Cadastro normalizado de concorrentes|Registro de share of wallet por cliente|Vinculação de oportunidades perdidas|Dashboard de análise automático|Histórico de evolução",
  "beneficios_to_be": "Visão consolidada de concorrentes|Análise de share of wallet|Identificação de tendências|Decisões baseadas em dados|Rastreamento de projetos perdidos",
  "tempo_medio_to_be": "5 minutos por registro",
  "areas_impactadas": "Comercial|Marketing|Estratégia|Inteligência de Mercado",
  "sistemas_tecnicos": "Salesforce|Power BI",
  "fonte_reuniao": "10/12/2025",
  "pendencias": "Normalização de cadastro pela TI|Critérios para projetos perdidos|Discussão com Edmundo",
  "detalhes": {
    "shareOfWallet": "Percentual de compra do cliente na Belgo vs concorrentes",
    "concorrentes": "Lista normalizada pela TI - desafio: concorrentes sazonais"
  }
}');

-- =============================================================================
-- Jornada 14: AMD Cross Company (COMPLETO)
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "AMD Cross Company",
  "icone": "🔄",
  "ordem": 14,
  "status": "Pendente",
  "as_is": "Processo de vendas entre empresas do grupo ArcelorMittal não contemplado no Salesforce atual",
  "passos_as_is": "AMD gerencia vendas em sistema próprio|Transações cross company manuais|Sem integração com Salesforce|Visibilidade limitada",
  "problemas_as_is": "AMD sem funcionalidades no Salesforce|Cross Company não contemplado|Falta rastreabilidade intercompany|Difícil consolidar resultados",
  "tempo_medio_as_is": "Variável",
  "to_be": "Integração do processo AMD Cross Company no Salesforce para gestão unificada de vendas intercompany",
  "passos_to_be": "Registro de transações AMD no Salesforce|Workflow de aprovação cross company|Integração com SAP para contabilização|Relatórios consolidados|Visibilidade completa",
  "beneficios_to_be": "Gestão unificada de vendas do grupo|Rastreabilidade intercompany|Consolidação de resultados|Visibilidade para todas as áreas|Processo padronizado",
  "tempo_medio_to_be": "A definir",
  "areas_impactadas": "Comercial|Financeiro|Controladoria|AMD",
  "sistemas_tecnicos": "Salesforce|SAP ECC|Sistema AMD",
  "fonte_reuniao": "10/12/2025",
  "pendencias": "Reunião com Renata e Victoria|Escopo AMD no Salesforce|Mapeamento cross company",
  "detalhes": {
    "amd": "ArcelorMittal Distribuição - Empresa do grupo para distribuição",
    "crossCompany": "Transações de venda entre diferentes empresas do grupo",
    "responsavel": "Renata Mello e Victoria"
  }
}');

-- Verificar resultado
SELECT COUNT(*) as total_jornadas FROM projeto_dados WHERE entidade_id = 18 AND projeto_id = 5;
