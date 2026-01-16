const { execSync } = require('child_process');
const path = require('path');

const projectDir = path.join(__dirname, '..');

function runSQL(sql) {
  const result = execSync(
    `npx wrangler d1 execute belgo-bbp-db --remote --command="${sql}" --json`,
    { cwd: projectDir, encoding: 'utf8', maxBuffer: 10 * 1024 * 1024 }
  );
  return JSON.parse(result);
}

console.log('=== Verificando Jornadas ===\n');

const countResult = runSQL("SELECT COUNT(*) as total FROM projeto_dados WHERE entidade_id = 18 AND projeto_id = 5");
console.log('Total de registros:', countResult[0].results[0].total);

const namesResult = runSQL("SELECT json_extract(dados, '$.nome') as nome, json_extract(dados, '$.ordem') as ordem FROM projeto_dados WHERE entidade_id = 18 AND projeto_id = 5 ORDER BY json_extract(dados, '$.ordem')");
console.log('\nJornadas inseridas:');
namesResult[0].results.forEach((r, i) => console.log(`  ${i+1}. ${r.nome} (ordem: ${r.ordem})`));
