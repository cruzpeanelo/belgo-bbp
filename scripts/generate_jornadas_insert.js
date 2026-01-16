/**
 * Script para gerar migração SQL com INSERT das jornadas
 * Lê arquivos JSON individuais e gera INSERT statements
 */

const fs = require('fs');
const path = require('path');

const jornadasDir = path.join(__dirname, '..', 'data', 'jornadas');
const outputFile = path.join(__dirname, '..', 'migrations', '052_jornadas_insert_completo.sql');

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

  // Detalhes adicionais
  if (jsonData.detalhes) {
    result.detalhes = jsonData.detalhes;
  }

  // Participantes de Reunião
  if (jsonData.participantesReunião && Array.isArray(jsonData.participantesReunião)) {
    result.participantes_reuniao = jsonData.participantesReunião;
  }

  // Fluxo de Aprovação
  if (jsonData.fluxoAprovação && Array.isArray(jsonData.fluxoAprovação)) {
    result.fluxo_aprovacao = jsonData.fluxoAprovação;
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

  return result;
}

function generateSQL() {
  let sql = `-- =====================================================
-- Migration 052: Jornadas - INSERT Completo
-- DELETA e INSERE todas as 14 jornadas com dados completos
-- extraídos dos arquivos data/jornadas/*.json
-- Projeto 5 (GTM Clone) - Entidade ID 18
-- =====================================================

-- Primeiro, deletar todos os registros de jornadas existentes
DELETE FROM projeto_dados WHERE entidade_id = 18 AND projeto_id = 5;

`;

  const files = fs.readdirSync(jornadasDir).filter(f => f.endsWith('.json') && f !== '_index.json');

  // Ordenar por ordem
  const jornadasData = [];
  for (const file of files) {
    const filePath = path.join(jornadasDir, file);
    const jsonContent = fs.readFileSync(filePath, 'utf8');
    const jsonData = JSON.parse(jsonContent);
    jornadasData.push({ file, data: jsonData });
  }

  // Ordenar por ordem
  jornadasData.sort((a, b) => (a.data.ordem || 0) - (b.data.ordem || 0));

  for (const { file, data: jsonData } of jornadasData) {
    const transformedData = transformJornadaData(jsonData);
    const jsonString = JSON.stringify(transformedData, null, 2);
    const escapedJson = escapeSQL(jsonString);

    sql += `-- =============================================================================
-- Jornada ${transformedData.ordem}: ${transformedData.nome}
-- Fonte: data/jornadas/${file}
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '${escapedJson}');

`;
  }

  sql += `
-- Verificar resultado
SELECT
  json_extract(dados, '$.nome') as nome,
  json_extract(dados, '$.ordem') as ordem,
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
