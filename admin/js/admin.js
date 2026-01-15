// =====================================================
// BELGO BBP - Admin JavaScript
// =====================================================

const API_BASE = '';

/**
 * Faz requisição autenticada para a API
 */
async function apiRequest(url, options = {}) {
    const token = sessionStorage.getItem('belgo_token');

    const defaultOptions = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
        }
    };

    const response = await fetch(`${API_BASE}${url}`, {
        ...defaultOptions,
        ...options,
        headers: {
            ...defaultOptions.headers,
            ...options.headers
        }
    });

    const data = await response.json();

    if (response.status === 401) {
        // Sessão expirada
        sessionStorage.clear();
        window.location.href = '/login.html?redirect=' + encodeURIComponent(window.location.pathname);
        throw new Error('Sessão expirada');
    }

    if (response.status === 403) {
        alert('Acesso negado. Você não tem permissão para esta ação.');
        throw new Error('Acesso negado');
    }

    return data;
}

/**
 * Verifica autenticação e permissão admin
 */
async function checkAuth() {
    const token = sessionStorage.getItem('belgo_token');
    const usuario = sessionStorage.getItem('belgo_usuario');

    if (!token || !usuario) {
        window.location.href = '/login.html?redirect=' + encodeURIComponent(window.location.pathname);
        return false;
    }

    try {
        const userData = JSON.parse(usuario);

        // Verificar se é admin
        if (!userData.isAdmin) {
            alert('Acesso negado. Área restrita a administradores.');
            window.location.href = '/landing.html';
            return false;
        }

        // Atualizar nome na interface
        const userNameEl = document.getElementById('userName');
        if (userNameEl) {
            userNameEl.textContent = userData.nome;
        }

        // Verificar sessão no servidor
        const res = await apiRequest('/api/auth/me');
        if (!res.success || !res.usuario.isAdmin) {
            sessionStorage.clear();
            window.location.href = '/login.html';
            return false;
        }

        return true;

    } catch (error) {
        console.error('Erro ao verificar auth:', error);
        return false;
    }
}

/**
 * Logout
 */
async function logout() {
    try {
        await apiRequest('/api/auth/logout', { method: 'POST' });
    } catch (e) {
        // Ignorar erro
    }

    sessionStorage.clear();
    window.location.href = '/login.html';
}

/**
 * Formata data para exibição
 */
function formatDate(dateString) {
    if (!dateString) return '-';

    const date = new Date(dateString);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');

    return `${day}/${month}/${year} ${hours}:${minutes}`;
}

/**
 * Formata data curta
 */
function formatDateShort(dateString) {
    if (!dateString) return '-';

    const date = new Date(dateString);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');

    return `${day}/${month}`;
}
