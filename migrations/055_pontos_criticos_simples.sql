-- =====================================================
-- Migration 055: Criar Pontos Críticos de forma simples
-- =====================================================

-- Primeiro, deletar se existir para recriar limpo
DELETE FROM projeto_entidades WHERE projeto_id = 5 AND codigo = 'pontos-criticos';

-- Criar entidade pontos-criticos
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
    'pontos-criticos',
    'Pontos Críticos',
    'Riscos, problemas e pontos de atenção do projeto',
    '⚠️',
    1,
    1,
    1,
    1,
    '{"layout":"tabela","filtros":{"habilitado":true,"campos":[{"campo":"categoria","tipo":"select","label":"Categoria"},{"campo":"severidade","tipo":"select","label":"Severidade"},{"campo":"status","tipo":"select","label":"Status"},{"campo":"busca","tipo":"text","label":"Buscar","campos_busca":["titulo","descricao"]}]},"metricas":{"habilitado":true,"cards":[{"tipo":"total","label":"Total","icone":"⚠️","cor":"blue"},{"tipo":"contador","campo":"status","valor":"Resolvido","label":"Resolvidos","icone":"✅","cor":"green"},{"tipo":"contador","campo":"status","valor":"Pendente","label":"Pendentes","icone":"⏳","cor":"yellow"}]},"paginacao":{"habilitado":false}}'
);

-- Atualizar menu Pontos Críticos
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=pontos-criticos',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5)
WHERE projeto_id = 5 AND nome LIKE '%Pontos%';
