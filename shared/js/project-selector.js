// =====================================================
// BELGO BBP - Seletor de Projetos
// =====================================================

const BelgoProjetos = {
    API_URL: '/api/projetos',
    projetos: [],
    projetoAtual: null,

    /**
     * Retorna o ID do projeto atual
     */
    getProjetoId() {
        if (this.projetoAtual) {
            return this.projetoAtual.id;
        }
        const saved = localStorage.getItem('belgo_projeto_id');
        return saved ? parseInt(saved) : 1; // Default: GTM (id=1)
    },

    /**
     * Retorna dados do projeto atual
     */
    getProjetoAtual() {
        return this.projetoAtual;
    },

    /**
     * Carrega lista de projetos do usuario
     */
    async carregarProjetos() {
        try {
            const response = await BelgoAuth.request(this.API_URL);
            if (!response || !response.ok) {
                console.error('Erro ao carregar projetos');
                return [];
            }

            const data = await response.json();
            this.projetos = data.projetos || [];

            // Selecionar projeto salvo ou primeiro da lista
            const savedId = localStorage.getItem('belgo_projeto_id');
            if (savedId) {
                const projeto = this.projetos.find(p => p.id === parseInt(savedId));
                if (projeto) {
                    this.projetoAtual = projeto;
                } else if (this.projetos.length > 0) {
                    this.selecionarProjeto(this.projetos[0].id, false);
                }
            } else if (this.projetos.length > 0) {
                this.selecionarProjeto(this.projetos[0].id, false);
            }

            return this.projetos;

        } catch (error) {
            console.error('Erro ao carregar projetos:', error);
            return [];
        }
    },

    /**
     * Seleciona um projeto
     */
    async selecionarProjeto(projetoId, emitirEvento = true) {
        const projeto = this.projetos.find(p => p.id === projetoId);
        if (!projeto) {
            console.error('Projeto nao encontrado:', projetoId);
            return false;
        }

        this.projetoAtual = projeto;
        localStorage.setItem('belgo_projeto_id', projetoId);

        // Atualizar UI do seletor
        this.atualizarUI();

        // Disparar evento para atualizar dados da pagina
        if (emitirEvento) {
            window.dispatchEvent(new CustomEvent('projeto-alterado', {
                detail: { projetoId, projeto }
            }));
        }

        return true;
    },

    /**
     * Atualiza UI do seletor de projetos
     */
    atualizarUI() {
        const seletor = document.getElementById('project-selector');
        if (!seletor) return;

        if (this.projetos.length === 0) {
            seletor.style.display = 'none';
            return;
        }

        seletor.style.display = 'flex';

        // Atualizar nome do projeto atual
        const nomeEl = seletor.querySelector('.projeto-atual-nome');
        if (nomeEl && this.projetoAtual) {
            nomeEl.textContent = this.projetoAtual.nome;
        }

        // Atualizar icone
        const iconeEl = seletor.querySelector('.projeto-atual-icone');
        if (iconeEl && this.projetoAtual) {
            iconeEl.textContent = this.projetoAtual.icone || '📁';
        }
    },

    /**
     * Renderiza o seletor de projetos no container
     */
    renderSeletor(containerId = 'project-selector-container') {
        const container = document.getElementById(containerId);
        if (!container) return;

        container.innerHTML = `
            <div id="project-selector" class="project-selector" style="display: none;">
                <button class="projeto-atual-btn" onclick="BelgoProjetos.toggleDropdown()">
                    <span class="projeto-atual-icone"></span>
                    <span class="projeto-atual-nome">Carregando...</span>
                    <span class="projeto-dropdown-arrow">▼</span>
                </button>
                <div id="project-dropdown" class="project-dropdown" style="display: none;">
                    <div class="project-dropdown-list"></div>
                </div>
            </div>
        `;

        // Fechar dropdown ao clicar fora
        document.addEventListener('click', (e) => {
            const seletor = document.getElementById('project-selector');
            if (seletor && !seletor.contains(e.target)) {
                this.fecharDropdown();
            }
        });
    },

    /**
     * Toggle dropdown de projetos
     */
    toggleDropdown() {
        const dropdown = document.getElementById('project-dropdown');
        if (!dropdown) return;

        if (dropdown.style.display === 'none') {
            this.abrirDropdown();
        } else {
            this.fecharDropdown();
        }
    },

    /**
     * Abre dropdown e renderiza lista de projetos
     */
    abrirDropdown() {
        const dropdown = document.getElementById('project-dropdown');
        const lista = dropdown?.querySelector('.project-dropdown-list');
        if (!dropdown || !lista) return;

        // Renderizar lista de projetos
        lista.innerHTML = this.projetos.map(p => `
            <div class="project-dropdown-item ${p.id === this.projetoAtual?.id ? 'active' : ''}"
                 onclick="BelgoProjetos.selecionarProjeto(${p.id}); BelgoProjetos.fecharDropdown();"
                 style="border-left: 3px solid ${p.cor || '#003B4A'}">
                <span class="project-item-icone">${p.icone || '📁'}</span>
                <span class="project-item-nome">${p.nome}</span>
                ${p.papel_nome ? `<span class="project-item-papel">${p.papel_nome}</span>` : ''}
            </div>
        `).join('');

        dropdown.style.display = 'block';
    },

    /**
     * Fecha dropdown
     */
    fecharDropdown() {
        const dropdown = document.getElementById('project-dropdown');
        if (dropdown) {
            dropdown.style.display = 'none';
        }
    },

    /**
     * Inicializa o seletor de projetos
     */
    async init(containerId = 'project-selector-container') {
        this.renderSeletor(containerId);
        await this.carregarProjetos();
        this.atualizarUI();
    },

    /**
     * Adiciona header X-Projeto-Id a requisicoes
     */
    getProjetoHeader() {
        return { 'X-Projeto-Id': String(this.getProjetoId()) };
    },

    /**
     * Faz requisicao com contexto de projeto
     */
    async request(url, options = {}) {
        const headers = {
            ...options.headers,
            ...this.getProjetoHeader()
        };

        return BelgoAuth.request(url, { ...options, headers });
    }
};

