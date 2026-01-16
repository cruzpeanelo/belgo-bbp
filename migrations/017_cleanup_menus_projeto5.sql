-- =====================================================
-- Migration 017: Limpar menus estaticos do Projeto 5
-- Manter apenas menus vinculados a entidades
-- =====================================================

-- Desativar menus que nao estao vinculados a entidades no projeto 5
UPDATE projeto_menus
SET ativo = 0
WHERE projeto_id = 5
AND entidade_id IS NULL
AND url NOT LIKE '/pages/entidade.html%'
AND url NOT LIKE 'pages/entidade.html%'
AND url NOT LIKE '/pages/dashboard.html%'
AND url NOT LIKE 'pages/dashboard.html%';

-- Garantir que menus de entidades tenham URL correta
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=' || (
    SELECT codigo FROM projeto_entidades WHERE id = projeto_menus.entidade_id
)
WHERE projeto_id = 5
AND entidade_id IS NOT NULL
AND url NOT LIKE '%/pages/entidade.html?e=%';

-- Verificar menus ativos do projeto 5
-- SELECT id, nome, url, entidade_id, ativo FROM projeto_menus WHERE projeto_id = 5;
