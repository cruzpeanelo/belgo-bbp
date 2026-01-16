const { execSync } = require('child_process');

const sql = `SELECT id, json_extract(dados, '$.tipo') as tipo, json_extract(dados, '$.nome') as nome, json_extract(dados, '$.id') as data_id FROM projeto_dados WHERE entidade_id = 25;`;

try {
    const result = execSync(`npx wrangler d1 execute belgo-bbp-db --remote --json --command "${sql}"`, {
        encoding: 'utf8',
        maxBuffer: 1024 * 1024 * 10,
        stdio: ['pipe', 'pipe', 'pipe']
    });

    const jsonMatch = result.match(/\[[\s\S]*\]/);
    if (jsonMatch) {
        const data = JSON.parse(jsonMatch[0]);
        console.log('\n=== TIPOS DE REGISTROS TIMELINE ===\n');
        const byType = {};
        data[0].results.forEach(r => {
            const tipo = r.tipo || 'sem_tipo';
            if (!byType[tipo]) byType[tipo] = [];
            byType[tipo].push({ id: r.id, nome: r.nome || r.data_id });
        });

        Object.keys(byType).forEach(tipo => {
            console.log(`\nTipo: ${tipo} (${byType[tipo].length} registros)`);
            byType[tipo].forEach(r => console.log(`  - ID ${r.id}: ${r.nome}`));
        });
    }
} catch (error) {
    console.error('Erro:', error.message);
}
