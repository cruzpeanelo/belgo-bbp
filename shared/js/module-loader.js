// =====================================================
// BELGO BBP - MODULE LOADER
// Sistema de navegacao multi-modulo
// =====================================================

const ModuleLoader = {
    currentModule: null,
    modules: [],
    moduleConfig: null,
    initialized: false,

    // Inicializar o sistema de modulos
    async init() {
        if (this.initialized) return;

        try {
            // Carregar configuracao central de modulos
            const basePath = this.getBasePath();
            const response = await fetch(`${basePath}/config/modules.json`);
            if (!response.ok) throw new Error('Falha ao carregar modules.json');

            const config = await response.json();
            this.modules = config.modules;

            // Detectar modulo atual pela URL
            this.currentModule = this.detectModule();

            // Se estiver em um modulo, carregar sua configuracao
            if (this.currentModule) {
                await this.loadModuleConfig();
            }

            // Renderizar seletor de modulos
            this.renderModuleSelector();

            // Renderizar sidebar se houver configuracao
            if (this.moduleConfig) {
                this.renderSidebar();
            }

            // Aplicar cor do tema do modulo
            this.applyModuleTheme();

            this.initialized = true;
            console.log('ModuleLoader inicializado:', this.currentModule || 'landing');

        } catch (error) {
            console.error('Erro ao inicializar ModuleLoader:', error);
        }
    },

    // Obter caminho base (para funcionar em subpastas)
    getBasePath() {
        const path = window.location.pathname;
        // Se estiver em /gtm/pages/algo.html, voltar para raiz
        if (path.includes('/gtm/')) return '/gtm/..';
        if (path.includes('/rede-ativa/')) return '/rede-ativa/..';
        if (path.includes('/roadmap/')) return '/roadmap/..';
        return '';
    },

    // Detectar modulo atual pela URL
    detectModule() {
        const path = window.location.pathname;

        for (const mod of this.modules) {
            if (path.includes(mod.path.replace(/\/$/, ''))) {
                return mod.id;
            }
        }

        // Se nao estiver em nenhum modulo, esta na landing
        return null;
    },

    // Carregar configuracao do modulo atual
    async loadModuleConfig() {
        const mod = this.modules.find(m => m.id === this.currentModule);
        if (!mod) return;

        try {
            const response = await fetch(`${mod.path}module.json`);
            if (response.ok) {
                this.moduleConfig = await response.json();
            }
        } catch (error) {
            console.warn('module.json nao encontrado para:', this.currentModule);
        }
    },

    // Trocar para outro modulo
    switchModule(moduleId) {
        const mod = this.modules.find(m => m.id === moduleId);
        if (mod) {
            // Salvar ultimo modulo visitado
            localStorage.setItem('belgo_last_module', moduleId);
            window.location.href = mod.path;
        }
    },

    // Renderizar seletor de modulos no header
    renderModuleSelector() {
        const header = document.querySelector('.sidebar-header');
        if (!header) return;

        const currentMod = this.modules.find(m => m.id === this.currentModule);
        const selectorHtml = `
            <div class="module-selector">
                <button class="module-selector-btn" onclick="ModuleLoader.toggleModuleDropdown()">
                    <span class="module-selector-icon">${currentMod ? currentMod.emoji : '🏠'}</span>
                    <span class="module-selector-name">${currentMod ? currentMod.name : 'Home'}</span>
                    <span class="module-selector-arrow">▼</span>
                </button>
                <div class="module-dropdown" id="moduleDropdown">
                    <a href="/" class="module-dropdown-item ${!this.currentModule ? 'active' : ''}">
                        <span class="module-icon">🏠</span>
                        <span class="module-name">Home</span>
                    </a>
                    ${this.modules.map(mod => `
                        <a href="${mod.path}" class="module-dropdown-item ${mod.id === this.currentModule ? 'active' : ''}">
                            <span class="module-icon">${mod.emoji}</span>
                            <span class="module-name">${mod.name}</span>
                            <span class="module-badge" style="background: ${mod.color}"></span>
                        </a>
                    `).join('')}
                </div>
            </div>
        `;

        // Inserir apos o subtitulo
        const subtitle = header.querySelector('.sidebar-subtitle');
        if (subtitle) {
            subtitle.insertAdjacentHTML('afterend', selectorHtml);
        }
    },

    // Toggle dropdown de modulos
    toggleModuleDropdown() {
        const dropdown = document.getElementById('moduleDropdown');
        if (dropdown) {
            dropdown.classList.toggle('open');
        }
    },

    // Renderizar sidebar dinamica
    renderSidebar() {
        if (!this.moduleConfig || !this.moduleConfig.menu) return;

        const nav = document.querySelector('.sidebar-nav');
        if (!nav) return;

        const currentPath = window.location.pathname;

        const menuHtml = this.moduleConfig.menu.map(item => {
            const isActive = currentPath.includes(item.path);
            return `
                <a href="${item.path}" class="nav-item ${isActive ? 'active' : ''}" data-page="${item.id}">
                    <span class="nav-icon">${item.icon}</span>
                    <span>${item.label}</span>
                </a>
            `;
        }).join('');

        nav.innerHTML = menuHtml;
    },

    // Aplicar tema do modulo
    applyModuleTheme() {
        const mod = this.modules.find(m => m.id === this.currentModule);
        if (mod) {
            document.documentElement.style.setProperty('--module-color', mod.color);
        }
    },

    // Obter modulo atual
    getCurrentModule() {
        return this.modules.find(m => m.id === this.currentModule);
    },

    // Obter ultimo modulo visitado
    getLastModule() {
        return localStorage.getItem('belgo_last_module') || 'gtm';
    }
};

// Fechar dropdown ao clicar fora
document.addEventListener('click', (e) => {
    if (!e.target.closest('.module-selector')) {
        const dropdown = document.getElementById('moduleDropdown');
        if (dropdown) {
            dropdown.classList.remove('open');
        }
    }
});

// Exportar para uso global
window.ModuleLoader = ModuleLoader;
