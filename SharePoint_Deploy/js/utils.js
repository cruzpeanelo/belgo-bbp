// =====================================================
// BELGO GTM - FUNÇÕES UTILITÁRIAS
// =====================================================

const Utils = {
    // Formatar data BR
    formatDate(dateStr) {
        if (!dateStr) return '-';
        const date = new Date(dateStr);
        return date.toLocaleDateString('pt-BR');
    },

    // Formatar data e hora
    formatDateTime(dateStr) {
        if (!dateStr) return '-';
        const date = new Date(dateStr);
        return date.toLocaleString('pt-BR');
    },

    // Calcular porcentagem
    calcPercent(value, total) {
        if (!total) return 0;
        return Math.round((value / total) * 100);
    },

    // Gerar cor do status
    getStatusColor(status) {
        const colors = {
            'Concluído': '#10b981',
            'Pendente': '#f59e0b',
            'Falhou': '#ef4444',
            'Em Andamento': '#3b82f6',
            'Resolvido': '#10b981',
            'Bloqueador': '#dc2626',
            'Agendado': '#6366f1'
        };
        return colors[status] || '#6b7280';
    },

    // Gerar classe CSS do badge
    getBadgeClass(status) {
        const classes = {
            'Concluído': 'badge-success',
            'Pendente': 'badge-warning',
            'Falhou': 'badge-danger',
            'Em Andamento': 'badge-info',
            'Resolvido': 'badge-success',
            'Bloqueador': 'badge-danger',
            'Crítica': 'badge-danger',
            'Alta': 'badge-warning',
            'Média': 'badge-info',
            'Baixa': 'badge-success'
        };
        return classes[status] || 'badge-info';
    },

    // Debounce para filtros
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

    // Salvar no localStorage
    saveToStorage(key, data) {
        try {
            localStorage.setItem(key, JSON.stringify(data));
            return true;
        } catch (e) {
            console.error('Erro ao salvar:', e);
            return false;
        }
    },

    // Carregar do localStorage
    loadFromStorage(key) {
        try {
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : null;
        } catch (e) {
            console.error('Erro ao carregar:', e);
            return null;
        }
    },

    // Exportar para CSV
    exportToCSV(data, filename) {
        const csv = this.convertToCSV(data);
        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = filename;
        link.click();
    },

    convertToCSV(data) {
        if (!data.length) return '';
        const headers = Object.keys(data[0]);
        const rows = data.map(obj =>
            headers.map(h => `"${(obj[h] || '').toString().replace(/"/g, '""')}"`).join(',')
        );
        return [headers.join(','), ...rows].join('\n');
    },

    // Mostrar notificação toast melhorada
    showToast(message, type = 'info', duration = 4000) {
        // Criar container se nao existir
        let container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
            document.body.appendChild(container);
        }

        // Icones por tipo
        const icons = {
            success: '✓',
            error: '✕',
            warning: '⚠',
            info: 'ℹ'
        };

        // Criar toast
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <span class="toast-icon">${icons[type] || icons.info}</span>
            <span class="toast-message">${message}</span>
            <button class="toast-close" onclick="this.parentElement.remove()">×</button>
        `;

        container.appendChild(toast);

        // Auto-remover apos duracao
        setTimeout(() => {
            toast.classList.add('removing');
            setTimeout(() => toast.remove(), 300);
        }, duration);

        return toast;
    },

    // Mostrar loading overlay
    showLoading(message = 'Carregando...') {
        let overlay = document.querySelector('.loading-overlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.className = 'loading-overlay';
            overlay.innerHTML = `
                <div class="spinner"></div>
                <div class="loading-text">${message}</div>
            `;
            document.body.appendChild(overlay);
        } else {
            overlay.classList.remove('hidden');
            const text = overlay.querySelector('.loading-text');
            if (text) text.textContent = message;
        }
        return overlay;
    },

    // Esconder loading overlay
    hideLoading() {
        const overlay = document.querySelector('.loading-overlay');
        if (overlay) {
            overlay.classList.add('hidden');
        }
    },

    // Criar estado vazio
    createEmptyState(icon, title, message, actionText, actionCallback) {
        const div = document.createElement('div');
        div.className = 'empty-state';
        div.innerHTML = `
            <div class="empty-state-icon">${icon}</div>
            <h3 class="empty-state-title">${title}</h3>
            <p class="empty-state-message">${message}</p>
            ${actionText ? `<button class="btn btn-primary">${actionText}</button>` : ''}
        `;
        if (actionText && actionCallback) {
            div.querySelector('.btn')?.addEventListener('click', actionCallback);
        }
        return div;
    },

    // Contador de resultados
    updateResultsCount(current, total, containerId = 'results-count') {
        let counter = document.getElementById(containerId);
        if (!counter) {
            counter = document.createElement('div');
            counter.id = containerId;
            counter.className = 'results-count';
        }
        counter.innerHTML = `Mostrando <strong>${current}</strong> de <strong>${total}</strong> resultados`;
        return counter;
    },

    // =====================================================
    // INTEGRAÇÃO MICROSOFT TEAMS
    // =====================================================

    // Webhook URL do Teams
    teamsWebhookUrl: 'https://arcelormittal.webhook.office.com/webhookb2/d931a635-801d-4032-ae69-27f6ee2c88af@37cd273a-1cec-4aae-a297-41480ea54f8d/IncomingWebhook/6284fbb6970849d8b57350074fa5ebff/8dd31791-e6bc-444b-b6c5-e4b6d73f1e5b/V28WZxUnp0pMRDYdKBFpYYVN6kJcnybTAzf0u5KUh9tvg1',

    // Enviar mensagem para o Teams
    async sendToTeams(card) {
        try {
            this.showLoading('Enviando para Teams...');

            // Usar mode: 'no-cors' para evitar bloqueio CORS em webhooks
            const response = await fetch(this.teamsWebhookUrl, {
                method: 'POST',
                mode: 'no-cors',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(card)
            });

            this.hideLoading();
            // Com no-cors, não recebemos status, mas a mensagem é enviada
            this.showToast('Mensagem enviada para o Teams!', 'success');
            return true;
        } catch (error) {
            this.hideLoading();
            console.error('Erro ao enviar para Teams:', error);
            this.showToast('Erro ao enviar para Teams: ' + error.message, 'error');
            return false;
        }
    },

    // Formatar MessageCard para Teams
    formatTeamsCard(tipo, titulo, facts) {
        const cores = {
            'teste': '0078d4',
            'jornada': '00A799',
            'ponto-critico': 'ED1C24',
            'reuniao': '003B4A',
            'pagina': '6264A7'
        };

        return {
            "@type": "MessageCard",
            "@context": "http://schema.org/extensions",
            "themeColor": cores[tipo] || '003B4A',
            "summary": titulo,
            "sections": [{
                "activityTitle": titulo,
                "activitySubtitle": `Cockpit GTM Belgo - ${new Date().toLocaleString('pt-BR')}`,
                "facts": facts.filter(f => f.value),
                "markdown": true
            }],
            "potentialAction": [{
                "@type": "OpenUri",
                "name": "Abrir no Cockpit",
                "targets": [{ "os": "default", "uri": window.location.href }]
            }]
        };
    },

    // Discutir página no Teams (função genérica para todas as páginas)
    async discussOnTeams(pageId, pageTitle, btn) {
        const originalText = btn.innerHTML;
        btn.innerHTML = '⏳ Enviando...';
        btn.disabled = true;
        btn.classList.remove('enviado', 'erro');

        const card = this.formatTeamsCard('pagina', `💬 Discussão: ${pageTitle}`, [
            { name: 'Página', value: pageTitle },
            { name: 'ID', value: pageId },
            { name: 'Solicitado em', value: new Date().toLocaleString('pt-BR') }
        ]);

        try {
            await fetch(this.teamsWebhookUrl, {
                method: 'POST',
                mode: 'no-cors',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(card)
            });
            btn.innerHTML = '✅ Enviado!';
            btn.classList.add('enviado');
            this.showToast('Discussão enviada para o Teams!', 'success');
            setTimeout(() => {
                btn.innerHTML = originalText;
                btn.classList.remove('enviado');
                btn.disabled = false;
            }, 2000);
        } catch (error) {
            btn.innerHTML = '❌ Erro';
            btn.classList.add('erro');
            this.showToast('Erro ao enviar para Teams: ' + error.message, 'error');
            setTimeout(() => {
                btn.innerHTML = originalText;
                btn.classList.remove('erro');
                btn.disabled = false;
            }, 2000);
            console.error('Erro ao enviar para Teams:', error);
        }
    }
};

// =====================================================
// MOBILE TOUCH IMPROVEMENTS
// =====================================================

// Detectar se é dispositivo touch
const isTouchDevice = ('ontouchstart' in window) || (navigator.maxTouchPoints > 0);

// Adicionar classe ao body para estilos específicos
if (isTouchDevice) {
    document.documentElement.classList.add('touch-device');
}

// FastClick - Remove 300ms delay em dispositivos touch
// Converte touchend em click imediatamente
function initFastClick() {
    if (!isTouchDevice) return;

    let touchStartY = 0;
    let touchStartX = 0;

    document.addEventListener('touchstart', function(e) {
        touchStartY = e.touches[0].clientY;
        touchStartX = e.touches[0].clientX;
    }, { passive: true });

    document.addEventListener('touchend', function(e) {
        // Ignora se houve scroll (movimento > 10px)
        if (!e.changedTouches || !e.changedTouches[0]) return;

        const touchEndY = e.changedTouches[0].clientY;
        const touchEndX = e.changedTouches[0].clientX;
        const deltaY = Math.abs(touchEndY - touchStartY);
        const deltaX = Math.abs(touchEndX - touchStartX);

        if (deltaY > 10 || deltaX > 10) return; // Foi scroll, não click

        const target = e.target;

        // Verifica se é um elemento clicável
        const clickable = target.closest('button, a, .btn, .btn-teams, .btn-teams-item, .nav-item, select, input');

        if (clickable && clickable.onclick) {
            // Previne o click atrasado do browser
            e.preventDefault();
            // Dispara o onclick imediatamente
            clickable.click();
        }
    }, { passive: false });
}

// Inicializa FastClick quando DOM estiver pronto
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFastClick);
} else {
    initFastClick();
}

// =====================================================
// MOBILE MENU FUNCTIONS
// =====================================================

// Toggle mobile menu
function toggleMobileMenu() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.querySelector('.sidebar-overlay');

    if (sidebar) {
        sidebar.classList.toggle('open');
    }
    if (overlay) {
        overlay.classList.toggle('active');
    }

    // Prevenir scroll do body quando menu está aberto
    document.body.style.overflow = sidebar?.classList.contains('open') ? 'hidden' : '';
}

// Fechar menu ao clicar em um link (mobile)
function setupMobileNavLinks() {
    const navLinks = document.querySelectorAll('.nav-item');
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            if (window.innerWidth <= 768) {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.querySelector('.sidebar-overlay');
                sidebar?.classList.remove('open');
                overlay?.classList.remove('active');
                document.body.style.overflow = '';
            }
        });
    });
}

// Fechar menu ao redimensionar para desktop
function handleResize() {
    if (window.innerWidth > 768) {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.querySelector('.sidebar-overlay');
        sidebar?.classList.remove('open');
        overlay?.classList.remove('active');
        document.body.style.overflow = '';
    }
}

// Inicializar eventos mobile
document.addEventListener('DOMContentLoaded', () => {
    setupMobileNavLinks();
    window.addEventListener('resize', handleResize);
});

// Exportar funções mobile para uso global
window.toggleMobileMenu = toggleMobileMenu;

// Exportar para uso global
window.Utils = Utils;
