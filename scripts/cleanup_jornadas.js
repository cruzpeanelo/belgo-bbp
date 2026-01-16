/**
 * Script para limpar duplicatas de jornadas
 * Deleta todos os registros e lista o resultado
 */

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

async function main() {
  console.log('=== Verificando registros de jornadas ===\n');

  // Count before
  console.log('1. Contando registros por projeto...');
  try {
    const countResult = runSQL("SELECT projeto_id, COUNT(*) as total FROM projeto_dados WHERE entidade_id = 18 GROUP BY projeto_id");
    console.log('Resultado:', JSON.stringify(countResult, null, 2));
  } catch (e) {
    console.log('Erro ao contar:', e.message);
  }

  // Delete all jornadas for project 5
  console.log('\n2. Deletando TODAS as jornadas do projeto 5...');
  try {
    const deleteResult = runSQL("DELETE FROM projeto_dados WHERE entidade_id = 18 AND projeto_id = 5");
    console.log('Delete resultado:', JSON.stringify(deleteResult, null, 2));
  } catch (e) {
    console.log('Erro ao deletar:', e.message);
  }

  // Count after delete
  console.log('\n3. Contando após delete...');
  try {
    const countAfter = runSQL("SELECT projeto_id, COUNT(*) as total FROM projeto_dados WHERE entidade_id = 18 GROUP BY projeto_id");
    console.log('Resultado:', JSON.stringify(countAfter, null, 2));
  } catch (e) {
    console.log('Erro ao contar:', e.message);
  }

  console.log('\n=== Concluído ===');
}

main().catch(console.error);
