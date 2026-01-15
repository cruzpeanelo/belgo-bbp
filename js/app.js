// =====================================================
// BELGO GTM - CORE DA APLICAÇÃO
// =====================================================

// =====================================================
// CONTROLE DE ACESSO - Verificação de Autenticação
// =====================================================
(function() {
    const SENHA_CORRETA = 'BelgoGTM2024';
    if (sessionStorage.getItem('belgo_auth') === 'true') return;

    document.addEventListener('DOMContentLoaded', function() {
        const appContainer = document.querySelector('.app-container');
        if (appContainer) appContainer.style.display = 'none';

        const loginOverlay = document.createElement('div');
        loginOverlay.className = 'login-overlay';
        loginOverlay.innerHTML = `
            <div class="login-box">
                <div class="login-logo">BELGO</div>
                <h2>Acesso Restrito</h2>
                <p>Cockpit GTM Belgo</p>
                <input type="password" id="senha-input" placeholder="Digite a senha" autocomplete="off">
                <button id="btn-entrar">Entrar</button>
                <p id="erro-msg" class="erro"></p>
            </div>
        `;
        document.body.appendChild(loginOverlay);

        const senhaInput = document.getElementById('senha-input');
        senhaInput.focus();

        function validarSenha() {
            if (senhaInput.value === SENHA_CORRETA) {
                sessionStorage.setItem('belgo_auth', 'true');
                location.reload();
            } else {
                document.getElementById('erro-msg').textContent = 'Senha incorreta';
                senhaInput.value = '';
                senhaInput.focus();
            }
        }

        document.getElementById('btn-entrar').addEventListener('click', validarSenha);
        senhaInput.addEventListener('keypress', e => { if (e.key === 'Enter') validarSenha(); });
    });

    throw new Error('Autenticação necessária');
})();

// =====================================================
// SINCRONIZAÇÃO COM CLOUDFLARE KV
// =====================================================
const KVSync = {
    apiUrl: '/api/testes-status',
    syncEnabled: true,
    lastSync: null,

    // Carregar status do KV
    async load() {
        if (!this.syncEnabled) return null;

        try {
            const response = await fetch(this.apiUrl, {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });

            if (response.ok) {
                const data = await response.json();
                this.lastSync = new Date();
                console.log(`KV Sync: Carregados ${data.testes?.length || 0} status (${data.updatedAt || 'nunca'})`);
                return data.testes || [];
            }
        } catch (e) {
            console.warn('KV Sync: Offline, usando localStorage como fallback', e);
        }
        return null;
    },

    // Salvar status no KV (background, nao bloqueia UI)
    async save(testes) {
        if (!this.syncEnabled) return false;

        try {
            const response = await fetch(this.apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    testes,
                    updatedBy: 'cockpit-gtm'
                })
            });

            if (response.ok) {
                const result = await response.json();
                this.lastSync = new Date();
                console.log(`KV Sync: Salvos ${result.count} status`);
                return true;
            }
        } catch (e) {
            console.warn('KV Sync: Erro ao salvar', e);
        }
        return false;
    }
};

window.KVSync = KVSync;

