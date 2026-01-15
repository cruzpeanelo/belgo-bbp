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

    // =====================================================
    // INICIALIZACAO
    // =====================================================
    async init(options) {
        this.projetoId = options.projetoId || localStorage.getItem('belgo_projeto_id') || 1;
        this.entidade = options.entidade;
        this.containerId = options.containerId || 'pageContent';

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

        // Carregar dados
        await this.carregarDados();

        // Renderizar
        this.render();

        // Setup responsividade
        this.setupResponsivo();
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

        if (this.config?.acoes_lote?.exportar_csv?.habilitado) {
            acoes.push(`<button class="btn btn-primary" onclick="ConfigRenderer.exportarCSV()">Exportar CSV</button>`);
        }

        return `
            <div class="page-header">
                <div class="page-title">
                    <span class="page-icon">${this.entidade?.icone || '📋'}</span>
                    <h2>${this.entidade?.nome_plural || 'Dados'}</h2>
                    <span class="badge-count">${this.dadosFiltrados.length} registros</span>
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
        const colunas = this.config?.tabela?.colunas || [];
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
    // RENDER CARDS GRID (Participantes)
    // =====================================================
    renderCardsGrid(dados) {
        const cardConfig = this.config?.card || {};
        const agrupamento = this.config?.agrupamento;

        if (agrupamento) {
            return this.renderCardsAgrupados();
        }

        return `
            <div class="cards-grid">
                ${dados.map(row => this.renderCard(row, cardConfig)).join('')}
            </div>
        `;
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
        const config = this.config?.acoes_lote?.exportar_csv;
        if (!config?.habilitado) return;

        const campos = config.campos || Object.keys(this.dados[0] || {});

        // Header
        let csv = campos.join(',') + '\n';

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
        const nomeArquivo = (config.nome_arquivo || 'export_{data}.csv').replace('{data}', new Date().toISOString().split('T')[0]);
        link.href = URL.createObjectURL(blob);
        link.download = nomeArquivo;
        link.click();

        this.showToast('Exportacao realizada com sucesso!', 'success');
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
    }
};

// Exportar globalmente
window.ConfigRenderer = ConfigRenderer;
