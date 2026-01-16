/**
 * Script de Migracao de Jornadas
 * Transforma dados do jornadas.json para formato do sistema dinamico
 *
 * Uso: node scripts/migrate-jornadas.js
 */

const fs = require('fs');
const path = require('path');

// Ler arquivo JSON original
const jornadasPath = path.join(__dirname, '..', 'data', 'jornadas.json');
const jornadasData = JSON.parse(fs.readFileSync(jornadasPath, 'utf-8'));

// Funcao para converter array em string delimitada
function arrayToDelimited(arr, delimiter = '|') {
    if (!arr) return '';
    if (Array.isArray(arr)) {
        return arr.join(delimiter);
    }
    return String(arr);
}

// Funcao para converter objeto/array em JSON string
function toJson(obj) {
    if (!obj) return '';
    return JSON.stringify(obj);
}

// Transformar processos para formato do sistema dinamico
const registrosTransformados = jornadasData.processos.map((processo, index) => {
    return {
        // Campos basicos
        nome: processo.nome,
        icone: processo.icone || '🔄',
        ordem: processo.ordem || (index + 1),
        status: processo.status || 'Pendente',

        // AS-IS
        as_is: processo.asIs?.descricao || processo.asIs?.descrição || '',
        passos_as_is: arrayToDelimited(processo.asIs?.passos),
        problemas_as_is: arrayToDelimited(processo.asIs?.problemas),
        tempo_medio_as_is: processo.asIs?.tempoMedio || processo.asIs?.tempoMédio || '',

        // TO-BE
        to_be: processo.toBe?.descricao || processo.toBe?.descrição || '',
        passos_to_be: arrayToDelimited(processo.toBe?.passos),
        beneficios_to_be: arrayToDelimited(processo.toBe?.beneficios || processo.toBe?.benefícios),
        tempo_medio_to_be: processo.toBe?.tempoMedio || processo.toBe?.tempoMédio || '',

        // Metadados texto
        areas_impactadas: arrayToDelimited(processo.areasImpactadas || processo.áreasImpactadas),
        sistemas_tecnicos: arrayToDelimited(processo.sistemasTecnicos || processo.sistemasTécnicos),
        fonte_reuniao: processo.fonteReuniao || processo.fonteReunião || '',
        pendencias: arrayToDelimited(processo.pendencias || processo.pendências),
        prerequisitos: arrayToDelimited(processo.prerequisitos || processo['pré-requisitos']),

        // Novos campos JSON ricos
        fontes_reuniao: arrayToDelimited(processo.fontesReuniao || processo.fontesReunião),
        tipos_conta: toJson(processo.tiposConta),
        campos_processo: toJson(processo.campos),
        regras_negocio: toJson(processo.regrasNegocio || processo.regrasNegócio),
        integracoes: toJson(processo.integracoes || processo.integrações),
        ciclos_teste: toJson(processo.ciclosTeste),
        abas_interface: toJson(processo.abasInterface),
        mensagens_sistema: toJson(processo.mensagensSistema),
        participantes_reuniao: toJson(processo.participantesReuniao || processo.participantesReunião),
        detalhes: toJson(processo.detalhes),
        detalhes_tecnicos: toJson(processo.detalhesTecnicos || processo.detalhesTécnicos)
    };
});

// Gerar arquivo JSON de importacao
const outputPath = path.join(__dirname, '..', 'data', 'jornadas-import.json');
const importData = {
    registros: registrosTransformados,
    modo: 'inserir'
};

fs.writeFileSync(outputPath, JSON.stringify(importData, null, 2), 'utf-8');

console.log('='.repeat(60));
console.log('MIGRACAO DE JORNADAS - GTM Clone');
console.log('='.repeat(60));
console.log(`Total de jornadas transformadas: ${registrosTransformados.length}`);
console.log(`Arquivo de importacao gerado: ${outputPath}`);
console.log('');
console.log('Jornadas transformadas:');
registrosTransformados.forEach((j, i) => {
    console.log(`  ${i + 1}. ${j.nome} (${j.status})`);
});
console.log('');
console.log('Para importar, use a API:');
console.log('POST /api/projetos/5/dados/jornadas/import');
console.log('Body: conteudo do arquivo jornadas-import.json');
console.log('='.repeat(60));

// Exportar para uso em outros scripts
module.exports = { registrosTransformados, importData };
