// =====================================================
// BELGO GTM - CORE DA APLICAÇÃO
// =====================================================

// =====================================================
// CONTROLE DE ACESSO - Verificação de Autenticação
// =====================================================
(function() {
    // Verificar autenticação via BelgoAuth
    if (typeof BelgoAuth !== 'undefined' && BelgoAuth.isAuthenticated()) {
        // Usuário autenticado - verificar acesso ao módulo GTM
        BelgoAuth.requireAuth('gtm').then(hasAccess => {
            if (!hasAccess) {
                // Será redirecionado pelo requireAuth
            }
        });
        return; // Continuar carregando a aplicação
    }

    // Não autenticado - redirecionar para login
    window.location.href = '/login.html?redirect=' + encodeURIComponent(window.location.pathname);
    throw new Error('Autenticação necessária');
})();

// =====================================================
// SINCRONIZAÇÃO COM CLOUDFLARE KV
// =====================================================
const KVSync = {
    apiUrl: '/api/testes-status',
    syncEnabled: true,
    lastSync: null,

    // Obter headers com autenticação
    getHeaders(contentType = false) {
        const headers = { 'Accept': 'application/json' };
        const token = sessionStorage.getItem('belgo_token');
        if (token) {
            headers['Authorization'] = `Bearer ${token}`;
        }
        if (contentType) {
            headers['Content-Type'] = 'application/json';
        }
        return headers;
    },

    // Carregar status do KV
    async load() {
        if (!this.syncEnabled) return null;

        try {
            const response = await fetch(this.apiUrl, {
                method: 'GET',
                headers: this.getHeaders()
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

    // Salvar status no KV (background, não bloqueia UI)
    async save(testes) {
        if (!this.syncEnabled) return false;

        try {
            const response = await fetch(this.apiUrl, {
                method: 'POST',
                headers: this.getHeaders(true),
                body: JSON.stringify({
                    testes,
                    updatedBy: BelgoAuth?.getUsuario()?.nome || 'cockpit-gtm'
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
    dataReady: false,  // Flag para indicar que todos os dados (incluindo KV) estao prontos
    projetoId: null,   // ID do projeto atual (carregado da API)
    entidadesCache: {}, // Cache de entidades com config_funcionalidades
    data: {
        dashboard: null,
        testes: null,
        jornadas: null,          // Indice de processos (_index.json)
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
                        // Também salvar no localStorage como cache
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

    // Fetch API autenticada
    async fetchAPI(endpoint, options = {}) {
        try {
            const token = sessionStorage.getItem('belgo_token');
            const headers = {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                ...options.headers
            };
            if (token) {
                headers['Authorization'] = `Bearer ${token}`;
            }

            const response = await fetch(endpoint, { ...options, headers });
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            console.warn(`Erro na API ${endpoint}:`, error);
            return null;
        }
    },

    // Carregar informacoes do projeto atual
    async loadProjetoInfo() {
        // Por enquanto, usar projeto 1 (GTM) como padrao
        // Futuramente: detectar pelo dominio ou URL
        this.projetoId = localStorage.getItem('belgo_projeto_id') || 1;
        return this.projetoId;
    },

    // Carregar entidade com config_funcionalidades
    async loadEntidade(codigo) {
        if (this.entidadesCache[codigo]) {
            return this.entidadesCache[codigo];
        }

        try {
            const result = await this.fetchAPI(`/api/projetos/${this.projetoId}/entidades`);
            if (result?.success && result.entidades) {
                // Cachear todas as entidades
                result.entidades.forEach(ent => {
                    this.entidadesCache[ent.codigo] = ent;
                });
            }
            return this.entidadesCache[codigo] || null;
        } catch (error) {
            console.warn('Erro ao carregar entidade:', error);
            return null;
        }
    },

    // Carregar dados de uma entidade da API dinamica
    async loadEntidadeDados(codigo, opcoes = {}) {
        const { limit = 1000, page = 1 } = opcoes;

        try {
            const result = await this.fetchAPI(
                `/api/projetos/${this.projetoId}/dados/${codigo}?limit=${limit}&page=${page}`
            );

            if (result?.success) {
                return {
                    entidade: result.entidade,
                    dados: result.dados || [],
                    paginacao: result.paginacao
                };
            }
            return { entidade: null, dados: [], paginacao: null };
        } catch (error) {
            console.warn(`Erro ao carregar dados de ${codigo}:`, error);
            return { entidade: null, dados: [], paginacao: null };
        }
    },

    // Inicializar pagina dinamica usando ConfigRenderer
    async initDynamicPage(containerSelector, entidadeCodigo) {
        const container = document.querySelector(containerSelector);
        if (!container) {
            console.error('Container nao encontrado:', containerSelector);
            return false;
        }

        await this.loadProjetoInfo();

        // Carregar entidade com config
        const entidade = await this.loadEntidade(entidadeCodigo);
        if (!entidade) {
            container.innerHTML = `
                <div class="error-state">
                    <h3>Entidade nao encontrada</h3>
                    <p>A entidade "${entidadeCodigo}" nao foi configurada.</p>
                </div>
            `;
            return false;
        }

        // Usar ConfigRenderer se disponivel
        if (typeof ConfigRenderer !== 'undefined') {
            container.id = container.id || 'dynamicContent';
            await ConfigRenderer.init({
                projetoId: this.projetoId,
                entidade: entidade,
                containerId: container.id
            });
            return true;
        }

        console.warn('ConfigRenderer nao carregado');
        return false;
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

                // Sincronizar com KV em background (não bloqueia)
                this.syncToKV();

                return true;
            }
        }
        return false;
    },

    // Sincronizar todos os status com KV (debounced)
    _syncTimeout: null,
    syncToKV() {
        // Debounce: esperar 1 segundo após última mudança
        if (this._syncTimeout) clearTimeout(this._syncTimeout);

        this._syncTimeout = setTimeout(async () => {
            const allStatuses = this.getAllTestStatuses();
            await KVSync.save(allStatuses);
        }, 1000);
    },

    // Obter todos os status de testes (para sincronização)
    getAllTestStatuses() {
        const statuses = [];

        if (!this.data.testes) return statuses;

        this.data.testes.categorias.forEach(cat => {
            cat.casos.forEach(caso => {
                // Incluir apenas testes que não estão Pendente
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

            // Filtro por IDs específicos (usado na linkagem Jornadas -> Testes)
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
