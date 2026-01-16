-- =====================================================
-- Migration 024: Importar categorias de Testes
-- Projeto 5 (GTM Clone) - Entidade ID 22 (testes)
-- Resumo das categorias de teste (casos detalhados em JSON)
-- =====================================================

-- Limpar dados existentes de testes do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 22 AND projeto_id = 5;

-- ===========================================
-- CATEGORIA 1: Workflow Pricing (CT 01-19)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "workflow-pricing",
    "nome": "Workflow Pricing",
    "range": "CT 01-19",
    "total_casos": 19,
    "cor": "#6366f1",
    "descricao": "Testes de criação, aprovação e integração de Workflow de Pricing no Salesforce",
    "sistema_principal": "Salesforce",
    "exemplos_casos": [
        "CT-01: Criar WF Pricing para desconto fixo em material específico",
        "CT-02: Alterar vigência individual por linha de material",
        "CT-03: Tentar criar WF sem canal atribuído ao cliente",
        "CT-10: Aprovar WF Nível 1 (Time Pricing)",
        "CT-12: Aprovar WF Nível 2 (Gerente)"
    ]
}');

-- ===========================================
-- CATEGORIA 2: Tributário (CT 20-26)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "tributario",
    "nome": "Tributário",
    "range": "CT 20-26",
    "total_casos": 7,
    "cor": "#f59e0b",
    "descricao": "Testes de configurações fiscais e tributárias",
    "sistema_principal": "SAP/Salesforce",
    "exemplos_casos": [
        "CT-20: Validar configuração de impostos por estado",
        "CT-21: Verificar cálculo de ICMS",
        "CT-22: Testar substituição tributária"
    ]
}');

-- ===========================================
-- CATEGORIA 3: Cadastro de Cliente (CT 27-45)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "cadastro-cliente",
    "nome": "Cadastro de Cliente",
    "range": "CT 27-45",
    "total_casos": 19,
    "cor": "#10b981",
    "descricao": "Testes de cadastro via SINTEGRA, validação de duplicidade e integração SAP",
    "sistema_principal": "Salesforce",
    "exemplos_casos": [
        "CT-27: Criar cliente PJ com integração SINTEGRA",
        "CT-28: Validar duplicidade por Termo de Pesquisa",
        "CT-29: Criar cliente PF com validação de CPF",
        "CT-30: Criar Parceiro Agrupador",
        "CT-35: Sincronizar cliente com SAP"
    ]
}');

-- ===========================================
-- CATEGORIA 4: Áreas de Crédito (CT 46-60)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "areas-credito",
    "nome": "Áreas de Crédito",
    "range": "CT 46-60",
    "total_casos": 15,
    "cor": "#8b5cf6",
    "descricao": "Testes das 4 áreas de crédito (BBA, CSP, DBA, ALPE) e integração ASCP",
    "sistema_principal": "Salesforce/ASCP",
    "exemplos_casos": [
        "CT-46: Consultar limite de crédito BBA",
        "CT-47: Verificar partidas em aberto",
        "CT-50: Testar bloqueio por limite excedido",
        "CT-55: Validar área de crédito DBA para distribuidores"
    ]
}');

-- ===========================================
-- CATEGORIA 5: Documentos Fiscais (CT 61-75)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "documentos-fiscais",
    "nome": "Documentos Fiscais",
    "range": "CT 61-75",
    "total_casos": 15,
    "cor": "#ec4899",
    "descricao": "Testes de download de XML, DANFE, certificados e integração Araujo",
    "sistema_principal": "Salesforce/Araujo",
    "exemplos_casos": [
        "CT-61: Download XML da NF-e",
        "CT-62: Download DANFE",
        "CT-63: Download Certificado de Qualidade",
        "CT-70: Verificar trigger automático após faturamento"
    ]
}');

-- ===========================================
-- CATEGORIA 6: Autoatendimento/Bot (CT 76-90)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "autoatendimento",
    "nome": "Autoatendimento e Bot Einstein",
    "range": "CT 76-90",
    "total_casos": 15,
    "cor": "#14b8a6",
    "descricao": "Testes do portal self-service e Bot WhatsApp Einstein",
    "sistema_principal": "Salesforce Service Cloud",
    "exemplos_casos": [
        "CT-76: Autenticação via CNPJ no Bot WhatsApp",
        "CT-77: Consulta status de pedido via Bot",
        "CT-80: Transbordo para Smart Center",
        "CT-85: Download de documentos via portal"
    ]
}');

