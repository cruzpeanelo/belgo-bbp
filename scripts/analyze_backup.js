/**
 * Analyze Backup Script
 * Identifies all inconsistencies in the backup data
 */

const fs = require('fs');
const path = require('path');

const BACKUP_DIR = path.join(__dirname, '..', 'backups');

// Find most recent backup (sort descending to get latest first)
const files = fs.readdirSync(BACKUP_DIR).filter(f => f.endsWith('.json')).sort().reverse();
const timestamp = files[0]?.split('_')[0];

console.log('='.repeat(60));
console.log('ANÁLISE DE INCONSISTÊNCIAS');
console.log(`Backup: ${timestamp}`);
console.log('='.repeat(60));

// 1. Analyze menus
console.log('\n📋 MENUS SEM ACENTOS:');
const menus = JSON.parse(fs.readFileSync(path.join(BACKUP_DIR, `${timestamp}_projeto_menus.json`)));
const menusProblems = menus.filter(m =>
    m.nome === 'Reunioes' ||
    m.nome === 'Glossario' ||
    m.nome === 'Pontos Criticos' ||
    m.nav_group === 'Administracao'
);
menusProblems.forEach(m => {
    console.log(`  ID ${m.id} (projeto ${m.projeto_id}): "${m.nome}" ${m.nav_group ? `[nav_group: ${m.nav_group}]` : ''}`);
});
console.log(`  Total: ${menusProblems.length} menus para corrigir`);

// 2. Analyze entities
console.log('\n📦 ENTIDADES SEM ACENTOS:');
const entidades = JSON.parse(fs.readFileSync(path.join(BACKUP_DIR, `${timestamp}_projeto_entidades.json`)));
const entidadesProblems = entidades.filter(e =>
    (e.nome && !e.nome.includes('ã') && !e.nome.includes('á') && !e.nome.includes('é') &&
        (e.nome.includes('Reunia') || e.nome.includes('Glossar'))) ||
    (e.nome_plural && !e.nome_plural.includes('õ') && !e.nome_plural.includes('á') &&
        (e.nome_plural.includes('Reunio') || e.nome_plural.includes('Glossar') || e.nome_plural.includes('Critico')))
);
entidadesProblems.forEach(e => {
    console.log(`  ID ${e.id}: nome="${e.nome}" nome_plural="${e.nome_plural}"`);
});
console.log(`  Total: ${entidadesProblems.length} entidades para corrigir`);

// 3. Analyze campos (fields)
console.log('\n🏷️ CAMPOS SEM ACENTOS:');
const campos = JSON.parse(fs.readFileSync(path.join(BACKUP_DIR, `${timestamp}_projeto_entidade_campos.json`)));
const camposProblems = campos.filter(c =>
    c.nome === 'Codigo' ||
    c.nome === 'Descricao' ||
    c.nome === 'Observacoes' ||
    c.nome === 'Definicao' ||
    c.nome === 'Execucao'
);
camposProblems.forEach(c => {
    console.log(`  ID ${c.id} (entidade ${c.entidade_id}): "${c.nome}"`);
});
console.log(`  Total: ${camposProblems.length} campos para corrigir`);

// 4. Analyze projeto_dados (JSON data)
console.log('\n📊 DADOS COM VALORES INCONSISTENTES:');
const dados = JSON.parse(fs.readFileSync(path.join(BACKUP_DIR, `${timestamp}_projeto_dados.json`)));
let categoriaProblems = 0;
let statusProblems = 0;

dados.forEach(d => {
    try {
        const json = JSON.parse(d.dados);

        // Check categoria
        if (json.categoria === 'workflow_pricing' ||
            json.categoria === 'WORKFLOW_PRICING') {
            categoriaProblems++;
            if (categoriaProblems <= 5) {
                console.log(`  ID ${d.id}: categoria="${json.categoria}" (entidade ${d.entidade_id})`);
            }
        }

        // Check status
        if (json.status === 'pendente' ||
            json.status === 'concluido' ||
            json.status === 'aprovado') {
            statusProblems++;
            if (statusProblems <= 5) {
                console.log(`  ID ${d.id}: status="${json.status}" (entidade ${d.entidade_id})`);
            }
        }
    } catch (e) {
        // Skip invalid JSON
    }
});

console.log(`  Categorias inconsistentes: ${categoriaProblems}`);
console.log(`  Status inconsistentes: ${statusProblems}`);

// Summary
console.log('\n' + '='.repeat(60));
console.log('RESUMO:');
console.log(`  Menus: ${menusProblems.length}`);
console.log(`  Entidades: ${entidadesProblems.length}`);
console.log(`  Campos: ${camposProblems.length}`);
console.log(`  Dados (categoria): ${categoriaProblems}`);
console.log(`  Dados (status): ${statusProblems}`);
console.log('='.repeat(60));

// Generate fix SQL
console.log('\n📝 SQL DE CORREÇÃO GERADO:\n');

console.log('-- Menus');
menusProblems.forEach(m => {
    if (m.nome === 'Reunioes') console.log(`UPDATE projeto_menus SET nome = 'Reuniões' WHERE id = ${m.id};`);
    if (m.nome === 'Glossario') console.log(`UPDATE projeto_menus SET nome = 'Glossário' WHERE id = ${m.id};`);
    if (m.nome === 'Pontos Criticos') console.log(`UPDATE projeto_menus SET nome = 'Pontos Críticos' WHERE id = ${m.id};`);
    if (m.nav_group === 'Administracao') console.log(`UPDATE projeto_menus SET nav_group = 'Administração' WHERE id = ${m.id};`);
});

console.log('\n-- Campos');
camposProblems.forEach(c => {
    if (c.nome === 'Codigo') console.log(`UPDATE projeto_entidade_campos SET nome = 'Código' WHERE id = ${c.id};`);
    if (c.nome === 'Descricao') console.log(`UPDATE projeto_entidade_campos SET nome = 'Descrição' WHERE id = ${c.id};`);
    if (c.nome === 'Observacoes') console.log(`UPDATE projeto_entidade_campos SET nome = 'Observações' WHERE id = ${c.id};`);
    if (c.nome === 'Definicao') console.log(`UPDATE projeto_entidade_campos SET nome = 'Definição' WHERE id = ${c.id};`);
    if (c.nome === 'Execucao') console.log(`UPDATE projeto_entidade_campos SET nome = 'Execução' WHERE id = ${c.id};`);
});

console.log('\n-- Dados JSON (categoria e status)');
console.log("UPDATE projeto_dados SET dados = json_replace(dados, '$.categoria', 'Workflow Pricing') WHERE json_extract(dados, '$.categoria') = 'workflow_pricing';");
console.log("UPDATE projeto_dados SET dados = json_replace(dados, '$.status', 'Pendente') WHERE json_extract(dados, '$.status') = 'pendente';");
