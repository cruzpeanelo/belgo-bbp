const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// IDs duplicados a serem removidos (mantendo os originais com IDs menores)
const duplicateIds = [1128, 1129, 1130, 1131, 1132, 1133, 1134, 1135, 1136, 1137, 1138];

console.log('=== LIMPEZA DE DUPLICATAS DO CRONOGRAMA ===\n');
console.log('IDs a remover:', duplicateIds.join(', '));

const sql = `DELETE FROM projeto_dados WHERE entidade_id = 24 AND id IN (${duplicateIds.join(', ')});`;
console.log('\nSQL:', sql);

const tempFile = path.join(__dirname, '..', 'temp_cleanup_cronograma.sql');
fs.writeFileSync(tempFile, sql);

try {
    const result = execSync(`npx wrangler d1 execute belgo-bbp-db --remote --file="${tempFile}"`, {
        encoding: 'utf8',
        maxBuffer: 1024 * 1024 * 10,
        cwd: path.join(__dirname, '..')
    });
    console.log('\nResultado:', result);

    // Verificar contagem após limpeza
    const checkSql = `SELECT COUNT(*) as total FROM projeto_dados WHERE entidade_id = 24;`;
    const checkResult = execSync(`npx wrangler d1 execute belgo-bbp-db --remote --json --command "${checkSql}"`, {
        encoding: 'utf8',
        maxBuffer: 1024 * 1024 * 10,
        cwd: path.join(__dirname, '..')
    });

    const jsonMatch = checkResult.match(/\[[\s\S]*\]/);
    if (jsonMatch) {
        const data = JSON.parse(jsonMatch[0]);
        console.log('\nTotal registros após limpeza:', data[0]?.results?.[0]?.total);
    }

    fs.unlinkSync(tempFile);
    console.log('\nLimpeza concluída!');
} catch (error) {
    console.error('Erro:', error.message);
    if (error.stderr) console.error('Stderr:', error.stderr);
}