// CSS inline para o seletor
const projetoSelectorCSS = `
    .project-selector {
        display: flex;
        align-items: center;
        position: relative;
    }

    .projeto-atual-btn {
        display: flex;
        align-items: center;
        gap: 8px;
        background: var(--bg-tertiary, #f0f0f0);
        border: 1px solid var(--border-color, #ddd);
        border-radius: 8px;
        padding: 8px 12px;
        cursor: pointer;
        font-size: 14px;
        transition: all 0.2s;
    }

    .projeto-atual-btn:hover {
        background: var(--bg-secondary, #e8e8e8);
    }

    .projeto-atual-icone {
        font-size: 16px;
    }

    .projeto-atual-nome {
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .projeto-dropdown-arrow {
        font-size: 10px;
        opacity: 0.6;
    }

    .project-dropdown {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        min-width: 250px;
        background: white;
        border: 1px solid var(--border-color, #ddd);
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 1000;
        margin-top: 4px;
        overflow: hidden;
    }

    .project-dropdown-list {
        max-height: 300px;
        overflow-y: auto;
    }

    .project-dropdown-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 12px 16px;
        cursor: pointer;
        transition: background 0.2s;
    }

    .project-dropdown-item:hover {
        background: var(--bg-secondary, #f5f5f5);
    }

    .project-dropdown-item.active {
        background: var(--primary-light, #e3f2fd);
    }

    .project-item-icone {
        font-size: 18px;
    }

    .project-item-nome {
        flex: 1;
        font-weight: 500;
    }

    .project-item-papel {
        font-size: 11px;
        padding: 2px 8px;
        background: var(--bg-tertiary, #f0f0f0);
        border-radius: 10px;
        color: var(--text-secondary, #666);
    }
`;

// Injetar CSS
if (typeof document !== 'undefined') {
    const style = document.createElement('style');
    style.textContent = projetoSelectorCSS;
    document.head.appendChild(style);
}

// Exportar para uso global
window.BelgoProjetos = BelgoProjetos;
