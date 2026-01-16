-- =====================================================
-- Migration 016: Importar dados completos de Testes
-- Projeto 5 (GTM Clone) - Entidade ID 22
-- =====================================================

-- Limpar dados existentes de testes do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 22 AND projeto_id = 5;

-- Categoria: Workflow Pricing (CT-01 a CT-19)
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-01","nome":"Criar WF Pricing para desconto fixo em material específico","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Acessar Conta integrada SAP|2. New WFPricing|3. Selecionar Canal e Escritorio|4. Navegar hierarquia 6 niveis|5. Definir desconto %|6. Criar","resultado_esperado":"WF criado, status Aguardando Aprovação, Integration Status=Completed","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-02","nome":"Alterar vigencia individual por linha de material","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Iniciar WF|2. Definir vigencia padrão|3. Alterar vigencia por material|4. Verificar diferenças|5. Criar","resultado_esperado":"Vigencias individuais por material respeitadas","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-03","nome":"Tentar criar WF sem canal atribuido ao cliente","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Conta sem canais configurados|2. Clicar New WFPricing|3. Verificar comportamento","resultado_esperado":"Mensagem: Não há canais disponíveis","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-04","nome":"Consultar histórico de WF Pricing de um cliente","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Conta com WF existentes|2. Navegar seção WF relacionados|3. Verificar lista|4. Visualizar detalhes","resultado_esperado":"Histórico completo visível com status, datas, materiais","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-05","nome":"Validar input manual de % de desconto","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Criar WF|2. Inserir valores: 5%, 10%, 7.5%|3. Validar limites 0-100%|4. Testar valor inválido (150%)","resultado_esperado":"Campo aceita 0-100%, decimais permitidos, validação funcionando","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-06","nome":"Criar WF para desconto em grupo de mercadoria","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Abrir Conta|2. New WFPricing|3. Navegar ate Grupo de Mercadoria|4. Definir desconto|5. Criar","resultado_esperado":"Desconto aplicado a todos materiais do grupo","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-07","nome":"Aprovar WF pelo time de Pricing","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Logar como aprovador Pricing|2. Verificar notificações|3. Acessar WF pendente|4. Revisar e Aprovar","resultado_esperado":"Status atualizado, aguardando gerente nível 2","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-08","nome":"Aprovar WF pelo gerente do Escritorio","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Logar como gerente|2. Verificar notificações|3. Acessar WF aprovado pelo Pricing|4. Aprovar","resultado_esperado":"WF aprovado, YDCF criada no SAP, status Aprovado","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-09","nome":"Rejeitar WF pelo time de Pricing","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Logar como aprovador|2. Acessar WF pendente|3. Rejeitar com justificativa","resultado_esperado":"WF rejeitado, solicitante notificado, sem condition SAP","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-10","nome":"Criar WF com multiplos materiais e % diferentes","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Iniciar WF|2. Selecionar 3 materiais|3. Definir 5%, 8%, 3%|4. Criar","resultado_esperado":"3 linhas de desconto, cada material com seu %","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-11","nome":"Tentar criar WF em conta sem código SAP","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Conta sem código SAP|2. Tentar clicar New WFPricing|3. Verificar comportamento","resultado_esperado":"Botão indisponível ou mensagem de erro","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Bug: Botão New WFPricing disponível mesmo para contas sem código SAP - deveria estar bloqueado"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-12","nome":"Verificar criação da YDCF no SAP apos aprovação","categoria":"Workflow Pricing","sistema":"SF+SAP","prioridade":"Alta","status":"Pendente","passos":"1. Aprovar WF completamente|2. Logar SAP|3. VK13 buscar YDCF|4. Verificar dados","resultado_esperado":"YDCF criada com dados exatos do WF","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-13","nome":"Criar WF para Segmento de Produto (nível hierárquico)","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Iniciar WF|2. Navegar hierarquia|3. Parar em Segmento de Produto|4. Definir desconto|5. Criar","resultado_esperado":"Desconto aplicável a todos materiais do segmento","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-14","nome":"Tentar criar WF com % inválido (-5% ou >100%)","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Iniciar WF|2. Tentar -5% ou 150%|3. Tentar criar","resultado_esperado":"Sistema valida e impede (0-100%)","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Bug: O workflow foi criado com sucesso mas valores abaixo de 0% não exibem mensagem de erro correta. Problema também ocorre para valores acima de 100%."}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-15","nome":"Criar WF com vigencia retroativa","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Iniciar WF|2. Data início no passado|3. Preencher demais dados","resultado_esperado":"Sistema alerta sobre data retroativa","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-16","nome":"Criar WF para canal específico e validar aplicação","categoria":"Workflow Pricing","sistema":"SF+SAP","prioridade":"Alta","status":"Pendente","passos":"1. Cliente com multiplos canais|2. Criar WF para canal 20|3. Criar 2 cotações (20 e 30)|4. Verificar desconto","resultado_esperado":"Desconto apenas no canal Industrial (20)","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-17","nome":"Validar envio de email de notificação","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Criar novo WF|2. Clicar Criar|3. Verificar email do aprovador","resultado_esperado":"Email recebido com informações do WF","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-18","nome":"Validar navegação completa na arvore de hierarquia","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Iniciar WF|2. Verificar 6 niveis|3. Usar Abrir/Fechar todos","resultado_esperado":"Árvore exibe 6 níveis corretamente, botões funcionam","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-19","nome":"Validar aprovação por aprovador alternativo","categoria":"Workflow Pricing","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Criar WF|2. Aprovador principal ausente|3. Aprovador alternativo aprova","resultado_esperado":"Aprovação funcionando com aprovador alternativo","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

