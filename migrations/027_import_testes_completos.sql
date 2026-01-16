-- =====================================================
-- Migration 027: Importar Testes Completos
-- Projeto 5 (GTM Clone) - Entidade: testes
-- Total: 152 casos de teste detalhados
-- =====================================================

-- Limpar dados existentes de testes do projeto 5
DELETE FROM projeto_dados WHERE projeto_id = 5
AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5);

-- ===========================================
-- CATEGORIA 1: WORKFLOW PRICING (CT 01-19)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-01", "categoria": "workflow-pricing", "nome": "Criar WF Pricing para desconto fixo em material específico", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Conta integrada SAP", "2. New WFPricing", "3. Selecionar Canal e Escritório", "4. Navegar hierarquia 6 níveis", "5. Definir desconto %", "6. Criar"], "resultado_esperado": "WF criado, status Aguardando Aprovação, Integration Status=Completed"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-02", "categoria": "workflow-pricing", "nome": "Alterar vigência individual por linha de material", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Iniciar WF", "2. Definir vigência padrão", "3. Alterar vigência por material", "4. Verificar diferenças", "5. Criar"], "resultado_esperado": "Vigências individuais por material respeitadas"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-03", "categoria": "workflow-pricing", "nome": "Tentar criar WF sem canal atribuído ao cliente", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Conta sem canais configurados", "2. Clicar New WFPricing", "3. Verificar comportamento"], "resultado_esperado": "Mensagem: Não há canais disponíveis"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-04", "categoria": "workflow-pricing", "nome": "Consultar histórico de WF Pricing de um cliente", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Conta com WF existentes", "2. Navegar seção WF relacionados", "3. Verificar lista", "4. Visualizar detalhes"], "resultado_esperado": "Histórico completo visível com status, datas, materiais"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-05", "categoria": "workflow-pricing", "nome": "Validar input manual de % de desconto", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Criar WF", "2. Inserir valores: 5%, 10%, 7.5%", "3. Validar limites 0-100%", "4. Testar valor inválido (150%)"], "resultado_esperado": "Campo aceita 0-100%, decimais permitidos, validação funcionando"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-06", "categoria": "workflow-pricing", "nome": "Criar WF para desconto em grupo de mercadoria", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Abrir Conta", "2. New WFPricing", "3. Navegar até Grupo de Mercadoria", "4. Definir desconto", "5. Criar"], "resultado_esperado": "Desconto aplicado a todos materiais do grupo"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-07", "categoria": "workflow-pricing", "nome": "Aprovar WF pelo time de Pricing", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Logar como aprovador Pricing", "2. Verificar notificações", "3. Acessar WF pendente", "4. Revisar e Aprovar"], "resultado_esperado": "Status atualizado, aguardando gerente nível 2"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-08", "categoria": "workflow-pricing", "nome": "Aprovar WF pelo gerente do Escritório", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Logar como gerente", "2. Verificar notificações", "3. Acessar WF aprovado pelo Pricing", "4. Aprovar"], "resultado_esperado": "WF aprovado, YDCF criada no SAP, status Aprovado"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-09", "categoria": "workflow-pricing", "nome": "Rejeitar WF pelo time de Pricing", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Logar como aprovador", "2. Acessar WF pendente", "3. Rejeitar com justificativa"], "resultado_esperado": "WF rejeitado, solicitante notificado, sem condition SAP"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-10", "categoria": "workflow-pricing", "nome": "Criar WF com múltiplos materiais e % diferentes", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Iniciar WF", "2. Selecionar 3 materiais", "3. Definir 5%, 8%, 3%", "4. Criar"], "resultado_esperado": "3 linhas de desconto, cada material com seu %"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-11", "categoria": "workflow-pricing", "nome": "Tentar criar WF em conta sem código SAP", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Conta sem código SAP", "2. Tentar clicar New WFPricing", "3. Verificar comportamento"], "resultado_esperado": "Botão indisponível ou mensagem de erro", "observacoes": "Bug: Botão disponível mesmo para contas sem código SAP"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-12", "categoria": "workflow-pricing", "nome": "Verificar criação da YDCF no SAP após aprovação", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Aprovar WF completamente", "2. Logar SAP", "3. VK13 buscar YDCF", "4. Verificar dados"], "resultado_esperado": "YDCF criada com dados exatos do WF"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-13", "categoria": "workflow-pricing", "nome": "Criar WF para Segmento de Produto (nível hierárquico)", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Iniciar WF", "2. Navegar hierarquia", "3. Parar em Segmento de Produto", "4. Definir desconto", "5. Criar"], "resultado_esperado": "Desconto aplicável a todos materiais do segmento"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-14", "categoria": "workflow-pricing", "nome": "Tentar criar WF com % inválido (-5% ou >100%)", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Iniciar WF", "2. Tentar -5% ou 150%", "3. Tentar criar"], "resultado_esperado": "Sistema valida e impede (0-100%)", "observacoes": "Bug identificado: validação de desconto negativo não exibe mensagem correta"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-15", "categoria": "workflow-pricing", "nome": "Criar WF com vigência retroativa", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Iniciar WF", "2. Data início no passado", "3. Preencher demais dados"], "resultado_esperado": "Sistema alerta sobre data retroativa"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-16", "categoria": "workflow-pricing", "nome": "Criar WF para canal específico e validar aplicação", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente com múltiplos canais", "2. Criar WF para canal 20", "3. Criar 2 cotações (20 e 30)", "4. Verificar desconto"], "resultado_esperado": "Desconto apenas no canal Industrial (20)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-17", "categoria": "workflow-pricing", "nome": "Validar envio de email de notificação", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Criar novo WF", "2. Clicar Criar", "3. Verificar email do aprovador"], "resultado_esperado": "Email recebido com informações do WF"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-18", "categoria": "workflow-pricing", "nome": "Validar navegação completa na árvore de hierarquia", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Iniciar WF", "2. Verificar 6 níveis", "3. Usar Abrir/Fechar todos"], "resultado_esperado": "Árvore exibe 6 níveis corretamente, botões funcionam"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-19", "categoria": "workflow-pricing", "nome": "Validar aprovação por aprovador alternativo", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Criar WF", "2. Verificar se aprovador delegado consegue aprovar"], "resultado_esperado": "Aprovador alternativo aprova, sistema registra quem"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 2: TRIBUTÁRIO (CT 20-55)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-20", "categoria": "tributario", "nome": "Testar material importado (II)", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Material importado", "2. Criar OV", "3. Gerar NF", "4. Verificar II"], "resultado_esperado": "II incorporado conforme parametrização"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-21", "categoria": "tributario", "nome": "Validar isenção total - Zona Franca", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente ZFM", "2. Verificar Região=ZFM", "3. Simular faturamento"], "resultado_esperado": "Isenção total: ICMS=0, IPI=0, PIS=0, COFINS=0, CFOP 6109"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-22", "categoria": "tributario", "nome": "Validar isenção - categoria fiscal isento", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente isento (órgão público)", "2. Verificar XD03", "3. Simular faturamento"], "resultado_esperado": "Impostos isentos, CST 40/41, código I0"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-23", "categoria": "tributario", "nome": "Determinação automática I3 - Canal 20", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Criar OV canal 20", "2. Conferir VA02/VA03", "3. Validar código I3"], "resultado_esperado": "I3 automático, ICMS/IPI/PIS/COFINS calculados"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-24", "categoria": "tributario", "nome": "Verificar I3 para canal Distribuidores (30)", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cotação canal 30", "2. Sincronizar e converter OV", "3. Validar código"], "resultado_esperado": "Código I3 atribuído para canal 30"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-25", "categoria": "tributario", "nome": "Determinação automática C3 - Canal 40", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Criar OV canal 40", "2. Conferir SAP", "3. Validar C3"], "resultado_esperado": "C3 automático, Base ICMS = Valor + IPI"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-26", "categoria": "tributario", "nome": "Validar cálculo ICMS ST na NF", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. OV com material ST", "2. Faturar", "3. VF03", "4. Verificar ICMS ST"], "resultado_esperado": "ICMS ST calculado conforme NCM e UF"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-27", "categoria": "tributario", "nome": "Validar cálculo IPI na NF", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. OV com IPI", "2. Faturar", "3. VF03", "4. Verificar IPI"], "resultado_esperado": "IPI conforme alíquota NCM"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-28", "categoria": "tributario", "nome": "ICMS ST canal 30 - intraestadual", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Ordem canal 30 mesma UF", "2. Material com ST", "3. Simular"], "resultado_esperado": "Base ST = (Valor+IPI) x (1+MVA), CFOP 5401/5403"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-29", "categoria": "tributario", "nome": "ICMS ST canal 30 - interestadual", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Ordem canal 30 UF diferente", "2. Material com ST", "3. Simular"], "resultado_esperado": "ST interestadual, MVA ajustado, CFOP 6401/6403"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-30", "categoria": "tributario", "nome": "NCM com exceção (VK11-ISTN) NÃO calcula ST", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Material com NCM exceção", "2. Ordem canal 30", "3. Simular"], "resultado_esperado": "ICMS normal calculado, ICMS ST = 0"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-31", "categoria": "tributario", "nome": "DIFAL canal 40 (PF) interestadual", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Ordem canal 40 UF diferente", "2. Simular", "3. Analisar impostos"], "resultado_esperado": "DIFAL calculado, GNRE gerada"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-32", "categoria": "tributario", "nome": "DIFAL NÃO calculado para canal 20/30", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Ordem canal 20/30 UF diferente", "2. Simular", "3. Verificar impostos"], "resultado_esperado": "Sem DIFAL para contribuintes ICMS"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-33", "categoria": "tributario", "nome": "FCP para canal 30", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Ordem canal 30", "2. Estado com FCP", "3. Simular"], "resultado_esperado": "FCP 2% calculado, GNRE para FCP"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-34", "categoria": "tributario", "nome": "FCP para canal 40 com DIFAL", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Ordem interestadual canal 40", "2. Estado com FCP", "3. Simular"], "resultado_esperado": "FCP + DIFAL calculados, partilha origem/destino"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-35", "categoria": "tributario", "nome": "IPI para todos os canais", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Ordens canais 20,30,40", "2. Material com IPI", "3. Simular cada"], "resultado_esperado": "IPI igual para todos canais conforme TIPI"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-36", "categoria": "tributario", "nome": "Canal 30 - Indústria com ICMS-ST (C4)", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Conferir OV SAP", "2. Material ST", "3. Verificar ICMS-ST"], "resultado_esperado": "Código C4, ICMS+IPI+PIS+COFINS+ST"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-37", "categoria": "tributario", "nome": "Canal 40 - IPI integra base ICMS", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Conferir OV SAP", "2. Cliente consumidor", "3. Verificar base ICMS"], "resultado_esperado": "Base ICMS = Valor Produto + IPI"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-38", "categoria": "tributario", "nome": "Diferimento de ICMS - Exceção VK", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente com diferimento VK", "2. Criar OV", "3. Verificar ICMS=0", "4. Verificar XML"], "resultado_esperado": "ICMS=0 (diferido), XML com tags diferimento"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-39", "categoria": "tributario", "nome": "NCM sem IPI - J1BTAX alíquota zero", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Material com NCM J1BTAX alíq 0", "2. Código I3", "3. Verificar IPI"], "resultado_esperado": "IPI=0 (NCM sobrescreve código)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-40", "categoria": "tributario", "nome": "NCM com IPI - Cálculo normal", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Material com NCM alíq IPI>0", "2. Código I3", "3. Verificar IPI"], "resultado_esperado": "IPI calculado conforme alíquota NCM"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-41", "categoria": "tributario", "nome": "Exceções múltiplas por cliente e material", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Configurar exceções VK11", "2. Cliente com múltiplas exceções", "3. Criar OV", "4. Verificar aplicação"], "resultado_esperado": "Exceções aplicadas na ordem correta de prioridade"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-42", "categoria": "tributario", "nome": "Testar venda interestadual com redução base ICMS", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Origem SP, Destino SP", "2. Material com redução", "3. Simular faturamento"], "resultado_esperado": "Base ICMS reduzida conforme legislação SP"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-43", "categoria": "tributario", "nome": "Testar venda intraestadual com alíquota interna", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Origem MG, Destino RJ", "2. Criar OV", "3. Verificar alíquota ICMS"], "resultado_esperado": "ICMS 12% aplicado corretamente"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-44", "categoria": "tributario", "nome": "CFOP correto para venda intraestadual", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. OV intraestadual", "2. Faturar", "3. Verificar CFOP na NF"], "resultado_esperado": "CFOP iniciado com 5 (5102, 5401, etc)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-45", "categoria": "tributario", "nome": "CFOP correto para venda interestadual", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. OV interestadual", "2. Faturar", "3. Verificar CFOP na NF"], "resultado_esperado": "CFOP iniciado com 6 (6102, 6401, etc)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-46", "categoria": "tributario", "nome": "Validar ZSD190 - Simulação de pricing", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar ZSD190", "2. Informar parâmetros", "3. Executar simulação"], "resultado_esperado": "Pricing simulado com todos impostos"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-47", "categoria": "tributario", "nome": "J1BTAX - Verificar tabelas de impostos", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar J1BTAX", "2. Verificar NCM", "3. Conferir alíquotas"], "resultado_esperado": "Alíquotas corretas conforme TIPI"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-48", "categoria": "tributario", "nome": "XML NF-e - Validar estrutura completa", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Gerar NF", "2. Extrair XML", "3. Validar campos obrigatórios"], "resultado_esperado": "XML válido conforme schema SEFAZ"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-49", "categoria": "tributario", "nome": "PIS/COFINS - Regime cumulativo", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente regime cumulativo", "2. Criar OV", "3. Verificar alíquotas PIS/COFINS"], "resultado_esperado": "PIS 0.65%, COFINS 3%"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-50", "categoria": "tributario", "nome": "PIS/COFINS - Regime não cumulativo", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente regime não cumulativo", "2. Criar OV", "3. Verificar alíquotas PIS/COFINS"], "resultado_esperado": "PIS 1.65%, COFINS 7.6%"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-51", "categoria": "tributario", "nome": "Alíquota ICMS por estado origem/destino", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Testar combinações UF origem x destino", "2. Verificar alíquotas aplicadas"], "resultado_esperado": "Alíquotas corretas conforme tabela interestadual"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-52", "categoria": "tributario", "nome": "MVA ajustado para ST interestadual", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Venda interestadual com ST", "2. Verificar MVA aplicado"], "resultado_esperado": "MVA ajustado conforme estado destino"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-53", "categoria": "tributario", "nome": "Base de cálculo dupla ST (IPI na base)", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Material com IPI e ST", "2. Verificar base ST"], "resultado_esperado": "Base ST = (Valor + IPI) x (1 + MVA)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-54", "categoria": "tributario", "nome": "Isenção IPI para exportação", "sistema": "SAP", "prioridade": "Media", "status": "Pendente", "passos": ["1. OV de exportação", "2. Verificar IPI"], "resultado_esperado": "IPI = 0, CST 41 (isento)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-55", "categoria": "tributario", "nome": "Validar CST de ICMS na NF", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Gerar NF", "2. Verificar CST ICMS no XML"], "resultado_esperado": "CST correto conforme situação tributária"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 3: SETUP E CONFIGURAÇÃO (CT 56-77)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-56", "categoria": "setup", "nome": "Transferir material para centro de vendas de teste", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação MIGO no SAP", "2. Selecionar tipo de movimento: Transferência", "3. Informar Material de teste", "4. Centro Origem: X, Centro Destino: Y", "5. Quantidade: 10.000 kg", "6. Salvar documento"], "resultado_esperado": "Material transferido com sucesso. Documento MM gerado."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-57", "categoria": "setup", "nome": "Verificar disponibilidade de estoque no centro", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação MMBE no SAP", "2. Informar código do material", "3. Informar centro de vendas", "4. Verificar estoque disponível"], "resultado_esperado": "Estoque disponível > 5.000 kg no centro de teste"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-58", "categoria": "setup", "nome": "Testar cotação com material expandido canal 20", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Identificar material expandido para canal 20", "2. Identificar cliente com canal 20 ativo", "3. Acessar Salesforce", "4. Criar nova cotação", "5. Adicionar material ao carrinho", "6. Sincronizar com SAP"], "resultado_esperado": "Cotação criada sem erros. Material disponível para canal."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-59", "categoria": "setup", "nome": "Testar erro com material NÃO expandido", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Identificar material SEM expansão para canal 20", "2. Acessar Salesforce", "3. Criar cotação para cliente canal 20", "4. Tentar adicionar material não expandido"], "resultado_esperado": "Erro exibido: Material não disponível para o canal selecionado"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-60", "categoria": "setup", "nome": "Testar WF Pricing com material multi-canal", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Identificar material expandido para canais 20, 30 e 40", "2. Acessar Salesforce", "3. Criar WF Pricing para cliente com todos os canais", "4. Selecionar material multi-canal", "5. Definir desconto", "6. Verificar aplicação em todos os canais"], "resultado_esperado": "Desconto aplicado em todos os 3 canais (20, 30, 40)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-61", "categoria": "setup", "nome": "Expandir materiais para canal 20 (Indústria)", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação MM02 ou ZWSWF001", "2. Selecionar material de teste", "3. Criar visão de Vendas", "4. Org.Vendas: 1", "5. Canal: 20 (Indústria)", "6. Salvar material"], "resultado_esperado": "Material expandido para canal 20. Visível na tabela MVKE."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-62", "categoria": "setup", "nome": "Expandir materiais para canal 30 (Revenda)", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação MM02", "2. Selecionar material", "3. Criar visão de Vendas", "4. Canal: 30 (Revenda)", "5. Salvar"], "resultado_esperado": "Material expandido para canal 30. Visível na tabela MVKE."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-63", "categoria": "setup", "nome": "Expandir materiais para canal 40 (Consumidor)", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação MM02", "2. Selecionar material", "3. Criar visão de Vendas", "4. Canal: 40 (Consumidor)", "5. Salvar"], "resultado_esperado": "Material expandido para canal 40. Visível na tabela MVKE."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-64", "categoria": "setup", "nome": "Cadastrar limite de crédito no FSCM", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação UKM_BP no SAP", "2. Buscar Business Partner de teste", "3. Definir Credit Limit: R$ 100.000", "4. Definir Credit Control Area", "5. Salvar configuração"], "resultado_esperado": "Limite de crédito de R$ 100.000 cadastrado no FSCM"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-65", "categoria": "setup", "nome": "Validar cliente com crédito bloqueado", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação UKM_BP", "2. Buscar Business Partner", "3. Definir Credit Limit: R$ 0 OU Credit Block ativo", "4. Tentar criar OV para este cliente"], "resultado_esperado": "Cliente bloqueado. OV não avança sem liberação."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-66", "categoria": "setup", "nome": "Validar cliente com crédito liberado", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação UKM_BP", "2. Buscar Business Partner", "3. Definir Credit Limit: R$ 500.000", "4. Verificar via UKM_CREDIT_CHECK", "5. Criar OV para este cliente"], "resultado_esperado": "Cliente liberado. OVs processadas sem bloqueio de crédito."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-67", "categoria": "setup", "nome": "Parametrizar condições de pagamento por canal e segmento", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar transação ZWSSD067", "2. Definir condição de pagamento", "3. Associar ao canal de vendas", "4. Associar ao segmento de produto", "5. Salvar parametrização"], "resultado_esperado": "Condições de pagamento parametrizadas por canal/segmento"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-68", "categoria": "setup", "nome": "Listar clientes necessários para os testes", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Revisar casos de teste", "2. Identificar perfis necessários: PJ com crédito, PJ sem crédito, PF, clientes de diferentes UFs, cliente Zona Franca", "3. Documentar lista em planilha"], "resultado_esperado": "Lista completa com mínimo de 5 clientes de teste documentada"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-69", "categoria": "setup", "nome": "Validar expansão completa via tabelas SAP", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar SE16 no SAP", "2. Consultar tabela MVKE (materiais)", "3. Verificar registros para canais 20, 30, 40", "4. Consultar tabela KNVV (clientes)", "5. Verificar registros por canal"], "resultado_esperado": "100% dos materiais e clientes de teste expandidos corretamente"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-70", "categoria": "setup", "nome": "Listar materiais necessários para os testes", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Revisar casos de teste", "2. Identificar materiais necessários: com IPI, sem IPI, com ST, importado, diferentes grupos", "3. Documentar lista em planilha"], "resultado_esperado": "Lista completa com mínimo de 10 materiais de teste documentada"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-71", "categoria": "setup", "nome": "Configurar usuário de teste no Salesforce", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Setup do Salesforce", "2. Criar usuário de teste", "3. Atribuir perfil de vendedor", "4. Associar escritório de vendas", "5. Testar login"], "resultado_esperado": "Usuário de teste criado e funcional"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-72", "categoria": "setup", "nome": "Configurar usuário aprovador Pricing", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Setup do Salesforce", "2. Criar usuário aprovador", "3. Atribuir perfil de aprovador Pricing", "4. Configurar queue de aprovação", "5. Testar login"], "resultado_esperado": "Usuário aprovador criado e funcional"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-73", "categoria": "setup", "nome": "Configurar usuário gerente escritório", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Setup do Salesforce", "2. Criar usuário gerente", "3. Atribuir perfil de gerente", "4. Associar escritório de vendas", "5. Testar login"], "resultado_esperado": "Usuário gerente criado e funcional"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-74", "categoria": "setup", "nome": "Validar integração SF-SAP está ativa", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Verificar configuração MuleSoft", "2. Testar conexão SF -> SAP", "3. Testar conexão SAP -> SF", "4. Verificar logs de integração"], "resultado_esperado": "Integração bidirecional funcionando corretamente"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-75", "categoria": "setup", "nome": "Configurar tabela de preços no SAP", "sistema": "SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar VK11", "2. Criar condição PR00 (preço base)", "3. Definir preço para materiais de teste", "4. Definir vigência", "5. Salvar"], "resultado_esperado": "Preços base cadastrados para todos materiais de teste"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-76", "categoria": "setup", "nome": "Validar hierarquia de produtos no SF", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar módulo de produtos", "2. Verificar hierarquia de 6 níveis", "3. Validar materiais em cada nível", "4. Testar navegação"], "resultado_esperado": "Hierarquia completa com todos níveis funcionando"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-77", "categoria": "setup", "nome": "Documentar ambiente de teste", "sistema": "SF+SAP", "prioridade": "Media", "status": "Pendente", "passos": ["1. Listar URLs de acesso", "2. Documentar credenciais de teste", "3. Listar clientes de teste", "4. Listar materiais de teste", "5. Criar documento de referência"], "resultado_esperado": "Documento completo com todas informações do ambiente"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 4: FINANCEIRO E CRÉDITO (CT 78-80)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-78", "categoria": "financeiro", "nome": "Verificar bloqueio automático de OV sem crédito", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Identificar cliente SEM crédito disponível", "2. Criar cotação no Salesforce", "3. Sincronizar e converter em OV", "4. Acessar OV no SAP (VA03)", "5. Verificar bloqueios ativos"], "resultado_esperado": "OV bloqueada automaticamente com código Z3 (Bloqueio de Crédito)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-79", "categoria": "financeiro", "nome": "Validar mensagem de alerta de crédito ao validar cotação", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Identificar cliente com problema de crédito", "2. Criar cotação no Salesforce", "3. Adicionar materiais", "4. Clicar em Validar ou Sincronizar", "5. Observar mensagens de alerta"], "resultado_esperado": "Alerta visual exibido na tela indicando problema de crédito"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-80", "categoria": "financeiro", "nome": "Consultar OV criada e verificar dados completos", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Identificar OV retornada do SAP para SF", "2. Acessar registro da OV no Salesforce", "3. Clicar no link da ordem", "4. Verificar aba Fluxo", "5. Verificar aba Detalhes", "6. Verificar Order Tracking"], "resultado_esperado": "Todos os dados corretos e consistentes entre SF e SAP"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 5: COTAÇÃO E ORDEM DE VENDAS (CT 81-101)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-81", "categoria": "cotacao-ov", "nome": "Verificar aplicação automática de YDCF na cotação", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente com WF Pricing aprovado", "2. Criar cotação (mesmo canal/escritório)", "3. Incluir material com YDCF", "4. Sincronizar com SAP", "5. Verificar campo Desconto Fixo"], "resultado_esperado": "Desconto Fixo aparece automaticamente"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-82", "categoria": "cotacao-ov", "nome": "Incluir material via busca por código", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Tela Produtos da cotação", "2. Clicar Busca de Produtos", "3. Digitar código do material", "4. Selecionar na lista", "5. Preencher quantidade"], "resultado_esperado": "Material adicionado com código, descrição e quantidade corretos"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-83", "categoria": "cotacao-ov", "nome": "Sincronizar cotação com material sem parametrização", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Incluir material NÃO parametrizado no SAP", "2. Tentar sincronizar cotação", "3. Verificar mensagens de erro"], "resultado_esperado": "Erro vermelho indicando falta de parametrização no SAP"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-84", "categoria": "cotacao-ov", "nome": "Verificar mensagem de disponibilidade (ATP)", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Criar cotação", "2. Adicionar material", "3. Verificar coluna Disponibilidade", "4. Observar sinal visual"], "resultado_esperado": "Mensagem Disponível em XX dias. Sinal: verde imediato, amarelo alguns dias, vermelho indisponível"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-85", "categoria": "cotacao-ov", "nome": "Validar erro com material sem estoque", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Identificar material SEM estoque", "2. Tentar criar cotação", "3. Verificar comportamento"], "resultado_esperado": "Erro: Material não disponível ou alerta de indisponibilidade"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-86", "categoria": "cotacao-ov", "nome": "Visualizar indicadores de pricing (tooltip)", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Sincronizar cotação", "2. Localizar ícone de dinheiro ($)", "3. Posicionar mouse sobre o ícone", "4. Verificar tooltip exibido"], "resultado_esperado": "Tooltip mostra: descontos aplicados, impostos calculados, margem estimada"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-87", "categoria": "cotacao-ov", "nome": "Verificar preço corresponde ao Pricing SAP", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Criar cotação SF", "2. Material X, sincronizar", "3. Anotar preço no SF", "4. Acessar VK13 no SAP", "5. Comparar valores"], "resultado_esperado": "Preço Salesforce = Preço SAP (VK13). Valores idênticos."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-88", "categoria": "cotacao-ov", "nome": "Uso da Área de Vendas na cotação", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Preencher Org Vendas", "2. Selecionar Canal (20/30/40)", "3. Selecionar Setor (55 - Prod. Acabado)", "4. Confirmar dados"], "resultado_esperado": "Cotação exibe informações da Área de Vendas corretamente"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-89", "categoria": "cotacao-ov", "nome": "Incluir múltiplos materiais via Lista de Produtos", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Clicar Lista de Produtos", "2. Selecionar Centro", "3. Selecionar Grupo de Mercadoria", "4. Clicar Buscar", "5. Selecionar 3 materiais", "6. Clicar Salvar"], "resultado_esperado": "3 materiais adicionados à tabela de produtos da cotação"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-90", "categoria": "cotacao-ov", "nome": "Incluir materiais via upload de planilha", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Clicar Template", "2. Baixar planilha Excel", "3. Preencher códigos e quantidades", "4. Clicar Carregar arquivos", "5. Fazer upload do Excel"], "resultado_esperado": "Materiais importados da planilha para a cotação"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-91", "categoria": "cotacao-ov", "nome": "Validação completa: Canal 20 + I3 + Setor 55", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente industrial canal 20", "2. Setor 55 (Produto Acabado)", "3. Material tributado normalmente", "4. Criar ordem completa", "5. Gerar XML da NF-e"], "resultado_esperado": "Código I3. ICMS + IPI + PIS + COFINS calculados. XML correto."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-92", "categoria": "cotacao-ov", "nome": "Validar ATP mostra data correta de entrega", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cotação com material", "2. Verificar data ATP exibida", "3. Comparar com regra Belgo"], "resultado_esperado": "Data ATP = D + X dias úteis (conforme regra de lead time Belgo)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-93", "categoria": "cotacao-ov", "nome": "Validar sincronização com expansão correta", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Material e cliente expandidos", "2. Criar cotação", "3. Clicar Sincronizar", "4. Verificar Integration Status"], "resultado_esperado": "Sincronização 100% sucesso. Integration Status = Completed."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-94", "categoria": "cotacao-ov", "nome": "Criar cotação completa para cliente com pré-requisitos", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Conta com: código SAP, escritório, vendedor, canais, crédito", "2. Acessar Cotação", "3. Preencher todos campos", "4. Clicar Salvar"], "resultado_esperado": "Cotação criada com sucesso. Confirmação exibida na tela."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-95", "categoria": "cotacao-ov", "nome": "Criar cotação para cliente PF (Pessoa Física)", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Conta tipo PF (com CPF)", "2. Canal 40 (Consumidores)", "3. Criar cotação", "4. Incluir materiais", "5. Sincronizar e converter OV"], "resultado_esperado": "Processo funciona para PF. Tributação adequada (C3 + DIFAL se interestadual)."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-96", "categoria": "cotacao-ov", "nome": "Sincronizar cotação e verificar precificação", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Materiais incluídos", "2. Verificar dados básicos", "3. Clicar Sincronizar", "4. Aguardar processamento", "5. Verificar campos de preço"], "resultado_esperado": "Campos preenchidos: preço unitário, impostos, descontos, totais."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-97", "categoria": "cotacao-ov", "nome": "Aplicar desconto manual e ressincronizar", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Após 1ª sincronização", "2. Preencher desconto manual (ex: 2%)", "3. Clicar Sincronizar novamente", "4. Verificar recálculo"], "resultado_esperado": "Sistema recalcula todos valores com desconto de 2% aplicado."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-98", "categoria": "cotacao-ov", "nome": "Verificar bloqueios na Ordem de Vendas", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar OV no Salesforce", "2. Aba Detalhes", "3. Seção Status", "4. Verificar bloqueios ativos"], "resultado_esperado": "Bloqueios identificados com código e descrição clara."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-99", "categoria": "cotacao-ov", "nome": "Verificar Order Tracking atualizado", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar OV no Salesforce", "2. Seção Order Tracking", "3. Verificar status atual", "4. Verificar histórico de status"], "resultado_esperado": "Order Tracking com todos status da ordem desde criação até momento atual."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-100", "categoria": "cotacao-ov", "nome": "Cancelar cotação e verificar reflexo no SAP", "sistema": "SF+SAP", "prioridade": "Media", "status": "Pendente", "passos": ["1. Cotação sincronizada no SAP", "2. Cancelar cotação no SF", "3. Verificar status no SAP", "4. Verificar se cotação foi cancelada"], "resultado_esperado": "Cotação cancelada em ambos sistemas. Status sincronizado."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-101", "categoria": "cotacao-ov", "nome": "Converter cotação em OV e validar integração", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cotação completa e validada", "2. Clicar Converter em Ordem", "3. Verificar criação da OV no SAP", "4. Verificar número da OV retornado"], "resultado_esperado": "OV criada no SAP. Número da ordem visível no Salesforce."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 6: CADASTRO (CT 102-120)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-102", "categoria": "cadastro", "nome": "Criar cliente PJ via SINTEGRA", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar módulo Contas", "2. Clicar Nova Conta", "3. Informar CNPJ", "4. Clicar Buscar SINTEGRA", "5. Validar dados preenchidos automaticamente", "6. Salvar conta"], "resultado_esperado": "Conta criada com dados do SINTEGRA: Razão Social, Endereço, IE"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-103", "categoria": "cadastro", "nome": "Validar duplicidade por Termo de Pesquisa", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Tentar criar conta com CNPJ já existente", "2. Verificar alerta de duplicidade", "3. Verificar link para conta existente"], "resultado_esperado": "Sistema bloqueia criação e mostra conta existente"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-104", "categoria": "cadastro", "nome": "Criar cliente PF com validação de CPF", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar módulo Contas", "2. Selecionar tipo PF", "3. Informar CPF válido", "4. Preencher dados obrigatórios", "5. Salvar conta"], "resultado_esperado": "Conta PF criada com CPF validado"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-105", "categoria": "cadastro", "nome": "Criar Parceiro Agrupador", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar módulo Contas", "2. Selecionar tipo Agrupador", "3. Preencher dados do grupo", "4. Associar contas filhas", "5. Salvar"], "resultado_esperado": "Parceiro Agrupador criado com hierarquia de contas"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-106", "categoria": "cadastro", "nome": "Sincronizar cliente com SAP", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente novo criado no SF", "2. Clicar Sincronizar com SAP", "3. Verificar retorno de código SAP", "4. Validar dados no SAP (XD03)"], "resultado_esperado": "Cliente criado no SAP com código retornado ao Salesforce"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-107", "categoria": "cadastro", "nome": "Atribuir escritório de vendas ao cliente", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Escritórios", "3. Adicionar escritório", "4. Selecionar vendedor responsável", "5. Salvar"], "resultado_esperado": "Escritório associado com vendedor. Cliente aparece na carteira do vendedor."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-108", "categoria": "cadastro", "nome": "Atribuir canais de venda ao cliente", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Canais", "3. Adicionar canal 20 (Indústria)", "4. Adicionar canal 30 (Revenda)", "5. Salvar"], "resultado_esperado": "Canais atribuídos. Cliente pode receber cotações nos canais selecionados."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-109", "categoria": "cadastro", "nome": "Adicionar contato ao cliente", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Contatos", "3. Clicar Novo Contato", "4. Preencher nome, email, telefone", "5. Definir função do contato", "6. Salvar"], "resultado_esperado": "Contato criado e vinculado à conta"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-110", "categoria": "cadastro", "nome": "Verificar integração do endereço de entrega", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Endereços", "3. Adicionar endereço de entrega", "4. Sincronizar com SAP", "5. Verificar no SAP (XD03)"], "resultado_esperado": "Endereço de entrega criado no SAP (Parceiro SH)"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-111", "categoria": "cadastro", "nome": "Alterar dados cadastrais e sincronizar", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta existente", "2. Alterar campo (ex: telefone)", "3. Salvar", "4. Sincronizar com SAP", "5. Verificar alteração no SAP"], "resultado_esperado": "Alteração refletida em ambos sistemas"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-112", "categoria": "cadastro", "nome": "Bloquear cliente no Salesforce", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar conta", "2. Clicar Bloquear", "3. Informar motivo", "4. Salvar"], "resultado_esperado": "Cliente bloqueado. Não permite criar cotações."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-113", "categoria": "cadastro", "nome": "Verificar dados de concorrentes", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Concorrentes", "3. Adicionar concorrente", "4. Informar participação estimada", "5. Salvar"], "resultado_esperado": "Concorrente registrado com share of wallet estimado"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-114", "categoria": "cadastro", "nome": "Consultar limite de crédito no Salesforce", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Crédito", "3. Verificar limite disponível", "4. Verificar utilizado", "5. Verificar partidas em aberto"], "resultado_esperado": "Dados de crédito visíveis: limite, utilizado, disponível, partidas"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-115", "categoria": "cadastro", "nome": "Solicitar aumento de limite de crédito", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Crédito", "3. Clicar Solicitar Aumento", "4. Informar valor desejado", "5. Anexar documentos", "6. Enviar"], "resultado_esperado": "Solicitação enviada para aprovação do financeiro"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-116", "categoria": "cadastro", "nome": "Verificar histórico de alterações do cliente", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Histórico", "3. Verificar alterações registradas"], "resultado_esperado": "Histórico completo com usuário, data e campos alterados"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-117", "categoria": "cadastro", "nome": "Classificar cliente por cluster", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Cluster", "3. Verificar cluster atribuído automaticamente", "4. Solicitar exceção se necessário"], "resultado_esperado": "Cluster calculado: A, B, C ou D baseado em critérios definidos"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-118", "categoria": "cadastro", "nome": "Criar cliente com dados incompletos", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar módulo Contas", "2. Clicar Nova Conta", "3. Preencher apenas campos obrigatórios mínimos", "4. Tentar salvar"], "resultado_esperado": "Sistema valida e exige campos obrigatórios faltantes"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-119", "categoria": "cadastro", "nome": "Exportar dados cadastrais para Excel", "sistema": "Salesforce", "prioridade": "Baixa", "status": "Pendente", "passos": ["1. Acessar lista de contas", "2. Aplicar filtros", "3. Clicar Exportar", "4. Selecionar formato Excel", "5. Download"], "resultado_esperado": "Arquivo Excel com dados das contas filtradas"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-120", "categoria": "cadastro", "nome": "Verificar integração Dow Jones (Compliance)", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Criar novo cliente", "2. Verificar validação Dow Jones", "3. Verificar status de compliance"], "resultado_esperado": "Cliente validado contra base Dow Jones. Status de compliance atualizado."}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 7: DOCUMENTOS FISCAIS (CT 121-135)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-121", "categoria": "documentos", "nome": "Download XML da NF-e", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar OV faturada", "2. Seção Documentos", "3. Localizar XML", "4. Clicar Download"], "resultado_esperado": "Arquivo XML baixado com sucesso"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-122", "categoria": "documentos", "nome": "Download DANFE", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar OV faturada", "2. Seção Documentos", "3. Localizar DANFE", "4. Clicar Download"], "resultado_esperado": "Arquivo PDF do DANFE baixado com sucesso"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-123", "categoria": "documentos", "nome": "Download Certificado de Qualidade", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar OV faturada", "2. Seção Documentos", "3. Localizar Certificado", "4. Clicar Download"], "resultado_esperado": "Certificado de qualidade baixado com sucesso"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-124", "categoria": "documentos", "nome": "Verificar trigger automático após faturamento", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Faturar OV no SAP", "2. Aguardar processamento", "3. Verificar disponibilidade no Salesforce"], "resultado_esperado": "Documentos disponíveis automaticamente após faturamento"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-125", "categoria": "documentos", "nome": "Reenviar documentos por email", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar OV faturada", "2. Seção Documentos", "3. Selecionar documentos", "4. Clicar Enviar por Email", "5. Informar destinatário"], "resultado_esperado": "Email enviado com documentos anexados"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-126", "categoria": "documentos", "nome": "Consultar histórico de documentos", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Documentos", "3. Filtrar por período", "4. Visualizar lista"], "resultado_esperado": "Lista de todos documentos do período selecionado"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-127", "categoria": "documentos", "nome": "Validar integração com sistema Araujo", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Faturar OV", "2. Verificar trigger SAP -> Araujo", "3. Verificar retorno Araujo -> SF"], "resultado_esperado": "Documentos gerados pelo Araujo disponíveis no Salesforce"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-128", "categoria": "documentos", "nome": "Consultar boletos em aberto", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Financeiro", "3. Aba Boletos", "4. Filtrar em aberto"], "resultado_esperado": "Lista de boletos em aberto com valores e vencimentos"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-129", "categoria": "documentos", "nome": "Download de boleto", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Financeiro", "3. Localizar boleto", "4. Clicar Download"], "resultado_esperado": "Arquivo PDF do boleto baixado"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-130", "categoria": "documentos", "nome": "Verificar carta de correção", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. NF com carta de correção emitida", "2. Acessar OV no Salesforce", "3. Seção Documentos", "4. Localizar carta de correção"], "resultado_esperado": "Carta de correção disponível para download"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-131", "categoria": "documentos", "nome": "Verificar NF de devolução", "sistema": "SF+SAP", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Processar devolução no SAP", "2. Verificar NF de devolução gerada", "3. Verificar documentos no Salesforce"], "resultado_esperado": "NF de devolução disponível com todos documentos"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-132", "categoria": "documentos", "nome": "Consultar partidas financeiras do cliente", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar conta", "2. Seção Crédito", "3. Aba Partidas", "4. Verificar lista de títulos"], "resultado_esperado": "Lista de partidas: número, valor, vencimento, status"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-133", "categoria": "documentos", "nome": "Verificar rastreamento de entrega", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar OV despachada", "2. Seção Logística", "3. Verificar código de rastreamento", "4. Verificar status de entrega"], "resultado_esperado": "Código de rastreamento disponível com status atualizado"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-134", "categoria": "documentos", "nome": "Download de múltiplos documentos", "sistema": "Salesforce", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar OV", "2. Seção Documentos", "3. Selecionar múltiplos documentos", "4. Clicar Download"], "resultado_esperado": "Arquivo ZIP com todos documentos selecionados"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-135", "categoria": "documentos", "nome": "Verificar integração Portal Logístico", "sistema": "Salesforce", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Verificar dados de restrição de entrega", "2. Verificar agendamento", "3. Comparar com Portal Logístico"], "resultado_esperado": "Dados de logística sincronizados entre sistemas"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 8: AUTOATENDIMENTO / BOT (CT 136-145)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-136", "categoria": "autoatendimento", "nome": "Autenticação via CNPJ no Bot WhatsApp", "sistema": "Bot Einstein", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Bot WhatsApp", "2. Enviar CNPJ", "3. Confirmar código de verificação", "4. Verificar acesso liberado"], "resultado_esperado": "Cliente autenticado e com acesso às funcionalidades"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-137", "categoria": "autoatendimento", "nome": "Consulta status de pedido via Bot", "sistema": "Bot Einstein", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente autenticado", "2. Solicitar status de pedido", "3. Informar número do pedido", "4. Verificar resposta"], "resultado_esperado": "Bot retorna status atualizado do pedido"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-138", "categoria": "autoatendimento", "nome": "Transbordo para Smart Center", "sistema": "Bot Einstein", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente solicita atendimento humano", "2. Verificar transbordo para Smart Center", "3. Verificar registro do caso"], "resultado_esperado": "Caso criado e transferido para atendente humano"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-139", "categoria": "autoatendimento", "nome": "Download de documentos via portal", "sistema": "Portal", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar portal autoatendimento", "2. Fazer login", "3. Navegar para documentos", "4. Baixar NF/DANFE"], "resultado_esperado": "Documentos baixados com sucesso"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-140", "categoria": "autoatendimento", "nome": "Consultar boletos via Bot", "sistema": "Bot Einstein", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Cliente autenticado", "2. Solicitar 2a via de boleto", "3. Verificar resposta com link"], "resultado_esperado": "Bot retorna link para download do boleto"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-141", "categoria": "autoatendimento", "nome": "Registrar reclamação via Bot", "sistema": "Bot Einstein", "prioridade": "Media", "status": "Pendente", "passos": ["1. Cliente autenticado", "2. Selecionar opção Reclamação", "3. Descrever problema", "4. Confirmar registro"], "resultado_esperado": "Caso de reclamação criado no Salesforce"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-142", "categoria": "autoatendimento", "nome": "Consultar histórico de pedidos via portal", "sistema": "Portal", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar portal", "2. Fazer login", "3. Navegar para Pedidos", "4. Filtrar por período"], "resultado_esperado": "Lista de pedidos com status e valores"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-143", "categoria": "autoatendimento", "nome": "Verificar horário de atendimento do Bot", "sistema": "Bot Einstein", "prioridade": "Baixa", "status": "Pendente", "passos": ["1. Acessar Bot fora do horário", "2. Verificar mensagem exibida"], "resultado_esperado": "Bot informa horário de atendimento e opções disponíveis"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-144", "categoria": "autoatendimento", "nome": "Testar FAQ do Bot", "sistema": "Bot Einstein", "prioridade": "Media", "status": "Pendente", "passos": ["1. Perguntar sobre prazo de entrega", "2. Perguntar sobre formas de pagamento", "3. Verificar respostas automáticas"], "resultado_esperado": "Bot responde perguntas frequentes corretamente"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-145", "categoria": "autoatendimento", "nome": "Verificar integração Bot com Salesforce", "sistema": "Bot Einstein", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Registrar atendimento via Bot", "2. Verificar registro no Salesforce", "3. Verificar histórico da conversa"], "resultado_esperado": "Atendimento registrado com histórico completo da conversa"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 9: HUB DE GESTÃO OC (CT 146-152)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-146", "categoria": "hub-gestao-oc", "nome": "Visualizar grupos no Hub", "sistema": "Salesforce (LWC)", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Hub de Gestão OC", "2. Verificar lista de grupos", "3. Selecionar um grupo", "4. Verificar membros"], "resultado_esperado": "Lista de grupos exibida com membros"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-147", "categoria": "hub-gestao-oc", "nome": "Adicionar membro a grupo", "sistema": "Salesforce (LWC)", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Hub", "2. Selecionar grupo", "3. Clicar Adicionar Membro", "4. Buscar por email/nome", "5. Confirmar"], "resultado_esperado": "Membro adicionado ao grupo"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-148", "categoria": "hub-gestao-oc", "nome": "Remover membro de grupo", "sistema": "Salesforce (LWC)", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Hub", "2. Selecionar grupo", "3. Localizar membro", "4. Clicar Remover", "5. Confirmar"], "resultado_esperado": "Membro removido do grupo"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-149", "categoria": "hub-gestao-oc", "nome": "Buscar por email/nome", "sistema": "Salesforce (LWC)", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar Hub", "2. Campo de busca", "3. Digitar email ou nome", "4. Verificar resultados"], "resultado_esperado": "Resultados filtrados por termo de busca"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-150", "categoria": "hub-gestao-oc", "nome": "Verificar logs de alterações", "sistema": "Salesforce (LWC)", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar Hub", "2. Selecionar grupo", "3. Aba Histórico", "4. Verificar log de alterações"], "resultado_esperado": "Histórico com data, usuário e tipo de alteração"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-151", "categoria": "hub-gestao-oc", "nome": "Criar novo grupo", "sistema": "Salesforce (LWC)", "prioridade": "Alta", "status": "Pendente", "passos": ["1. Acessar Hub", "2. Clicar Novo Grupo", "3. Informar nome", "4. Adicionar membros iniciais", "5. Salvar"], "resultado_esperado": "Grupo criado com membros"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id": "CT-152", "categoria": "hub-gestao-oc", "nome": "Excluir grupo", "sistema": "Salesforce (LWC)", "prioridade": "Media", "status": "Pendente", "passos": ["1. Acessar Hub", "2. Selecionar grupo", "3. Clicar Excluir", "4. Confirmar exclusão"], "resultado_esperado": "Grupo excluído com sucesso"}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;

