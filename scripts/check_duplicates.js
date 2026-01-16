const { execSync } = require('child_process');

function checkDuplicates(entidadeId, nome, campoTitulo, campoData) {
    const sql = `SELECT id, json_extract(dados, '$.${campoTitulo}') as titulo, json_extract(dados, '$.${campoData}') as data FROM projeto_dados WHERE entidade_id = ${entidadeId} ORDER BY data;`;

    try {
        const result = execSync(`npx wrangler d1 execute belgo-bbp-db --remote --json --command "${sql}"`, {
            encoding: 'utf8',
            maxBuffer: 1024 * 1024 * 10,
            stdio: ['pipe', 'pipe', 'pipe']
        });

        const match = result.match(/\[[\s\S]*\]/);
        if (match) {
            const data = JSON.parse(match[0]);
            console.log(`\n=== ${nome.toUpperCase()} (entidade_id=${entidadeId}) ===`);
            console.log(`Total: ${data[0].results.length} registros\n`);

            // Agrupar por titulo+data
            const grupos = {};
            data[0].results.forEach(r => {
                const key = `${r.titulo}|${r.data}`;
                if (!grupos[key]) grupos[key] = [];
                grupos[key].push(r.id);
            });

            const duplicados = Object.entries(grupos).filter(([k, v]) => v.length > 1);
            if (duplicados.length > 0) {
                console.log('DUPLICADOS ENCONTRADOS:');
                duplicados.forEach(([key, ids]) => {
                    const [titulo, data] = key.split('|');
                    console.log(`  - "${titulo}" (${data}) -> IDs: ${ids.join(', ')}`);
                });
                return duplicados.length;
            } else {
                console.log('Nenhum duplicado encontrado');
                return 0;
            }
        }
    } catch (error) {
        console.error(`Erro ao verificar ${nome}:`, error.message);
    }
    return 0;
}

// Verificar cronograma
checkDuplicates(24, 'Cronograma', 'titulo', 'data');

// Verificar timeline
checkDuplicates(25, 'Timeline', 'nome', 'periodo');
