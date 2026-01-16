-- =====================================================
-- Migration 054: Fix Pontos Críticos entity
-- =====================================================

-- Garantir que a entidade pontos-criticos existe
INSERT OR REPLACE INTO projeto_entidades (
    id,
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
SELECT
    COALESCE((SELECT id FROM projeto_entidades WHERE projeto_id = 5 AND codigo = 'pontos-criticos'), NULL),
    5,
    'pontos-criticos',
    'Pontos Críticos',
    'Riscos, problemas e pontos de atenção do projeto',
    '⚠️',
    1,
    1,
    1,
    1,
    '{
  "layout": "kanban",
  "kanban": {
    "campo_coluna": "status",
    "colunas": [
      { "valor": "Pendente", "label": "Pendente", "cor": "#EAB308" },
      { "valor": "Em Andamento", "label": "Em Andamento", "cor": "#3B82F6" },
      { "valor": "Resolvido", "label": "Resolvido", "cor": "#22C55E" }
    ],
    "permite_arrastar": true
  },
  "filtros": {
    "habilitado": true,
    "campos": [
      { "campo": "categoria", "tipo": "select", "label": "Categoria", "opcoes_de": "campo" },
      { "campo": "severidade", "tipo": "select", "label": "Severidade" },
      { "campo": "busca", "tipo": "text", "label": "Buscar", "placeholder": "Buscar problema...", "campos_busca": ["titulo", "descricao", "responsavel"] }
    ]
  },
  "metricas": {
    "habilitado": true,
    "cards": [
      { "tipo": "total", "label": "Total", "icone": "⚠️", "cor": "blue" },
      { "tipo": "contador", "campo": "severidade", "valor": "Crítica", "label": "Críticos", "icone": "🔴", "cor": "red" },
      { "tipo": "contador", "campo": "status", "valor": "Resolvido", "label": "Resolvidos", "icone": "✅", "cor": "green" },
      { "tipo": "contador", "campo": "status", "valor": "Pendente", "label": "Pendentes", "icone": "⏳", "cor": "yellow" }
    ]
  },
  "card": {
    "campos": [
      { "campo": "id", "estilo": "badge_id" },
      { "campo": "titulo", "estilo": "titulo" },
      { "campo": "descricao", "estilo": "descricao", "truncar": 100 },
      { "campo": "severidade", "estilo": "badge" },
      { "campo": "categoria", "estilo": "badge", "cor": "gray" },
      { "campo": "responsavel", "estilo": "avatar_nome", "icone": "👤" }
    ]
  },
  "modal_detalhe": {
    "habilitado": true,
    "titulo": "{id}: {titulo}",
    "secoes": [
      { "tipo": "header_status", "campos": ["status", "severidade", "categoria"] },
      { "tipo": "bloco", "campo": "descricao", "titulo": "Descrição" },
      { "tipo": "bloco", "campo": "acao_tomada", "titulo": "Ação Tomada", "condicional": true },
      { "tipo": "bloco", "campo": "impacto", "titulo": "Impacto", "condicional": true },
      { "tipo": "info_grid", "campos": [
        { "campo": "responsavel", "label": "Responsável", "icone": "👤" },
        { "campo": "data_identificacao", "label": "Identificado em", "icone": "📅", "formato": "data" },
        { "campo": "data_resolucao", "label": "Resolvido em", "icone": "✅", "formato": "data", "condicional": true },
        { "campo": "fonte_reuniao", "label": "Fonte", "icone": "📋" }
      ]}
    ]
  },
  "paginacao": { "habilitado": false },
  "responsivo": {
    "mobile": { "breakpoint": 768, "layout": "cards", "metricas_grid": 2 },
    "desktop": { "layout": "kanban", "metricas_grid": 4 }
  }
}';