-- ===========================================
-- RESUMO GERAL DOS TESTES
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{
    "tipo": "resumo_geral",
    "titulo": "Resumo do Caderno de Testes GTM",
    "total_categorias": 9,
    "total_casos": 152,
    "status_geral": "Em Elaboração",
    "go_live": "15/03/2026",
    "categorias_resumo": [
        {"nome": "Workflow Pricing", "range": "CT 01-19", "casos": 19, "status": "Definido"},
        {"nome": "Tributário", "range": "CT 20-55", "casos": 36, "status": "Definido"},
        {"nome": "Setup e Configuração", "range": "CT 56-77", "casos": 22, "status": "Definido"},
        {"nome": "Financeiro e Crédito", "range": "CT 78-80", "casos": 3, "status": "Definido"},
        {"nome": "Cotação e Ordem de Vendas", "range": "CT 81-101", "casos": 21, "status": "Definido"},
        {"nome": "Cadastro", "range": "CT 102-120", "casos": 19, "status": "Definido"},
        {"nome": "Documentos Fiscais", "range": "CT 121-135", "casos": 15, "status": "Definido"},
        {"nome": "Autoatendimento/Bot", "range": "CT 136-145", "casos": 10, "status": "Definido"},
        {"nome": "Hub de Gestão OC", "range": "CT 146-152", "casos": 7, "status": "Definido"}
    ]
}'
FROM projeto_entidades WHERE codigo = 'testes' AND projeto_id = 5;
