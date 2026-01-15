-- =====================================================
-- BELGO BBP - Migration 005: Sistema de Templates Completo
-- Expande a tabela projeto_templates para suportar
-- criacao de projetos completos a partir de templates
-- =====================================================

-- 1. Adicionar campo config_completo (JSON unificado)
-- Contem: entidades, campos, menus, acoes, dashboard
ALTER TABLE projeto_templates ADD COLUMN config_completo TEXT;

-- 2. Adicionar campo para indicar projeto de origem
-- Permite rastrear de qual projeto o template foi exportado
ALTER TABLE projeto_templates ADD COLUMN projeto_origem_id INTEGER REFERENCES projetos(id);

-- 3. Adicionar campo de versao do template
ALTER TABLE projeto_templates ADD COLUMN versao TEXT DEFAULT '1.0';

-- 4. Adicionar metadados
ALTER TABLE projeto_templates ADD COLUMN criado_por INTEGER REFERENCES usuarios(id);
ALTER TABLE projeto_templates ADD COLUMN updated_at TEXT DEFAULT CURRENT_TIMESTAMP;

-- 5. Adicionar campo para preview/thumbnail
ALTER TABLE projeto_templates ADD COLUMN preview_url TEXT;

-- =====================================================
-- Estrutura esperada do config_completo:
-- =====================================================
-- {
--   "versao": "1.0",
--   "exportado_em": "2026-01-15T10:00:00Z",
--   "projeto_origem": { "id": 1, "codigo": "gtm", "nome": "GTM" },
--
--   "entidades": [
--     {
--       "codigo": "testes",
--       "nome": "Teste",
--       "nome_plural": "Testes",
--       "descricao": "...",
--       "icone": "...",
--       "tipo": "tabela",
--       "permite_criar": 1,
--       "permite_editar": 1,
--       "permite_excluir": 0,
--       "permite_importar": 1,
--       "permite_exportar": 1,
--       "config_funcionalidades": { ... },
--       "campos": [
--         {
--           "codigo": "nome",
--           "nome": "Nome",
--           "tipo": "text",
--           "obrigatorio": 1,
--           "ordem": 1,
--           "config": null,
--           "opcoes": []
--         }
--       ]
--     }
--   ],
--
--   "menus": [
--     {
--       "codigo": "dashboard",
--       "nome": "Dashboard",
--       "url": "pages/dashboard.html",
--       "icone": "...",
--       "ordem": 1,
--       "entidade_codigo": null,
--       "pagina_dinamica": 0
--     },
--     {
--       "codigo": "testes",
--       "nome": "Testes",
--       "url": "pages/entidade.html?e=testes",
--       "icone": "...",
--       "ordem": 2,
--       "entidade_codigo": "testes",
--       "pagina_dinamica": 1
--     }
--   ],
--
--   "dashboard": {
--     "widgets": [...]
--   },
--
--   "integracao": {
--     "teams_habilitado": true,
--     "sharepoint_habilitado": false
--   }
-- }
-- =====================================================

-- 6. Atualizar templates existentes com config_completo basico
UPDATE projeto_templates
SET config_completo = json_object(
    'versao', '1.0',
    'entidades', json('[]'),
    'menus', json('[]'),
    'dashboard', json_object('widgets', json('[]'))
)
WHERE config_completo IS NULL;
