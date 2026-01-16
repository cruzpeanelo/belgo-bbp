-- =====================================================
-- Migration 031: Correção Completa do GTM Clone
-- Projeto 5 - Fixes para menus, entidades e dados
-- =====================================================

-- ===========================================
-- PARTE 1: GARANTIR ENTIDADE CRONOGRAMA
-- ===========================================

-- Primeiro, verificar se existe e deletar para recriar limpo
DELETE FROM projeto_entidades
WHERE projeto_id = 5 AND codigo = 'cronograma';

-- Criar entidade cronograma
INSERT INTO projeto_entidades (
    projeto_id,
    codigo,
    nome,
    descricao,
    icone,
    permite_criar,
    permite_editar,
    permite_excluir,
    permite_exportar,
    config_funcionalidades
)
VALUES (
    5,
    'cronograma',
    'Cronograma',
    'Cronograma do projeto GTM - Workshops, marcos e atividades',
    '📅',
    1,
    1,
    1,
    1,
    '{
        "layout": "cards_agrupados",
        "agrupamento": {
            "habilitado": true,
            "campo": "tipo",
            "ordem": ["resumo", "marco", "workshop", "atividade"]
        },
        "card": {
            "campo_titulo": "titulo",
            "campo_badge": "status",
            "campos_info": [
                {"campo": "data", "label": "Data", "icone": "📅", "tipo": "date"},
                {"campo": "fase", "label": "Fase", "icone": "📍"},
                {"campo": "responsavel", "label": "Responsável", "icone": "👤"}
            ]
        },
        "filtros": {
            "habilitado": true,
            "campos": [
                {"campo": "tipo", "label": "Tipo", "tipo": "select"},
                {"campo": "status", "label": "Status", "tipo": "select"},
                {"campo": "fase", "label": "Fase", "tipo": "select"}
            ]
        },
        "metricas": {
            "habilitado": true,
            "cards": [
                {"label": "Total Itens", "tipo": "total", "icone": "📋", "cor": "blue"},
                {"label": "Concluídos", "tipo": "contagem", "campo": "status", "valor": "Concluído", "icone": "✅", "cor": "green"},
                {"label": "Pendentes", "tipo": "contagem", "campo": "status", "valor": "Pendente", "icone": "⏳", "cor": "yellow"},
                {"label": "Workshops", "tipo": "contagem", "campo": "tipo", "valor": "workshop", "icone": "👥", "cor": "purple"}
            ]
        },
        "modal_detalhe": {
            "habilitado": true,
            "titulo_campo": "titulo",
            "campos": ["tipo", "data", "titulo", "status", "fase", "responsavel", "descricao", "foco", "destaques", "participantes"]
        },
        "paginacao": {
            "habilitado": false
        }
    }'
);

-- ===========================================
-- PARTE 2: GARANTIR ENTIDADE DOCUMENTOS
-- ===========================================

-- Verificar se documentos existe, se não criar
INSERT OR IGNORE INTO projeto_entidades (
    projeto_id,
    codigo,
    nome,
    descricao,
    icone,
    permite_criar,
    permite_editar,
    permite_excluir,
    permite_exportar,
    config_funcionalidades
)
VALUES (
    5,
    'documentos',
    'Documentos',
    'Documentos do projeto GTM',
    '📄',
    1,
    1,
    1,
    1,
    '{
        "layout": "documentos_rico",
        "card": {
            "campo_titulo": "nome",
            "campo_id": "codigo",
            "campo_categoria": "categoria",
            "campo_descricao": "descricao",
            "campo_tamanho": "tamanho",
            "campo_tabelas": "tabelas"
        },
        "filtros": {
            "habilitado": true,
            "campos": [
                {"campo": "categoria", "label": "Categoria", "tipo": "select"},
                {"campo": "busca", "label": "Buscar", "tipo": "texto", "placeholder": "Buscar documento..."}
            ]
        },
        "modal_detalhe": {
            "habilitado": true,
            "titulo_campo": "nome",
            "campos": ["codigo", "nome", "categoria", "descricao", "tamanho", "tabelas", "url"]
        },
        "paginacao": {
            "habilitado": true,
            "itens_por_pagina": 20
        }
    }'
);

-- ===========================================
-- PARTE 3: CORRIGIR MENUS - URLs DINÂMICAS
-- ===========================================

-- Atualizar Cronograma para página dinâmica
UPDATE projeto_menus
SET
    url = '/pages/entidade.html?e=cronograma',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5 LIMIT 1)
WHERE projeto_id = 5
AND (nome LIKE '%Cronograma%' OR nome LIKE '%cronograma%');

-- Atualizar Documentos para página dinâmica
UPDATE projeto_menus
SET
    url = '/pages/entidade.html?e=documentos',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'documentos' AND projeto_id = 5 LIMIT 1)
WHERE projeto_id = 5
AND (nome LIKE '%Documentos%' OR nome LIKE '%documentos%');

-- ===========================================
-- PARTE 4: IMPORTAR DADOS DO CRONOGRAMA
-- ===========================================

-- Limpar dados antigos do cronograma (se houver)
DELETE FROM projeto_dados
WHERE projeto_id = 5
AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5);

