// =====================================================
// BELGO BBP - CONFIG RENDERER
// Renderizador de paginas baseado em config_funcionalidades
// Preserva TODAS as funcionalidades existentes
// =====================================================

const ConfigRenderer = {
    config: null,
    entidade: null,
    dados: [],
    dadosFiltrados: [],
    projetoId: null,
    paginacao: { pagina: 1, itensPorPagina: 20 },
    filtros: {},
    containerId: 'pageContent',
    permissoes: null, // Permissoes do usuario carregadas via BelgoAuth

    // =====================================================
    // INICIALIZACAO
    // =====================================================
    async init(options) {
        this.projetoId = options.projetoId || localStorage.getItem('belgo_projeto_id') || 1;
        this.entidade = options.entidade;
        this.containerId = options.containerId || 'pageContent';
        this.campos = []; // Reset campos
        this.permissoes = null; // Reset permissoes

        // Carregar permissoes do usuario no projeto
        await this.carregarPermissoes();

        // Carregar config_funcionalidades
        if (this.entidade?.config_funcionalidades) {
            try {
                this.config = typeof this.entidade.config_funcionalidades === 'string'
                    ? JSON.parse(this.entidade.config_funcionalidades)
                    : this.entidade.config_funcionalidades;
            } catch (e) {
                console.error('Erro ao parsear config:', e);
                this.config = {};
            }
        }

        // Configurar paginacao
        if (this.config?.paginacao?.itens_por_pagina) {
            this.paginacao.itensPorPagina = this.config.paginacao.itens_por_pagina;
        }

        // Carregar campos da entidade (para criar/exportar) - se usuario tem permissao
        if (this.podeCriar() || this.podeExportar()) {
            await this.carregarCampos();
        }

        // Carregar dados
        await this.carregarDados();

        // Inicializar ActionEngine (se disponivel)
        if (typeof ActionEngine !== 'undefined') {
            await ActionEngine.init({
                projetoId: this.projetoId,
                entidadeId: this.entidade?.id,
                entidadeCodigo: this.entidade?.codigo,
                permissoes: this.permissoes
            });

            // Escutar eventos de acao executada para atualizar
            window.addEventListener('actionExecuted', async () => {
                await this.carregarDados();
                this.render();
            });
        }

        // Renderizar
        this.render();

        // Setup responsividade
        this.setupResponsivo();
    },

    // =====================================================
    // PERMISSOES
    // =====================================================
    async carregarPermissoes() {
        // Tentar usar BelgoAuth se disponivel
        if (typeof BelgoAuth !== 'undefined' && BelgoAuth.getPermissoes) {
            try {
                this.permissoes = await BelgoAuth.getPermissoes(this.projetoId);
            } catch (e) {
                console.warn('Erro ao carregar permissoes:', e);
                this.permissoes = null;
            }
        }
    },

    /**
     * Verifica se usuario pode criar na entidade atual
     */
    podeCriar() {
        // Primeiro verifica se a entidade permite criar
        if (!this.entidade?.permite_criar) return false;

        // Se nao tem permissoes carregadas, usar permissao da entidade
        if (!this.permissoes) return true;

        // Admin tem todas as permissoes
        if (this.permissoes.isAdmin || this.permissoes.isAdminGlobal) return true;

        // Verificar permissao especifica da entidade
        const codigo = this.entidade?.codigo;
        if (codigo && this.permissoes.permissoes) {
            return this.permissoes.permissoes.includes(`${codigo}.criar`);
        }

        // Fallback para permissao geral
        return this.permissoes.pode?.criar || false;
    },

    /**
     * Verifica se usuario pode editar na entidade atual
     */
    podeEditar() {
        if (!this.entidade?.permite_editar) return false;
        if (!this.permissoes) return true;
        if (this.permissoes.isAdmin || this.permissoes.isAdminGlobal) return true;

        const codigo = this.entidade?.codigo;
        if (codigo && this.permissoes.permissoes) {
            return this.permissoes.permissoes.includes(`${codigo}.editar`);
        }
        return this.permissoes.pode?.editar || false;
    },

    /**
     * Verifica se usuario pode excluir na entidade atual
     */
    podeExcluir() {
        if (!this.entidade?.permite_excluir) return false;
        if (!this.permissoes) return true;
        if (this.permissoes.isAdmin || this.permissoes.isAdminGlobal) return true;

        const codigo = this.entidade?.codigo;
        if (codigo && this.permissoes.permissoes) {
            return this.permissoes.permissoes.includes(`${codigo}.excluir`);
        }
        return this.permissoes.pode?.excluir || false;
    },

    /**
     * Verifica se usuario pode exportar na entidade atual
     */
    podeExportar() {
        if (!this.entidade?.permite_exportar) return false;
        if (!this.permissoes) return true;
        if (this.permissoes.isAdmin || this.permissoes.isAdminGlobal) return true;

        const codigo = this.entidade?.codigo;
        if (codigo && this.permissoes.permissoes) {
            return this.permissoes.permissoes.includes(`${codigo}.exportar`);
        }
        return this.permissoes.pode?.exportar || false;
    },

    /**
     * Verifica se usuario pode importar na entidade atual
     */
    podeImportar() {
        if (!this.entidade?.permite_importar) return false;
        if (!this.permissoes) return true;
        if (this.permissoes.isAdmin || this.permissoes.isAdminGlobal) return true;

        const codigo = this.entidade?.codigo;
        if (codigo && this.permissoes.permissoes) {
            return this.permissoes.permissoes.includes(`${codigo}.importar`);
        }
        return this.permissoes.pode?.importar || false;
    },

    // =====================================================
    // CARREGAR DADOS DA API
    // =====================================================
    async carregarDados() {
        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(`/api/projetos/${this.projetoId}/dados/${this.entidade.codigo}?limit=1000`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) throw new Error('Erro ao carregar dados');

            const result = await response.json();
            // Extrair dados - a API ja retorna os dados expandidos
            this.dados = (result.dados || []).map(r => ({
                _id: r.id,
                _meta: r._meta,
                ...r  // dados ja estao expandidos no objeto
            }));
            this.dadosFiltrados = [...this.dados];

        } catch (error) {
            console.error('Erro ao carregar dados:', error);
            this.dados = [];
            this.dadosFiltrados = [];
        }
    },

    // =====================================================
    // RENDER PRINCIPAL
    // =====================================================
    render() {
        const container = document.getElementById(this.containerId);
        if (!container) return;

        this.aplicarFiltros();

        const layout = this.config?.layout || 'tabela';

        container.innerHTML = `
            <div class="config-page">
                ${this.renderHeader()}
                ${this.renderFiltros()}
                ${this.config?.metricas?.habilitado ? this.renderMetricas() : ''}
                <div id="dataContainer" class="data-container">
                    ${this.renderDados(layout)}
                </div>
                ${this.config?.paginacao?.habilitado ? this.renderPaginacao() : ''}
            </div>
            ${this.config?.modal_detalhe?.habilitado ? this.renderModalTemplate() : ''}
        `;

        this.setupEventListeners();
    },

    // =====================================================
    // RENDER HEADER
    // =====================================================
    renderHeader() {
        const acoes = [];

        // Botao de adicionar (se usuario pode criar)
        if (this.podeCriar()) {
            acoes.push(`<button class="btn btn-success" onclick="ConfigRenderer.abrirModalCriar()">➕ Adicionar</button>`);
        }

        // Botao de exportar (se usuario pode exportar)
        if (this.podeExportar()) {
            acoes.push(`<button class="btn btn-primary" onclick="ConfigRenderer.exportarCSV()">📥 Exportar</button>`);
        }

        // Botao de importar (se usuario pode importar)
        if (this.podeImportar()) {
            acoes.push(`<button class="btn btn-secondary" onclick="ConfigRenderer.abrirModalImportar()">📤 Importar</button>`);
        }

        // Mostrar papel do usuario (se disponivel)
        const papelBadge = this.permissoes?.papel
            ? `<span class="badge-papel" style="background: ${this.permissoes.papel.cor || '#666'}; color: white; margin-left: 8px; padding: 2px 8px; border-radius: 4px; font-size: 11px;">${this.permissoes.papel.nome}</span>`
            : '';

        return `
            <div class="page-header">
                <div class="page-title">
                    <span class="page-icon">${this.entidade?.icone || '📋'}</span>
                    <h2>${this.entidade?.nome_plural || 'Dados'}</h2>
                    <span class="badge-count">${this.dadosFiltrados.length} registros</span>
                    ${papelBadge}
                </div>
                <div class="page-actions">${acoes.join('')}</div>
            </div>
        `;
    },

    // =====================================================
    // RENDER FILTROS
    // =====================================================
    renderFiltros() {
        if (!this.config?.filtros?.habilitado) return '';

        const campos = this.config.filtros.campos || [];
        const tipo = this.config.filtros.tipo || 'campos';

        // Filtros por botoes
        if (tipo === 'botoes') {
            const opcoes = this.config.filtros.opcoes || [];
            return `
                <div class="filtros-container filtros-botoes">
                    ${opcoes.map(op => `
                        <button class="btn-filtro ${op.default ? 'active' : ''}"
                                data-valor="${op.valor}"
                                onclick="ConfigRenderer.filtrarPorBotao('${op.valor}')">
                            ${op.label}
                        </button>
                    `).join('')}
                </div>
            `;
        }

        // Filtros por campos
        return `
            <div class="filtros-container filtros-campos">
                ${campos.map(campo => this.renderCampoFiltro(campo)).join('')}
            </div>
        `;
    },

    renderCampoFiltro(campo) {
        switch (campo.tipo) {
            case 'select':
                const opcoes = this.getOpcoesFiltro(campo);
                return `
                    <div class="filter-group">
                        <label for="filter-${campo.campo}">${campo.label}</label>
                        <select id="filter-${campo.campo}" onchange="ConfigRenderer.aplicarFiltro('${campo.campo}', this.value)">
                            <option value="all">${campo.opcao_todos || 'Todos'}</option>
                            ${opcoes.map(op => `<option value="${op}">${op}</option>`).join('')}
                        </select>
                    </div>
                `;
            case 'text':
                return `
                    <div class="filter-group">
                        <label for="filter-${campo.campo}">${campo.label}</label>
                        <input type="text" id="filter-${campo.campo}"
                               placeholder="${campo.placeholder || 'Buscar...'}"
                               onkeyup="ConfigRenderer.debounce(() => ConfigRenderer.aplicarFiltro('${campo.campo}', this.value), 300)()">
                    </div>
                `;
            default:
                return '';
        }
    },

    getOpcoesFiltro(campo) {
        if (campo.opcoes) return campo.opcoes.filter(o => o !== 'Todos');
        if (campo.opcoes_de === 'dados') {
            const valores = [...new Set(this.dados.map(d => d[campo.campo_opcoes || campo.campo]).filter(Boolean))];
            return valores.sort();
        }
        return [];
    },

    // =====================================================
    // RENDER METRICAS
    // =====================================================
    renderMetricas() {
        const cards = this.config.metricas.cards || [];
        const gridClass = this.isMobile() ? 'metricas-grid-2' : 'metricas-grid-4';

        return `
            <div class="metrics-grid ${gridClass}" id="metricsContainer">
                ${cards.map(card => this.renderMetricCard(card)).join('')}
            </div>
        `;
    },

    renderMetricCard(card) {
        const valor = this.calcularMetrica(card);
        const corClass = card.cor || 'blue';

        return `
            <div class="metric-card">
                <div class="metric-icon ${corClass}">${card.icone || '📊'}</div>
                <div class="metric-info">
                    <h3>${valor}</h3>
                    <p>${card.label}</p>
                </div>
            </div>
        `;
    },

    calcularMetrica(card) {
        const dados = this.dadosFiltrados;

        switch (card.tipo) {
            case 'total':
                return dados.length;
            case 'contador':
                return dados.filter(d => d[card.campo] === card.valor).length;
            case 'distinct':
                if (Array.isArray(dados[0]?.[card.campo])) {
                    const all = dados.flatMap(d => d[card.campo] || []);
                    return new Set(all).size;
                }
                return new Set(dados.map(d => d[card.campo]).filter(Boolean)).size;
            case 'soma_array':
                return dados.reduce((sum, d) => sum + (d[card.campo]?.length || 0), 0);
            default:
                return 0;
        }
    },

    // FASE 12 P1: Render métricas de agregação (stats no topo com contagem por campo)
    renderMetricasAgregacao(campo, titulo) {
        const dados = this.dadosFiltrados;
        const contagem = {};

        dados.forEach(d => {
            const valor = d[campo] || 'Outros';
            contagem[valor] = (contagem[valor] || 0) + 1;
        });

        const entries = Object.entries(contagem).sort((a, b) => b[1] - a[1]);

        return `
            <div class="stats-agregacao">
                <div class="stat-card">
                    <div class="stat-valor">${dados.length}</div>
                    <div class="stat-label">Total</div>
                </div>
                ${entries.slice(0, 5).map(([valor, count]) => `
                    <div class="stat-card">
                        <div class="stat-valor">${count}</div>
                        <div class="stat-label">${this.escapeHTML(valor)}</div>
                    </div>
                `).join('')}
            </div>
        `;
    },

    // =====================================================
    // RENDER DADOS (TABELA ou CARDS)
    // =====================================================
    renderDados(layout) {
        if (this.dadosFiltrados.length === 0) {
            return `
                <div class="empty-state">
                    <span class="empty-icon">${this.entidade?.icone || '📋'}</span>
                    <h3>Nenhum registro encontrado</h3>
                    <p>Ajuste os filtros ou adicione novos registros.</p>
                </div>
            `;
        }

        // Aplicar paginacao
        const inicio = (this.paginacao.pagina - 1) * this.paginacao.itensPorPagina;
        const fim = inicio + this.paginacao.itensPorPagina;
        const dadosPaginados = this.dadosFiltrados.slice(inicio, fim);

        switch (layout) {
            case 'tabela':
                return this.isMobile() ? this.renderCardsMobile(dadosPaginados) : this.renderTabela(dadosPaginados);
            case 'cards':
                return this.renderCards(dadosPaginados);
            case 'cards_grid':
                return this.renderCardsGrid(dadosPaginados);
            case 'cards_agrupados':
                return this.renderCardsAgrupados();
            case 'timeline':
                return this.renderTimeline(dadosPaginados);
            default:
                return this.renderTabela(dadosPaginados);
        }
    },

    // =====================================================
    // RENDER TABELA
    // =====================================================
    renderTabela(dados) {
        // Usar colunas do config ou gerar automaticamente dos campos da entidade
        let colunas = this.config?.tabela?.colunas || [];

        // Se nao tem config de colunas, gerar a partir dos campos carregados
        if (colunas.length === 0 && this.campos.length > 0) {
            colunas = this.campos
                .filter(c => c.visivel_listagem !== 0)
                .map(c => ({
                    campo: c.codigo,
                    label: c.nome,
                    tipo: c.tipo === 'select' ? 'badge' : 'text',
                    largura: c.largura_coluna || 'auto'
                }));
        }

        // Se ainda nao tem colunas, extrair dos dados
        if (colunas.length === 0 && dados.length > 0) {
            colunas = Object.keys(dados[0])
                .filter(k => !k.startsWith('_'))
                .map(k => ({ campo: k, label: k, tipo: 'text' }));
        }

        const acoes = this.config?.tabela?.acoes || [];

        return `
            <div class="table-container tabela-dinamica">
                <table>
                    <thead>
                        <tr>
                            ${colunas.map(col => `
                                <th style="${col.largura ? `width: ${col.largura}` : ''}">${col.label}</th>
                            `).join('')}
                            ${acoes.length > 0 ? '<th style="width: 120px;">Acoes</th>' : ''}
                        </tr>
                    </thead>
                    <tbody>
                        ${dados.map((row, idx) => `
                            <tr data-idx="${idx}">
                                ${colunas.map(col => `
                                    <td>${this.renderCelula(row, col)}</td>
                                `).join('')}
                                ${acoes.length > 0 ? `<td>${this.renderAcoes(row, acoes)}</td>` : ''}
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        `;
    },

    renderCelula(row, col) {
        const valor = row[col.campo];
        if (valor === null || valor === undefined) return '-';

        // Badge para status
        if (col.tipo === 'badge') {
            const classe = this.getBadgeClass(valor);
            return `<span class="badge ${classe}">${this.escapeHTML(valor)}</span>`;
        }

        // Estilo secundario
        if (col.estilo === 'secundario') {
            return `<span style="color: #6b7280; font-size: 0.85rem;">${this.escapeHTML(valor)}</span>`;
        }

        // Negrito
        if (col.negrito) {
            return `<strong>${this.escapeHTML(valor)}</strong>`;
        }

        return this.escapeHTML(String(valor));
    },

    renderAcoes(row, acoes) {
        // Se ActionEngine estiver disponivel e tiver acoes carregadas, usar ele
        if (typeof ActionEngine !== 'undefined' && ActionEngine.acoes && ActionEngine.acoes.length > 0) {
            return ActionEngine.renderBotoes('linha', row, { tamanho: 'sm', mostrarNome: false });
        }

        // Fallback para acoes do config (compatibilidade)
        return acoes.map(acao => {
            switch (acao) {
                case 'ver':
                    return `<button class="btn btn-primary btn-sm" onclick="ConfigRenderer.verDetalhe('${row.codigo || row._id}')">Ver</button>`;
                case 'marcar_concluido':
                    if (row.status === 'Pendente') {
                        return `<button class="btn btn-success btn-sm" onclick="ConfigRenderer.marcarStatus('${row.codigo || row._id}', 'Concluido')">OK</button>`;
                    }
                    return '';
                case 'teams':
                    return `<button class="btn btn-teams btn-sm" onclick="ConfigRenderer.compartilharTeams('${row.codigo || row._id}')" title="Compartilhar no Teams">📤</button>`;
                default:
                    return '';
            }
        }).join(' ');
    },

    // =====================================================
    // RENDER CARDS MOBILE
    // =====================================================
    renderCardsMobile(dados) {
        const colunas = this.config?.tabela?.colunas || [];
        const acoes = this.config?.tabela?.acoes || [];

        return `
            <div class="cards-mobile">
                ${dados.map((row, idx) => `
                    <div class="card-mobile" data-idx="${idx}">
                        <div class="card-mobile-header">
                            <strong>${this.escapeHTML(row[colunas[0]?.campo] || '')}</strong>
                            ${row.status ? `<span class="badge ${this.getBadgeClass(row.status)}">${row.status}</span>` : ''}
                        </div>
                        <div class="card-mobile-body">
                            ${colunas.slice(1).map(col => `
                                <div class="card-mobile-field">
                                    <span class="field-label">${col.label}:</span>
                                    <span class="field-value">${this.escapeHTML(row[col.campo] || '-')}</span>
                                </div>
                            `).join('')}
                        </div>
                        <div class="card-mobile-actions">
                            ${this.renderAcoes(row, acoes)}
                        </div>
                    </div>
                `).join('')}
            </div>
        `;
    },

    // =====================================================
    // RENDER CARDS (Jornadas - com secoes comparativas)
    // =====================================================
    renderCards(dados) {
        const cardConfig = this.config?.card || {};
        const header = cardConfig.header || [];
        const secoes = cardConfig.secoes || [];
        const acoes = cardConfig.acoes || [];
        const expandedByDefault = cardConfig.expanded === true;

        return `
            <div class="cards-expandable">
                ${dados.map((row, idx) => `
                    <div class="card-expandable ${expandedByDefault ? 'expanded' : ''}" data-idx="${idx}">
                        <div class="card-expandable-header" onclick="ConfigRenderer.toggleCardExpand(${idx})">
                            <div class="card-header-left">
                                ${header.includes('icone') && row.icone ? `<span class="card-icone">${row.icone}</span>` : ''}
                                ${header.includes('nome') ? `<h4 class="card-nome">${this.escapeHTML(row.nome || '')}</h4>` : ''}
                            </div>
                            <div class="card-header-right">
                                ${header.includes('status') && row.status ? `<span class="badge ${this.getBadgeClass(row.status)}">${row.status}</span>` : ''}
                                <span class="expand-icon">▼</span>
                            </div>
                        </div>
                        <div class="card-expandable-body">
                            ${secoes.map(secao => this.renderSecaoCard(row, secao)).join('')}
                            <div class="card-expandable-actions">
                                ${acoes.includes('teams') ? `<button class="btn-teams btn-sm" onclick="event.stopPropagation(); ConfigRenderer.compartilharTeams('${this.escapeHTML(row.nome || '')}')">📤 Teams</button>` : ''}
                                ${this.entidade?.permite_editar ? `<button class="btn btn-sm btn-secondary" onclick="event.stopPropagation(); ConfigRenderer.abrirModalEditar(${row.id || row._id})">✏️ Editar</button>` : ''}
                                ${this.entidade?.permite_excluir ? `<button class="btn btn-sm btn-danger" onclick="event.stopPropagation(); ConfigRenderer.confirmarExcluir(${row.id || row._id}, '${this.escapeHTML(row.nome || '')}')">🗑️ Excluir</button>` : ''}
                            </div>
                        </div>
                    </div>
                `).join('')}
            </div>
        `;
    },

    renderSecaoCard(row, secao) {
        switch (secao.tipo) {
            case 'comparativo':
                const campos = secao.campos || [];
                const titulos = secao.titulos || ['Antes', 'Depois'];
                return `
                    <div class="secao-comparativo">
                        ${campos.map((campo, i) => `
                            <div class="comparativo-item">
                                <h5 class="comparativo-titulo">${titulos[i] || ''}</h5>
                                <div class="comparativo-conteudo">${this.escapeHTML(row[campo] || '-')}</div>
                            </div>
                        `).join('')}
                    </div>
                `;

            case 'comparativo_detalhado':
                // Seção comparativo completo com passos, problemas, benefícios, tempo
                const asIsConfig = secao.as_is || {};
                const toBeConfig = secao.to_be || {};
                return `
                    <div class="secao-comparativo-detalhado">
                        <div class="comparativo-lado as-is">
                            <div class="comparativo-header">
                                <span class="comparativo-badge as-is">AS-IS</span>
                                <span class="comparativo-subtitulo">${asIsConfig.subtitulo || 'Processo Atual'}</span>
                            </div>
                            <div class="comparativo-descricao">${this.escapeHTML(row[asIsConfig.descricao] || '-')}</div>
                            ${this.renderPassosNumerados(row[asIsConfig.passos], 'Passos do Processo')}
                            ${this.renderListaItens(row[asIsConfig.problemas], 'Problemas Identificados', 'problema')}
                            ${row[asIsConfig.tempo] ? `<div class="comparativo-tempo"><strong>⏱ Tempo Médio:</strong> ${this.escapeHTML(row[asIsConfig.tempo])}</div>` : ''}
                        </div>
                        <div class="comparativo-lado to-be">
                            <div class="comparativo-header">
                                <span class="comparativo-badge to-be">TO-BE</span>
                                <span class="comparativo-subtitulo">${toBeConfig.subtitulo || 'Processo Futuro'}</span>
                            </div>
                            <div class="comparativo-descricao">${this.escapeHTML(row[toBeConfig.descricao] || '-')}</div>
                            ${this.renderPassosNumerados(row[toBeConfig.passos], 'Passos do Processo')}
                            ${this.renderListaItens(row[toBeConfig.beneficios], 'Benefícios Esperados', 'beneficio')}
                            ${row[toBeConfig.tempo] ? `<div class="comparativo-tempo"><strong>⏱ Tempo Médio:</strong> ${this.escapeHTML(row[toBeConfig.tempo])}</div>` : ''}
                        </div>
                    </div>
                `;

            case 'passos_numerados':
                return this.renderPassosNumerados(row[secao.campo], secao.titulo);

            case 'badges':
                const badgesTexto = row[secao.campo] || '';
                const badges = typeof badgesTexto === 'string'
                    ? badgesTexto.split('\n').map(b => b.trim()).filter(b => b)
                    : (Array.isArray(badgesTexto) ? badgesTexto : []);
                if (badges.length === 0) return '';
                return `
                    <div class="secao-badges">
                        ${secao.titulo ? `<h5 class="secao-titulo">${secao.titulo}</h5>` : ''}
                        <div class="badges-container">
                            ${badges.map(badge => `<span class="badge-item ${secao.estilo || ''}">${this.escapeHTML(badge)}</span>`).join('')}
                        </div>
                    </div>
                `;

            case 'info_grid':
                const infos = secao.campos || [];
                const infosFiltradas = infos.filter(info => row[info.campo]);
                if (infosFiltradas.length === 0) return '';
                return `
                    <div class="secao-info-grid">
                        ${secao.titulo ? `<h5 class="secao-titulo">${secao.titulo}</h5>` : ''}
                        <div class="info-grid">
                            ${infosFiltradas.map(info => `
                                <div class="info-item">
                                    <span class="info-label">${info.icone || ''} ${info.label || info.campo}</span>
                                    <span class="info-valor">${this.escapeHTML(row[info.campo])}</span>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                `;

            case 'texto':
                return `<p class="secao-texto">${this.escapeHTML(row[secao.campo] || '')}</p>`;

            case 'lista':
                const lista = row[secao.campo];
                if (!Array.isArray(lista)) return '';
                return `
                    <div class="secao-lista">
                        <h5>${secao.titulo || ''}</h5>
                        <ul>${lista.map(item => `<li>${this.escapeHTML(item)}</li>`).join('')}</ul>
                    </div>
                `;

            // FASE 12 P1: Seção de Citações/Pain Points
            case 'citacoes':
                const citacoesTexto = row[secao.campo];
                const citacoes = typeof citacoesTexto === 'string'
                    ? citacoesTexto.split('\n').map(c => c.trim()).filter(c => c)
                    : (Array.isArray(citacoesTexto) ? citacoesTexto : []);
                if (citacoes.length === 0) return '';
                return `
                    <div class="secao-citacoes">
                        ${secao.titulo ? `<h5 class="secao-titulo">${secao.titulo}</h5>` : ''}
                        ${citacoes.map(citacao => `
                            <div class="citacao-item">
                                <span class="citacao-texto">${this.escapeHTML(citacao)}</span>
                            </div>
                        `).join('')}
                    </div>
                `;

            // FASE 12 P1: Tabela aninhada dentro de card
            case 'tabela':
                const tabelaDados = row[secao.campo];
                if (!tabelaDados || !Array.isArray(tabelaDados) || tabelaDados.length === 0) {
                    // Tentar parsear como JSON se for string
                    let dados = tabelaDados;
                    if (typeof tabelaDados === 'string') {
                        try { dados = JSON.parse(tabelaDados); } catch(e) { return ''; }
                    }
                    if (!Array.isArray(dados) || dados.length === 0) return '';
                }
                const colunas = secao.colunas || Object.keys(tabelaDados[0] || {});
                return `
                    <div class="secao-tabela">
                        ${secao.titulo ? `<h5 class="secao-titulo">${secao.titulo}</h5>` : ''}
                        <table class="tabela-aninhada">
                            <thead>
                                <tr>${colunas.map(col => `<th>${this.escapeHTML(col.label || col)}</th>`).join('')}</tr>
                            </thead>
                            <tbody>
                                ${(Array.isArray(tabelaDados) ? tabelaDados : []).map(linha => `
                                    <tr>${colunas.map(col => {
                                        const campo = col.campo || col;
                                        return `<td>${this.escapeHTML(linha[campo] || '')}</td>`;
                                    }).join('')}</tr>
                                `).join('')}
                            </tbody>
                        </table>
                    </div>
                `;

            default:
                return '';
        }
    },

    // Helper: Renderiza passos numerados a partir de texto com quebras de linha
    // Suporta estilo rico com círculos coloridos via config.card.passos_estilo_rico
    renderPassosNumerados(texto, titulo, estiloRico = true) {
        if (!texto) return '';
        const passos = typeof texto === 'string'
            ? texto.split('\n').map(p => p.trim()).filter(p => p)
            : (Array.isArray(texto) ? texto : []);
        if (passos.length === 0) return '';

        // Usar estilo rico por padrão (círculos coloridos)
        const listaClass = estiloRico ? 'passos-lista-rico' : 'passos-lista';
        const tag = estiloRico ? 'ul' : 'ol';

        return `
            <div class="passos-numerados">
                ${titulo ? `<h6 class="passos-titulo">${titulo}</h6>` : ''}
                <${tag} class="${listaClass}">
                    ${passos.map(passo => `<li>${this.escapeHTML(passo)}</li>`).join('')}
                </${tag}>
            </div>
        `;
    },

    // Helper: Renderiza lista de itens (problemas, benefícios, etc.)
    renderListaItens(texto, titulo, tipo) {
        if (!texto) return '';
        const itens = typeof texto === 'string'
            ? texto.split('\n').map(i => i.trim()).filter(i => i)
            : (Array.isArray(texto) ? texto : []);
        if (itens.length === 0) return '';
        const icone = tipo === 'problema' ? '⚠️' : (tipo === 'beneficio' ? '✅' : '•');
        return `
            <div class="lista-itens ${tipo || ''}">
                ${titulo ? `<h6 class="lista-titulo">${titulo}</h6>` : ''}
                <ul class="lista-conteudo">
                    ${itens.map(item => `<li><span class="item-icone">${icone}</span> ${this.escapeHTML(item)}</li>`).join('')}
                </ul>
            </div>
        `;
    },

    toggleCardExpand(idx) {
        const card = document.querySelector(`.card-expandable[data-idx="${idx}"]`);
        if (card) {
            card.classList.toggle('expanded');
        }
    },

    // =====================================================
    // RENDER CARDS GRID (Participantes)
    // =====================================================
    renderCardsGrid(dados) {
        const cardConfig = this.config?.card || {};
        const agrupamento = this.config?.agrupamento;

        // Se tem agrupamento, usar renderização agrupada com headers
        if (agrupamento) {
            return this.renderCardsGridAgrupado(dados, cardConfig, agrupamento);
        }

        return `
            <div class="cards-grid">
                ${dados.map(row => this.renderCard(row, cardConfig)).join('')}
            </div>
        `;
    },

    // Renderiza cards grid com headers de grupo (P0 - Fase 12)
    renderCardsGridAgrupado(dados, cardConfig, agrupamento) {
        const mostrarHeader = agrupamento.mostrar_header_grupo !== false; // Default true
        const campoGrupo = agrupamento.campo;
        const iconesPorGrupo = agrupamento.icones || {};
        const coresPorGrupo = agrupamento.cores || {};

        // Agrupar dados
        const grupos = {};
        dados.forEach(row => {
            const grupo = row[campoGrupo] || 'Outros';
            if (!grupos[grupo]) grupos[grupo] = [];
            grupos[grupo].push(row);
        });

        // Ordenar grupos se configurado
        let gruposOrdenados = Object.entries(grupos);
        if (agrupamento.ordem) {
            const ordemConfig = agrupamento.ordem;
            gruposOrdenados.sort((a, b) => {
                const idxA = ordemConfig.indexOf(a[0]);
                const idxB = ordemConfig.indexOf(b[0]);
                if (idxA === -1 && idxB === -1) return 0;
                if (idxA === -1) return 1;
                if (idxB === -1) return -1;
                return idxA - idxB;
            });
        }

        return `
            <div class="cards-grid-agrupado">
                ${gruposOrdenados.map(([grupo, items]) => {
                    const icone = iconesPorGrupo[grupo] || '👥';
                    const corClasse = this.getGrupoCorClasse(grupo);

                    return `
                        <div class="grupo-container-grid">
                            ${mostrarHeader ? `
                                <div class="grupo-header ${corClasse}">
                                    <div class="grupo-header-icon">${icone}</div>
                                    <div class="grupo-header-content">
                                        <h3 class="grupo-header-titulo">${this.escapeHTML(grupo)}</h3>
                                        <p class="grupo-header-count">${items.length} participante${items.length !== 1 ? 's' : ''}</p>
                                    </div>
                                </div>
                            ` : `
                                <h3 class="grupo-titulo">${this.escapeHTML(grupo)}</h3>
                            `}
                            <div class="cards-grid">
                                ${items.map(row => this.renderCard(row, cardConfig)).join('')}
                            </div>
                        </div>
                    `;
                }).join('')}
            </div>
        `;
    },

    // Helper para obter classe de cor do grupo
    getGrupoCorClasse(grupo) {
        const grupoLower = (grupo || '').toLowerCase();
        if (grupoLower.includes('key') || grupoLower.includes('usuario')) return 'key-users';
        if (grupoLower.includes('equipe') || grupoLower.includes('time')) return 'equipe';
        if (grupoLower.includes('stakeholder') || grupoLower.includes('gestor')) return 'stakeholder';
        return '';
    },

    renderCard(row, cardConfig) {
        const campos = cardConfig.campos || [];
        const avatar = cardConfig.avatar;
        const acoes = cardConfig.acoes || [];

        let avatarHtml = '';
        if (avatar) {
            const nome = row[avatar.campo] || '';
            const iniciais = nome.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
            const corClass = avatar.cor_por ? `avatar-${row[avatar.cor_por]}` : '';
            avatarHtml = `<div class="card-avatar ${corClass}">${iniciais}</div>`;
        }

        return `
            <div class="card-item">
                ${avatarHtml}
                <div class="card-content">
                    ${campos.map(c => this.renderCampoCard(row, c)).join('')}
                </div>
                <div class="card-actions">
                    ${acoes.includes('teams') ? `<button class="btn-teams btn-sm" onclick="ConfigRenderer.compartilharTeams('${row.nome || row._id}')">📤</button>` : ''}
                </div>
            </div>
        `;
    },

    renderCampoCard(row, campo) {
        const valor = row[campo.campo];
        if (campo.condicional && !valor) return '';

        switch (campo.estilo) {
            case 'titulo':
                return `<h4 class="card-titulo">${this.escapeHTML(valor || '')}</h4>`;
            case 'subtitulo':
                return `<p class="card-subtitulo">${this.escapeHTML(valor || '')}</p>`;
            case 'badge':
                return `<span class="badge badge-info">${this.escapeHTML(valor || '')}</span>`;
            case 'tags':
                if (Array.isArray(valor)) {
                    return `<div class="card-tags">${valor.map(v => `<span class="tag">${this.escapeHTML(v)}</span>`).join('')}</div>`;
                }
                return `<span class="tag">${this.escapeHTML(valor || '')}</span>`;
            case 'descricao':
                return `<p class="card-descricao">${this.escapeHTML(valor || '')}</p>`;
            default:
                return `<p>${this.escapeHTML(valor || '')}</p>`;
        }
    },

    // =====================================================
    // RENDER CARDS AGRUPADOS (Glossario)
    // =====================================================
    renderCardsAgrupados() {
        const agrupamento = this.config?.agrupamento;
        if (!agrupamento) return this.renderCardsGrid(this.dadosFiltrados);

        const grupos = {};
        this.dadosFiltrados.forEach(row => {
            const grupo = row[agrupamento.campo] || 'Outros';
            if (!grupos[grupo]) grupos[grupo] = [];
            grupos[grupo].push(row);
        });

        const cardConfig = this.config?.card || {};

        return Object.entries(grupos).map(([grupo, items]) => `
            <div class="grupo-container">
                <h3 class="grupo-titulo">${this.escapeHTML(grupo)}</h3>
                <div class="cards-grid">
                    ${items.map(row => this.renderCardGlossario(row, cardConfig)).join('')}
                </div>
            </div>
        `).join('');
    },

    renderCardGlossario(row, cardConfig) {
        const campos = cardConfig.campos || [];
        const acoes = cardConfig.acoes || [];

        return `
            <div class="term-card">
                ${campos.map(c => {
                    const valor = row[c.campo];
                    switch (c.estilo) {
                        case 'titulo':
                            return `<div class="term-sigla" style="color: ${c.cor || '#003B4A'}">${this.escapeHTML(valor || '')}</div>`;
                        case 'subtitulo':
                            return `<div class="term-nome">${this.escapeHTML(valor || '')}</div>`;
                        case 'descricao':
                            return `<div class="term-descricao">${this.escapeHTML(valor || '')}</div>`;
                        default:
                            return '';
                    }
                }).join('')}
                ${acoes.includes('teams') ? `
                    <button class="btn-teams btn-sm" onclick="ConfigRenderer.compartilharTeams('${row.sigla || row._id}')">📤</button>
                ` : ''}
            </div>
        `;
    },

    // =====================================================
    // RENDER TIMELINE (Reunioes)
    // =====================================================
    renderTimeline(dados) {
        const cardConfig = this.config?.card || {};

        return `
            <div class="timeline-container">
                ${dados.map((row, idx) => this.renderTimelineCard(row, idx, cardConfig)).join('')}
            </div>
        `;
    },

    renderTimelineCard(row, idx, cardConfig) {
        const header = cardConfig.header || [];
        const contadores = cardConfig.contadores || [];
        const expansivel = cardConfig.expansivel;
        const secoesExpandidas = cardConfig.secoes_expandidas || [];

        // Formatar data
        const dataFormatada = row.data ? new Date(row.data).toLocaleDateString('pt-BR') : '';

        return `
            <div class="reuniao-card ${expansivel ? 'expansivel' : ''}" data-idx="${idx}">
                <div class="reuniao-header" onclick="ConfigRenderer.toggleExpand(${idx})">
                    <span class="reuniao-data">${dataFormatada}</span>
                    <h4 class="reuniao-titulo">${this.escapeHTML(row.titulo || '')}</h4>
                    <div class="reuniao-contadores">
                        ${contadores.map(c => {
                            const valor = Array.isArray(row[c]) ? row[c].length : (row[c] || 0);
                            return `<span class="contador">${valor} ${c}</span>`;
                        }).join('')}
                    </div>
                    <button class="btn-teams btn-sm" onclick="event.stopPropagation(); ConfigRenderer.compartilharTeams('${row._id}')">📤</button>
                    ${expansivel ? '<span class="expand-arrow">▼</span>' : ''}
                </div>
                ${expansivel ? `
                    <div class="reuniao-detalhes" id="detalhes-${idx}" style="display: none;">
                        ${secoesExpandidas.map(secao => this.renderSecaoExpandida(row, secao)).join('')}
                    </div>
                ` : ''}
            </div>
        `;
    },

    renderSecaoExpandida(row, secao) {
        const valor = row[secao.campo];
        if (!valor || (Array.isArray(valor) && valor.length === 0)) return '';

        switch (secao.tipo) {
            case 'lista':
                if (!Array.isArray(valor)) return '';
                return `
                    <div class="secao-expandida">
                        <h5>${secao.icone || ''} ${secao.titulo}</h5>
                        <ul>${valor.map(v => `<li>${this.escapeHTML(typeof v === 'object' ? v.texto || v.nome : v)}</li>`).join('')}</ul>
                    </div>
                `;
            case 'grid_avatares':
                if (!Array.isArray(valor)) return '';
                return `
                    <div class="secao-expandida">
                        <h5>${secao.titulo}</h5>
                        <div class="avatares-grid">
                            ${valor.slice(0, 8).map(p => {
                                const nome = typeof p === 'object' ? p.nome : p;
                                const iniciais = nome.split(' ').map(n => n[0]).join('').substring(0, 2);
                                return `<div class="avatar-mini" title="${this.escapeHTML(nome)}">${iniciais}</div>`;
                            }).join('')}
                            ${valor.length > 8 ? `<span class="mais">+${valor.length - 8}</span>` : ''}
                        </div>
                    </div>
                `;
            case 'texto_longo':
                const texto = String(valor);
                const truncado = secao.truncar && texto.length > secao.truncar;
                return `
                    <div class="secao-expandida">
                        <h5>${secao.titulo}</h5>
                        <p class="texto-resumo">${this.escapeHTML(truncado ? texto.substring(0, secao.truncar) + '...' : texto)}</p>
                    </div>
                `;
            default:
                return '';
        }
    },

    toggleExpand(idx) {
        const detalhes = document.getElementById(`detalhes-${idx}`);
        const card = detalhes?.closest('.reuniao-card');
        if (detalhes) {
            const isHidden = detalhes.style.display === 'none';
            detalhes.style.display = isHidden ? 'block' : 'none';
            card?.classList.toggle('expanded', isHidden);
        }
    },

    // =====================================================
    // RENDER PAGINACAO
    // =====================================================
    renderPaginacao() {
        const total = this.dadosFiltrados.length;
        const totalPaginas = Math.ceil(total / this.paginacao.itensPorPagina);
        if (totalPaginas <= 1) return '';

        const { pagina } = this.paginacao;
        const inicio = (pagina - 1) * this.paginacao.itensPorPagina + 1;
        const fim = Math.min(pagina * this.paginacao.itensPorPagina, total);

        // Gerar botoes de pagina
        const maxBotoes = this.config?.paginacao?.max_botoes || 5;
        let startPage = Math.max(1, pagina - Math.floor(maxBotoes / 2));
        let endPage = Math.min(totalPaginas, startPage + maxBotoes - 1);
        if (endPage - startPage < maxBotoes - 1) {
            startPage = Math.max(1, endPage - maxBotoes + 1);
        }

        let botoesPagina = '';
        for (let i = startPage; i <= endPage; i++) {
            botoesPagina += `<button class="pagination-btn ${i === pagina ? 'active' : ''}" onclick="ConfigRenderer.irParaPagina(${i})">${i}</button>`;
        }

        return `
            <div class="pagination" id="paginacaoContainer">
                <button class="pagination-btn" onclick="ConfigRenderer.irParaPagina(1)" ${pagina === 1 ? 'disabled' : ''}>⟨⟨</button>
                <button class="pagination-btn" onclick="ConfigRenderer.irParaPagina(${pagina - 1})" ${pagina === 1 ? 'disabled' : ''}>⟨</button>
                ${botoesPagina}
                <button class="pagination-btn" onclick="ConfigRenderer.irParaPagina(${pagina + 1})" ${pagina === totalPaginas ? 'disabled' : ''}>⟩</button>
                <button class="pagination-btn" onclick="ConfigRenderer.irParaPagina(${totalPaginas})" ${pagina === totalPaginas ? 'disabled' : ''}>⟩⟩</button>
                <span class="pagination-info">${inicio}-${fim} de ${total}</span>
            </div>
        `;
    },

    irParaPagina(pagina) {
        const totalPaginas = Math.ceil(this.dadosFiltrados.length / this.paginacao.itensPorPagina);
        if (pagina < 1 || pagina > totalPaginas) return;
        this.paginacao.pagina = pagina;
        this.render();
        document.getElementById('dataContainer')?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    },

    // =====================================================
    // MODAL DE DETALHES
    // =====================================================
    renderModalTemplate() {
        return `
            <div class="modal-overlay" id="modal-detalhe" onclick="if(event.target === this) ConfigRenderer.fecharModal()">
                <div class="modal">
                    <div class="modal-header">
                        <h3 id="modal-titulo">Detalhe</h3>
                        <button class="modal-close" onclick="ConfigRenderer.fecharModal()">&times;</button>
                    </div>
                    <div class="modal-body" id="modal-body"></div>
                </div>
            </div>
        `;
    },

    verDetalhe(id) {
        const registro = this.dados.find(d => d.codigo === id || d._id === id || String(d._id) === String(id));
        if (!registro) return;

        const modalConfig = this.config?.modal_detalhe;
        if (!modalConfig) return;

        // Titulo
        let titulo = modalConfig.titulo || '{nome}';
        titulo = titulo.replace(/\{(\w+)\}/g, (_, campo) => registro[campo] || '');

        document.getElementById('modal-titulo').textContent = titulo;

        // Body
        const secoes = modalConfig.secoes || [];
        let bodyHtml = '';

        secoes.forEach(secao => {
            const valor = registro[secao.campo];

            switch (secao.tipo) {
                case 'header_status':
                    bodyHtml += `
                        <div style="margin-bottom: 20px;">
                            ${secao.campos.map(c => {
                                if (c === 'status') {
                                    return `<span class="badge ${this.getBadgeClass(registro.status)}">${this.escapeHTML(registro.status || '')}</span>`;
                                }
                                return `<span style="margin-left: 10px; color: #6b7280;">${this.escapeHTML(registro[c] || '')}</span>`;
                            }).join('')}
                        </div>
                    `;
                    break;
                case 'lista':
                    if (valor && (Array.isArray(valor) ? valor.length > 0 : valor)) {
                        const items = Array.isArray(valor) ? valor : valor.split('\n');
                        const tag = secao.ordenada ? 'ol' : 'ul';
                        bodyHtml += `
                            <h4 style="color: #003B4A; margin-bottom: 10px;">${secao.titulo}</h4>
                            <${tag} style="margin: 0 0 20px 20px; line-height: 1.8;">
                                ${items.map(item => `<li>${this.escapeHTML(item)}</li>`).join('')}
                            </${tag}>
                        `;
                    }
                    break;
                case 'bloco':
                    if (!secao.condicional || valor) {
                        let corFundo = '#f3f4f6';
                        if (secao.cor_status && registro.status) {
                            corFundo = registro.status === 'Falhou' ? '#fee2e2' : '#d1fae5';
                        } else if (secao.cor === 'warning') {
                            corFundo = '#fef3c7';
                        }
                        bodyHtml += `
                            <h4 style="color: #003B4A; margin-bottom: 10px;">${secao.titulo}</h4>
                            <div style="background: ${corFundo}; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                                ${this.escapeHTML(valor || '')}
                            </div>
                        `;
                    }
                    break;
            }
        });

        // Acoes do rodape
        const acoesRodape = modalConfig.acoes_rodape || [];
        if (acoesRodape.length > 0) {
            bodyHtml += `
                <div style="margin-top: 25px; padding-top: 20px; border-top: 1px solid #e5e7eb;">
                    ${acoesRodape.includes('marcar_concluido') ? `<button class="btn btn-success" onclick="ConfigRenderer.marcarStatus('${id}', 'Concluido'); ConfigRenderer.fecharModal();">✅ Marcar Concluido</button>` : ''}
                    ${acoesRodape.includes('marcar_falhou') ? `<button class="btn btn-danger" onclick="ConfigRenderer.marcarStatus('${id}', 'Falhou'); ConfigRenderer.fecharModal();">❌ Marcar Falhou</button>` : ''}
                    ${acoesRodape.includes('marcar_pendente') ? `<button class="btn" style="background: #f59e0b; color: white;" onclick="ConfigRenderer.marcarStatus('${id}', 'Pendente'); ConfigRenderer.fecharModal();">⏳ Marcar Pendente</button>` : ''}
                    ${acoesRodape.includes('teams') ? `<button class="btn" style="background: #6264A7; color: white; margin-left: 10px;" onclick="ConfigRenderer.compartilharTeams('${id}');">📤 Teams</button>` : ''}
                </div>
            `;
        }

        document.getElementById('modal-body').innerHTML = bodyHtml;
        document.getElementById('modal-detalhe').classList.add('active');
    },

    fecharModal() {
        document.getElementById('modal-detalhe')?.classList.remove('active');
    },

    // =====================================================
    // FILTROS
    // =====================================================
    aplicarFiltro(campo, valor) {
        if (valor === 'all' || valor === '') {
            delete this.filtros[campo];
        } else {
            this.filtros[campo] = valor;
        }
        this.paginacao.pagina = 1;
        this.render();
    },

    filtrarPorBotao(valor) {
        // Atualizar botoes ativos
        document.querySelectorAll('.btn-filtro').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.valor === valor);
        });

        if (valor === 'all') {
            this.filtros = {};
        } else {
            const opcao = this.config?.filtros?.opcoes?.find(o => o.valor === valor);
            if (opcao) {
                this.filtros = {};
                this.filtros._botao = { campo: opcao.filtro_campo, valor: valor, contem: opcao.contem };
            }
        }
        this.paginacao.pagina = 1;
        this.render();
    },

    aplicarFiltros() {
        this.dadosFiltrados = this.dados.filter(row => {
            // Filtros de campo
            for (const [campo, valor] of Object.entries(this.filtros)) {
                if (campo === '_botao') {
                    const filtro = valor;
                    const valorCampo = String(row[filtro.campo] || '').toLowerCase();
                    if (filtro.contem) {
                        if (!valorCampo.includes(filtro.valor.toLowerCase())) return false;
                    } else {
                        if (valorCampo !== filtro.valor.toLowerCase()) return false;
                    }
                    continue;
                }

                // Busca textual
                const configCampo = this.config?.filtros?.campos?.find(c => c.campo === campo);
                if (configCampo?.tipo === 'text' && configCampo?.campos_busca) {
                    const termoBusca = valor.toLowerCase();
                    const encontrou = configCampo.campos_busca.some(c =>
                        String(row[c] || '').toLowerCase().includes(termoBusca)
                    );
                    if (!encontrou) return false;
                } else if (row[campo] !== valor) {
                    return false;
                }
            }
            return true;
        });

        // Aplicar ordenacao
        const ordenacao = this.config?.ordenacao;
        if (ordenacao?.campo_padrao) {
            const campo = ordenacao.campo_padrao;
            const direcao = ordenacao.direcao_padrao === 'desc' ? -1 : 1;
            this.dadosFiltrados.sort((a, b) => {
                const va = a[campo];
                const vb = b[campo];
                if (va < vb) return -1 * direcao;
                if (va > vb) return 1 * direcao;
                return 0;
            });
        }
    },

    // =====================================================
    // ACOES
    // =====================================================
    async marcarStatus(id, novoStatus) {
        const registro = this.dados.find(d => d.codigo === id || d._id === id);
        if (!registro) return;

        // Confirmar se for "Falhou"
        if (novoStatus === 'Falhou' && this.config?.status_editavel?.confirmar_falhou) {
            if (!confirm(`Tem certeza que deseja marcar como "Falhou"?`)) return;
        }

        // Atualizar local
        registro.status = novoStatus;

        // Persistir
        if (this.config?.persistencia) {
            // localStorage
            if (this.config.persistencia.localStorage) {
                const key = `status_${this.entidade.codigo}_${id}`;
                localStorage.setItem(key, JSON.stringify({ status: novoStatus, data: new Date().toISOString() }));
            }

            // KV Sync (se configurado)
            if (this.config.persistencia.kvSync && this.config.persistencia.endpoint) {
                try {
                    const token = sessionStorage.getItem('belgo_token');
                    await fetch(this.config.persistencia.endpoint, {
                        method: 'POST',
                        headers: {
                            'Authorization': `Bearer ${token}`,
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ testes: [{ id, status: novoStatus }] })
                    });
                } catch (e) {
                    console.warn('Erro ao sincronizar status:', e);
                }
            }
        }

        this.showToast(`Status atualizado para "${novoStatus}"`, novoStatus === 'Concluido' ? 'success' : novoStatus === 'Falhou' ? 'error' : 'info');
        this.render();
    },

    compartilharTeams(id) {
        const registro = this.dados.find(d => d.codigo === id || d._id === id || d.sigla === id || d.nome === id);
        if (!registro) return;

        const teamsConfig = this.config?.teams;
        if (!teamsConfig?.habilitado) return;

        // Montar titulo
        let titulo = teamsConfig.titulo || `${this.entidade.icone} ${this.entidade.nome}: {nome}`;
        titulo = titulo.replace(/\{(\w+)\}/g, (_, campo) => registro[campo] || '');

        // Montar facts
        const facts = (teamsConfig.facts || []).map(campo => {
            const valor = registro[campo];
            if (!valor) return null;
            const label = campo.charAt(0).toUpperCase() + campo.slice(1).replace(/([A-Z])/g, ' $1');
            return { name: label, value: Array.isArray(valor) ? valor.join(', ') : String(valor) };
        }).filter(Boolean);

        // Abrir Teams antes do fetch (iOS Safari)
        if (typeof Utils !== 'undefined' && Utils.openTeamsChannel) {
            Utils.openTeamsChannel();
        }

        // Enviar card
        const card = {
            "@type": "MessageCard",
            "@context": "https://schema.org/extensions",
            "themeColor": "003B4A",
            "summary": titulo,
            "sections": [{
                "activityTitle": titulo,
                "facts": facts,
                "markdown": true
            }],
            "potentialAction": [{
                "@type": "OpenUri",
                "name": "Abrir no Cockpit",
                "targets": [{ "os": "default", "uri": window.location.href }]
            }]
        };

        if (typeof Utils !== 'undefined' && Utils.sendToTeams) {
            Utils.sendToTeams(card);
        }

        this.showToast('Compartilhado no Teams!', 'success');
    },

    exportarCSV() {
        if (!this.entidade?.permite_exportar) return;

        // Usar campos da entidade ou extrair dos dados
        let campos = [];
        if (this.campos.length > 0) {
            campos = this.campos.map(c => c.codigo);
        } else if (this.dados.length > 0) {
            campos = Object.keys(this.dados[0]).filter(k => !k.startsWith('_'));
        }

        if (campos.length === 0) {
            this.showToast('Nenhum campo para exportar', 'error');
            return;
        }

        // Header com nomes dos campos
        const headers = this.campos.length > 0
            ? this.campos.map(c => c.nome)
            : campos;
        let csv = headers.join(',') + '\n';

        // Dados
        this.dadosFiltrados.forEach(row => {
            const linha = campos.map(campo => {
                const valor = row[campo];
                if (valor === null || valor === undefined) return '';
                const str = String(valor).replace(/"/g, '""');
                return str.includes(',') || str.includes('"') || str.includes('\n') ? `"${str}"` : str;
            });
            csv += linha.join(',') + '\n';
        });

        // Download
        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        const nomeArquivo = `${this.entidade.codigo}_${new Date().toISOString().split('T')[0]}.csv`;
        link.href = URL.createObjectURL(blob);
        link.download = nomeArquivo;
        link.click();

        this.showToast('Exportacao realizada com sucesso!', 'success');
    },

    abrirModalImportar() {
        if (!this.entidade?.permite_importar) return;
        this.showToast('Funcionalidade de importacao em desenvolvimento', 'info');
    },

    // =====================================================
    // UTILITARIOS
    // =====================================================
    escapeHTML(str) {
        if (!str) return '';
        const div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    },

    getBadgeClass(status) {
        const statusLower = (status || '').toLowerCase();
        if (statusLower.includes('conclu') || statusLower === 'ok') return 'badge-success';
        if (statusLower.includes('pend') || statusLower === 'em andamento') return 'badge-warning';
        if (statusLower.includes('falh') || statusLower === 'erro') return 'badge-danger';
        return 'badge-info';
    },

    showToast(message, type = 'info') {
        if (typeof Utils !== 'undefined' && Utils.showToast) {
            Utils.showToast(message, type);
        } else {
            console.log(`[${type}] ${message}`);
        }
    },

    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    isMobile() {
        return window.innerWidth < (this.config?.responsivo?.mobile?.breakpoint || 768);
    },

    setupResponsivo() {
        let resizeTimeout;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(() => this.render(), 250);
        });
    },

    setupEventListeners() {
        // Fechar modal com ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') this.fecharModal();
        });
    },

    // =====================================================
    // CRIAR REGISTRO
    // =====================================================
    campos: [],

    async carregarCampos() {
        if (this.campos.length > 0) return this.campos;
        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(`/api/projetos/${this.projetoId}/entidades/${this.entidade.id}/campos`, {
                headers: { 'Authorization': `Bearer ${token}` }
            });
            if (response.ok) {
                const result = await response.json();
                this.campos = result.campos || [];
            }
        } catch (e) {
            console.error('Erro ao carregar campos:', e);
        }
        return this.campos;
    },

    async abrirModalCriar() {
        await this.carregarCampos();

        const modalHtml = `
            <div class="modal-overlay active" id="modalCriar" onclick="if(event.target === this) ConfigRenderer.fecharModalCriar()">
                <div class="modal-content modal-criar">
                    <div class="modal-header">
                        <h3>➕ Adicionar ${this.entidade?.nome || 'Registro'}</h3>
                        <button class="modal-close" onclick="ConfigRenderer.fecharModalCriar()">&times;</button>
                    </div>
                    <div class="modal-body">
                        <form id="formCriar" onsubmit="event.preventDefault(); ConfigRenderer.salvarNovoRegistro();">
                            ${this.renderCamposForm()}
                            <div class="form-actions">
                                <button type="button" class="btn btn-secondary" onclick="ConfigRenderer.fecharModalCriar()">Cancelar</button>
                                <button type="submit" class="btn btn-success">Salvar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHtml);
        document.body.style.overflow = 'hidden';

        // Focar no primeiro campo
        setTimeout(() => {
            const firstInput = document.querySelector('#formCriar input, #formCriar select, #formCriar textarea');
            if (firstInput) firstInput.focus();
        }, 100);
    },

    renderCamposForm() {
        if (this.campos.length === 0) {
            return '<p>Nenhum campo configurado para esta entidade.</p>';
        }

        return this.campos.map(campo => {
            const required = campo.obrigatorio ? 'required' : '';
            const requiredMark = campo.obrigatorio ? '<span style="color: red;">*</span>' : '';

            switch (campo.tipo) {
                case 'text':
                case 'email':
                case 'url':
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <input type="${campo.tipo}" id="campo-${campo.codigo}" name="${campo.codigo}"
                                   placeholder="${campo.placeholder || ''}" ${required}>
                        </div>
                    `;
                case 'textarea':
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <textarea id="campo-${campo.codigo}" name="${campo.codigo}"
                                      rows="4" placeholder="${campo.placeholder || ''}" ${required}></textarea>
                        </div>
                    `;
                case 'number':
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <input type="number" id="campo-${campo.codigo}" name="${campo.codigo}" ${required}>
                        </div>
                    `;
                case 'select':
                    let opcoes = campo.opcoes || [];
                    // Parsear se for string JSON
                    if (typeof opcoes === 'string') {
                        try { opcoes = JSON.parse(opcoes); } catch(e) { opcoes = []; }
                    }
                    // Escapar aspas no nome do campo para evitar quebra do onclick
                    const campoNomeEscaped = (campo.nome || '').replace(/'/g, "\\'");
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <div class="select-with-add">
                                <select id="campo-${campo.codigo}" name="${campo.codigo}" ${required}>
                                    <option value="">Selecione...</option>
                                    ${opcoes.map(op => {
                                        // Suporta tanto string simples quanto objeto {valor, label}
                                        const valor = typeof op === 'string' ? op : (op.valor || op.value || op);
                                        const label = typeof op === 'string' ? op : (op.label || op.nome || valor);
                                        return `<option value="${valor}">${label}</option>`;
                                    }).join('')}
                                </select>
                                <button type="button" class="btn-add-option"
                                        onclick="ConfigRenderer.abrirModalAddOpcao('${campo.codigo}', '${campoNomeEscaped}')"
                                        title="Adicionar nova opção">+</button>
                            </div>
                        </div>
                    `;
                case 'checkbox':
                    return `
                        <div class="form-group form-check">
                            <input type="checkbox" id="campo-${campo.codigo}" name="${campo.codigo}">
                            <label for="campo-${campo.codigo}">${campo.nome}</label>
                        </div>
                    `;
                case 'date':
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <input type="date" id="campo-${campo.codigo}" name="${campo.codigo}" ${required}>
                        </div>
                    `;
                default:
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <input type="text" id="campo-${campo.codigo}" name="${campo.codigo}" ${required}>
                        </div>
                    `;
            }
        }).join('');
    },

    fecharModalCriar() {
        const modal = document.getElementById('modalCriar');
        if (modal) {
            modal.remove();
            document.body.style.overflow = '';
        }
    },

    async salvarNovoRegistro() {
        const form = document.getElementById('formCriar');
        if (!form) return;

        const formData = new FormData(form);
        const dados = {};

        for (const [key, value] of formData.entries()) {
            if (value !== '') {
                dados[key] = value;
            }
        }

        // Validar campos obrigatorios
        for (const campo of this.campos) {
            if (campo.obrigatorio && !dados[campo.codigo]) {
                this.showToast(`Campo obrigatorio: ${campo.nome}`, 'error');
                return;
            }
        }

        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(`/api/projetos/${this.projetoId}/dados/${this.entidade.codigo}`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ dados })
            });

            const result = await response.json();

            if (response.ok && result.success) {
                this.showToast('Registro criado com sucesso!', 'success');
                this.fecharModalCriar();
                await this.carregarDados();
                this.render();
            } else {
                this.showToast(result.error || 'Erro ao criar registro', 'error');
            }
        } catch (error) {
            console.error('Erro ao salvar:', error);
            this.showToast('Erro ao salvar registro', 'error');
        }
    },

    // =========================================
    // Funções para EDITAR registros
    // =========================================

    async abrirModalEditar(registroId) {
        await this.carregarCampos();

        // Buscar dados do registro
        const registro = this.dados.find(r => (r.id || r._id) == registroId);
        if (!registro) {
            this.showToast('Registro não encontrado', 'error');
            return;
        }

        this.registroEditando = registro;

        const modalHtml = `
            <div class="modal-overlay active" id="modalEditar" onclick="if(event.target === this) ConfigRenderer.fecharModalEditar()">
                <div class="modal-content modal-criar">
                    <div class="modal-header">
                        <h3>✏️ Editar ${this.entidade?.nome || 'Registro'}</h3>
                        <button class="modal-close" onclick="ConfigRenderer.fecharModalEditar()">&times;</button>
                    </div>
                    <div class="modal-body">
                        <form id="formEditar" onsubmit="event.preventDefault(); ConfigRenderer.salvarEdicao();">
                            ${this.renderCamposFormEditar(registro)}
                            <div class="form-actions">
                                <button type="button" class="btn btn-secondary" onclick="ConfigRenderer.fecharModalEditar()">Cancelar</button>
                                <button type="submit" class="btn btn-success">Salvar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHtml);
        document.body.style.overflow = 'hidden';
    },

    renderCamposFormEditar(registro) {
        if (this.campos.length === 0) {
            return '<p>Nenhum campo configurado para esta entidade.</p>';
        }

        return this.campos.map(campo => {
            const required = campo.obrigatorio ? 'required' : '';
            const requiredMark = campo.obrigatorio ? '<span style="color: red;">*</span>' : '';
            const valor = registro[campo.codigo] || '';

            switch (campo.tipo) {
                case 'text':
                case 'email':
                case 'url':
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <input type="${campo.tipo}" id="campo-${campo.codigo}" name="${campo.codigo}"
                                   value="${this.escapeHTML(valor)}" placeholder="${campo.placeholder || ''}" ${required}>
                        </div>
                    `;
                case 'textarea':
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <textarea id="campo-${campo.codigo}" name="${campo.codigo}"
                                      rows="4" placeholder="${campo.placeholder || ''}" ${required}>${this.escapeHTML(valor)}</textarea>
                        </div>
                    `;
                case 'number':
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <input type="number" id="campo-${campo.codigo}" name="${campo.codigo}" value="${valor}" ${required}>
                        </div>
                    `;
                case 'select':
                    let opcoes = campo.opcoes || [];
                    if (typeof opcoes === 'string') {
                        try { opcoes = JSON.parse(opcoes); } catch(e) { opcoes = []; }
                    }
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <select id="campo-${campo.codigo}" name="${campo.codigo}" ${required}>
                                <option value="">Selecione...</option>
                                ${opcoes.map(op => {
                                    const opValor = typeof op === 'string' ? op : (op.valor || op.value || op);
                                    const opLabel = typeof op === 'string' ? op : (op.label || op.nome || opValor);
                                    const selected = opValor == valor ? 'selected' : '';
                                    return `<option value="${opValor}" ${selected}>${opLabel}</option>`;
                                }).join('')}
                            </select>
                        </div>
                    `;
                case 'date':
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <input type="date" id="campo-${campo.codigo}" name="${campo.codigo}" value="${valor}" ${required}>
                        </div>
                    `;
                default:
                    return `
                        <div class="form-group">
                            <label for="campo-${campo.codigo}">${campo.nome} ${requiredMark}</label>
                            <input type="text" id="campo-${campo.codigo}" name="${campo.codigo}"
                                   value="${this.escapeHTML(valor)}" ${required}>
                        </div>
                    `;
            }
        }).join('');
    },

    fecharModalEditar() {
        const modal = document.getElementById('modalEditar');
        if (modal) {
            modal.remove();
            document.body.style.overflow = '';
        }
        this.registroEditando = null;
    },

    async salvarEdicao() {
        const form = document.getElementById('formEditar');
        if (!form || !this.registroEditando) return;

        const formData = new FormData(form);
        const dados = {};

        for (const [key, value] of formData.entries()) {
            dados[key] = value;
        }

        const registroId = this.registroEditando.id || this.registroEditando._id;
        const entidadeCodigo = this.entidade?.codigo || this.entidadeCodigo;

        try {
            const response = await fetch(`/api/projetos/${this.projetoId}/dados/${entidadeCodigo}/${registroId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${BelgoAuth.getToken()}`
                },
                body: JSON.stringify({ dados })
            });

            const result = await response.json();

            if (result.success) {
                this.showToast('Registro atualizado com sucesso!', 'success');
                this.fecharModalEditar();
                await this.carregarDados();
                this.render();
            } else {
                this.showToast(result.error || 'Erro ao atualizar registro', 'error');
            }
        } catch (error) {
            console.error('Erro ao atualizar:', error);
            this.showToast('Erro ao atualizar registro', 'error');
        }
    },

    // =========================================
    // Funções para EXCLUIR registros
    // =========================================

    confirmarExcluir(registroId, nome) {
        const modalHtml = `
            <div class="modal-overlay active" id="modalExcluir" onclick="if(event.target === this) ConfigRenderer.fecharModalExcluir()">
                <div class="modal-content modal-sm">
                    <div class="modal-header">
                        <h3>🗑️ Confirmar Exclusão</h3>
                        <button class="modal-close" onclick="ConfigRenderer.fecharModalExcluir()">&times;</button>
                    </div>
                    <div class="modal-body">
                        <p>Tem certeza que deseja excluir <strong>"${nome}"</strong>?</p>
                        <p style="color: #dc3545; font-size: 0.9em;">Esta ação não pode ser desfeita.</p>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" onclick="ConfigRenderer.fecharModalExcluir()">Cancelar</button>
                        <button class="btn btn-danger" onclick="ConfigRenderer.executarExclusao(${registroId})">Excluir</button>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHtml);
        document.body.style.overflow = 'hidden';
    },

    fecharModalExcluir() {
        const modal = document.getElementById('modalExcluir');
        if (modal) {
            modal.remove();
            document.body.style.overflow = '';
        }
    },

    async executarExclusao(registroId) {
        const entidadeCodigo = this.entidade?.codigo || this.entidadeCodigo;
        try {
            const response = await fetch(`/api/projetos/${this.projetoId}/dados/${entidadeCodigo}/${registroId}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${BelgoAuth.getToken()}`
                }
            });

            const result = await response.json();

            if (result.success) {
                this.showToast('Registro excluído com sucesso!', 'success');
                this.fecharModalExcluir();
                await this.carregarDados();
                this.render();
            } else {
                this.showToast(result.error || 'Erro ao excluir registro', 'error');
            }
        } catch (error) {
            console.error('Erro ao excluir:', error);
            this.showToast('Erro ao excluir registro', 'error');
        }
    },

    // =========================================
    // Funções para adicionar opções em campos select
    // =========================================

    abrirModalAddOpcao(campoCodigo, campoNome) {
        const modalHtml = `
            <div class="modal-overlay active" id="modalAddOpcao" onclick="if(event.target === this) ConfigRenderer.fecharModalAddOpcao()">
                <div class="modal-content modal-sm">
                    <div class="modal-header">
                        <h3>➕ Nova Opção: ${campoNome}</h3>
                        <button class="modal-close" onclick="ConfigRenderer.fecharModalAddOpcao()">×</button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="nova-opcao-valor">Valor (código interno) *</label>
                            <input type="text" id="nova-opcao-valor" placeholder="ex: em_andamento" required>
                            <small class="form-help">Use letras minúsculas, sem acentos ou espaços</small>
                        </div>
                        <div class="form-group">
                            <label for="nova-opcao-label">Rótulo (exibição) *</label>
                            <input type="text" id="nova-opcao-label" placeholder="ex: Em Andamento" required>
                        </div>
                        <div class="form-group">
                            <label for="nova-opcao-cor">Cor do badge</label>
                            <input type="color" id="nova-opcao-cor" value="#6B7280">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" onclick="ConfigRenderer.fecharModalAddOpcao()">Cancelar</button>
                        <button class="btn btn-primary" onclick="ConfigRenderer.salvarNovaOpcao('${campoCodigo}')">Salvar</button>
                    </div>
                </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', modalHtml);

        // Focar no primeiro campo
        setTimeout(() => {
            const input = document.getElementById('nova-opcao-valor');
            if (input) input.focus();
        }, 100);
    },

    fecharModalAddOpcao() {
        const modal = document.getElementById('modalAddOpcao');
        if (modal) modal.remove();
    },

    async salvarNovaOpcao(campoCodigo) {
        const valorInput = document.getElementById('nova-opcao-valor');
        const labelInput = document.getElementById('nova-opcao-label');
        const corInput = document.getElementById('nova-opcao-cor');

        // Normalizar valor: minúsculas, sem acentos, espaços viram underscore
        let valor = valorInput.value.trim()
            .toLowerCase()
            .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
            .replace(/\s+/g, '_')
            .replace(/[^a-z0-9_]/g, '');

        const label = labelInput.value.trim();
        const cor = corInput.value;

        if (!valor || !label) {
            this.showToast('Valor e Rótulo são obrigatórios', 'error');
            return;
        }

        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(`/api/projetos/${this.projetoId}/entidades/${this.entidade.id}/opcoes`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`
                },
                body: JSON.stringify({
                    campo_codigo: campoCodigo,
                    valor,
                    label,
                    cor
                })
            });

            const result = await response.json();

            if (result.success) {
                // Adicionar opção ao select
                const select = document.getElementById(`campo-${campoCodigo}`);
                if (select) {
                    const option = document.createElement('option');
                    option.value = valor;
                    option.textContent = label;
                    select.appendChild(option);
                    select.value = valor; // Selecionar a nova opção
                }

                // Atualizar cache local dos campos
                const campo = this.campos.find(c => c.codigo === campoCodigo);
                if (campo) {
                    if (!campo.opcoes) campo.opcoes = [];
                    campo.opcoes.push({ valor, label, cor });
                }

                this.showToast('Opção adicionada com sucesso!', 'success');
                this.fecharModalAddOpcao();
            } else {
                this.showToast(result.message || 'Erro ao salvar opção', 'error');
            }
        } catch (error) {
            console.error('Erro ao salvar opção:', error);
            this.showToast('Erro ao salvar opção', 'error');
        }
    }
};

// Exportar globalmente
window.ConfigRenderer = ConfigRenderer;
