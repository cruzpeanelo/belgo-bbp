// =====================================================
// BELGO GTM - LÓGICA DO DASHBOARD
// =====================================================

const Dashboard = {
    // Inicializar dashboard
    async init() {
        // Aguardar App carregar dados
        await this.waitForData();
        this.renderMetrics();
        this.renderCategoriasProgress();
        this.renderPontosCriticos();
        this.renderWorkshops();
        this.updateLastUpdate();
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

    // Renderizar métricas principais
    renderMetrics() {
        const metrics = App.data.dashboard.metricas;
        const container = document.getElementById('metrics-grid');
        if (!container) return;

        container.innerHTML = `
            <div class="metric-card">
                <div class="metric-icon blue">📊</div>
                <div class="metric-info">
                    <h3>${metrics.totalTestes}</h3>
                    <p>Total de Testes</p>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon green">✅</div>
                <div class="metric-info">
                    <h3>${metrics.testesExecutados}</h3>
                    <p>Executados</p>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon yellow">⏳</div>
                <div class="metric-info">
                    <h3>${metrics.testesPendentes}</h3>
                    <p>Pendentes</p>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon red">❌</div>
                <div class="metric-info">
                    <h3>${metrics.testesFalhados}</h3>
                    <p>Falharam</p>
                </div>
            </div>
        `;
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
                    <strong style="font-size: 0.9rem;">${issue.id}: ${issue.titulo}</strong>
                    <span class="badge ${Utils.getBadgeClass(issue.severidade)}">${issue.severidade}</span>
                </div>
                <p style="font-size: 0.8rem; color: #6b7280; margin-top: 5px;">
                    ${issue.descricao.substring(0, 80)}...
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
                        <strong>${w.titulo}</strong>
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
        if (el && App.data.dashboard?.ultimaAtualizacao) {
            el.textContent = Utils.formatDateTime(App.data.dashboard.ultimaAtualizacao);
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
