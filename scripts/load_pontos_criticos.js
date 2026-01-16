/**
 * Script para carregar pontos críticos
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const dataDir = path.join(__dirname, '..', 'data');

function escapeSQL(str) {
  if (typeof str !== 'string') return str;
  return str.replace(/'/g, "''");
}

const pontosCriticosData = JSON.parse(fs.readFileSync(path.join(dataDir, 'pontos-criticos.json'), 'utf8'));

const records = pontosCriticosData.issues.map(issue => ({
  id: issue.id,
  titulo: issue.título || issue.titulo || '',
  descricao: issue.descrição || issue.descricao || '',
  categoria: issue.categoria || '',
  severidade: issue.severidade || 'Media',
  status: issue.status || 'Pendente',
  data_identificacao: issue.dataIdentificação || issue.dataIdentificacao || '',
  data_resolucao: issue.dataResolução || issue.dataResolucao || '',
  acao_tomada: issue.açãoTomada || issue.acaoTomada || '',
  responsavel: issue.responsável || issue.responsavel || '',
  fonte_reuniao: issue.fonteReunião || issue.fonteReuniao || '',
  impacto: issue.impacto || ''
}));

console.log('Total registros pontos-criticos:', records.length);

let sql = "DELETE FROM projeto_dados WHERE projeto_id = 5 AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5);\n";

records.forEach(record => {
  const jsonString = JSON.stringify(record);
  const escapedJson = escapeSQL(jsonString);
  sql += `INSERT INTO projeto_dados (projeto_id, entidade_id, dados) SELECT 5, id, '${escapedJson}' FROM projeto_entidades WHERE codigo = 'pontos-criticos' AND projeto_id = 5;\n`;
});

const sqlFile = path.join(__dirname, '..', 'temp_pontos.sql');
fs.writeFileSync(sqlFile, sql, 'utf8');
console.log('SQL file created. Executing...');

try {
  execSync('npx wrangler d1 execute belgo-bbp-db --remote --file=temp_pontos.sql', {
    cwd: path.join(__dirname, '..'),
    stdio: 'inherit'
  });
  console.log('Pontos criticos loaded successfully!');
} catch(e) {
  console.error('Error:', e.message);
}

// Cleanup
if (fs.existsSync(sqlFile)) {
  fs.unlinkSync(sqlFile);
}
