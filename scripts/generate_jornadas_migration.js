/**
 * Script para gerar migração SQL com dados completos das jornadas
 * Lê arquivos JSON individuais e gera UPDATE statements
 */

const fs = require('fs');
const path = require('path');

const jornadasDir = path.join(__dirname, '..', 'data', 'jornadas');
const outputFile = path.join(__dirname, '..', 'migrations', '051_jornadas_dados_completos_json.sql');

// Mapeamento de arquivo JSON para nome da jornada na base
const fileToJornada = {
  'cadastro-cliente.json': 'Cadastro de Cliente',
  'areas-vendas.json': 'Áreas de Vendas',
  'documentos-fiscais.json': 'Documentos Fiscais',
  'contatos.json': 'Gestão de Contatos',
  'logistica.json': 'Portal Logístico',
  'financeiro.json': 'Financeiro/Crédito',
  'concorrentes.json': 'Rastreamento de Concorrentes',
  'autoatendimento.json': 'Autoatendimento',
  'workflow-pricing.json': 'Workflow Pricing',
  'cotacao-ov.json': 'Cotação e Ordem de Vendas',
  'hub-gestao.json': 'Hub de Gestão OC',
  'restricoes-logisticas.json': 'Restrições Logísticas',
  'market-share.json': 'Market Share e Concorrentes',
  'amd-cross-company.json': 'AMD Cross Company'
};

