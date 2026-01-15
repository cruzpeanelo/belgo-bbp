// =====================================================
// BELGO BBP - Cliente de Autenticacao
// =====================================================

const BelgoAuth = {
    API_URL: '/api/auth',

    /**
     * Retorna o token da sessao
     */
    getToken() {
        return sessionStorage.getItem('belgo_token');
    },

    /**
     * Retorna dados do usuario logado
     */
    getUsuario() {
        const data = sessionStorage.getItem('belgo_usuario');
        return data ? JSON.parse(data) : null;
    },

    /**
     * Retorna modulos do usuario
     */
    getModulos() {
        const data = sessionStorage.getItem('belgo_modulos');
        return data ? JSON.parse(data) : [];
    },

    /**
     * Verifica se usuario esta autenticado
     */
    isAuthenticated() {
        return !!this.getToken();
    },

    /**
     * Verifica se usuario e admin
     */
    isAdmin() {
        const usuario = this.getUsuario();
        return usuario?.isAdmin === true;
    },

    /**
     * Verifica se usuario tem acesso a um modulo
     */
    hasModuleAccess(moduloCodigo) {
        const modulos = this.getModulos();
        return modulos.some(m => m.codigo === moduloCodigo);
    },

    /**
     * Faz requisicao autenticada
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

        // Sessao expirada
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

        // Salvar sessao
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
     * Limpa sessao local
     */
    clearSession() {
        sessionStorage.removeItem('belgo_token');
        sessionStorage.removeItem('belgo_usuario');
        sessionStorage.removeItem('belgo_modulos');
    },

    /**
     * Verifica e redireciona se nao autenticado
     */
    async requireAuth(moduloCodigo = null) {
        if (!this.isAuthenticated()) {
            window.location.href = '/login.html?redirect=' + encodeURIComponent(window.location.pathname);
            return false;
        }

        // Verificar sessao no servidor
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

            // Verificar acesso ao modulo
            if (moduloCodigo && !data.modulos.some(m => m.codigo === moduloCodigo)) {
                alert(`Voce nao tem acesso ao modulo ${moduloCodigo}`);
                window.location.href = '/landing.html';
                return false;
            }

            return true;

        } catch (error) {
            console.error('Erro ao verificar autenticacao:', error);
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
     * Renderiza informacoes do usuario na interface
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
     * Renderiza botao de logout
     */
    renderLogoutButton(containerId = 'logoutBtn') {
        const container = document.getElementById(containerId);
        if (!container) return;

        container.innerHTML = `
            <button onclick="BelgoAuth.logout()" class="btn-logout">Sair</button>
        `;
    }
};

// Exportar para uso global
window.BelgoAuth = BelgoAuth;
