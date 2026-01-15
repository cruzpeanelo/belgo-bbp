// =====================================================
// BELGO BBP - COMPONENTES DINAMICOS
// Sistema de renderizacao dinamica baseado em configuracao
// =====================================================

// =====================================================
// 1. DYNAMIC TABLE - Tabela dinamica baseada em campos
// =====================================================
const DynamicTable = {
    entidade: null,
    campos: [],
    dados: [],
    paginacao: null,
    containerId: null,
    onRowClick: null,
    onEdit: null,
    onDelete: null,
    permissoes: {},

    // Inicializar tabela
    async init(options) {
        this.containerId = options.containerId;
        this.entidade = options.entidade;
        this.campos = options.campos || [];
        this.onRowClick = options.onRowClick;
        this.onEdit = options.onEdit;
        this.onDelete = options.onDelete;
        this.permissoes = options.permissoes || {};

        await this.carregarDados();
        this.render();
    },

    // Carregar dados da API
    async carregarDados(page = 1) {
        if (!this.entidade) return;

        try {
            const token = sessionStorage.getItem('belgo_token');
            const projetoId = this.entidade.projeto_id || localStorage.getItem('belgo_projeto_id');

            const response = await fetch(`/api/projetos/${projetoId}/dados/${this.entidade.codigo}?page=${page}&limit=25`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) throw new Error('Erro ao carregar dados');

            const result = await response.json();
            this.dados = result.dados || [];
            this.paginacao = result.paginacao;

        } catch (error) {
            console.error('Erro ao carregar dados:', error);
            this.dados = [];
        }
    },

    // Renderizar tabela
    render() {
        const container = document.getElementById(this.containerId);
        if (!container) return;

        const camposVisiveis = this.campos.filter(c => c.visivel_listagem);

        if (this.dados.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <span class="empty-icon">${this.entidade?.icone || '📋'}</span>
                    <h3>Nenhum registro encontrado</h3>
                    <p>Clique em "Novo" para adicionar o primeiro registro.</p>
                </div>
            `;
            return;
        }

        container.innerHTML = `
            <div class="dynamic-table-wrapper">
                <table class="dynamic-table">
                    <thead>
                        <tr>
                            ${camposVisiveis.map(c => `
                                <th style="${c.largura_coluna ? `width: ${c.largura_coluna}` : ''}">${c.nome}</th>
                            `).join('')}
                            <th class="col-actions">Acoes</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${this.dados.map(row => `
                            <tr data-id="${row.id}" ${this.onRowClick ? 'class="clickable"' : ''}>
                                ${camposVisiveis.map(c => `
                                    <td>${this.formatarValor(row[c.codigo], c)}</td>
                                `).join('')}
                                <td class="col-actions">
                                    ${this.permissoes.editar ? `
                                        <button class="btn-icon" onclick="DynamicTable.editarRegistro(${row.id})" title="Editar">
                                            ✏️
                                        </button>
                                    ` : ''}
                                    ${this.permissoes.excluir ? `
                                        <button class="btn-icon btn-danger" onclick="DynamicTable.excluirRegistro(${row.id})" title="Excluir">
                                            🗑️
                                        </button>
                                    ` : ''}
                                </td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
            ${this.renderPaginacao()}
        `;

        // Event listeners para clique na linha
        if (this.onRowClick) {
            container.querySelectorAll('tr.clickable').forEach(tr => {
                tr.addEventListener('click', (e) => {
                    if (!e.target.closest('.btn-icon')) {
                        this.onRowClick(parseInt(tr.dataset.id));
                    }
                });
            });
        }
    },

    // Formatar valor baseado no tipo do campo
    formatarValor(valor, campo) {
        if (valor === null || valor === undefined) return '-';

        switch (campo.tipo) {
            case 'date':
                return this.formatarData(valor);
            case 'datetime':
                return this.formatarDataHora(valor);
            case 'currency':
                return this.formatarMoeda(valor);
            case 'number':
                return this.formatarNumero(valor);
            case 'boolean':
                return valor ? '✅' : '❌';
            case 'select':
                return this.formatarSelect(valor, campo);
            case 'multiselect':
                return this.formatarMultiSelect(valor, campo);
            default:
                return this.truncarTexto(String(valor), 50);
        }
    },

    formatarData(valor) {
        if (!valor) return '-';
        try {
            return new Date(valor).toLocaleDateString('pt-BR');
        } catch {
            return valor;
        }
    },

    formatarDataHora(valor) {
        if (!valor) return '-';
        try {
            return new Date(valor).toLocaleString('pt-BR');
        } catch {
            return valor;
        }
    },

    formatarMoeda(valor) {
        if (isNaN(valor)) return valor;
        return new Intl.NumberFormat('pt-BR', {
            style: 'currency',
            currency: 'BRL'
        }).format(valor);
    },

    formatarNumero(valor) {
        if (isNaN(valor)) return valor;
        return new Intl.NumberFormat('pt-BR').format(valor);
    },

    formatarSelect(valor, campo) {
        if (!campo.opcoes) return valor;
        const opcao = campo.opcoes.find(o => o.valor === valor);
        if (opcao) {
            const cor = opcao.cor || '#6B7280';
            return `<span class="badge" style="background: ${cor}20; color: ${cor}">${opcao.label}</span>`;
        }
        return valor;
    },

    formatarMultiSelect(valor, campo) {
        if (!valor || !Array.isArray(valor)) return '-';
        return valor.map(v => this.formatarSelect(v, campo)).join(' ');
    },

    truncarTexto(texto, max) {
        if (texto.length <= max) return texto;
        return texto.substring(0, max) + '...';
    },

    // Renderizar paginacao
    renderPaginacao() {
        if (!this.paginacao || this.paginacao.paginas <= 1) return '';

        const { pagina, paginas, total } = this.paginacao;

        return `
            <div class="table-pagination">
                <span class="pagination-info">${total} registro(s)</span>
                <div class="pagination-buttons">
                    <button class="btn btn-sm" ${pagina <= 1 ? 'disabled' : ''} onclick="DynamicTable.irParaPagina(${pagina - 1})">
                        Anterior
                    </button>
                    <span class="pagination-current">Pagina ${pagina} de ${paginas}</span>
                    <button class="btn btn-sm" ${pagina >= paginas ? 'disabled' : ''} onclick="DynamicTable.irParaPagina(${pagina + 1})">
                        Proxima
                    </button>
                </div>
            </div>
        `;
    },

    // Navegar para pagina
    async irParaPagina(page) {
        await this.carregarDados(page);
        this.render();
    },

    // Editar registro
    editarRegistro(id) {
        if (this.onEdit) {
            this.onEdit(id);
        }
    },

    // Excluir registro
    async excluirRegistro(id) {
        if (!confirm('Deseja realmente excluir este registro?')) return;

        if (this.onDelete) {
            await this.onDelete(id);
            await this.carregarDados(this.paginacao?.pagina || 1);
            this.render();
        }
    },

    // Recarregar dados
    async reload() {
        await this.carregarDados(this.paginacao?.pagina || 1);
        this.render();
    }
};

// =====================================================
// 2. DYNAMIC FORM - Formulario dinamico baseado em campos
// =====================================================
const DynamicForm = {
    entidade: null,
    campos: [],
    registro: null,
    containerId: null,
    onSubmit: null,
    onCancel: null,
    modo: 'criar', // criar ou editar

    // Inicializar formulario
    init(options) {
        this.containerId = options.containerId;
        this.entidade = options.entidade;
        this.campos = options.campos || [];
        this.registro = options.registro || null;
        this.onSubmit = options.onSubmit;
        this.onCancel = options.onCancel;
        this.modo = options.registro ? 'editar' : 'criar';

        this.render();
    },

    // Renderizar formulario
    render() {
        const container = document.getElementById(this.containerId);
        if (!container) return;

        const camposVisiveis = this.campos.filter(c => c.visivel_formulario);

        container.innerHTML = `
            <form id="dynamicForm" class="dynamic-form" onsubmit="DynamicForm.submit(event)">
                ${camposVisiveis.map(c => this.renderCampo(c)).join('')}
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="DynamicForm.cancelar()">Cancelar</button>
                    <button type="submit" class="btn btn-primary">${this.modo === 'criar' ? 'Criar' : 'Salvar'}</button>
                </div>
            </form>
        `;

        // Inicializar campos especiais
        this.inicializarCamposEspeciais();
    },

    // Renderizar campo individual
    renderCampo(campo) {
        const valor = this.registro ? this.registro[campo.codigo] : campo.valor_padrao || '';
        const required = campo.obrigatorio ? 'required' : '';
        const id = `campo_${campo.codigo}`;

        let input = '';

        switch (campo.tipo) {
            case 'text':
                input = `<input type="text" id="${id}" name="${campo.codigo}" value="${this.escapeHtml(valor)}" ${required}>`;
                break;

            case 'textarea':
                input = `<textarea id="${id}" name="${campo.codigo}" rows="4" ${required}>${this.escapeHtml(valor)}</textarea>`;
                break;

            case 'number':
                input = `<input type="number" id="${id}" name="${campo.codigo}" value="${valor}" step="any" ${required}>`;
                break;

            case 'currency':
                input = `<input type="number" id="${id}" name="${campo.codigo}" value="${valor}" step="0.01" ${required}>`;
                break;

            case 'date':
                input = `<input type="date" id="${id}" name="${campo.codigo}" value="${valor}" ${required}>`;
                break;

            case 'datetime':
                input = `<input type="datetime-local" id="${id}" name="${campo.codigo}" value="${valor}" ${required}>`;
                break;

            case 'boolean':
                input = `
                    <label class="toggle-switch">
                        <input type="checkbox" id="${id}" name="${campo.codigo}" ${valor ? 'checked' : ''}>
                        <span class="toggle-slider"></span>
                    </label>
                `;
                break;

            case 'select':
                input = `
                    <select id="${id}" name="${campo.codigo}" ${required}>
                        <option value="">Selecione...</option>
                        ${(campo.opcoes || []).map(o => `
                            <option value="${o.valor}" ${valor === o.valor ? 'selected' : ''}>${o.label}</option>
                        `).join('')}
                    </select>
                `;
                break;

            case 'multiselect':
                const valoresArray = Array.isArray(valor) ? valor : [];
                input = `
                    <select id="${id}" name="${campo.codigo}" multiple ${required}>
                        ${(campo.opcoes || []).map(o => `
                            <option value="${o.valor}" ${valoresArray.includes(o.valor) ? 'selected' : ''}>${o.label}</option>
                        `).join('')}
                    </select>
                `;
                break;

            case 'file':
            case 'image':
                input = `
                    <input type="file" id="${id}" name="${campo.codigo}" ${campo.tipo === 'image' ? 'accept="image/*"' : ''}>
                    ${valor ? `<p class="file-current">Arquivo atual: ${valor}</p>` : ''}
                `;
                break;

            case 'relation':
                input = `
                    <select id="${id}" name="${campo.codigo}" class="relation-select" data-entidade="${campo.relacao_entidade_id}" ${required}>
                        <option value="">Carregando...</option>
                    </select>
                `;
                break;

            default:
                input = `<input type="text" id="${id}" name="${campo.codigo}" value="${this.escapeHtml(valor)}" ${required}>`;
        }

        return `
            <div class="form-group">
                <label for="${id}">
                    ${campo.nome}
                    ${campo.obrigatorio ? '<span class="required">*</span>' : ''}
                </label>
                ${input}
                ${campo.descricao ? `<small class="field-help">${campo.descricao}</small>` : ''}
            </div>
        `;
    },

    // Inicializar campos especiais (relacoes, etc)
    async inicializarCamposEspeciais() {
        // Carregar dados de campos de relacao
        const selects = document.querySelectorAll('.relation-select');
        for (const select of selects) {
            const entidadeId = select.dataset.entidade;
            if (entidadeId) {
                await this.carregarOpcoesRelacao(select, entidadeId);
            }
        }
    },

    // Carregar opcoes de relacao
    async carregarOpcoesRelacao(select, entidadeId) {
        try {
            const token = sessionStorage.getItem('belgo_token');
            const projetoId = localStorage.getItem('belgo_projeto_id');

            // Primeiro buscar a entidade para saber o codigo
            const entidadeRes = await fetch(`/api/projetos/${projetoId}/entidades/${entidadeId}`, {
                headers: { 'Authorization': `Bearer ${token}` }
            });

            if (!entidadeRes.ok) return;
            const entidadeData = await entidadeRes.json();

            // Depois buscar os dados
            const response = await fetch(`/api/projetos/${projetoId}/dados/${entidadeData.entidade.codigo}?limit=100`, {
                headers: { 'Authorization': `Bearer ${token}` }
            });

            if (!response.ok) return;
            const data = await response.json();

            const campoExibir = select.closest('.form-group').querySelector('label').textContent.trim();
            const valorAtual = this.registro ? this.registro[select.name] : '';

            select.innerHTML = '<option value="">Selecione...</option>' +
                (data.dados || []).map(d => {
                    const label = d.nome || d.titulo || d.descricao || `#${d.id}`;
                    return `<option value="${d.id}" ${valorAtual == d.id ? 'selected' : ''}>${label}</option>`;
                }).join('');

        } catch (error) {
            console.error('Erro ao carregar relacao:', error);
            select.innerHTML = '<option value="">Erro ao carregar</option>';
        }
    },

    // Escapar HTML
    escapeHtml(text) {
        if (text === null || text === undefined) return '';
        const div = document.createElement('div');
        div.textContent = String(text);
        return div.innerHTML;
    },

    // Submit do formulario
    async submit(event) {
        event.preventDefault();

        const form = document.getElementById('dynamicForm');
        const formData = new FormData(form);
        const dados = {};

        // Processar campos
        for (const campo of this.campos) {
            const element = form.elements[campo.codigo];
            if (!element) continue;

            switch (campo.tipo) {
                case 'boolean':
                    dados[campo.codigo] = element.checked;
                    break;
                case 'multiselect':
                    dados[campo.codigo] = Array.from(element.selectedOptions).map(o => o.value);
                    break;
                case 'number':
                case 'currency':
                    dados[campo.codigo] = element.value ? parseFloat(element.value) : null;
                    break;
                default:
                    dados[campo.codigo] = element.value || null;
            }
        }

        if (this.onSubmit) {
            await this.onSubmit(dados, this.registro?.id);
        }
    },

    // Cancelar
    cancelar() {
        if (this.onCancel) {
            this.onCancel();
        }
    }
};

// =====================================================
// 3. DYNAMIC PAGE - Renderizador de pagina dinamica
// =====================================================
const DynamicPage = {
    menu: null,
    entidade: null,
    campos: [],
    projetoId: null,

    // Inicializar pagina
    async init(options) {
        this.projetoId = options.projetoId || localStorage.getItem('belgo_projeto_id');
        this.menu = options.menu;

        if (!this.projetoId) {
            console.error('DynamicPage: projetoId nao fornecido');
            return;
        }

        // Se menu tem entidade vinculada, carregar configuracao
        if (this.menu?.entidade_id) {
            await this.carregarEntidade(this.menu.entidade_id);
        }

        this.render();
    },

    // Carregar entidade com campos
    async carregarEntidade(entidadeId) {
        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(`/api/projetos/${this.projetoId}/entidades/${entidadeId}`, {
                headers: { 'Authorization': `Bearer ${token}` }
            });

            if (!response.ok) throw new Error('Erro ao carregar entidade');

            const data = await response.json();
            this.entidade = data.entidade;
            this.campos = data.entidade.campos || [];

        } catch (error) {
            console.error('Erro ao carregar entidade:', error);
        }
    },

    // Renderizar pagina baseado no tipo de conteudo
    render() {
        const tipoConteudo = this.menu?.tipo_conteudo || 'listagem';

        switch (tipoConteudo) {
            case 'dashboard':
                this.renderDashboard();
                break;
            case 'listagem':
                this.renderListagem();
                break;
            case 'mapa':
                this.renderMapa();
                break;
            case 'timeline':
                this.renderTimeline();
                break;
            case 'kanban':
                this.renderKanban();
                break;
            case 'documentos':
                this.renderDocumentos();
                break;
            default:
                this.renderListagem();
        }
    },

    // Renderizar listagem padrao
    renderListagem() {
        const container = document.getElementById('pageContent');
        if (!container) return;

        container.innerHTML = `
            <div class="page-header">
                <div class="page-title">
                    <span class="page-icon">${this.entidade?.icone || this.menu?.icone || '📋'}</span>
                    <h2>${this.entidade?.nome_plural || this.menu?.nome || 'Dados'}</h2>
                </div>
                <div class="page-actions">
                    ${this.entidade?.permite_criar ? `
                        <button class="btn btn-primary" onclick="DynamicPage.abrirFormulario()">
                            <span class="icon">➕</span>
                            Novo ${this.entidade?.nome || 'Registro'}
                        </button>
                    ` : ''}
                    ${this.entidade?.permite_importar ? `
                        <button class="btn btn-secondary" onclick="DynamicPage.abrirImportacao()">
                            <span class="icon">📥</span>
                            Importar
                        </button>
                    ` : ''}
                </div>
            </div>
            <div class="page-filters">
                <input type="text" id="searchInput" placeholder="Buscar..." class="search-input" onkeyup="DynamicPage.filtrar()">
            </div>
            <div id="tableContainer" class="table-container">
                <p class="loading">Carregando...</p>
            </div>
        `;

        // Inicializar tabela
        if (this.entidade) {
            DynamicTable.init({
                containerId: 'tableContainer',
                entidade: { ...this.entidade, projeto_id: this.projetoId },
                campos: this.campos,
                onEdit: (id) => this.abrirFormulario(id),
                onDelete: (id) => this.excluirRegistro(id),
                permissoes: {
                    editar: this.entidade.permite_editar,
                    excluir: this.entidade.permite_excluir
                }
            });
        }
    },

    // Renderizar dashboard
    renderDashboard() {
        const container = document.getElementById('pageContent');
        if (!container) return;

        container.innerHTML = `
            <div class="dashboard-grid">
                <div class="dashboard-widget widget-stats">
                    <h3>Estatisticas</h3>
                    <p>Dashboard em construcao...</p>
                </div>
            </div>
        `;
    },

    // Renderizar mapa
    renderMapa() {
        const container = document.getElementById('pageContent');
        if (!container) return;

        container.innerHTML = `
            <div class="mapa-container">
                <h3>Mapa do Brasil</h3>
                <p>Componente de mapa em construcao...</p>
            </div>
        `;
    },

    // Renderizar timeline
    renderTimeline() {
        const container = document.getElementById('pageContent');
        if (!container) return;

        container.innerHTML = `
            <div class="timeline-container">
                <h3>Timeline</h3>
                <p>Componente de timeline em construcao...</p>
            </div>
        `;
    },

    // Renderizar kanban
    renderKanban() {
        const container = document.getElementById('pageContent');
        if (!container) return;

        container.innerHTML = `
            <div class="kanban-container">
                <h3>Kanban</h3>
                <p>Componente kanban em construcao...</p>
            </div>
        `;
    },

    // Renderizar documentos
    renderDocumentos() {
        const container = document.getElementById('pageContent');
        if (!container) return;

        container.innerHTML = `
            <div class="documentos-container">
                <h3>Documentos</h3>
                <p>Gerenciador de documentos em construcao...</p>
            </div>
        `;
    },

    // Abrir formulario
    async abrirFormulario(id = null) {
        let registro = null;

        if (id) {
            // Carregar registro
            try {
                const token = sessionStorage.getItem('belgo_token');
                const response = await fetch(`/api/projetos/${this.projetoId}/dados/${this.entidade.codigo}/${id}`, {
                    headers: { 'Authorization': `Bearer ${token}` }
                });

                if (response.ok) {
                    const data = await response.json();
                    registro = data.registro;
                }
            } catch (error) {
                console.error('Erro ao carregar registro:', error);
            }
        }

        // Mostrar modal com formulario
        const modal = document.createElement('div');
        modal.className = 'modal active';
        modal.id = 'modalFormulario';
        modal.innerHTML = `
            <div class="modal-content modal-lg">
                <div class="modal-header">
                    <h3>${id ? 'Editar' : 'Novo'} ${this.entidade?.nome || 'Registro'}</h3>
                    <button class="modal-close" onclick="DynamicPage.fecharFormulario()">&times;</button>
                </div>
                <div class="modal-body" id="formContainer"></div>
            </div>
        `;

        document.body.appendChild(modal);

        // Inicializar formulario
        DynamicForm.init({
            containerId: 'formContainer',
            entidade: this.entidade,
            campos: this.campos,
            registro: registro,
            onSubmit: async (dados, registroId) => {
                await this.salvarRegistro(dados, registroId);
                this.fecharFormulario();
                DynamicTable.reload();
            },
            onCancel: () => this.fecharFormulario()
        });
    },

    // Fechar formulario
    fecharFormulario() {
        const modal = document.getElementById('modalFormulario');
        if (modal) modal.remove();
    },

    // Salvar registro
    async salvarRegistro(dados, id = null) {
        try {
            const token = sessionStorage.getItem('belgo_token');
            const url = id
                ? `/api/projetos/${this.projetoId}/dados/${this.entidade.codigo}/${id}`
                : `/api/projetos/${this.projetoId}/dados/${this.entidade.codigo}`;

            const response = await fetch(url, {
                method: id ? 'PUT' : 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ dados })
            });

            const result = await response.json();

            if (!result.success) {
                alert(result.error || 'Erro ao salvar');
                return false;
            }

            return true;

        } catch (error) {
            console.error('Erro ao salvar:', error);
            alert('Erro ao salvar registro');
            return false;
        }
    },

    // Excluir registro
    async excluirRegistro(id) {
        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(`/api/projetos/${this.projetoId}/dados/${this.entidade.codigo}/${id}`, {
                method: 'DELETE',
                headers: { 'Authorization': `Bearer ${token}` }
            });

            const result = await response.json();

            if (!result.success) {
                alert(result.error || 'Erro ao excluir');
                return false;
            }

            return true;

        } catch (error) {
            console.error('Erro ao excluir:', error);
            alert('Erro ao excluir registro');
            return false;
        }
    },

    // Filtrar
    filtrar() {
        // TODO: Implementar filtro
        console.log('Filtrar:', document.getElementById('searchInput').value);
    },

    // Abrir importacao
    abrirImportacao() {
        alert('Funcionalidade de importacao em desenvolvimento');
    }
};

// Exportar para uso global
window.DynamicTable = DynamicTable;
window.DynamicForm = DynamicForm;
window.DynamicPage = DynamicPage;
