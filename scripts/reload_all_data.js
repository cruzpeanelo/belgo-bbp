/**
 * Script para recarregar todos os dados das entidades
 * Garante que dados estão no formato correto para o banco
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const dataDir = path.join(__dirname, '..', 'data');
const projectDir = path.join(__dirname, '..');

// Helper para escapar SQL
function escapeSQL(str) {
  if (typeof str !== 'string') return str;
  return str.replace(/'/g, "''");
}

// Helper para normalizar nome de campo (remover acentos)
function normalizeFieldName(name) {
  return name
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]/g, '_');
}

// Função para transformar arrays em pipe-delimited
function arrayToPipe(arr) {
  if (!arr) return '';
  if (Array.isArray(arr)) {
    return arr.map(item => {
      if (typeof item === 'object') {
        return item.texto || item.nome || item.acao || JSON.stringify(item);
      }
      return item;
    }).join('|');
  }
  return String(arr);
}

// =====================================================
// TRANSFORMADORES DE DADOS
// =====================================================

function transformReuniones() {
  const filePath = path.join(dataDir, 'reunioes.json');
  if (!fs.existsSync(filePath)) return [];

  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  const reunioes = data.reunioes || [];

  return reunioes.map(r => ({
    id: r.id,
    data: r.data,
    titulo: r.titulo,
    duracao: r.duracao || '',
    tipo: r.tipo || 'reuniao',
    resumo: r.resumo || '',
    participantes: arrayToPipe(r.participantes),
    topicos: arrayToPipe(r.topicosAbordados),
    decisoes: arrayToPipe(r.decisoes),
    problemas: arrayToPipe(r.problemas),
    acoes: r.acoes ? JSON.stringify(r.acoes) : '',
    jornadas_relacionadas: arrayToPipe(r.jornadasRelacionadas)
  }));
}

function transformTimeline() {
  const filePath = path.join(dataDir, 'timeline.json');
  if (!fs.existsSync(filePath)) return [];

  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  const records = [];

  // Transformar fases em registros
  if (data.fases) {
    data.fases.forEach((fase, idx) => {
      records.push({
        id: `F${idx + 1}`,
        tipo: 'fase',
        nome: fase.nome,
        periodo: fase.período || fase.periodo || '',
        status: fase.status || 'planejado',
        marcos: JSON.stringify(fase.marcos || []),
        descricao: ''
      });
    });
  }

  // Transformar stakeholders
  if (data.stakeholders) {
    data.stakeholders.forEach((s, idx) => {
      records.push({
        id: `S${idx + 1}`,
        tipo: 'stakeholder',
        nome: s.nome,
        papel: s.papel || '',
        area: s.area || s.área || '',
        status: 'ativo'
      });
    });
  }

  // Transformar próximos passos
  if (data.próximosPassos || data.proximosPassos) {
    const passos = data.próximosPassos || data.proximosPassos;
    passos.forEach((p, idx) => {
      records.push({
        id: `P${idx + 1}`,
        tipo: 'proximo_passo',
        nome: p.descrição || p.descricao || '',
        prioridade: p.prioridade || idx + 1,
        prazo: p.prazo || '',
        status: 'pendente'
      });
    });
  }

  return records;
}

function transformCronograma() {
  const filePath = path.join(dataDir, 'cronograma.json');
  if (!fs.existsSync(filePath)) return [];

  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  const records = [];

  // Workshops
  if (data.workshops) {
    data.workshops.forEach(w => {
      records.push({
        id: w.id,
        tipo: 'workshop',
        data: w.data,
        titulo: w.título || w.titulo || '',
        status: w.status || 'Pendente',
        foco: arrayToPipe(w.foco),
        participantes: typeof w.participantes === 'number' ? String(w.participantes) : arrayToPipe(w.participantes),
        destaques: arrayToPipe(w.destaques),
        problemas: arrayToPipe(w.problemasIdentificados),
        feedback: w.feedbackMaria || w.feedback || ''
      });
    });
  }

  // Marcos
  if (data.marcos) {
    data.marcos.forEach((m, idx) => {
      records.push({
        id: `M${idx + 1}`,
        tipo: 'marco',
        data: m.data,
        titulo: m.título || m.titulo || '',
        status: m.status || 'Pendente'
      });
    });
  }

  return records;
}

function transformPontosCriticos() {
  const filePath = path.join(dataDir, 'pontos-criticos.json');
  if (!fs.existsSync(filePath)) return [];

  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  const issues = data.issues || [];

  return issues.map(issue => ({
    id: issue.id,
    titulo: issue.título || issue.titulo || '',
    descricao: issue.descrição || issue.descricao || '',
    categoria: issue.categoria || '',
    severidade: issue.severidade || 'Média',
    status: issue.status || 'Pendente',
    data_identificacao: issue.dataIdentificação || issue.dataIdentificacao || '',
    data_resolucao: issue.dataResolução || issue.dataResolucao || '',
    acao_tomada: issue.açãoTomada || issue.acaoTomada || '',
    responsavel: issue.responsável || issue.responsavel || '',
    fonte_reuniao: issue.fonteReunião || issue.fonteReuniao || '',
    impacto: issue.impacto || ''
  }));
}

// =====================================================
// EXECUÇÃO PRINCIPAL
// =====================================================

async function main() {
  const entities = [
    { codigo: 'reunioes', transform: transformReuniones },
    { codigo: 'timeline', transform: transformTimeline },
    { codigo: 'cronograma', transform: transformCronograma },
    { codigo: 'pontos-criticos', transform: transformPontosCriticos }
  ];

  let allSQL = '';

  for (const entity of entities) {
    console.log(`\nProcessando: ${entity.codigo}`);

    const records = entity.transform();
    console.log(`  Registros: ${records.length}`);

    if (records.length === 0) {
      console.log(`  Pulando (sem dados)`);
      continue;
    }

    // SQL para deletar dados existentes e inserir novos
    allSQL += `-- Recarregar dados de ${entity.codigo}\n`;
    allSQL += `DELETE FROM projeto_dados WHERE projeto_id = 5 AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = '${entity.codigo}' AND projeto_id = 5);\n`;

    records.forEach(record => {
      const jsonString = JSON.stringify(record);
      const escapedJson = escapeSQL(jsonString);
      allSQL += `INSERT INTO projeto_dados (projeto_id, entidade_id, dados) SELECT 5, id, '${escapedJson}' FROM projeto_entidades WHERE codigo = '${entity.codigo}' AND projeto_id = 5;\n`;
    });

    allSQL += '\n';
  }

  // Salvar e executar SQL
  const sqlFile = path.join(projectDir, 'temp_reload.sql');
  fs.writeFileSync(sqlFile, allSQL, 'utf8');
  console.log(`\nSQL salvo em: temp_reload.sql`);
  console.log('Executando...');

  try {
    execSync('npx wrangler d1 execute belgo-bbp-db --remote --file=temp_reload.sql', {
      cwd: projectDir,
      stdio: 'inherit'
    });
    console.log('\nDados recarregados com sucesso!');
  } catch (e) {
    console.error('Erro:', e.message);
  }

  // Cleanup
  if (fs.existsSync(sqlFile)) {
    fs.unlinkSync(sqlFile);
  }
}

main();