-- ===========================================
-- CATEGORIA 7: Hub de Gestão OC (CT 91-105)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "hub-gestao-oc",
    "nome": "Hub de Gestão OC",
    "range": "CT 91-105",
    "total_casos": 15,
    "cor": "#f97316",
    "descricao": "Testes do Hub de gerenciamento de Ordens de Compra via LWC",
    "sistema_principal": "Salesforce (LWC)",
    "exemplos_casos": [
        "CT-91: Visualizar grupos no Hub",
        "CT-92: Adicionar membro a grupo",
        "CT-95: Buscar por email/nome",
        "CT-100: Verificar logs de alterações"
    ]
}');

-- ===========================================
-- CATEGORIA 8: Cotação e Pedidos (CT 106-120)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "cotacao-pedidos",
    "nome": "Cotação e Ordem de Vendas",
    "range": "CT 106-120",
    "total_casos": 15,
    "cor": "#3b82f6",
    "descricao": "Testes de criação de cotação, ATP e conversão para OV",
    "sistema_principal": "Salesforce/SAP",
    "exemplos_casos": [
        "CT-106: Criar cotação com preços do SAP",
        "CT-107: Verificar ATP (disponibilidade)",
        "CT-110: Aplicar desconto YDCF automático",
        "CT-115: Converter cotação para OV"
    ]
}');

-- ===========================================
-- CATEGORIA 9: Clusterização (CT 121-135)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "clusterizacao",
    "nome": "Clusterização de Clientes",
    "range": "CT 121-135",
    "total_casos": 15,
    "cor": "#a855f7",
    "descricao": "Testes de cálculo automático de cluster e workflow de exceção",
    "sistema_principal": "Salesforce",
    "exemplos_casos": [
        "CT-121: Verificar cluster automático para novo cliente",
        "CT-125: Solicitar exceção de cluster",
        "CT-126: Aprovar exceção de cluster",
        "CT-130: Verificar integração com relatórios"
    ]
}');

-- ===========================================
-- CATEGORIA 10: Integrações SAP (CT 136-150)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "categoria": "integracoes-sap",
    "nome": "Integrações SAP",
    "range": "CT 136-150",
    "total_casos": 15,
    "cor": "#ef4444",
    "descricao": "Testes de integração Salesforce-SAP via middleware",
    "sistema_principal": "Middleware/SAP",
    "exemplos_casos": [
        "CT-136: Sincronização de cliente criado",
        "CT-140: Retorno de código SAP",
        "CT-145: Verificar condition YDCF no SAP",
        "CT-150: Testar rollback em caso de erro"
    ]
}');

-- ===========================================
-- Resumo Geral
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 22, '{
    "tipo": "resumo_geral",
    "titulo": "Resumo do Caderno de Testes GTM",
    "total_categorias": 10,
    "total_casos": 150,
    "status_geral": "Em Elaboração",
    "go_live": "15/03/2026",
    "observacao": "Casos de teste detalhados disponíveis em data/testes.json",
    "categorias_resumo": [
        {"nome": "Workflow Pricing", "casos": 19, "status": "Definido"},
        {"nome": "Tributário", "casos": 7, "status": "Definido"},
        {"nome": "Cadastro de Cliente", "casos": 19, "status": "Definido"},
        {"nome": "Áreas de Crédito", "casos": 15, "status": "Definido"},
        {"nome": "Documentos Fiscais", "casos": 15, "status": "Definido"},
        {"nome": "Autoatendimento/Bot", "casos": 15, "status": "Em Elaboração"},
        {"nome": "Hub de Gestão OC", "casos": 15, "status": "Definido"},
        {"nome": "Cotação e Pedidos", "casos": 15, "status": "Definido"},
        {"nome": "Clusterização", "casos": 15, "status": "Definido"},
        {"nome": "Integrações SAP", "casos": 15, "status": "Definido"}
    ]
}');
