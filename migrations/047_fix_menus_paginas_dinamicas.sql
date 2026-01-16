-- =====================================================
-- Migration 047: Corrigir menus para paginas dinamicas
-- Remove menus que apontam para paginas estaticas deletadas
-- Projeto 5 (GTM Clone)
-- =====================================================

-- Timeline e Pontos Criticos nao tem entidades dinamicas
-- Remover esses menus que apontavam para paginas estaticas

DELETE FROM projeto_menus
WHERE projeto_id = 5
AND url IN ('/pages/timeline.html', '/pages/pontos-criticos.html');

-- Verificar menus restantes
SELECT id, titulo, url, icone, ordem FROM projeto_menus WHERE projeto_id = 5 ORDER BY ordem;
