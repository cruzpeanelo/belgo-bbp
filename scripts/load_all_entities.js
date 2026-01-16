/**
 * Script unificado para carga das 6 entidades restantes
 * FASE 26 - Paridade completa com GTM Clone
 *
 * Entidades:
 * - Timeline: 5 fases
 * - Reunioes: 9 reunioes
 * - Documentos: 69 documentos
 * - Cronograma: workshops + marcos
 * - Glossario: 72 termos
 * - Pontos Criticos: 14 issues
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const dataDir = path.join(__dirname, '..', 'data');

function escapeSQL(str) {
  if (typeof str !== 'string') return str;
  return str.replace(/'/g, "''");
}

// =====================================================
// TRANSFORMADORES POR ENTIDADE
// =====================================================

function transformTimeline(jsonData) {
  const records = [];

  // Cada fase vira um registro
  if (jsonData.fases && Array.isArray(jsonData.fases)) {
    jsonData.fases.forEach((fase, idx) => {
      const record = {
        nome: fase.nome,
        tipo: 'fase',
        periodo: fase.período || fase.periodo || '',
        status: fase.status || 'planejado',
        ordem: idx + 1
      };

      // Marcos como JSON array
      if (fase.marcos && Array.isArray(fase.marcos)) {
        record.marcos = fase.marcos;
      }

      records.push(record);
    });
  }

  // Adicionar stakeholders como registros separados
  if (jsonData.stakeholders && Array.isArray(jsonData.stakeholders)) {
    jsonData.stakeholders.forEach((sh, idx) => {
      records.push({
        nome: sh.nome,
        tipo: 'stakeholder',
        papel: sh.papel || '',
        area: sh.area || '',
        ordem: 100 + idx
      });
    });
  }

  // Adicionar proximos passos
  if (jsonData.próximosPassos && Array.isArray(jsonData.próximosPassos)) {
    jsonData.próximosPassos.forEach((p, idx) => {
      records.push({
        nome: p.descrição || p.descricao || '',
        tipo: 'proximo_passo',
        prioridade: p.prioridade || idx + 1,
        prazo: p.prazo || '',
        ordem: 200 + idx
      });
    });
  }

  return records;
}

function transformReunioes(jsonData) {
  const records = [];

  if (jsonData.reunioes && Array.isArray(jsonData.reunioes)) {
    jsonData.reunioes.forEach(r => {
      const record = {
        id: r.id,
        data: r.data,
        titulo: r.titulo,
        duracao: r.duracao || '',
        tipo: r.tipo || 'reuniao',
        resumo: r.resumo || ''
      };

      // Arrays para pipe-delimited
      if (r.participantes && Array.isArray(r.participantes)) {
        record.participantes = r.participantes.join('|');
      }
      if (r.topicosAbordados && Array.isArray(r.topicosAbordados)) {
        record.topicos = r.topicosAbordados.join('|');
      }
      if (r.decisoes && Array.isArray(r.decisoes)) {
        record.decisoes = r.decisoes.join('|');
      }
      if (r.problemas && Array.isArray(r.problemas)) {
        record.problemas = r.problemas.join('|');
      }
      if (r.jornadasRelacionadas && Array.isArray(r.jornadasRelacionadas)) {
        record.jornadas_relacionadas = r.jornadasRelacionadas.join('|');
      }

      // Acoes como JSON
      if (r.acoes && Array.isArray(r.acoes)) {
        record.acoes = r.acoes;
      }

      records.push(record);
    });
  }

  return records;
}

function transformDocumentos(jsonData) {
  const records = [];

  if (jsonData.documentos && Array.isArray(jsonData.documentos)) {
    jsonData.documentos.forEach(doc => {
      records.push({
        id: doc.id,
        codigo: doc.id,
        nome: doc.arquivo,
        arquivo: doc.arquivo,
        resumo: doc.resumo || '',
        descricao: doc.resumo || '',
        categoria: doc.categoria || 'outros',
        status: doc.status || 'extraido',
        total_paragrafos: doc.total_paragrafos || 0,
        total_tabelas: doc.total_tabelas || 0,
        tamanho: `${doc.total_paragrafos || 0} parágrafos`,
        tabelas: doc.total_tabelas || 0
      });
    });
  }

  return records;
}

function transformCronograma(jsonData) {
  const records = [];

  // Workshops
  if (jsonData.workshops && Array.isArray(jsonData.workshops)) {
    jsonData.workshops.forEach(w => {
      const record = {
        id: w.id,
        tipo: 'workshop',
        data: w.data,
        titulo: w.título || w.titulo || '',
        status: w.status || 'Pendente',
        participantes: w.participantes || ''
      };

      if (w.foco && Array.isArray(w.foco)) {
        record.foco = w.foco.join('|');
      }
      if (w.problemasIdentificados && Array.isArray(w.problemasIdentificados)) {
        record.problemas = w.problemasIdentificados.join('|');
      }
      if (w.destaques) {
        record.destaques = Array.isArray(w.destaques) ? w.destaques.join('|') : w.destaques;
      }
      if (w.feedbackMaria) {
        record.feedback = w.feedbackMaria;
      }

      records.push(record);
    });
  }

  // Marcos
  if (jsonData.marcos && Array.isArray(jsonData.marcos)) {
    jsonData.marcos.forEach(m => {
      records.push({
        id: `M${records.length + 1}`,
        tipo: 'marco',
        data: m.data,
        titulo: m.título || m.titulo || '',
        status: m.status || 'Pendente'
      });
    });
  }

  return records;
}

function transformGlossario(jsonData) {
  const records = [];

  if (jsonData.categorias) {
    Object.entries(jsonData.categorias).forEach(([categoria, termos]) => {
      if (Array.isArray(termos)) {
        termos.forEach(termo => {
          // Normalizar nome da categoria
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

function transformPontosCriticos(jsonData) {
  const records = [];

  if (jsonData.issues && Array.isArray(jsonData.issues)) {
    jsonData.issues.forEach(issue => {
      records.push({
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
      });
    });
  }

  return records;
}

// =====================================================
// FUNÇÕES DE EXECUÇÃO
// =====================================================

function executeSQLFile(sqlContent, filename) {
  const sqlFile = path.join(__dirname, '..', filename);
  fs.writeFileSync(sqlFile, sqlContent, 'utf8');

  try {
    execSync(`npx wrangler d1 execute belgo-bbp-db --remote --file=${filename}`, {
      cwd: path.join(__dirname, '..'),
      stdio: 'pipe'
    });
    return true;
  } catch (error) {
    console.error(`Erro executando ${filename}:`, error.message);
    return false;
  } finally {
    // Cleanup
    if (fs.existsSync(sqlFile)) {
      fs.unlinkSync(sqlFile);
    }
  }
}

function loadEntity(entityCode, records, deleteFirst = true) {
  console.log(`\n=== Carregando ${entityCode}: ${records.length} registros ===`);

  let sql = `-- Carga de ${entityCode}\n`;

  if (deleteFirst) {
    sql += `DELETE FROM projeto_dados WHERE projeto_id = 5 AND entidade_id = (SELECT id FROM projeto_entidades WHERE codigo = '${entityCode}' AND projeto_id = 5);\n\n`;
  }

  records.forEach((record, idx) => {
    const jsonString = JSON.stringify(record);
    const escapedJson = escapeSQL(jsonString);
    sql += `INSERT INTO projeto_dados (projeto_id, entidade_id, dados) SELECT 5, id, '${escapedJson}' FROM projeto_entidades WHERE codigo = '${entityCode}' AND projeto_id = 5;\n`;
  });

  const success = executeSQLFile(sql, `temp_load_${entityCode}.sql`);
  if (success) {
    console.log(`  ✓ ${records.length} registros carregados em ${entityCode}`);
  } else {
    console.log(`  ✗ Erro ao carregar ${entityCode}`);
  }

  return success;
}

// =====================================================
// MAIN
// =====================================================

async function main() {
  console.log('=========================================');
  console.log('FASE 26 - Carga das 6 Entidades');
  console.log('=========================================');

  const results = {};

  // 1. Timeline
  try {
    const timelineData = JSON.parse(fs.readFileSync(path.join(dataDir, 'timeline.json'), 'utf8'));
    const timelineRecords = transformTimeline(timelineData);
    results.timeline = loadEntity('timeline', timelineRecords);
  } catch (e) {
    console.error('Erro em timeline:', e.message);
    results.timeline = false;
  }

  // 2. Reunioes
  try {
    const reunioesData = JSON.parse(fs.readFileSync(path.join(dataDir, 'reunioes.json'), 'utf8'));
    const reunioesRecords = transformReunioes(reunioesData);
    results.reunioes = loadEntity('reunioes', reunioesRecords);
  } catch (e) {
    console.error('Erro em reunioes:', e.message);
    results.reunioes = false;
  }

  // 3. Documentos
  try {
    const documentosData = JSON.parse(fs.readFileSync(path.join(dataDir, 'documentos', '_index.json'), 'utf8'));
    const documentosRecords = transformDocumentos(documentosData);
    results.documentos = loadEntity('documentos', documentosRecords);
  } catch (e) {
    console.error('Erro em documentos:', e.message);
    results.documentos = false;
  }

  // 4. Cronograma
  try {
    const cronogramaData = JSON.parse(fs.readFileSync(path.join(dataDir, 'cronograma.json'), 'utf8'));
    const cronogramaRecords = transformCronograma(cronogramaData);
    results.cronograma = loadEntity('cronograma', cronogramaRecords);
  } catch (e) {
    console.error('Erro em cronograma:', e.message);
    results.cronograma = false;
  }

  // 5. Glossario
  try {
    const glossarioData = JSON.parse(fs.readFileSync(path.join(dataDir, 'glossario.json'), 'utf8'));
    const glossarioRecords = transformGlossario(glossarioData);
    results.glossario = loadEntity('glossario', glossarioRecords);
  } catch (e) {
    console.error('Erro em glossario:', e.message);
    results.glossario = false;
  }

  // 6. Pontos Criticos
  try {
    const pontosCriticosData = JSON.parse(fs.readFileSync(path.join(dataDir, 'pontos-criticos.json'), 'utf8'));
    const pontosCriticosRecords = transformPontosCriticos(pontosCriticosData);
    results.pontos_criticos = loadEntity('pontos-criticos', pontosCriticosRecords);
  } catch (e) {
    console.error('Erro em pontos-criticos:', e.message);
    results.pontos_criticos = false;
  }

  // Resumo
  console.log('\n=========================================');
  console.log('RESUMO DA CARGA');
  console.log('=========================================');
  Object.entries(results).forEach(([entity, success]) => {
    console.log(`${success ? '✓' : '✗'} ${entity}`);
  });

  const total = Object.keys(results).length;
  const succeeded = Object.values(results).filter(Boolean).length;
  console.log(`\nTotal: ${succeeded}/${total} entidades carregadas com sucesso`);
}

main().catch(console.error);
