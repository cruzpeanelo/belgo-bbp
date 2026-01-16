-- =====================================================
-- Migration 030: Garantir que entidade cronograma existe
-- Projeto 5 (GTM Clone)
-- =====================================================

-- Criar entidade cronograma se não existir
INSERT OR IGNORE INTO projeto_entidades (
    projeto_id,
    codigo,
    nome,
    descricao,
    icone,
    permite_criar,
    permite_editar,
    permite_excluir,
    permite_exportar
)
VALUES (
    5,
    'cronograma',
    'Cronograma',
    'Cronograma do projeto GTM - Workshops, marcos e atividades',
    '📅',
    0,
    0,
    0,
    1
);

-- Criar menu para cronograma se não existir
INSERT OR IGNORE INTO projeto_menus (
    projeto_id,
    nome,
    icone,
    url,
    ordem,
    ativo,
    entidade_id
)
SELECT
    5,
    'Cronograma',
    '📅',
    '/pages/entidade.html?e=cronograma',
    50,
    1,
    id
FROM projeto_entidades
WHERE codigo = 'cronograma' AND projeto_id = 5;

-- Atualizar menu existente se estiver apontando para página estática
UPDATE projeto_menus
SET
    url = '/pages/entidade.html?e=cronograma',
    ativo = 1,
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'cronograma' AND projeto_id = 5)
WHERE projeto_id = 5
AND nome LIKE '%Cronograma%'
AND url NOT LIKE '%entidade.html%';
