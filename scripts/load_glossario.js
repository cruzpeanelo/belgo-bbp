/**
 * Script para carregar apenas o glossário
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const dataDir = path.join(__dirname, '..', 'data');

function escapeSQL(str) {
  if (typeof str !== 'string') return str;
  return str.replace(/'/g, "''");
}

function transformGlossario(jsonData) {
  const records = [];
  if (jsonData.categorias) {
    Object.entries(jsonData.categorias).forEach(([categoria, termos]) => {
      if (Array.isArray(termos)) {
        termos.forEach(termo => {
          const categoriaNormalizada = categoria
            .replace(/([A-Z])/g, ' $1')
            .trim()
            .toLowerCase()
            .replace(/^./, c => c.toUpperCase());
          records.push({
            sigla: termo.sigla || termo.nome || '',
            nome: termo.nome || termo.sigla || '',
            descricao: termo.descrição || termo.descricao || '',
            categoria: categoriaNormalizada,
            contexto: termo.contexto || '',
            status: termo.status || '',
            alternativo: termo.alternativo || ''
          });
        });
      }
    });
  }
  return records;
}

const glossarioData = JSON.parse(fs.readFileSync(path.join(dataDir, 'glossario.json'), 'utf8'));
const records = transformGlossario(glossarioData);
console.log('Total registros glossario:', records.length);

let sql = "DELETE FROM projeto_dados WHERE projeto_id = 5 AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = 'glossario' AND projeto_id = 5);\n";

records.forEach(record => {
  const jsonString = JSON.stringify(record);
  const escapedJson = escapeSQL(jsonString);
  sql += `INSERT INTO projeto_dados (projeto_id, entidade_id, dados) SELECT 5, id, '${escapedJson}' FROM projeto_entidades WHERE codigo = 'glossario' AND projeto_id = 5;\n`;
});

const sqlFile = path.join(__dirname, '..', 'temp_glossario.sql');
fs.writeFileSync(sqlFile, sql, 'utf8');
console.log('SQL file created. Executing...');

try {
  execSync('npx wrangler d1 execute belgo-bbp-db --remote --file=temp_glossario.sql', {
    cwd: path.join(__dirname, '..'),
    stdio: 'inherit'
  });
  console.log('Glossario loaded successfully!');
} catch(e) {
  console.error('Error:', e.message);
}

// Cleanup
if (fs.existsSync(sqlFile)) {
  fs.unlinkSync(sqlFile);
}
