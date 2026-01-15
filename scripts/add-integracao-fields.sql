-- Script: add-integracao-fields.sql
-- Adiciona campos para white label, Teams e SharePoint na tabela projetos
-- Executar via: wrangler d1 execute belgo-bbp-db --file=scripts/add-integracao-fields.sql

-- Campo para URL do logo (armazenado no R2)
ALTER TABLE projetos ADD COLUMN logo_url TEXT;

-- Campos para integracao Microsoft Teams
ALTER TABLE projetos ADD COLUMN teams_webhook_url TEXT;
ALTER TABLE projetos ADD COLUMN teams_channel_url TEXT;

-- Campos para integracao Microsoft SharePoint
ALTER TABLE projetos ADD COLUMN sharepoint_folder_url TEXT;
ALTER TABLE projetos ADD COLUMN sharepoint_drive_id TEXT;
ALTER TABLE projetos ADD COLUMN sharepoint_folder_id TEXT;

-- Indice para consultas por status
CREATE INDEX IF NOT EXISTS idx_projetos_ativo ON projetos(ativo);
