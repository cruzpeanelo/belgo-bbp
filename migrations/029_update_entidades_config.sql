-- =====================================================
-- Migration 029: Atualizar Config das Entidades
-- Projeto 5 (GTM Clone) - Aplicar layouts corretos
-- =====================================================

-- ===========================================
-- JORNADAS: Layout Comparativo AS-IS/TO-BE
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
    "layout": "comparativo_as_is_to_be",
    "comparativo": {
        "campo_nome": "nome",
        "campo_as_is": "as_is",
        "campo_to_be": "to_be",
        "campo_descricao": "descricao",
        "campo_categoria": "categoria",
        "campo_status": "status"
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
                "tipo": "select"
            }
        ]
    },
    "modal_detalhe": {
        "habilitado": true,
        "titulo_campo": "nome",
        "campos": ["nome", "descricao", "categoria", "status", "as_is", "to_be", "beneficios", "sistemas_envolvidos"]
    },
    "paginacao": {
        "habilitado": false
    }
}'
WHERE projeto_id = 5 AND codigo = 'jornadas';

-- ===========================================
-- TESTES: Layout Cards com Breadcrumb
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
    "layout": "cards_grid",
    "agrupamento": {
        "habilitado": true,
        "campo": "categoria"
    },
    "card": {
        "campo_titulo": "nome",
        "campo_badge": "prioridade",
        "campo_subtitulo": "id",
        "campos_info": [
            {"campo": "sistema", "label": "Sistema", "icone": "💻"},
            {"campo": "status", "label": "Status", "tipo": "badge"}
        ]
    },
    "filtros": {
        "habilitado": true,
        "campos": [
            {
                "campo": "categoria",
                "label": "Categoria",
                "tipo": "select",
                "mostrar_icone": true
            },
            {
                "campo": "prioridade",
                "label": "Prioridade",
                "tipo": "select"
            },
            {
                "campo": "status",
                "label": "Status",
                "tipo": "select"
            },
            {
                "campo": "sistema",
                "label": "Sistema",
                "tipo": "select"
            }
        ]
    },
    "metricas": {
        "habilitado": true,
        "cards": [
            {"label": "Total Testes", "tipo": "total", "icone": "📋", "cor": "blue"},
            {"label": "Alta Prioridade", "tipo": "contagem", "campo": "prioridade", "valor": "Alta", "icone": "🔴", "cor": "red"},
            {"label": "Pendentes", "tipo": "contagem", "campo": "status", "valor": "Pendente", "icone": "⏳", "cor": "yellow"},
            {"label": "Concluídos", "tipo": "contagem", "campo": "status", "valor": "Aprovado", "icone": "✅", "cor": "green"}
        ]
    },
    "modal_detalhe": {
        "habilitado": true,
        "titulo_campo": "nome",
        "campos": ["id", "nome", "categoria", "sistema", "prioridade", "status", "passos", "resultado_esperado", "resultado_obtido", "observacoes"]
    },
    "paginacao": {
        "habilitado": true,
        "itens_por_pagina": 20
    }
}'
WHERE projeto_id = 5 AND codigo = 'testes';

-- ===========================================
-- CRONOGRAMA: Layout Timeline com Agrupamento
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
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
            {
                "campo": "tipo",
                "label": "Tipo",
                "tipo": "select"
            },
            {
                "campo": "status",
                "label": "Status",
                "tipo": "select"
            },
            {
                "campo": "fase",
                "label": "Fase",
                "tipo": "select"
            }
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
WHERE projeto_id = 5 AND codigo = 'cronograma';

-- ===========================================
-- GLOSSARIO: Verificar se já usa glossario_tabs
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
    "layout": "glossario_tabs",
    "agrupamento": {
        "campo": "categoria"
    },
    "card": {
        "campo_titulo": "sigla",
        "campo_subtitulo": "nome",
        "campo_descricao": "descricao",
        "campos_info": [
            {"campo": "contexto", "label": "Contexto", "ocultar_vazio": true}
        ]
    },
    "filtros": {
        "habilitado": true,
        "campos": [
            {
                "campo": "busca",
                "label": "Buscar",
                "tipo": "texto",
                "placeholder": "Buscar termo..."
            }
        ]
    },
    "modal_detalhe": {
        "habilitado": true,
        "titulo_campo": "sigla",
        "campos": ["sigla", "nome", "descricao", "categoria", "contexto", "alternativo", "status"]
    },
    "paginacao": {
        "habilitado": false
    }
}'
WHERE projeto_id = 5 AND codigo = 'glossario';

-- ===========================================
-- DOCUMENTOS: Layout documentos_rico
-- ===========================================

UPDATE projeto_entidades
SET config_funcionalidades = '{
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
            {
                "campo": "categoria",
                "label": "Categoria",
                "tipo": "select"
            },
            {
                "campo": "busca",
                "label": "Buscar",
                "tipo": "texto",
                "placeholder": "Buscar documento..."
            }
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
WHERE projeto_id = 5 AND codigo = 'documentos';
