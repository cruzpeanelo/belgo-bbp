// =====================================================
// BELGO BBP - DASHBOARD RENDERER
// Engine de dashboard dinamico configuravel
// =====================================================

const DashboardRenderer = {
    projetoId: null,
    config: null,
    widgets: [],
    dadosCache: {},
    container: null,

    // =====================================================
    // INICIALIZACAO
    // =====================================================
    async init(containerId, projetoId) {
        this.container = document.querySelector(containerId);
        this.projetoId = projetoId;
        this.dadosCache = {};

        if (!this.container) {
            console.error('Container nao encontrado:', containerId);
            return false;
        }

        try {
            // Mostrar loading
            this.container.innerHTML = this.renderLoading();

            // Carregar configuracao e widgets
            await this.carregarConfig();
            await this.carregarWidgets();

            // Renderizar dashboard
            await this.render();

            return true;
        } catch (error) {
            console.error('Erro ao inicializar dashboard:', error);
            this.container.innerHTML = this.renderError('Erro ao carregar dashboard');
            return false;
        }
    },

    // =====================================================
    // CARREGAMENTO DE DADOS
    // =====================================================
    async carregarConfig() {
        const token = localStorage.getItem('belgo_token');
        const response = await fetch(`/api/projetos/${this.projetoId}/dashboard`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });

        if (response.ok) {
            const result = await response.json();
            this.config = result.config || {};
            this.widgets = result.widgets || [];
        } else {
            // Config padrao se API nao existir
            this.config = { titulo: 'Dashboard', layout: 'grid', colunas: 4 };
            this.widgets = [];
        }
    },

    async carregarWidgets() {
        // Ja carregado junto com config
        // Metodo separado para futuras expansoes
    },

    async carregarDadosEntidade(entidadeCodigo, filtros = null) {
        // Usar cache se disponivel
        const cacheKey = `${entidadeCodigo}_${JSON.stringify(filtros)}`;
        if (this.dadosCache[cacheKey]) {
            return this.dadosCache[cacheKey];
        }

        try {
            const token = localStorage.getItem('belgo_token');
            let url = `/api/projetos/${this.projetoId}/dados/${entidadeCodigo}`;

            // Adicionar filtros como query params
            if (filtros) {
                const params = new URLSearchParams();
                Object.entries(filtros).forEach(([key, value]) => {
                    params.append(key, value);
                });
                url += `?${params.toString()}`;
            }

            const response = await fetch(url, {
                headers: { 'Authorization': `Bearer ${token}` }
            });

            if (response.ok) {
                const result = await response.json();
                this.dadosCache[cacheKey] = result.dados || result.data || [];
                return this.dadosCache[cacheKey];
            }
        } catch (error) {
            console.warn('Erro ao carregar dados:', error);
        }

        return [];
    },

    // =====================================================
    // RENDERIZACAO PRINCIPAL
    // =====================================================
    async render() {
        const titulo = this.config.titulo || 'Dashboard';
        const subtitulo = this.config.subtitulo || '';

        let html = `
            <div class="dashboard-container">
                <div class="dashboard-header">
                    <div class="dashboard-header-text">
                        <h1 class="dashboard-title">${titulo}</h1>
                        ${subtitulo ? `<p class="dashboard-subtitle">${subtitulo}</p>` : ''}
                    </div>
                    <div class="dashboard-actions">
                        <button class="btn btn-outline" onclick="DashboardRenderer.refresh()">
                            <span class="icon">&#8635;</span> Atualizar
                        </button>
                    </div>
                </div>
                <div class="dashboard-widgets-grid" style="--colunas: ${this.config.colunas || 4}">
        `;

        // Renderizar cada widget
        for (const widget of this.widgets) {
            if (!widget.ativo) continue;
            const widgetHtml = await this.renderWidget(widget);
            html += widgetHtml;
        }

        // Se nao houver widgets, mostrar estado vazio
        if (this.widgets.filter(w => w.ativo).length === 0) {
            html += `
                <div class="dashboard-empty" style="grid-column: 1 / -1;">
                    <div class="empty-icon">&#128202;</div>
                    <h3>Dashboard nao configurado</h3>
                    <p>Configure widgets no painel administrativo</p>
                </div>
            `;
        }

        html += `
                </div>
            </div>
        `;

        this.container.innerHTML = html;
    },

    async refresh() {
        this.dadosCache = {};
        await this.render();
        this.showToast('Dashboard atualizado!', 'success');
    },

    // =====================================================
    // RENDERIZACAO DE WIDGETS
    // =====================================================
    async renderWidget(widget) {
        const largura = widget.largura || 1;
        const altura = widget.altura || 1;

        let conteudo = '';

        try {
            switch (widget.tipo) {
                case 'metrica':
                    conteudo = await this.renderWidgetMetrica(widget);
                    break;
                case 'grafico_pizza':
                    conteudo = await this.renderWidgetGraficoPizza(widget);
                    break;
                case 'grafico_barras':
                    conteudo = await this.renderWidgetGraficoBarras(widget);
                    break;
                case 'lista':
                    conteudo = await this.renderWidgetLista(widget);
                    break;
                case 'progresso':
                    conteudo = await this.renderWidgetProgresso(widget);
                    break;
                case 'timeline':
                    conteudo = await this.renderWidgetTimeline(widget);
                    break;
                case 'tabela':
                    conteudo = await this.renderWidgetTabela(widget);
                    break;
                default:
                    conteudo = `<p>Tipo de widget nao suportado: ${widget.tipo}</p>`;
            }
        } catch (error) {
            console.error('Erro ao renderizar widget:', widget.codigo, error);
            conteudo = `<p class="widget-error">Erro ao carregar dados</p>`;
        }

        return `
            <div class="dashboard-widget widget-${widget.tipo}"
                 style="grid-column: span ${largura}; grid-row: span ${altura};"
                 data-widget="${widget.codigo}">
                <div class="widget-header">
                    <h3 class="widget-title">${widget.titulo}</h3>
                </div>
                <div class="widget-content">
                    ${conteudo}
                </div>
            </div>
        `;
    },

    // =====================================================
    // WIDGET: METRICA
    // =====================================================
    async renderWidgetMetrica(widget) {
        const config = widget.config || {};
        const { entidade, tipo_calculo, campo, filtro, icone, cor, link } = config;

        let valor = 0;

        if (entidade) {
            const dados = await this.carregarDadosEntidade(entidade);

            // Aplicar filtro se houver
            let dadosFiltrados = dados;
            if (filtro) {
                dadosFiltrados = this.aplicarFiltro(dados, filtro);
            }

            // Calcular valor
            switch (tipo_calculo) {
                case 'total':
                    valor = dadosFiltrados.length;
                    break;
                case 'contador':
                    valor = dadosFiltrados.length;
                    break;
                case 'soma':
                    valor = dadosFiltrados.reduce((acc, item) => {
                        const v = parseFloat(item[campo]) || 0;
                        return acc + v;
                    }, 0);
                    break;
                case 'media':
                    const soma = dadosFiltrados.reduce((acc, item) => {
                        const v = parseFloat(item[campo]) || 0;
                        return acc + v;
                    }, 0);
                    valor = dadosFiltrados.length > 0 ? (soma / dadosFiltrados.length).toFixed(1) : 0;
                    break;
                case 'distinct':
                    const distintos = new Set(dadosFiltrados.map(item => item[campo]));
                    valor = distintos.size;
                    break;
                default:
                    valor = dadosFiltrados.length;
            }
        }

        const iconeHtml = this.getIcone(icone || 'chart');
        const corClass = cor || 'blue';
        const linkHtml = link ? `onclick="window.location.href='${link}'"` : '';
        const cursorClass = link ? 'clickable' : '';

        return `
            <div class="metrica-card ${cursorClass}" ${linkHtml}>
                <div class="metrica-icon ${corClass}">${iconeHtml}</div>
                <div class="metrica-valor">${valor}</div>
            </div>
        `;
    },

    // =====================================================
    // WIDGET: GRAFICO PIZZA
    // =====================================================
    async renderWidgetGraficoPizza(widget) {
        const config = widget.config || {};
        const { entidade, agrupar_por, cores } = config;

        if (!entidade || !agrupar_por) {
            return '<p class="widget-error">Configuracao incompleta</p>';
        }

        const dados = await this.carregarDadosEntidade(entidade);

        // Agrupar dados
        const grupos = {};
        dados.forEach(item => {
            const valor = item[agrupar_por] || 'Outros';
            grupos[valor] = (grupos[valor] || 0) + 1;
        });

        // Gerar grafico CSS (sem biblioteca externa)
        const total = Object.values(grupos).reduce((a, b) => a + b, 0);
        const coresDefault = ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899'];

        let gradientParts = [];
        let legendaHtml = '';
        let acumulado = 0;
        let i = 0;

        Object.entries(grupos).forEach(([key, count]) => {
            const cor = (cores && cores[key]) || coresDefault[i % coresDefault.length];
            const percent = (count / total) * 100;
            gradientParts.push(`${cor} ${acumulado}% ${acumulado + percent}%`);

            legendaHtml += `
                <div class="legenda-item">
                    <span class="legenda-cor" style="background: ${cor}"></span>
                    <span class="legenda-label">${key}</span>
                    <span class="legenda-valor">${count} (${percent.toFixed(0)}%)</span>
                </div>
            `;

            acumulado += percent;
            i++;
        });

        const gradient = gradientParts.join(', ');

        return `
            <div class="grafico-pizza-container">
                <div class="grafico-pizza" style="background: conic-gradient(${gradient})">
                    <div class="grafico-pizza-centro">${total}</div>
                </div>
                <div class="grafico-legenda">
                    ${legendaHtml}
                </div>
            </div>
        `;
    },

    // =====================================================
    // WIDGET: GRAFICO BARRAS
    // =====================================================
    async renderWidgetGraficoBarras(widget) {
        const config = widget.config || {};
        const { entidade, agrupar_por, orientacao } = config;

        if (!entidade || !agrupar_por) {
            return '<p class="widget-error">Configuracao incompleta</p>';
        }

        const dados = await this.carregarDadosEntidade(entidade);

        // Agrupar dados
        const grupos = {};
        dados.forEach(item => {
            const valor = item[agrupar_por] || 'Outros';
            grupos[valor] = (grupos[valor] || 0) + 1;
        });

        const maxValor = Math.max(...Object.values(grupos));
        const coresDefault = ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6'];

        let barrasHtml = '';
        let i = 0;

        Object.entries(grupos).forEach(([key, count]) => {
            const percent = (count / maxValor) * 100;
            const cor = coresDefault[i % coresDefault.length];

            if (orientacao === 'horizontal') {
                barrasHtml += `
                    <div class="barra-horizontal-item">
                        <span class="barra-label">${key}</span>
                        <div class="barra-track">
                            <div class="barra-fill" style="width: ${percent}%; background: ${cor}"></div>
                        </div>
                        <span class="barra-valor">${count}</span>
                    </div>
                `;
            } else {
                barrasHtml += `
                    <div class="barra-vertical-item">
                        <div class="barra-vertical-track">
                            <div class="barra-vertical-fill" style="height: ${percent}%; background: ${cor}"></div>
                        </div>
                        <span class="barra-label">${key}</span>
                        <span class="barra-valor">${count}</span>
                    </div>
                `;
            }
            i++;
        });

        const containerClass = orientacao === 'horizontal' ? 'grafico-barras-horizontal' : 'grafico-barras-vertical';

        return `<div class="${containerClass}">${barrasHtml}</div>`;
    },

    // =====================================================
    // WIDGET: LISTA
    // =====================================================
    async renderWidgetLista(widget) {
        const config = widget.config || {};
        const { entidade, filtro, ordenar_por, limite, campos_exibir, link } = config;

        if (!entidade) {
            return '<p class="widget-error">Entidade nao configurada</p>';
        }

        let dados = await this.carregarDadosEntidade(entidade);

        // Aplicar filtro
        if (filtro) {
            dados = this.aplicarFiltro(dados, filtro);
        }

        // Ordenar
        if (ordenar_por) {
            dados.sort((a, b) => {
                const va = a[ordenar_por] || '';
                const vb = b[ordenar_por] || '';
                return String(va).localeCompare(String(vb));
            });
        }

        // Limitar
        if (limite) {
            dados = dados.slice(0, limite);
        }

        if (dados.length === 0) {
            return '<p class="lista-vazia">Nenhum item encontrado</p>';
        }

        const campos = campos_exibir || ['nome', 'status'];

        let html = '<ul class="widget-lista">';
        dados.forEach(item => {
            const itemLink = link ? link.replace('{_id}', item._id || item.id) : '';
            const clickable = itemLink ? `onclick="window.location.href='${itemLink}'"` : '';

            html += `<li class="lista-item ${itemLink ? 'clickable' : ''}" ${clickable}>`;
            campos.forEach((campo, idx) => {
                const valor = item[campo] || '';
                if (idx === 0) {
                    html += `<span class="lista-titulo">${valor}</span>`;
                } else {
                    html += `<span class="lista-badge badge-${this.getBadgeClass(valor)}">${valor}</span>`;
                }
            });
            html += '</li>';
        });
        html += '</ul>';

        return html;
    },

    // =====================================================
    // WIDGET: PROGRESSO
    // =====================================================
    async renderWidgetProgresso(widget) {
        const config = widget.config || {};
        const { entidade, agrupar_por, campo_completo, valor_completo, mostrar_detalhes } = config;

        if (!entidade || !agrupar_por || !campo_completo) {
            return '<p class="widget-error">Configuracao incompleta</p>';
        }

        const dados = await this.carregarDadosEntidade(entidade);

        // Agrupar por categoria
        const grupos = {};
        dados.forEach(item => {
            const grupo = item[agrupar_por] || 'Outros';
            if (!grupos[grupo]) {
                grupos[grupo] = { total: 0, completos: 0 };
            }
            grupos[grupo].total++;
            if (item[campo_completo] === valor_completo) {
                grupos[grupo].completos++;
            }
        });

        const coresDefault = ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6', '#ec4899'];
        let html = '';
        let i = 0;

        Object.entries(grupos).forEach(([grupo, stats]) => {
            const percent = stats.total > 0 ? Math.round((stats.completos / stats.total) * 100) : 0;
            const cor = coresDefault[i % coresDefault.length];

            html += `
                <div class="progresso-item">
                    <div class="progresso-header">
                        <span class="progresso-label">${grupo}</span>
                        <span class="progresso-stats">${stats.completos}/${stats.total} (${percent}%)</span>
                    </div>
                    <div class="progresso-bar">
                        <div class="progresso-fill" style="width: ${percent}%; background: ${cor}"></div>
                    </div>
                </div>
            `;
            i++;
        });

        return `<div class="widget-progresso">${html}</div>`;
    },

    // =====================================================
    // WIDGET: TIMELINE
    // =====================================================
    async renderWidgetTimeline(widget) {
        const config = widget.config || {};
        const { entidade, campo_data, campo_titulo, campo_status, limite } = config;

        if (!entidade) {
            return '<p class="widget-error">Entidade nao configurada</p>';
        }

        let dados = await this.carregarDadosEntidade(entidade);

        // Ordenar por data
        if (campo_data) {
            dados.sort((a, b) => {
                const da = new Date(a[campo_data] || 0);
                const db = new Date(b[campo_data] || 0);
                return da - db;
            });
        }

        // Limitar
        if (limite) {
            dados = dados.slice(0, limite);
        }

        if (dados.length === 0) {
            return '<p class="lista-vazia">Nenhum item na timeline</p>';
        }

        const tituloField = campo_titulo || 'titulo' || 'nome';
        const statusField = campo_status || 'status';
        const dataField = campo_data || 'data';

        let html = '<div class="widget-timeline">';
        dados.forEach(item => {
            const titulo = item[tituloField] || 'Sem titulo';
            const status = item[statusField] || '';
            const data = item[dataField] ? this.formatarData(item[dataField]) : '';
            const completo = status === 'Concluido' || status === 'Realizado';

            html += `
                <div class="timeline-item ${completo ? 'completed' : 'pending'}">
                    <div class="timeline-marker"></div>
                    <div class="timeline-content">
                        <div class="timeline-header">
                            <span class="timeline-titulo">${titulo}</span>
                            ${status ? `<span class="badge badge-${this.getBadgeClass(status)}">${status}</span>` : ''}
                        </div>
                        ${data ? `<span class="timeline-data">${data}</span>` : ''}
                    </div>
                </div>
            `;
        });
        html += '</div>';

        return html;
    },

    // =====================================================
    // WIDGET: TABELA
    // =====================================================
    async renderWidgetTabela(widget) {
        const config = widget.config || {};
        const { entidade, filtro, colunas, limite, link } = config;

        if (!entidade) {
            return '<p class="widget-error">Entidade nao configurada</p>';
        }

        let dados = await this.carregarDadosEntidade(entidade);

        // Aplicar filtro
        if (filtro) {
            dados = this.aplicarFiltro(dados, filtro);
        }

        // Limitar
        if (limite) {
            dados = dados.slice(0, limite);
        }

        if (dados.length === 0) {
            return '<p class="lista-vazia">Nenhum dado encontrado</p>';
        }

        const cols = colunas || Object.keys(dados[0]).slice(0, 4);

        let html = '<table class="widget-tabela"><thead><tr>';
        cols.forEach(col => {
            html += `<th>${this.formatarNomeCampo(col)}</th>`;
        });
        html += '</tr></thead><tbody>';

        dados.forEach(item => {
            const itemLink = link ? link.replace('{_id}', item._id || item.id) : '';
            const clickable = itemLink ? `onclick="window.location.href='${itemLink}'" class="clickable"` : '';

            html += `<tr ${clickable}>`;
            cols.forEach(col => {
                const valor = item[col] || '';
                html += `<td>${this.formatarValor(valor)}</td>`;
            });
            html += '</tr>';
        });

        html += '</tbody></table>';
        return html;
    },

    // =====================================================
    // UTILITARIOS
    // =====================================================
    aplicarFiltro(dados, filtro) {
        return dados.filter(item => {
            for (const [campo, valor] of Object.entries(filtro)) {
                const itemValor = item[campo];

                // Suporte a operadores
                if (typeof valor === 'string' && valor.startsWith('!=')) {
                    if (itemValor === valor.substring(2)) return false;
                } else if (typeof valor === 'string' && valor.startsWith('>')) {
                    if (!(parseFloat(itemValor) > parseFloat(valor.substring(1)))) return false;
                } else if (typeof valor === 'string' && valor.startsWith('<')) {
                    if (!(parseFloat(itemValor) < parseFloat(valor.substring(1)))) return false;
                } else {
                    if (itemValor !== valor) return false;
                }
            }
            return true;
        });
    },

    getIcone(icone) {
        const icones = {
            'chart': '&#128202;',
            'check': '&#10004;',
            'clock': '&#128337;',
            'x': '&#10006;',
            'users': '&#128101;',
            'file': '&#128196;',
            'calendar': '&#128197;',
            'alert': '&#9888;',
            'star': '&#11088;',
            'target': '&#127919;'
        };
        return icones[icone] || icones['chart'];
    },

    getBadgeClass(valor) {
        const classes = {
            'Concluido': 'success',
            'Concluído': 'success',
            'Realizado': 'success',
            'OK': 'success',
            'Pendente': 'warning',
            'Em Andamento': 'info',
            'Falhou': 'danger',
            'Bloqueador': 'danger',
            'Critico': 'danger',
            'Crítico': 'danger',
            'Alta': 'warning',
            'Media': 'info',
            'Média': 'info',
            'Baixa': 'secondary'
        };
        return classes[valor] || 'secondary';
    },

    formatarData(data) {
        if (!data) return '';
        try {
            const d = new Date(data);
            return d.toLocaleDateString('pt-BR');
        } catch {
            return data;
        }
    },

    formatarNomeCampo(campo) {
        return campo
            .replace(/_/g, ' ')
            .replace(/([A-Z])/g, ' $1')
            .replace(/^\w/, c => c.toUpperCase())
            .trim();
    },

    formatarValor(valor) {
        if (valor === null || valor === undefined) return '';
        if (Array.isArray(valor)) return valor.join(', ');
        if (typeof valor === 'boolean') return valor ? 'Sim' : 'Nao';
        return String(valor);
    },

    renderLoading() {
        return `
            <div class="dashboard-loading">
                <div class="loading-spinner"></div>
                <p>Carregando dashboard...</p>
            </div>
        `;
    },

    renderError(mensagem) {
        return `
            <div class="dashboard-error">
                <div class="error-icon">&#9888;</div>
                <h3>Erro</h3>
                <p>${mensagem}</p>
            </div>
        `;
    },

    showToast(message, type = 'info') {
        if (typeof Utils !== 'undefined' && Utils.showToast) {
            Utils.showToast(message, type);
        } else {
            console.log(`[${type}] ${message}`);
        }
    }
};

// Exportar globalmente
window.DashboardRenderer = DashboardRenderer;
