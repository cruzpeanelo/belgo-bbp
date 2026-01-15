// =====================================================
// BELGO BBP - Cliente de Autenticação
// =====================================================

const BelgoAuth = {
    API_URL: '/api/auth',

    /**
     * Retorna o token da sessão
     */
    getToken() {
        return sessionStorage.getItem('belgo_token');
    },

    /**
     * Retorna dados do usuário logado
     */
    getUsuario() {
        const data = sessionStorage.getItem('belgo_usuario');
        return data ? JSON.parse(data) : null;
    },

    /**
     * Retorna módulos do usuário
     */
    getModulos() {
        const data = sessionStorage.getItem('belgo_modulos');
        return data ? JSON.parse(data) : [];
    },

    /**
     * Verifica se usuário está autenticado
     */
    isAuthenticated() {
        return !!this.getToken();
    },

    /**
     * Verifica se usuário é admin
     */
    isAdmin() {
        const usuario = this.getUsuario();
        return usuario?.isAdmin === true;
    },

    /**
     * Verifica se usuário tem acesso a um módulo
     */
    hasModuleAccess(moduloCodigo) {
        const modulos = this.getModulos();
        return modulos.some(m => m.codigo === moduloCodigo);
    },

    /**
     * Faz requisição autenticada
     */
    async request(url, options = {}) {
        const token = this.getToken();

        const defaultHeaders = {
            'Content-Type': 'application/json'
        };

        if (token) {
            defaultHeaders['Authorization'] = `Bearer ${token}`;
        }

        const response = await fetch(url, {
            ...options,
            headers: {
                ...defaultHeaders,
                ...options.headers
            }
        });

        // Sessão expirada
        if (response.status === 401) {
            this.clearSession();
            window.location.href = '/login.html?redirect=' + encodeURIComponent(window.location.pathname);
            return null;
        }

        return response;
    },

    /**
     * Login
     */
    async login(email, senha) {
        const response = await fetch(`${this.API_URL}/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, senha })
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Erro ao fazer login');
        }

        // Salvar sessão
        sessionStorage.setItem('belgo_token', data.token);
        sessionStorage.setItem('belgo_usuario', JSON.stringify(data.usuario));
        sessionStorage.setItem('belgo_modulos', JSON.stringify(data.modulos));

        return data;
    },

    /**
     * Logout
     */
    async logout() {
        const token = this.getToken();

        if (token) {
            try {
                await fetch(`${this.API_URL}/logout`, {
                    method: 'POST',
                    headers: { 'Authorization': `Bearer ${token}` }
                });
            } catch (e) {
                // Ignorar erro
            }
        }

        this.clearSession();
        window.location.href = '/login.html';
    },

    /**
     * Limpa sessão local
     */
    clearSession() {
        sessionStorage.removeItem('belgo_token');
        sessionStorage.removeItem('belgo_usuario');
        sessionStorage.removeItem('belgo_modulos');
    },

    /**
     * Verifica e redireciona se não autenticado
     */
    async requireAuth(moduloCodigo = null) {
        if (!this.isAuthenticated()) {
            window.location.href = '/login.html?redirect=' + encodeURIComponent(window.location.pathname);
            return false;
        }

        // Verificar sessão no servidor
        try {
            const response = await this.request(`${this.API_URL}/me`);
            if (!response || !response.ok) {
                this.clearSession();
                window.location.href = '/login.html';
                return false;
            }

            const data = await response.json();

            // Atualizar dados locais
            sessionStorage.setItem('belgo_usuario', JSON.stringify(data.usuario));
            sessionStorage.setItem('belgo_modulos', JSON.stringify(data.modulos));

            // Verificar acesso ao módulo
            if (moduloCodigo && !data.modulos.some(m => m.codigo === moduloCodigo)) {
                alert(`Você não tem acesso ao módulo ${moduloCodigo}`);
                window.location.href = '/landing.html';
                return false;
            }

            return true;

        } catch (error) {
            console.error('Erro ao verificar autenticação:', error);
            this.clearSession();
            window.location.href = '/login.html';
            return false;
        }
    },

    /**
     * Trocar senha
     */
    async changePassword(senhaAtual, novaSenha, confirmarSenha) {
        const response = await this.request(`${this.API_URL}/change-password`, {
            method: 'POST',
            body: JSON.stringify({ senhaAtual, novaSenha, confirmarSenha })
        });

        if (!response) return null;

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Erro ao trocar senha');
        }

        return data;
    },

    /**
     * Renderiza informações do usuário na interface
     */
    renderUserInfo(containerId = 'userInfo') {
        const container = document.getElementById(containerId);
        if (!container) return;

        const usuario = this.getUsuario();
        if (!usuario) return;

        container.innerHTML = `
            <span class="user-name">${usuario.nome}</span>
            ${this.isAdmin() ? '<span class="user-badge admin">Admin</span>' : ''}
        `;
    },

    /**
     * Renderiza botão de logout
     */
    renderLogoutButton(containerId = 'logoutBtn') {
        const container = document.getElementById(containerId);
        if (!container) return;

        container.innerHTML = `
            <button onclick="BelgoAuth.logout()" class="btn-logout">Sair</button>
        `;
    },

    // =========================================
    // PERMISSOES POR PROJETO
    // =========================================

    /**
     * Cache de permissoes por projeto
     */
    _permissoesCache: {},

    /**
     * Carrega permissoes do usuario em um projeto
     * @param {number} projetoId - ID do projeto
     * @param {boolean} forceRefresh - Forcar atualizacao do cache
     * @returns {Promise<Object>}
     */
    async getPermissoes(projetoId, forceRefresh = false) {
        // Verificar cache
        if (!forceRefresh && this._permissoesCache[projetoId]) {
            return this._permissoesCache[projetoId];
        }

        try {
            const response = await this.request(`/api/projetos/${projetoId}/permissoes`);
            if (!response || !response.ok) {
                return null;
            }

            const data = await response.json();
            if (data.success) {
                // Salvar no cache
                this._permissoesCache[projetoId] = data;
                return data;
            }

            return null;
        } catch (error) {
            console.error('Erro ao carregar permissoes:', error);
            return null;
        }
    },

    /**
     * Verifica se usuario tem uma permissao especifica
     * @param {number} projetoId - ID do projeto
     * @param {string} permissao - Codigo da permissao (ex: 'testes.criar')
     * @returns {Promise<boolean>}
     */
    async temPermissao(projetoId, permissao) {
        const dados = await this.getPermissoes(projetoId);
        if (!dados) return false;

        // Admin tem todas as permissoes
        if (dados.isAdmin || dados.isAdminGlobal) return true;

        // Verificar na lista de permissoes
        return dados.permissoes && dados.permissoes.includes(permissao);
    },

    /**
     * Verifica se usuario pode criar em uma entidade
     * @param {number} projetoId - ID do projeto
     * @param {string} entidadeCodigo - Codigo da entidade (opcional)
     * @returns {Promise<boolean>}
     */
    async podeCriar(projetoId, entidadeCodigo = null) {
        const dados = await this.getPermissoes(projetoId);
        if (!dados) return false;
        if (dados.isAdmin || dados.isAdminGlobal) return true;
        if (entidadeCodigo) {
            return dados.permissoes && dados.permissoes.includes(`${entidadeCodigo}.criar`);
        }
        return dados.pode && dados.pode.criar;
    },

    /**
     * Verifica se usuario pode editar em uma entidade
     * @param {number} projetoId - ID do projeto
     * @param {string} entidadeCodigo - Codigo da entidade (opcional)
     * @returns {Promise<boolean>}
     */
    async podeEditar(projetoId, entidadeCodigo = null) {
        const dados = await this.getPermissoes(projetoId);
        if (!dados) return false;
        if (dados.isAdmin || dados.isAdminGlobal) return true;
        if (entidadeCodigo) {
            return dados.permissoes && dados.permissoes.includes(`${entidadeCodigo}.editar`);
        }
        return dados.pode && dados.pode.editar;
    },

    /**
     * Verifica se usuario pode excluir em uma entidade
     * @param {number} projetoId - ID do projeto
     * @param {string} entidadeCodigo - Codigo da entidade (opcional)
     * @returns {Promise<boolean>}
     */
    async podeExcluir(projetoId, entidadeCodigo = null) {
        const dados = await this.getPermissoes(projetoId);
        if (!dados) return false;
        if (dados.isAdmin || dados.isAdminGlobal) return true;
        if (entidadeCodigo) {
            return dados.permissoes && dados.permissoes.includes(`${entidadeCodigo}.excluir`);
        }
        return dados.pode && dados.pode.excluir;
    },

    /**
     * Verifica se usuario e admin do projeto
     * @param {number} projetoId - ID do projeto
     * @returns {Promise<boolean>}
     */
    async isProjetoAdmin(projetoId) {
        const dados = await this.getPermissoes(projetoId);
        if (!dados) return false;
        return dados.isAdmin || dados.isAdminGlobal;
    },

    /**
     * Retorna papel do usuario no projeto
     * @param {number} projetoId - ID do projeto
     * @returns {Promise<Object|null>}
     */
    async getPapel(projetoId) {
        const dados = await this.getPermissoes(projetoId);
        if (!dados) return null;
        return dados.papel;
    },

    /**
     * Limpa cache de permissoes
     * @param {number} projetoId - ID do projeto (opcional, se nao passar limpa tudo)
     */
    limparCachePermissoes(projetoId = null) {
        if (projetoId) {
            delete this._permissoesCache[projetoId];
        } else {
            this._permissoesCache = {};
        }
    }
};

// Exportar para uso global
window.BelgoAuth = BelgoAuth;
