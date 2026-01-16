-- =====================================================
-- Migration 028: Completar Glossário com Stakeholders
-- Projeto 5 (GTM Clone) - Entidade: glossario
-- Adiciona os 4 stakeholders faltantes
-- =====================================================

-- ===========================================
-- CATEGORIA: stakeholders do projeto (4 termos faltantes)
-- ===========================================

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"sigla": "Leandro Cruz", "nome": "Gerente de TI", "descricao": "Gerente de TI responsável pelo projeto GTM", "categoria": "stakeholders_projeto", "area": "TI", "papel": "Gerente de TI"}'
FROM projeto_entidades WHERE codigo = 'glossario' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"sigla": "Leandro Gimenes", "nome": "PO GTM", "descricao": "Product Owner do projeto GTM Vendas", "categoria": "stakeholders_projeto", "area": "Comercial", "papel": "PO GTM"}'
FROM projeto_entidades WHERE codigo = 'glossario' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"sigla": "Ronildo", "nome": "PO Pricing", "descricao": "Product Owner do módulo de Pricing", "categoria": "stakeholders_projeto", "area": "Pricing", "papel": "PO Pricing"}'
FROM projeto_entidades WHERE codigo = 'glossario' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"sigla": "Thalita Rhein", "nome": "Gerente Negócio GTM", "descricao": "Gerente de Negócio responsável pelo GTM", "categoria": "stakeholders_projeto", "area": "Comercial/Marketing", "papel": "Gerente Negócio GTM"}'
FROM projeto_entidades WHERE codigo = 'glossario' AND projeto_id = 5;
