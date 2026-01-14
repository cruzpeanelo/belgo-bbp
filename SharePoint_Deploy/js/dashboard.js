// =====================================================
// BELGO GTM - LÓGICA DO DASHBOARD
// =====================================================

const Dashboard = {
    // Inicializar dashboard
    async init() {
        // Mostrar skeletons imediatamente
        this.showSkeletons();

        // Aguardar App carregar dados
        await this.waitForData();

        // Substituir skeletons por dados reais
        this.renderMetrics();
        this.renderCategoriasProgress();
        this.renderPontosCriticos();
        this.renderWorkshops();
        this.updateLastUpdate();
    },

    // Mostrar skeleton loaders enquanto carrega
    showSkeletons() {
        // Skeleton para métricas
        const metricsContainer = document.getElementById('metrics-grid');
        if (metricsContainer) {
            metricsContainer.innerHTML = Array(8).fill(0).map(() => `
                <div class="skeleton-metric">
                    <div class="skeleton skeleton-metric-icon"></div>
                    <div class="skeleton-metric-info">
                        <div class="skeleton skeleton-metric-value"></div>
                        <div class="skeleton skeleton-metric-label"></div>
                    </div>
                </div>
            `).join('');
        }

        // Skeleton para categorias
        const categoriasContainer = document.getElementById('categorias-progress');
        if (categoriasContainer) {
            categoriasContainer.innerHTML = Array(5).fill(0).map(() => `
                <div class="skeleton-progress">
                    <div class="skeleton-progress-header">
                        <div class="skeleton skeleton-progress-label"></div>
                        <div class="skeleton skeleton-progress-value"></div>
                    </div>
                    <div class="skeleton skeleton-progress-bar"></div>
                </div>
            `).join('');
        }

        // Skeleton para pontos críticos
        const pontosContainer = document.getElementById('pontos-criticos-list');
        if (pontosContainer) {
            pontosContainer.innerHTML = Array(4).fill(0).map(() => `
                <div class="skeleton-card" style="margin-bottom: 10px;">
                    <div class="skeleton-card-header">
                        <div class="skeleton skeleton-card-title"></div>
                        <div class="skeleton skeleton-card-badge"></div>
                    </div>
                    <div class="skeleton skeleton-card-line" style="width: 90%;"></div>
                </div>
            `).join('');
        }

        // Skeleton para workshops
        const workshopsContainer = document.getElementById('workshops-timeline');
        if (workshopsContainer) {
            workshopsContainer.innerHTML = Array(3).fill(0).map(() => `
                <div class="skeleton-card" style="margin-bottom: 15px;">
                    <div class="skeleton-card-header">
                        <div class="skeleton skeleton-card-title" style="width: 180px;"></div>
                        <div class="skeleton skeleton-card-badge"></div>
                    </div>
                    <div class="skeleton skeleton-card-line" style="width: 100px; margin-top: 5px;"></div>
                    <div style="display: flex; gap: 8px; margin-top: 10px;">
                        <div class="skeleton" style="width: 80px; height: 20px; border-radius: 12px;"></div>
                        <div class="skeleton" style="width: 100px; height: 20px; border-radius: 12px;"></div>
                    </div>
                </div>
            `).join('');
        }
    },

    // Aguardar dados carregarem
    waitForData() {
        return new Promise((resolve) => {
            const check = () => {
                if (App.data.dashboard && App.data.cronograma) {
                    resolve();
                } else {
                    setTimeout(check, 100);
                }
            };
            check();
        });
    },

    // Renderizar métricas principais com animação countUp
    renderMetrics() {
        const metrics = App.data.dashboard.metricas;
        const container = document.getElementById('metrics-grid');
        if (!container) return;

        const metricsData = [
            { icon: '📊', iconClass: 'blue', value: metrics.totalTestes, label: 'Total de Testes' },
            { icon: '✅', iconClass: 'green', value: metrics.testesExecutados, label: 'Executados' },
            { icon: '⏳', iconClass: 'yellow', value: metrics.testesPendentes, label: 'Pendentes' },
            { icon: '❌', iconClass: 'red', value: metrics.testesFalhados, label: 'Falharam' },
            { icon: '🔄', style: 'background: #e0f2fe; color: #0369a1;', value: metrics.totalJornadas || 14, label: 'Jornadas' },
            { icon: '⚠️', style: 'background: #fef3c7; color: #92400e;', value: metrics.pontosCriticos || 0, label: 'Pontos Críticos' },
            { icon: '👥', style: 'background: #f0fdf4; color: #166534;', value: metrics.totalParticipantes || 0, label: 'Participantes' },
            { icon: '📖', style: 'background: #fdf4ff; color: #86198f;', value: metrics.totalTermosGlossario || 0, label: 'Termos Glossário' }
        ];

        container.innerHTML = metricsData.map((m, i) => `
            <div class="metric-card">
                <div class="metric-icon ${m.iconClass || ''}" ${m.style ? `style="${m.style}"` : ''}>${m.icon}</div>
                <div class="metric-info">
                    <h3 class="countup" data-target="${m.value}">0</h3>
                    <p>${m.label}</p>
                </div>
            </div>
        `).join('');

        // Aplicar animação countUp após renderização
        setTimeout(() => {
            container.querySelectorAll('.countup').forEach((el, i) => {
                const target = parseInt(el.dataset.target, 10);
                // Delay escalonado para cada número
                setTimeout(() => Utils.countUp(el, target, 800), i * 50);
            });
        }, 100);
    },

    // Renderizar progresso por categoria
    renderCategoriasProgress() {
        const categorias = App.data.dashboard.statusPorCategoria;
        const container = document.getElementById('categorias-progress');
        if (!container) return;

        container.innerHTML = categorias.map(cat => {
            const percent = Utils.calcPercent(cat.ok, cat.total);
            return `
                <div style="margin-bottom: 20px;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                        <span style="font-weight: 500;">${cat.categoria}</span>
                        <span style="color: #6b7280; font-size: 0.9rem;">
                            ${cat.ok}/${cat.total} (${percent}%)
                        </span>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: ${percent}%; background: ${cat.cor};"></div>
                    </div>
                    <div style="display: flex; gap: 15px; margin-top: 5px; font-size: 0.8rem; color: #6b7280;">
                        <span>✅ ${cat.ok} OK</span>
                        <span>❌ ${cat.falhou} Falhou</span>
                        <span>⏳ ${cat.pendente} Pendente</span>
                    </div>
                </div>
            `;
        }).join('');
    },

    // Renderizar pontos críticos
    renderPontosCriticos() {
        const issues = App.data.pontosCriticos?.issues || [];
        const container = document.getElementById('pontos-criticos-list');
        if (!container) return;

        // Mostrar apenas os 4 mais críticos (não resolvidos)
        const criticalIssues = issues
            .filter(i => i.status !== 'Resolvido')
            .slice(0, 4);

        container.innerHTML = criticalIssues.map(issue => `
            <div style="padding: 12px; border-left: 4px solid ${this.getSeverityColor(issue.severidade)};
                        background: #f9fafb; margin-bottom: 10px; border-radius: 0 8px 8px 0;">
                <div style="display: flex; justify-content: space-between; align-items: start;">
                    <strong style="font-size: 0.9rem;">${issue.id}: ${issue.título}</strong>
                    <span class="badge ${Utils.getBadgeClass(issue.severidade)}">${issue.severidade}</span>
                </div>
                <p style="font-size: 0.8rem; color: #6b7280; margin-top: 5px;">
                    ${(issue.descrição || '').substring(0, 80)}...
                </p>
            </div>
        `).join('') || '<p style="color: #6b7280;">Nenhum ponto crítico pendente</p>';
    },

    // Renderizar timeline de workshops
    renderWorkshops() {
        const workshops = App.data.cronograma?.workshops || [];
        const container = document.getElementById('workshops-timeline');
        if (!container) return;

        container.innerHTML = workshops.map(w => `
            <div class="timeline-item ${w.status === 'Concluído' ? 'completed' : 'pending'}">
                <div style="display: flex; justify-content: space-between; align-items: start;">
                    <div>
                        <strong>${w.título}</strong>
                        <p style="font-size: 0.85rem; color: #6b7280; margin-top: 3px;">
                            ${Utils.formatDate(w.data)}
                        </p>
                    </div>
                    <span class="badge ${Utils.getBadgeClass(w.status)}">${w.status}</span>
                </div>
                <div style="margin-top: 8px; display: flex; gap: 8px; flex-wrap: wrap;">
                    ${w.foco.map(f => `<span style="background: #e5e7eb; padding: 2px 8px; border-radius: 12px; font-size: 0.75rem;">${f}</span>`).join('')}
                </div>
            </div>
        `).join('');
    },

    // Atualizar última atualização
    updateLastUpdate() {
        const el = document.getElementById('ultima-atualizacao');
        // Suporta ambas as versões da chave (com e sem acento)
        const data = App.data.dashboard?.últimaAtualização || App.data.dashboard?.ultimaAtualizacao;
        if (el && data) {
            el.textContent = Utils.formatDateTime(data);
        }
    },

    // Cor por severidade
    getSeverityColor(severity) {
        const colors = {
            'Bloqueador': '#dc2626',
            'Crítica': '#ef4444',
            'Alta': '#f59e0b',
            'Média': '#3b82f6',
            'Baixa': '#10b981'
        };
        return colors[severity] || '#6b7280';
    }
};

// Inicializar quando App estiver pronto
document.addEventListener('DOMContentLoaded', () => {
    setTimeout(() => Dashboard.init(), 200);
});

window.Dashboard = Dashboard;
