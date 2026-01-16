/**
 * Script para inserir jornadas individualmente via wrangler
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const jornadasDir = path.join(__dirname, '..', 'data', 'jornadas');

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

  // Tipos de Conta
  if (jsonData.tiposConta && Array.isArray(jsonData.tiposConta)) {
    result.tipos_conta = jsonData.tiposConta;
  }

  // Detalhes
  if (jsonData.detalhes) {
    result.detalhes = jsonData.detalhes;
  }

  // Participantes
  if (jsonData.participantesReunião && Array.isArray(jsonData.participantesReunião)) {
    result.participantes_reuniao = jsonData.participantesReunião;
  }

  // Fluxo de Aprovação
  if (jsonData.fluxoAprovação && Array.isArray(jsonData.fluxoAprovação)) {
    result.fluxo_aprovacao = jsonData.fluxoAprovação;
  }

  return result;
}

async function insertJornadas() {
  const files = fs.readdirSync(jornadasDir).filter(f => f.endsWith('.json') && f !== '_index.json');

  // Ordenar por ordem
  const jornadasData = [];
  for (const file of files) {
    const filePath = path.join(jornadasDir, file);
    const jsonContent = fs.readFileSync(filePath, 'utf8');
    const jsonData = JSON.parse(jsonContent);
    jornadasData.push({ file, data: jsonData });
  }
  jornadasData.sort((a, b) => (a.data.ordem || 0) - (b.data.ordem || 0));

  console.log(`Inserindo ${jornadasData.length} jornadas...`);

  for (const { file, data: jsonData } of jornadasData) {
    const transformedData = transformJornadaData(jsonData);
    const jsonString = JSON.stringify(transformedData);
    const escapedJson = escapeSQL(jsonString);

    // Criar arquivo SQL temporário
    const sqlFile = path.join(__dirname, '..', 'temp_insert.sql');
    const sql = `INSERT INTO projeto_dados (projeto_id, entidade_id, dados) VALUES (5, 18, '${escapedJson}');`;
    fs.writeFileSync(sqlFile, sql, 'utf8');

    try {
      console.log(`  Inserindo: ${transformedData.nome} (${file})...`);
      execSync(`npx wrangler d1 execute belgo-bbp-db --remote --file=temp_insert.sql`, {
        cwd: path.join(__dirname, '..'),
        stdio: 'inherit'
      });
      console.log(`  ✓ ${transformedData.nome}`);
    } catch (error) {
      console.error(`  ✗ Erro em ${transformedData.nome}:`, error.message);
    }
  }

  // Limpar arquivo temporário
  const sqlFile = path.join(__dirname, '..', 'temp_insert.sql');
  if (fs.existsSync(sqlFile)) {
    fs.unlinkSync(sqlFile);
  }

  console.log('\nConcluído!');
}

insertJornadas().catch(console.error);