-- Categoria: Hub de Gestão OC
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-20","nome":"Visualizar grupos de email existentes","categoria":"Hub de Gestão OC","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Acessar Gerenciar Grupos|2. Filtrar por grupo","resultado_esperado":"Lista de grupos com membros visíveis","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-21","nome":"Adicionar membro a grupo existente","categoria":"Hub de Gestão OC","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Acessar grupo|2. Buscar usuário por email|3. Adicionar ao grupo","resultado_esperado":"Membro adicionado, confirmação exibida","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-22","nome":"Remover membro de grupo","categoria":"Hub de Gestão OC","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Acessar grupo|2. Selecionar membro|3. Remover","resultado_esperado":"Membro removido, log registrado","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-23","nome":"Visualizar logs de alterações","categoria":"Hub de Gestão OC","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Acessar seção de logs|2. Filtrar por período|3. Verificar detalhes","resultado_esperado":"Logs exibidos com data, ação, usuário","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

-- Categoria: Cadastro de Cliente
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-116","nome":"Validar preenchimento automático CNAE via SINTEGRA","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Criar nova conta PJ|2. Inserir CNPJ válido|3. Clicar Integrar SINTEGRA|4. Verificar CNAE","resultado_esperado":"CNAE preenchido automaticamente com descrição completa","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Documento 876268"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-117","nome":"Testar SINTEGRA com diferentes tipos de empresa","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Testar CNPJ de comércio|2. Testar CNPJ de indústria|3. Testar CNPJ de serviços|4. Verificar CNAEs","resultado_esperado":"CNAEs corretos para cada tipo de empresa","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Contas teste: ADUBOSREAL, SANTA RITA, PERAM, DIVINO ANT, VALDIR FLOR"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-118","nome":"Tentar cadastro com Termo de Pesquisa duplicado","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Criar conta|2. Inserir Termo de Pesquisa existente|3. Tentar salvar","resultado_esperado":"Mensagem de erro bloqueando cadastro duplicado","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Documento 899139"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-119","nome":"Cadastro com Termo de Pesquisa único","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Criar conta|2. Inserir Termo de Pesquisa novo|3. Completar cadastro|4. Salvar","resultado_esperado":"Cadastro concluído com sucesso","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-120","nome":"Validar cálculo automático de Cluster","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Criar conta com dados completos|2. Verificar cluster calculado|3. Validar regras aplicadas","resultado_esperado":"Cluster calculado automaticamente baseado em regras","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Documento 862865"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-121","nome":"Testar workflow de exceção de Cluster","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Solicitar alteração de Cluster|2. Enviar para aprovação|3. Aprovar|4. Verificar campo Cluster Exceção","resultado_esperado":"Cluster alterado após aprovação, campo exceção marcado","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Contas teste: Mercbenz, Leao, FRUITTOOLS"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-122","nome":"Notificação de cadastro pendente","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Deixar cadastro incompleto|2. Aguardar notificação|3. Verificar destinatários","resultado_esperado":"Notificação enviada automaticamente","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Documento 881196"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-123","nome":"Automatização de Segmento e Subsegmento","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Media","status":"Pendente","passos":"1. Criar conta|2. Verificar segmento automático|3. Validar regras de classificação","resultado_esperado":"Segmento e Subsegmento preenchidos automaticamente","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Documento 895163"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-124","nome":"Verificar remoção de botões desnecessários","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Baixa","status":"Pendente","passos":"1. Acessar tela de Contas|2. Verificar ausência de Descobrir Empresas|3. Verificar ausência de Importar|4. Verificar ausência de Atribuir Rótulo","resultado_esperado":"Botões removidos da interface","resultado_obtido":"","data_execucao":"","executor":"","observacoes":"Roteiro de Teste - CNAE"}');

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 22, '{"id":"CT-125","nome":"Preenchimento automático de Escritório e Equipe de Vendas","categoria":"Cadastro de Cliente","sistema":"Salesforce","prioridade":"Alta","status":"Pendente","passos":"1. Criar conta|2. Verificar Escritório de Vendas (perfil)|3. Verificar Equipe de Vendas (time)","resultado_esperado":"Campos preenchidos automaticamente conforme perfil do usuário","resultado_obtido":"","data_execucao":"","executor":"","observacoes":""}');