const App = {
    dataReady: false,  // Flag para indicar que todos os dados (incluindo KV) estão prontos
    data: {
        dashboard: null,
        testes: null,
        jornadas: null,          // Índice de processos (_index.json)
        jornadasCache: {},       // Cache de processos carregados
        cronograma: null,
        pontosCriticos: null
    },

    // Detectar caminho base (raiz ou subpasta)
    getBasePath() {
        const path = window.location.pathname;
        if (path.includes('/pages/')) {
            return '../';
        }
        return './';
    },

    // Inicializar aplicação
    async init() {
        console.log('Iniciando Cockpit GTM Belgo...');
        await this.loadAllData();

        // SEMPRE recalcular métricas após carregar dados (corrige dashboard mockado)
        this.recalculateMetrics();

        this.setupNavigation();
        console.log('Cockpit inicializado com sucesso!');
    },

    // Carregar todos os dados
    async loadAllData() {
        const base = this.getBasePath();
        try {
            const [dashboard, testes, jornadasIndex, cronograma, pontosCriticos] = await Promise.all([
                this.fetchJSON(base + 'data/dashboard.json'),
                this.fetchJSON(base + 'data/testes.json'),
                this.fetchJSON(base + 'data/jornadas/_index.json'),
                this.fetchJSON(base + 'data/cronograma.json'),
                this.fetchJSON(base + 'data/pontos-criticos.json')
            ]);

            this.data.dashboard = dashboard;
            this.data.testes = testes;
            this.data.jornadas = jornadasIndex;
            this.data.cronograma = cronograma;
            this.data.pontosCriticos = pontosCriticos;

            // Restaurar status salvos (KV primeiro, localStorage fallback)
            await this.restoreSavedStatuses();

            // Marcar dados como prontos
            this.dataReady = true;

            console.log('Dados carregados:', this.data);
        } catch (error) {
            console.error('Erro ao carregar dados:', error);
        }
    },

    // Restaurar status de testes (KV primeiro, depois localStorage)
    async restoreSavedStatuses() {
        if (!this.data.testes) return;

        // Tentar carregar do KV primeiro
        const kvStatuses = await KVSync.load();

        let restored = 0;

        if (kvStatuses && kvStatuses.length > 0) {
            // Usar dados do KV
            kvStatuses.forEach(item => {
                for (const cat of this.data.testes.categorias) {
                    const caso = cat.casos.find(c => c.id === item.id);
                    if (caso) {
                        caso.status = item.status;
                        caso.dataExecucao = item.data;
                        // Tambem salvar no localStorage como cache
                        Utils.saveToStorage('testes_' + item.id, { status: item.status, data: item.data });
                        restored++;
                        break;
                    }
                }
            });
            console.log(`Restaurados ${restored} status de testes do Cloudflare KV`);
        } else {
            // Fallback: usar localStorage
            this.data.testes.categorias.forEach(cat => {
                cat.casos.forEach(caso => {
                    const saved = Utils.loadFromStorage('testes_' + caso.id);
                    if (saved && saved.status) {
                        caso.status = saved.status;
                        caso.dataExecucao = saved.data;
                        restored++;
                    }
                });
            });

            if (restored > 0) {
                console.log(`Restaurados ${restored} status de testes do localStorage (fallback)`);
            }
        }

        if (restored > 0) {
            this.recalculateMetrics();
        }
    },

    // Carregar um processo específico (com cache)
    async loadProcesso(id) {
        // Verificar cache
        if (this.data.jornadasCache[id]) {
            return this.data.jornadasCache[id];
        }

        const base = this.getBasePath();
        const processo = await this.fetchJSON(base + `data/jornadas/${id}.json`);

        if (processo) {
            this.data.jornadasCache[id] = processo;
        }

        return processo;
    },

    // Carregar todos os processos
    async loadAllProcessos() {
        if (!this.data.jornadas || !this.data.jornadas.processos) {
            return [];
        }

        const promises = this.data.jornadas.processos.map(p => this.loadProcesso(p.id));
        return await Promise.all(promises);
    },

    // Fetch JSON com tratamento de erro
    async fetchJSON(url) {
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            console.warn(`Erro ao carregar ${url}:`, error);
            return null;
        }
    },

    // Configurar navegação
    setupNavigation() {
        document.querySelectorAll('.nav-item').forEach(item => {
            item.addEventListener('click', (e) => {
                document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
                item.classList.add('active');
            });
        });
    },

    // Atualizar status de um teste
    updateTestStatus(testId, newStatus) {
        if (!this.data.testes) return false;

        for (const cat of this.data.testes.categorias) {
            const test = cat.casos.find(c => c.id === testId);
            if (test) {
                test.status = newStatus;
                test.dataExecucao = new Date().toISOString();
                Utils.saveToStorage('testes_' + testId, { status: newStatus, data: test.dataExecucao });
                this.recalculateMetrics();

                // Sincronizar com KV em background (nao bloqueia)
                this.syncToKV();

                return true;
            }
        }
        return false;
    },

    // Sincronizar todos os status com KV (debounced)
    _syncTimeout: null,
    syncToKV() {
        // Debounce: esperar 1 segundo apos ultima mudanca
        if (this._syncTimeout) clearTimeout(this._syncTimeout);

        this._syncTimeout = setTimeout(async () => {
            const allStatuses = this.getAllTestStatuses();
            await KVSync.save(allStatuses);
        }, 1000);
    },

    // Obter todos os status de testes (para sincronizacao)
    getAllTestStatuses() {
        const statuses = [];

        if (!this.data.testes) return statuses;

        this.data.testes.categorias.forEach(cat => {
            cat.casos.forEach(caso => {
                // Incluir apenas testes que nao estao Pendente
                if (caso.status && caso.status !== 'Pendente') {
                    statuses.push({
                        id: caso.id,
                        status: caso.status,
                        data: caso.dataExecucao || new Date().toISOString()
                    });
                }
            });
        });

        return statuses;
    },

    // Recalcular métricas baseado nos dados REAIS de testes.json
    recalculateMetrics() {
        if (!this.data.testes || !this.data.dashboard) return;

        let executados = 0, pendentes = 0, falhados = 0, totalReal = 0;

        this.data.testes.categorias.forEach(cat => {
            let catOk = 0, catFalhou = 0, catPendente = 0;

            cat.casos.forEach(caso => {
                totalReal++;
                if (caso.status === 'Concluído') { executados++; catOk++; }
                else if (caso.status === 'Falhou') { falhados++; catFalhou++; }
                else { pendentes++; catPendente++; }
            });

            // Atualizar categoria no dashboard
            const dashCat = this.data.dashboard.statusPorCategoria.find(c => c.id === cat.id);
            if (dashCat) {
                dashCat.ok = catOk;
                dashCat.falhou = catFalhou;
                dashCat.pendente = catPendente;
                dashCat.total = cat.casos.length; // Sincronizar total também
            }
        });

        // Atualizar métricas com valores REAIS calculados
        this.data.dashboard.metricas.totalTestes = totalReal;
        this.data.dashboard.metricas.testesExecutados = executados;
        this.data.dashboard.metricas.testesFalhados = falhados;
        this.data.dashboard.metricas.testesPendentes = pendentes;
        this.data.dashboard.metricas.progressoGeral = Utils.calcPercent(executados, totalReal);

        console.log(`Métricas recalculadas: ${executados} executados, ${falhados} falhados, ${pendentes} pendentes de ${totalReal} testes`);
    },

    // Filtrar testes
    filterTests(filters = {}) {
        if (!this.data.testes) return [];

        let results = [];
        this.data.testes.categorias.forEach(cat => {
            let casos = cat.casos;

            // Filtro por IDs especificos (usado na linkagem Jornadas -> Testes)
            if (filters.ids && filters.ids.length > 0) {
                casos = casos.filter(c => filters.ids.includes(c.id));
            }

            if (filters.categoria && filters.categoria !== 'all' && cat.id !== filters.categoria) {
                return;
            }

            if (filters.status && filters.status !== 'all') {
                casos = casos.filter(c => c.status === filters.status);
            }

            if (filters.busca) {
                const termo = filters.busca.toLowerCase();
                casos = casos.filter(c =>
                    c.id.toLowerCase().includes(termo) ||
                    c.nome.toLowerCase().includes(termo)
                );
            }

            results = results.concat(casos.map(c => ({ ...c, categoria: cat.nome })));
        });

        return results;
    },

    // Obter estatísticas
    getStats() {
        if (!this.data.dashboard) return null;
        return this.data.dashboard.metricas;
    }
};

// Inicializar quando DOM estiver pronto
document.addEventListener('DOMContentLoaded', () => App.init());

// Exportar para uso global
window.App = App;
