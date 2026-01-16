const { execSync } = require('child_process');

// Limpar registros da timeline que não são fases
// As fases (tipo=fase) já têm os marcos aninhados

const sql = `DELETE FROM projeto_dados WHERE entidade_id = 25 AND json_extract(dados, '$.tipo') != 'fase';`;

console.log('Limpando registros que não são fases da timeline...');
console.log('SQL:', sql);

try {
    const result = execSync(`npx wrangler d1 execute belgo-bbp-db --remote --command "${sql}"`, {
        encoding: 'utf8',
        maxBuffer: 1024 * 1024 * 10,
        stdio: ['pipe', 'pipe', 'pipe']
    });

    console.log('Limpeza executada!');

    // Verificar resultado
    const checkSql = `SELECT COUNT(*) as total FROM projeto_dados WHERE entidade_id = 25;`;
    const checkResult = execSync(`npx wrangler d1 execute belgo-bbp-db --remote --json --command "${checkSql}"`, {
        encoding: 'utf8',
        maxBuffer: 1024 * 1024 * 10,
        stdio: ['pipe', 'pipe', 'pipe']
    });

    const jsonMatch = checkResult.match(/\[[\s\S]*\]/);
    if (jsonMatch) {
        const data = JSON.parse(jsonMatch[0]);
        console.log('Total registros após limpeza:', data[0]?.results?.[0]?.total);
    }
} catch (error) {
    console.error('Erro:', error.message);
}
