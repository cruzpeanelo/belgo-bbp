// =====================================================
// BELGO GTM - LÓGICA DA PÁGINA DE TESTES
// =====================================================

const Testes = {
    filtros: {
        categoria: 'all',
        status: 'all',
        busca: '',
        ids: []  // IDs especificos vindos da URL
    },
    origemJornada: null,  // Origem da navegacao (ex: ciclo de teste)

    async init() {
        await this.waitForData();
        this.parseUrlParams();  // Ler parametros da URL primeiro
        this.populateCategorias();
        this.setupFilters();
        this.renderBreadcrumb();  // Mostrar origem se veio de jornadas
        this.renderResumo();
        this.renderTabela();
    },

    parseUrlParams() {
        const params = new URLSearchParams(window.location.search);

        // Ler IDs especificos
        const idsParam = params.get('ids');
        if (idsParam) {
            this.filtros.ids = idsParam.split(',').map(id => id.trim());
        }

        // Ler origem (nome do ciclo de teste)
        const origemParam = params.get('origem');
        if (origemParam) {
            this.origemJornada = decodeURIComponent(origemParam);
        }
    },

    renderBreadcrumb() {
        const container = document.getElementById('breadcrumb-container');
        if (!container) return;

        if (this.origemJornada && this.filtros.ids.length > 0) {
            container.innerHTML = `
                <div class="breadcrumb-alert">
                    <span class="breadcrumb-icon">🔗</span>
                    <span class="breadcrumb-text">
                        <strong>Origem:</strong> ${this.origemJornada}
                    </span>
                    <span class="breadcrumb-count">${this.filtros.ids.length} teste(s) vinculado(s)</span>
                    <button class="breadcrumb-clear" onclick="Testes.clearUrlFilter()">✕ Limpar filtro</button>
                </div>
            `;
            container.style.display = 'block';
        } else {
            container.style.display = 'none';
        }
    },

    clearUrlFilter() {
        this.filtros.ids = [];
        this.origemJornada = null;
        // Limpar URL
        window.history.replaceState({}, document.title, window.location.pathname);
        this.renderBreadcrumb();
        this.renderResumo();
        this.renderTabela();
    },

    waitForData() {
        return new Promise((resolve) => {
            const check = () => {
                if (App.data.testes) resolve();
                else setTimeout(check, 100);
            };
            check();
        });
    },

    populateCategorias() {
        const select = document.getElementById('filter-categoria');
        if (!select) return;

        App.data.testes.categorias.forEach(cat => {
            const opt = document.createElement('option');
            opt.value = cat.id;
            opt.textContent = `${cat.nome} (${cat.range})`;
            select.appendChild(opt);
        });
    },

    setupFilters() {
        const categoriaSelect = document.getElementById('filter-categoria');
        const statusSelect = document.getElementById('filter-status');
        const buscaInput = document.getElementById('filter-busca');

        categoriaSelect?.addEventListener('change', (e) => {
            this.filtros.categoria = e.target.value;
            this.renderTabela();
        });

        statusSelect?.addEventListener('change', (e) => {
            this.filtros.status = e.target.value;
            this.renderTabela();
        });

        buscaInput?.addEventListener('input', Utils.debounce((e) => {
            this.filtros.busca = e.target.value;
            this.renderTabela();
        }, 300));
    },

    renderResumo() {
        const container = document.getElementById('testes-resumo');
        if (!container) return;

        const stats = this.calcularStats();

        container.innerHTML = `
            <div class="metric-card">
                <div class="metric-icon blue">📊</div>
                <div class="metric-info">
                    <h3>${stats.total}</h3>
                    <p>Total Filtrado</p>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon green">✅</div>
                <div class="metric-info">
                    <h3>${stats.concluido}</h3>
                    <p>Concluídos</p>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon yellow">⏳</div>
                <div class="metric-info">
                    <h3>${stats.pendente}</h3>
                    <p>Pendentes</p>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon red">❌</div>
                <div class="metric-info">
                    <h3>${stats.falhou}</h3>
                    <p>Falharam</p>
                </div>
            </div>
        `;
    },

    calcularStats() {
        const testes = this.getTestesFiltrados();
        return {
            total: testes.length,
            concluido: testes.filter(t => t.status === 'Concluído').length,
            pendente: testes.filter(t => t.status === 'Pendente').length,
            falhou: testes.filter(t => t.status === 'Falhou').length
        };
    },

    getTestesFiltrados() {
        return App.filterTests(this.filtros);
    },

    renderTabela() {
        const tbody = document.getElementById('testes-tbody');
        if (!tbody) return;

        const testes = this.getTestesFiltrados();
        this.renderResumo();

        if (testes.length === 0) {
            tbody.innerHTML = `<tr><td colspan="5" style="text-align: center; padding: 40px; color: #6b7280;">Nenhum teste encontrado</td></tr>`;
            return;
        }

        tbody.innerHTML = testes.map(t => `
            <tr>
                <td><strong>${t.id}</strong></td>
                <td>${t.nome}</td>
                <td><span style="color: #6b7280; font-size: 0.85rem;">${t.categoria}</span></td>
                <td><span class="badge ${Utils.getBadgeClass(t.status)}">${t.status}</span></td>
                <td>
                    <button class="btn btn-primary" style="padding: 5px 10px; font-size: 0.8rem;"
                            onclick="Testes.verDetalhe('${t.id}')">Ver</button>
                    ${t.status === 'Pendente' ? `
                        <button class="btn btn-success" style="padding: 5px 10px; font-size: 0.8rem;"
                                onclick="Testes.marcarStatus('${t.id}', 'Concluído')">OK</button>
                    ` : ''}
                    <button class="btn" style="background: #6264A7; color: white; padding: 5px 10px; font-size: 0.8rem;"
                            onclick="event.stopPropagation(); Testes.compartilharTeams('${t.id}')">📤</button>
                </td>
            </tr>
        `).join('');
    },

    verDetalhe(id) {
        let teste = null;
        let categoria = '';

        for (const cat of App.data.testes.categorias) {
            const found = cat.casos.find(c => c.id === id);
            if (found) {
                teste = found;
                categoria = cat.nome;
                break;
            }
        }

        if (!teste) return;

        document.getElementById('modal-titulo').textContent = `${teste.id}: ${teste.nome}`;
        document.getElementById('modal-body').innerHTML = `
            <div style="margin-bottom: 20px;">
                <span class="badge ${Utils.getBadgeClass(teste.status)}">${teste.status}</span>
                <span style="margin-left: 10px; color: #6b7280;">${categoria}</span>
            </div>

            <h4 style="color: #003B4A; margin-bottom: 10px;">Passo a Passo</h4>
            <ol style="margin: 0 0 20px 20px; line-height: 1.8;">
                ${teste.passos.map(p => `<li>${p}</li>`).join('')}
            </ol>

            <h4 style="color: #003B4A; margin-bottom: 10px;">Resultado Esperado</h4>
            <div style="background: #f3f4f6; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                ${teste.resultadoEsperado}
            </div>

            ${teste.resultadoObtido ? `
                <h4 style="color: #003B4A; margin-bottom: 10px;">Resultado Obtido</h4>
                <div style="background: ${teste.status === 'Falhou' ? '#fee2e2' : '#d1fae5'}; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    ${teste.resultadoObtido}
                </div>
            ` : ''}

            ${teste.observacoes ? `
                <h4 style="color: #003B4A; margin-bottom: 10px;">Observações</h4>
                <div style="background: #fef3c7; padding: 15px; border-radius: 8px;">
                    ${teste.observacoes}
                </div>
            ` : ''}

            <div style="margin-top: 25px; padding-top: 20px; border-top: 1px solid #e5e7eb;">
                <button class="btn btn-success" onclick="Testes.marcarStatus('${teste.id}', 'Concluído'); Testes.fecharModal();">
                    ✅ Marcar Concluído
                </button>
                <button class="btn btn-danger" onclick="Testes.marcarStatus('${teste.id}', 'Falhou'); Testes.fecharModal();">
                    ❌ Marcar Falhou
                </button>
                <button class="btn" style="background: #f59e0b; color: white;" onclick="Testes.marcarStatus('${teste.id}', 'Pendente'); Testes.fecharModal();">
                    ⏳ Marcar Pendente
                </button>
                <button class="btn" style="background: #6264A7; color: white; margin-left: 10px;" onclick="Testes.compartilharTeams('${teste.id}');">
                    📤 Teams
                </button>
            </div>
        `;

        document.getElementById('modal-detalhe').classList.add('active');
    },

    fecharModal() {
        document.getElementById('modal-detalhe').classList.remove('active');
    },

    marcarStatus(id, status) {
        App.updateTestStatus(id, status);
        this.renderTabela();
        Utils.showToast(`Teste ${id} marcado como ${status}`, status === 'Concluído' ? 'success' : status === 'Falhou' ? 'error' : 'info');
    },

    exportar() {
        const testes = this.getTestesFiltrados().map(t => ({
            ID: t.id,
            Nome: t.nome,
            Categoria: t.categoria,
            Status: t.status,
            Sistema: t.sistema || '',
            Prioridade: t.prioridade || ''
        }));
        Utils.exportToCSV(testes, `testes_belgo_${new Date().toISOString().split('T')[0]}.csv`);
        Utils.showToast('Exportação realizada com sucesso!', 'success');
    },

    // Compartilhar teste no Microsoft Teams
    async compartilharTeams(id) {
        let teste = null;
        let categoria = '';

        for (const cat of App.data.testes.categorias) {
            const found = cat.casos.find(c => c.id === id);
            if (found) {
                teste = found;
                categoria = cat.nome;
                break;
            }
        }

        if (!teste) {
            Utils.showToast('Teste não encontrado', 'error');
            return;
        }

        const card = Utils.formatTeamsCard('teste', `📋 Teste: ${teste.id} - ${teste.nome}`, [
            { name: "Status", value: teste.status },
            { name: "Categoria", value: categoria },
            { name: "Sistema", value: teste.sistema },
            { name: "Prioridade", value: teste.prioridade },
            { name: "Resultado Esperado", value: teste.resultadoEsperado },
            { name: "Observações", value: teste.observacoes }
        ]);

        await Utils.sendToTeams(card);
    }
};

document.addEventListener('DOMContentLoaded', () => {
    setTimeout(() => Testes.init(), 200);
});

// Fechar modal ao clicar fora
document.addEventListener('click', (e) => {
    if (e.target.classList.contains('modal-overlay')) {
        Testes.fecharModal();
    }
});

window.Testes = Testes;
