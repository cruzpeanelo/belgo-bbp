-- =====================================================
-- Migration 025: Corrigir URLs do Menu do Projeto 5
-- Mudar de páginas estáticas para páginas dinâmicas
-- =====================================================

-- Atualizar menu de Cronograma: estático -> dinâmico
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=cronograma'
WHERE projeto_id = 5
AND (
    url = '/pages/cronograma.html' OR
    url = 'pages/cronograma.html' OR
    url LIKE '%cronograma.html'
)
AND url NOT LIKE '%entidade.html%';

-- Atualizar menu de Documentos: estático -> dinâmico
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=documentos'
WHERE projeto_id = 5
AND (
    url = '/pages/documentos.html' OR
    url = 'pages/documentos.html' OR
    url LIKE '%documentos.html'
)
AND url NOT LIKE '%entidade.html%';

-- Garantir que menu de cronograma esteja ativo e vinculado à entidade
UPDATE projeto_menus
SET ativo = 1,
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5 LIMIT 1)
WHERE projeto_id = 5
AND url LIKE '%cronograma%';

-- Garantir que menu de documentos esteja ativo e vinculado à entidade
UPDATE projeto_menus
SET ativo = 1,
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'documentos' AND projeto_id = 5 LIMIT 1)
WHERE projeto_id = 5
AND url LIKE '%documentos%';

-- Verificar resultado
-- SELECT id, nome, url, entidade_id, ativo FROM projeto_menus WHERE projeto_id = 5;