-- Workshop 1: Kickoff
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "workshop", "id": "W1", "data": "2025-12-03", "titulo": "W1 - Kickoff e Alinhamento", "status": "Concluído", "fase": "Fase II", "responsavel": "Leandro Cruz", "descricao": "Workshop de kickoff do projeto GTM", "foco": "Alinhamento inicial e apresentação do projeto", "destaques": "Definição de escopo e cronograma", "participantes": "15 participantes"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Workshop 2: Cadastro
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "workshop", "id": "W2", "data": "2025-12-09", "titulo": "W2 - Cadastro, Áreas de Vendas e Concorrentes", "status": "Concluído", "fase": "Fase II", "responsavel": "Leandro Cruz", "descricao": "Workshop sobre cadastro de clientes e áreas", "foco": "SINTEGRA, tipos de conta, áreas de vendas", "destaques": "Cadastro de cliente, Canais 20/30/40, Concorrentes", "participantes": "12 participantes"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Workshop 3: Documentos Fiscais
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "workshop", "id": "W3", "data": "2025-12-15", "titulo": "W3 - Documentos Fiscais e Autoatendimento", "status": "Concluído", "fase": "Fase II", "responsavel": "Leandro Cruz", "descricao": "Workshop sobre documentos fiscais e portal", "foco": "NF-e, XML, Portal Autoatendimento", "destaques": "Download documentos fiscais, Portal cliente", "participantes": "10 participantes"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Workshop 4: Pricing
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "workshop", "id": "W4", "data": "2025-12-16", "titulo": "W4 - Workflow Pricing", "status": "Concluído", "fase": "Fase II", "responsavel": "Rodrigo", "descricao": "Workshop sobre workflow de pricing", "foco": "Fluxo de aprovação e níveis de desconto", "destaques": "YDCF, Aprovação 2 níveis, Hierarquia de materiais", "participantes": "Rodrigo, Leandro, Thalita"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Workshop 5: Revisão Final
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "workshop", "id": "W5", "data": "2025-12-21", "titulo": "W5 - Revisão GTM e Ajustes Finais", "status": "Concluído", "fase": "Fase II", "responsavel": "Leandro Cruz", "descricao": "Workshop de revisão final e ajustes", "foco": "Nova estrutura organizacional, 4 macro setores", "destaques": "Hard reboot, Escritórios de vendas", "participantes": "Leandro, Thalita, Gimenes, Ciorlia, Riqueti"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Marco 1: Kickoff Projeto
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "marco", "id": "M1", "data": "2025-01-14", "titulo": "Kickoff Projeto", "status": "Concluído", "fase": "Fase I", "responsavel": "Equipe GTM", "descricao": "Início oficial do projeto GTM Vendas"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Marco 2: GO Live Fase I
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "marco", "id": "M2", "data": "2025-08-31", "titulo": "GO Live Fase I", "status": "Concluído", "fase": "Fase I", "responsavel": "Equipe GTM", "descricao": "Entrada em produção da primeira fase"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Marco 3: Fim Workshops
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "marco", "id": "M3", "data": "2025-12-21", "titulo": "Fim Workshops AS IS/TO BE", "status": "Concluído", "fase": "Fase II", "responsavel": "Equipe GTM", "descricao": "Conclusão de todos os workshops de levantamento"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Marco 4: BBP Completo
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "marco", "id": "M4", "data": "2026-01-12", "titulo": "Estruturação BBP Completo", "status": "Concluído", "fase": "Fase II", "responsavel": "Leandro Cruz", "descricao": "Documentação BBP finalizada com 69 documentos e 14 jornadas"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Marco 5: UAT
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "marco", "id": "M5", "data": "2026-01-19", "titulo": "UAT - Testes de Aceitação", "status": "Pendente", "fase": "Fase II", "responsavel": "Key Users", "descricao": "Início dos testes de aceitação pelos usuários"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Marco 6: GO Live Fase II
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"tipo": "marco", "id": "M6", "data": "2026-03-14", "titulo": "GO Live Fase II", "status": "Pendente", "fase": "Fase II", "responsavel": "Equipe GTM", "descricao": "Entrada em produção da segunda fase do projeto"}'
FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5;

-- ===========================================
-- PARTE 5: VERIFICAR CONFIG_FUNCIONALIDADES TESTES
-- ===========================================

-- Atualizar config de testes para garantir que está correto
UPDATE projeto_entidades
SET config_funcionalidades = '{
    "layout": "tabela",
    "filtros": {
        "habilitado": true,
        "campos": [
            {"campo": "categoria", "label": "Categoria", "tipo": "select", "mostrar_icone": true},
            {"campo": "status", "label": "Status", "tipo": "select"},
            {"campo": "sistema", "label": "Sistema", "tipo": "select"},
            {"campo": "prioridade", "label": "Prioridade", "tipo": "select"},
            {"campo": "busca", "label": "Buscar", "tipo": "texto", "placeholder": "CT-XX ou nome..."}
        ]
    },
    "metricas": {
        "habilitado": true,
        "cards": [
            {"label": "Total", "tipo": "total", "icone": "📊", "cor": "blue"},
            {"label": "Concluídos", "tipo": "contagem", "campo": "status", "valor": "Aprovado", "icone": "✅", "cor": "green"},
            {"label": "Pendentes", "tipo": "contagem", "campo": "status", "valor": "Pendente", "icone": "⏳", "cor": "yellow"},
            {"label": "Falharam", "tipo": "contagem", "campo": "status", "valor": "Falhou", "icone": "❌", "cor": "red"}
        ]
    },
    "tabela": {
        "colunas": ["codigo", "nome", "categoria", "status", "sistema", "prioridade", "passos", "resultado_esperado", "resultado_obtido", "executor", "observacoes"]
    },
    "modal_detalhe": {
        "habilitado": true,
        "titulo_campo": "nome",
        "campos": ["codigo", "nome", "categoria", "sistema", "prioridade", "status", "passos", "resultado_esperado", "resultado_obtido", "executor", "observacoes"]
    },
    "paginacao": {
        "habilitado": true,
        "itens_por_pagina": 20
    }
}'
WHERE projeto_id = 5 AND codigo = 'testes';
