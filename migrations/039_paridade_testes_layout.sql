-- =====================================================
-- Migration 039: Paridade Layout Testes GTM Clone
-- Configurar layout de tabela igual ao GTM Original
-- =====================================================

-- ===========================================
-- TESTES: Layout Tabela com 5 Colunas
-- Similar ao pages/testes.html do GTM Original
-- Colunas: ID, Caso de Teste, Categoria, Status, Acoes
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
    "layout": "tabela",
    "tabela": {
        "colunas": [
            {
                "campo": "codigo",
                "label": "ID",
                "largura": "80px",
                "negrito": true
            },
            {
                "campo": "nome",
                "label": "Caso de Teste",
                "largura": "auto"
            },
            {
                "campo": "categoria",
                "label": "Categoria",
                "largura": "150px",
                "estilo": "secundario"
            },
            {
                "campo": "status",
                "label": "Status",
                "largura": "100px",
                "tipo": "badge"
            }
        ],
        "acoes": ["ver", "marcar_concluido", "teams"]
    },
    "filtros": {
        "habilitado": true,
        "campos": [
            {
                "campo": "categoria",
                "label": "Categoria",
                "tipo": "select"
            },
            {
                "campo": "status",
                "label": "Status",
                "tipo": "select",
                "opcoes": ["Pendente", "Concluido", "Falhou"]
            },
            {
                "campo": "busca",
                "label": "Buscar",
                "tipo": "texto",
                "placeholder": "CT-XX ou nome..."
            }
        ]
    },
    "metricas": {
        "habilitado": true,
        "cards": [
            {"label": "Total", "tipo": "total", "icone": "📊", "cor": "blue"},
            {"label": "Concluidos", "tipo": "contagem", "campo": "status", "valor": "Concluido", "icone": "✅", "cor": "green"},
            {"label": "Pendentes", "tipo": "contagem", "campo": "status", "valor": "Pendente", "icone": "⏳", "cor": "yellow"},
            {"label": "Falharam", "tipo": "contagem", "campo": "status", "valor": "Falhou", "icone": "❌", "cor": "red"}
        ]
    },
    "modal_detalhe": {
        "habilitado": true,
        "titulo_campo": "nome",
        "titulo_prefixo": "codigo",
        "secoes": [
            {
                "tipo": "badges",
                "campos": ["status", "categoria", "prioridade"]
            },
            {
                "tipo": "lista_numerada",
                "titulo": "Passo a Passo",
                "campo": "passos",
                "delimitador": "|"
            },
            {
                "tipo": "bloco",
                "titulo": "Resultado Esperado",
                "campo": "resultado_esperado",
                "estilo": "destaque"
            },
            {
                "tipo": "bloco",
                "titulo": "Resultado Obtido",
                "campo": "resultado_obtido",
                "estilo_condicional": {
                    "campo": "status",
                    "valores": {
                        "Falhou": "erro",
                        "Concluido": "sucesso"
                    }
                },
                "ocultar_vazio": true
            },
            {
                "tipo": "bloco",
                "titulo": "Observacoes",
                "campo": "observacoes",
                "estilo": "aviso",
                "ocultar_vazio": true
            }
        ],
        "acoes_rodape": ["marcar_concluido", "marcar_falhou", "marcar_pendente", "teams"]
    },
    "paginacao": {
        "habilitado": true,
        "itens_por_pagina": 20
    },
    "exportacao": {
        "habilitado": true,
        "campos": ["codigo", "nome", "categoria", "status", "sistema", "prioridade"]
    }
}'
WHERE projeto_id = 5 AND codigo = 'testes';

-- ===========================================
-- Atualizar campos da entidade com visivel_listagem
-- Para garantir que apenas os campos corretos aparecem
-- ===========================================

-- Atualizar campo codigo para ser visivel e primeiro na listagem
UPDATE projeto_entidade_campos
SET visivel_listagem = 1, ordem = 1, largura_coluna = '80px'
WHERE entidade_id = (SELECT id FROM projeto_entidades WHERE projeto_id = 5 AND codigo = 'testes')
AND codigo = 'codigo';

-- Atualizar campo nome para ser visivel
UPDATE projeto_entidade_campos
SET visivel_listagem = 1, ordem = 2
WHERE entidade_id = (SELECT id FROM projeto_entidades WHERE projeto_id = 5 AND codigo = 'testes')
AND codigo = 'nome';

-- Atualizar campo categoria para ser visivel
UPDATE projeto_entidade_campos
SET visivel_listagem = 1, ordem = 3, largura_coluna = '150px'
WHERE entidade_id = (SELECT id FROM projeto_entidades WHERE projeto_id = 5 AND codigo = 'testes')
AND codigo = 'categoria';

-- Atualizar campo status para ser visivel
UPDATE projeto_entidade_campos
SET visivel_listagem = 1, ordem = 4, largura_coluna = '100px'
WHERE entidade_id = (SELECT id FROM projeto_entidades WHERE projeto_id = 5 AND codigo = 'testes')
AND codigo = 'status';

-- Ocultar campos que nao devem aparecer na listagem
UPDATE projeto_entidade_campos
SET visivel_listagem = 0
WHERE entidade_id = (SELECT id FROM projeto_entidades WHERE projeto_id = 5 AND codigo = 'testes')
AND codigo IN ('sistema', 'prioridade', 'passos', 'resultado_esperado', 'resultado_obtido', 'data_execucao', 'executor', 'observacoes');

-- ===========================================
-- Verificar resultado
-- ===========================================
SELECT id, codigo, nome, config_funcionalidades
FROM projeto_entidades
WHERE projeto_id = 5 AND codigo = 'testes';
