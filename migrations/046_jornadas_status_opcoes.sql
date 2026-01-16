-- =====================================================
-- Migration 046: Adicionar opcoes de status para Jornadas
-- Projeto 5 (GTM Clone) - Entidade ID 18
-- =====================================================

-- Adicionar opcoes de status para o campo 'status' da entidade Jornadas
-- Valores baseados nos dados existentes: Pendente, Em Andamento, Em Desenvolvimento, Concluido

INSERT OR IGNORE INTO projeto_entidade_opcoes (entidade_id, campo_codigo, valor, label, cor, icone, ordem, ativo)
VALUES
(18, 'status', 'Pendente', 'Pendente', '#6B7280', NULL, 1, 1),
(18, 'status', 'Em Andamento', 'Em Andamento', '#F59E0B', NULL, 2, 1),
(18, 'status', 'Em Desenvolvimento', 'Em Desenvolvimento', '#3B82F6', NULL, 3, 1),
(18, 'status', 'Concluido', 'Concluido', '#10B981', NULL, 4, 1);

-- Verificar resultado
SELECT * FROM projeto_entidade_opcoes WHERE entidade_id = 18 AND campo_codigo = 'status';
