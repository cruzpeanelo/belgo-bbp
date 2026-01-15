-- =====================================================
-- Migration 004: Adicionar campos de integracao aos projetos
-- Data: 2026-01-15
-- Descricao: Adiciona campos para Teams, SharePoint e URL do modulo
-- =====================================================

-- Campos de integracao Microsoft Teams
ALTER TABLE projetos ADD COLUMN teams_channel_url TEXT;
ALTER TABLE projetos ADD COLUMN teams_webhook_url TEXT;

-- Campos de integracao SharePoint
ALTER TABLE projetos ADD COLUMN sharepoint_folder_url TEXT;
ALTER TABLE projetos ADD COLUMN sharepoint_drive_id TEXT;
ALTER TABLE projetos ADD COLUMN sharepoint_folder_id TEXT;

-- Campo para URL do modulo (pagina principal do projeto)
ALTER TABLE projetos ADD COLUMN url_modulo TEXT;

-- Campo para logo do projeto
ALTER TABLE projetos ADD COLUMN logo_url TEXT;

-- =====================================================
-- FIM DA MIGRATION
-- =====================================================