function escapeSQL(str) {
  if (typeof str !== 'string') return str;
  return str.replace(/'/g, "''");
}

function transformJornadaData(jsonData) {
  const result = {
    nome: jsonData.nome || '',
    icone: jsonData.icone || '',
    ordem: jsonData.ordem || 0,
    status: jsonData.status || 'Pendente'
  };

  // AS-IS
  if (jsonData.asIs) {
    result.as_is = jsonData.asIs.descrição || jsonData.asIs.descricao || '';
    if (jsonData.asIs.passos && Array.isArray(jsonData.asIs.passos)) {
      result.passos_as_is = jsonData.asIs.passos.join('|');
    }
    if (jsonData.asIs.problemas && Array.isArray(jsonData.asIs.problemas)) {
      result.problemas_as_is = jsonData.asIs.problemas.join('|');
    }
    result.tempo_medio_as_is = jsonData.asIs.tempoMedio || jsonData.asIs.tempoMédio || '';
  }

  // TO-BE
  if (jsonData.toBe) {
    result.to_be = jsonData.toBe.descrição || jsonData.toBe.descricao || '';
    if (jsonData.toBe.passos && Array.isArray(jsonData.toBe.passos)) {
      result.passos_to_be = jsonData.toBe.passos.join('|');
    }
    if (jsonData.toBe.beneficios && Array.isArray(jsonData.toBe.beneficios)) {
      result.beneficios_to_be = jsonData.toBe.beneficios.join('|');
    }
    result.tempo_medio_to_be = jsonData.toBe.tempoMedio || jsonData.toBe.tempoMédio || '';
  }

  // Áreas Impactadas
  if (jsonData.áreasImpactadas && Array.isArray(jsonData.áreasImpactadas)) {
    result.areas_impactadas = jsonData.áreasImpactadas.join('|');
  }

  // Sistemas Técnicos
  if (jsonData.sistemasTécnicos && Array.isArray(jsonData.sistemasTécnicos)) {
    result.sistemas_tecnicos = jsonData.sistemasTécnicos.join('|');
  }

  // Fontes de Reunião
  result.fonte_reuniao = jsonData.fonteReunião || jsonData.fonteReuniao || '';
  if (jsonData.fontesReunião && Array.isArray(jsonData.fontesReunião)) {
    result.fontes_reuniao = jsonData.fontesReunião.join('|');
  }

  // Pendências
  if (jsonData.pendências && Array.isArray(jsonData.pendências)) {
    result.pendencias = jsonData.pendências.join('|');
  }

  // Pré-requisitos
  if (jsonData.prerequisitos && Array.isArray(jsonData.prerequisitos)) {
    result.prerequisitos = jsonData.prerequisitos.join('|');
  }

  // Campos do Processo
  if (jsonData.campos && Array.isArray(jsonData.campos)) {
    result.campos_processo = jsonData.campos;
  }

  // Regras de Negócio
  if (jsonData.regrasNegócio && Array.isArray(jsonData.regrasNegócio)) {
    result.regras_negocio = jsonData.regrasNegócio;
  }

  // Integrações
  if (jsonData.integrações && Array.isArray(jsonData.integrações)) {
    result.integracoes = jsonData.integrações;
  }

  // Ciclos de Teste
  if (jsonData.ciclosTeste && Array.isArray(jsonData.ciclosTeste)) {
    result.ciclos_teste = jsonData.ciclosTeste;
  }

  // Mensagens do Sistema
  if (jsonData.mensagensSistema && Array.isArray(jsonData.mensagensSistema)) {
    result.mensagens_sistema = jsonData.mensagensSistema;
  }

  // Abas Interface
  if (jsonData.abasInterface && Array.isArray(jsonData.abasInterface)) {
    result.abas_interface = jsonData.abasInterface;
  }

  // Tipos de Conta (específico de cadastro)
  if (jsonData.tiposConta && Array.isArray(jsonData.tiposConta)) {
    result.tipos_conta = jsonData.tiposConta;
  }

  // Áreas de Crédito (específico de financeiro)
  if (jsonData.áreasCrédito && Array.isArray(jsonData.áreasCrédito)) {
    result.areas_credito = jsonData.áreasCrédito;
  }

  // Canais de Venda (específico de áreas de venda)
  if (jsonData.canaisVenda && Array.isArray(jsonData.canaisVenda)) {
    result.canais_venda = jsonData.canaisVenda;
  }

  // Detalhes adicionais
  if (jsonData.detalhes) {
    result.detalhes = jsonData.detalhes;
  }

  // Participantes de Reunião
  if (jsonData.participantesReunião && Array.isArray(jsonData.participantesReunião)) {
    result.participantes_reuniao = jsonData.participantesReunião;
  }

  // Fluxo de Aprovação
  if (jsonData.regrasNegócio) {
    const workflowRule = jsonData.regrasNegócio.find(r =>
      r.regra && (r.regra.includes('Workflow') || r.regra.includes('Aprovação'))
    );
    if (workflowRule && workflowRule.fluxo) {
      result.fluxo_aprovacao = workflowRule.fluxo;
    }
  }

  // Contexto de Reunião
  if (jsonData.contextoReunião) {
    result.contexto_reuniao = jsonData.contextoReunião;
  }

  // Discussão de Reuniões
  if (jsonData.discussãoReuniões) {
    result.discussao_reunioes = jsonData.discussãoReuniões;
  }

  // Citações de Transcrições
  if (jsonData.citacoesTranscricoes) {
    result.citacoes_transcricoes = jsonData.citacoesTranscricoes;
  }

  // Dados do Tester (extraídos dos documentos)
  if (jsonData.dadosExtraidosTester889851) {
    result.dados_tester = jsonData.dadosExtraidosTester889851;
  }

  return result;
}

function generateSQL() {
  let sql = `-- =====================================================
-- Migration 051: Jornadas - Dados Completos dos Arquivos JSON
-- Atualiza dados de Jornadas com TODOS os campos dos arquivos
-- JSON individuais para paridade 100% com dados originais
-- Projeto 5 (GTM Clone) - Entidade ID 18
-- =====================================================

-- NOTA: Esta migração atualiza os registros criados pela migração 049
-- com dados COMPLETOS extraídos dos arquivos data/jornadas/*.json

`;

  const files = fs.readdirSync(jornadasDir).filter(f => f.endsWith('.json') && f !== '_index.json');

  for (const file of files) {
    const jornadaName = fileToJornada[file];
    if (!jornadaName) {
      console.log(`Arquivo ${file} não tem mapeamento definido, pulando...`);
      continue;
    }

    const filePath = path.join(jornadasDir, file);
    const jsonContent = fs.readFileSync(filePath, 'utf8');
    const jsonData = JSON.parse(jsonContent);

    const transformedData = transformJornadaData(jsonData);
    const jsonString = JSON.stringify(transformedData, null, 2);
    const escapedJson = escapeSQL(jsonString);

    sql += `-- =============================================================================
-- Jornada: ${jornadaName}
-- Fonte: data/jornadas/${file}
-- =============================================================================
UPDATE projeto_dados
SET dados = '${escapedJson}'
WHERE projeto_id = 5
  AND entidade_id = 18
  AND json_extract(dados, '$.nome') = '${escapeSQL(jornadaName)}';

`;
  }

  sql += `
-- Verificar resultado
SELECT
  json_extract(dados, '$.nome') as nome,
  json_extract(dados, '$.status') as status,
  length(dados) as tamanho_dados
FROM projeto_dados
WHERE entidade_id = 18 AND projeto_id = 5
ORDER BY json_extract(dados, '$.ordem');
`;

  return sql;
}

// Executar
try {
  const sql = generateSQL();
  fs.writeFileSync(outputFile, sql, 'utf8');
  console.log(`Migração gerada com sucesso: ${outputFile}`);
  console.log(`Tamanho: ${(sql.length / 1024).toFixed(2)} KB`);
} catch (error) {
  console.error('Erro ao gerar migração:', error);
  process.exit(1);
}