-- Carregar dados de pontos-criticos
DELETE FROM projeto_dados WHERE projeto_id = 5 AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5);

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-01","titulo":"Key Users não identificados formalmente","descricao":"Alguns usuários-chave designados não sabiam que eram key users, chegando despreparados para as responsabilidades de teste","categoria":"Pessoas","severidade":"Alta","status":"Resolvido","data_identificacao":"2025-12-04","data_resolucao":"2025-12-04","acao_tomada":"Declarado requisito para todos os gerentes identificarem formalmente key users com 2h semanais dedicadas","responsavel":"Thalita Rhein","fonte_reuniao":"04/12/2025","impacto":"Atraso na fase de testes"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-02","titulo":"Gap de conhecimento AS IS / TO BE","descricao":"O que tenho que testar? O que muda no meu processo? Não sei, não participei, não tenho visão.","categoria":"Conhecimento","severidade":"Crítica","status":"Resolvido","data_identificacao":"2025-12-04","data_resolucao":"2025-12-16","acao_tomada":"Workshops semanais de mapeamento AS IS - TO BE concluídos (4 sessões realizadas)","responsavel":"Leandro Cruz / Thalita Rhein","fonte_reuniao":"04/12/2025"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-03","titulo":"Gestão de Dados de Concorrentes","descricao":"Informações de concorrentes são sazonais e dinâmicas. Dificuldade em vincular projetos perdidos a concorrentes específicos.","categoria":"Dados","severidade":"Média","status":"Pendente","data_identificacao":"2025-12-10","acao_tomada":"Discussão agendada com Edmundo. Normalização de concorrentes pela TI.","responsavel":"Leandro Cruz","fonte_reuniao":"10/12/2025"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-04","titulo":"Integração Portal Logístico pendente","descricao":"Portal logístico atualmente não integrado com SAP, causando redundância de dados entre sistemas","categoria":"Integração","severidade":"Alta","status":"Pendente","data_identificacao":"2025-12-16","acao_tomada":"Reunião de follow-up agendada para verificar integração SAP - Portal Logístico","responsavel":"TI","fonte_reuniao":"16/12/2025"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-05","titulo":"Bugs Críticos CT-11 e CT-14","descricao":"CT-11: Botão New WFPricing disponível para contas sem SAP. CT-14: Validação aceita descontos inválidos (negativos, >100%)","categoria":"Desenvolvimento","severidade":"Bloqueador","status":"Pendente","data_identificacao":"2025-12-10","acao_tomada":"Correção necessária antes do GO LIVE","responsavel":"TI","fonte_reuniao":"Caderno de Testes"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-06","titulo":"Qualidade de Dados de Contato","descricao":"Dados de contato incompletos ou incorretos impactam as funcionalidades de autoatendimento e comunicação automatizada","categoria":"Dados","severidade":"Alta","status":"Em Andamento","data_identificacao":"2025-12-16","acao_tomada":"Campanha de atualização de cadastros iniciada","responsavel":"Comercial","fonte_reuniao":"16/12/2025"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-07","titulo":"Integração AMD pendente no Salesforce","descricao":"AMD (Aços Maranhão Distribuição) não tem funcionalidades no Salesforce. Processo Cross Company não contemplado.","categoria":"Integração","severidade":"Média","status":"Pendente","data_identificacao":"2025-12-10","acao_tomada":"Reunião específica agendada com Renata Mello e Victoria para tratar AMD","responsavel":"TI / Comercial","fonte_reuniao":"10/12/2025"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-08","titulo":"Go Live reprogramado para março","descricao":"Data original de Go Live (janeiro/fevereiro) foi reprogramada para 15/03/2026 para garantir qualidade dos testes","categoria":"Cronograma","severidade":"Média","status":"Resolvido","data_identificacao":"2026-01-13","data_resolucao":"2026-01-13","acao_tomada":"Timeline ajustado com nova data de Go Live em 15/03/2026","responsavel":"Leandro Cruz / Thalita Rhein","fonte_reuniao":"Revisão BBP"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-09","titulo":"Impactos em controles SOX a avaliar","descricao":"Novo CRM precisa ser avaliado quanto aos controles SOX e possível entrada no escopo de auditoria","categoria":"Compliance","severidade":"Alta","status":"Pendente","data_identificacao":"2025-12-03","acao_tomada":"Maria Luiza Chaves (Controladoria) designada como key user para acompanhar","responsavel":"Controladoria / TI","fonte_reuniao":"03/12/2025"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-10","titulo":"Integração Dow Jones não contemplada","descricao":"Integração com Dow Jones para due diligence de clientes (compliance/RC) não está no escopo atual do projeto. Fluxo via BRO precisa ser revisto.","categoria":"Integração","severidade":"Alta","status":"Pendente","data_identificacao":"2025-12-03","acao_tomada":"Necessário avaliar com Controladoria o fluxo de compliance para novos clientes","responsavel":"Renato Araujo / TI","fonte_reuniao":"03/12/2025","impacto":"Risco de compliance para cadastro de novos clientes"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-11","titulo":"Segment Report precisa reestruturação","descricao":"Segment Report da Controladoria precisa ser ajustado devido às mudanças organizacionais dos 4 macro setores (Agro, Construção Civil, Indústria, Distribuição)","categoria":"Relatórios","severidade":"Média","status":"Pendente","data_identificacao":"2025-12-17","acao_tomada":"Carla Venâncio e equipe de BI precisam redefinir estrutura de relatórios","responsavel":"Carla Venâncio / Luis Riqueti","fonte_reuniao":"17/12/2025"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-12","titulo":"Canal 25 em desativação","descricao":"Canal 25 (Casos Especiais) está sendo desativado. Clientes existentes precisam ser migrados para canais 20, 30 ou 40.","categoria":"Configuração","severidade":"Média","status":"Pendente","data_identificacao":"2025-12-03","acao_tomada":"Identificar clientes no canal 25 e definir para qual canal serão migrados","responsavel":"Comercial","fonte_reuniao":"03/12/2025","impacto":"Clientes que usam canal 25 precisam ser reclassificados"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-13","titulo":"Nova estrutura organizacional 4 macro setores","descricao":"Mudança estrutural urgente: diretoria comercial reorganizada em 4 macro setores (Alta Energia, Agricultura, Indústria, Construção Civil). Impacta hierarquia ECC, escritórios de vendas e workflow de aprovação.","categoria":"Organizacional","severidade":"Crítica","status":"Em Andamento","data_identificacao":"2025-12-22","acao_tomada":"Reunião de emergência realizada. 7 ações definidas para ajustar hierarquia comercial, escritórios e workflow.","responsavel":"Leandro Gimenes / Thalita Rhein","fonte_reuniao":"22/12/2025","impacto":"Revisão completa das jornadas AS-IS/TO-BE necessária"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
SELECT 5, id, '{"id":"PC-14","titulo":"Migração massiva de clientes (Hard Reboot)","descricao":"Base de clientes dos últimos 24 meses precisa ser associada aos novos escritórios de vendas conforme nova estrutura organizacional","categoria":"Dados","severidade":"Alta","status":"Pendente","data_identificacao":"2025-12-22","acao_tomada":"Planilha DE/PARA em construção. Extração da base de clientes pendente.","responsavel":"Leandro Cruz / Jefferson Pinheiro / Fabricio França","fonte_reuniao":"22/12/2025, 29/12/2025"}'
FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;

-- Atualizar menu Pontos Críticos para apontar para página dinâmica
UPDATE projeto_menus
SET url = '/pages/entidade.html?e=pontos-criticos',
    entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5)
WHERE projeto_id = 5 AND (nome LIKE '%Pontos Críticos%' OR nome LIKE '%Pontos Criticos%' OR nome LIKE '%pontos-criticos%');
