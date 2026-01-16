// =====================================================
// BELGO BBP - DYNAMIC NAVIGATION
// Sistema de navegacao dinamica baseado em banco de dados
// =====================================================

const DynamicNav = {
    menus: [],
    projetoId: null,
    initialized: false,
    basePath: '',

    // Normalizar URL para ser absoluta (comecar com /)
    normalizeUrl(url) {
        if (!url || url === '#') return url;
        // Se ja comeca com / ou http, retornar como esta
        if (url.startsWith('/') || url.startsWith('http')) return url;
        // Adicionar / no inicio
        return '/' + url;
    },

    // Inicializar navegacao dinamica
    async init(options = {}) {
        if (this.initialized) return;

        try {
            // Obter ID do projeto
            this.projetoId = options.projetoId || this.getProjetoId();

            if (!this.projetoId) {
                console.warn('DynamicNav: projetoId nao encontrado');
                return;
            }

            // Calcular base path
            this.basePath = this.calculateBasePath();

            // Buscar menus da API
            await this.fetchMenus();

            // Renderizar sidebar
            this.renderSidebar();

            // Renderizar dropdown de projetos se houver multiplos
            if (options.showProjectSelector !== false) {
                await this.renderProjectSelector();
            }

            this.initialized = true;
            console.log('DynamicNav inicializado para projeto:', this.projetoId);

        } catch (error) {
            console.error('Erro ao inicializar DynamicNav:', error);
            // Fallback: manter menus estaticos se houver erro
        }
    },

    // Obter ID do projeto do contexto ou localStorage
    getProjetoId() {
        // Tentar do BelgoProjetoContext
        if (window.BelgoProjetoContext?.projetoAtual?.id) {
            return window.BelgoProjetoContext.projetoAtual.id;
        }

        // Tentar do localStorage
        const projetoId = localStorage.getItem('belgo_projeto_id');
        if (projetoId) {
            return parseInt(projetoId);
        }

        // Tentar inferir da URL
        return this.inferProjetoFromUrl();
    },

    // Inferir projeto da URL (fallback)
    inferProjetoFromUrl() {
        const path = window.location.pathname.toLowerCase();

        // Mapeamento de pastas para IDs de projeto (fallback)
        const mapeamento = {
            '/rede-ativa/': 2,
            '/roadmap/': 3
        };

        for (const [pasta, id] of Object.entries(mapeamento)) {
            if (path.includes(pasta)) {
                return id;
            }
        }

        // Se estiver na raiz, assume GTM (id=1)
        if (path === '/' || path === '/index.html' || path.match(/^\/[^\/]+\.html$/)) {
            return 1;
        }

        return null;
    },

    // Calcular base path para URLs relativas
    calculateBasePath() {
        const path = window.location.pathname;

        // Se estiver em subpasta, calcular caminho de volta
        if (path.includes('/rede-ativa/')) return '/rede-ativa/';
        if (path.includes('/roadmap/')) return '/roadmap/';

        return '/';
    },

    // Buscar menus do servidor
    async fetchMenus() {
        try {
            const token = sessionStorage.getItem('belgo_token');

            // Verificar se usuario eh admin (pode ver todos os menus)
            const isAdmin = window.BelgoAuth && BelgoAuth.isAdmin();

            // Usar filtro de entidades para usuarios normais
            const apiUrl = isAdmin
                ? `/api/menus/${this.projetoId}`
                : `/api/menus/${this.projetoId}?onlyEntities=true`;

            const response = await fetch(apiUrl, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
            }

            const data = await response.json();
            this.menus = data.menus || [];

        } catch (error) {
            console.error('Erro ao buscar menus:', error);
            this.menus = [];
        }
    },

    // Renderizar sidebar com menus do banco
    renderSidebar() {
        const nav = document.querySelector('.sidebar-nav');
        if (!nav) {
            console.warn('DynamicNav: .sidebar-nav nao encontrado');
            return;
        }

        if (this.menus.length === 0) {
            console.warn('DynamicNav: nenhum menu encontrado');
            return;
        }

        const currentPath = window.location.pathname;
        const currentPage = currentPath.split('/').pop() || 'index.html';

        const menuHtml = this.menus.map(menu => {
            // Verificar se e a pagina atual
            const menuPage = menu.url.split('/').pop();
            const isActive = currentPage === menuPage ||
                           currentPath.endsWith(menu.url) ||
                           (menu.url === 'index.html' && (currentPage === '' || currentPath.endsWith('/')));

            return `
                <a href="${this.normalizeUrl(menu.url)}" class="nav-item ${isActive ? 'active' : ''}" data-menu-id="${menu.id}">
                    <span class="nav-icon">${menu.icone || '📄'}</span>
                    <span>${menu.nome}</span>
                </a>
            `;
        }).join('');

        // Secao de admin (se usuario eh admin)
        let adminHtml = '';
        if (window.BelgoAuth && BelgoAuth.isAdmin()) {
            adminHtml = `
                <div class="nav-divider"></div>
                <div class="nav-section-title">Administração</div>
                <a href="/admin/entidades.html?projeto=${this.projetoId}" class="nav-item nav-admin">
                    <span class="nav-icon">🗃</span>
                    <span>Entidades</span>
                </a>
                <a href="/admin/menus.html?projeto=${this.projetoId}" class="nav-item nav-admin">
                    <span class="nav-icon">☰</span>
                    <span>Menus</span>
                </a>
                <a href="/admin/dashboard-config.html?projeto=${this.projetoId}" class="nav-item nav-admin">
                    <span class="nav-icon">📊</span>
                    <span>Dashboard Config</span>
                </a>
                <a href="/admin/index.html" class="nav-item nav-admin">
                    <span class="nav-icon">🛠️</span>
                    <span>Painel Admin Geral</span>
                </a>
            `;
        }

        // Footer com navegacao e logout
        const footerHtml = `
            <div class="nav-footer">
                <a href="/landing.html" class="nav-item">
                    <span class="nav-icon">🏠</span>
                    <span>Todos os Projetos</span>
                </a>
                <button onclick="BelgoAuth.logout()" class="nav-item nav-logout">
                    <span class="nav-icon">🚪</span>
                    <span>Sair</span>
                </button>
            </div>
        `;

        nav.innerHTML = menuHtml + adminHtml + footerHtml;
    },

    // Renderizar seletor de projetos
    async renderProjectSelector() {
        const header = document.querySelector('.sidebar-header');
        if (!header) return;

        // Verificar se ja existe seletor
        if (header.querySelector('.project-selector')) return;

        try {
            // Buscar projetos do usuario
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch('/api/projetos', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) return;

            const data = await response.json();
            const projetos = data.projetos || [];

            // Se so tem um projeto, nao mostrar seletor
            if (projetos.length <= 1) return;

            const projetoAtual = projetos.find(p => p.id === this.projetoId);

            const selectorHtml = `
                <div class="project-selector">
                    <button class="project-selector-btn" onclick="DynamicNav.toggleProjectDropdown()">
                        <span class="project-icon">${projetoAtual?.icone || '📁'}</span>
                        <span class="project-name">${projetoAtual?.nome || 'Projeto'}</span>
                        <span class="project-arrow">▼</span>
                    </button>
                    <div class="project-dropdown" id="projectDropdown">
                        <a href="/landing.html" class="project-dropdown-item">
                            <span class="project-icon">🏠</span>
                            <span class="project-name">Todos os Projetos</span>
                        </a>
                        <div class="project-dropdown-divider"></div>
                        ${projetos.map(p => {
                            const url = this.normalizeUrl(p.url_modulo) || '#';
                            return `
                            <a href="${url}"
                               class="project-dropdown-item ${p.id === this.projetoId ? 'active' : ''}"
                               onclick="event.preventDefault(); DynamicNav.switchProject(${p.id}, '${url}')">
                                <span class="project-icon">${p.icone || '📁'}</span>
                                <span class="project-name">${p.nome}</span>
                                <span class="project-badge" style="background: ${p.cor || '#003B4A'}"></span>
                            </a>
                        `}).join('')}
                    </div>
                </div>
            `;

            // Inserir apos o titulo (ou no final do header)
            const title = header.querySelector('h1, .sidebar-title, .sidebar-subtitle');
            if (title) {
                title.insertAdjacentHTML('afterend', selectorHtml);
            } else {
                header.insertAdjacentHTML('beforeend', selectorHtml);
            }

        } catch (error) {
            console.error('Erro ao carregar projetos:', error);
        }
    },

    // Toggle dropdown de projetos
    toggleProjectDropdown() {
        const dropdown = document.getElementById('projectDropdown');
        if (dropdown) {
            dropdown.classList.toggle('open');
        }
    },

    // Trocar de projeto
    switchProject(projetoId, url) {
        localStorage.setItem('belgo_projeto_id', projetoId);
        if (url && url !== '#') {
            // Normalizar URL para garantir que seja absoluta
            window.location.href = this.normalizeUrl(url);
        }
    },

    // Atualizar menu ativo
    setActiveMenu(menuId) {
        const items = document.querySelectorAll('.sidebar-nav .nav-item');
        items.forEach(item => {
            if (item.dataset.menuId === String(menuId)) {
                item.classList.add('active');
            } else {
                item.classList.remove('active');
            }
        });
    },

    // Recarregar menus
    async reload() {
        this.initialized = false;
        this.menus = [];
        await this.init({ projetoId: this.projetoId });
    }
};

// Fechar dropdown ao clicar fora
document.addEventListener('click', (e) => {
    if (!e.target.closest('.project-selector')) {
        const dropdown = document.getElementById('projectDropdown');
        if (dropdown) {
            dropdown.classList.remove('open');
        }
    }
});

// Exportar para uso global
window.DynamicNav = DynamicNav;
