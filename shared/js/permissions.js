// =====================================================
// BELGO BBP - Gerenciador de Permissoes Frontend
// =====================================================

const BelgoPermissoes = {
    permissoes: new Set(),
    papel: null,
    carregado: false,

    /**
     * Carrega permissoes do usuario no projeto atual
     */
    async carregar() {
        try {
            const projetoId = BelgoProjetos.getProjetoId();

            const response = await BelgoAuth.request(`/api/projetos/${projetoId}`);
            if (!response || !response.ok) {
                console.error('Erro ao carregar permissoes');
                return false;
            }

            const data = await response.json();

            // Armazenar permissoes
            this.permissoes = new Set(data.projeto?.minhasPermissoes || []);
            this.papel = data.projeto?.papel_codigo || null;
            this.carregado = true;

            // Aplicar permissoes na UI
            this.aplicarNaUI();

            return true;

        } catch (error) {
            console.error('Erro ao carregar permissoes:', error);
            return false;
        }
    },

    /**
     * Recarrega permissoes quando projeto muda
     */
    async recarregar() {
        this.carregado = false;
        this.permissoes = new Set();
        await this.carregar();
    },

    /**
     * Verifica se usuario tem uma permissao
     */
    pode(permissao) {
        // Admin global sempre pode
        if (BelgoAuth.isAdmin()) {
            return true;
        }

        return this.permissoes.has(permissao);
    },

    /**
     * Verifica se usuario pode ver uma entidade
     */
    podeVer(entidade) {
        return this.pode(`${entidade}.ver`);
    },

    /**
     * Verifica se usuario pode criar uma entidade
     */
    podeCriar(entidade) {
        return this.pode(`${entidade}.criar`);
    },

    /**
     * Verifica se usuario pode editar uma entidade
     */
    podeEditar(entidade) {
        return this.pode(`${entidade}.editar`);
    },

    /**
     * Verifica se usuario pode excluir uma entidade
     */
    podeExcluir(entidade) {
        return this.pode(`${entidade}.excluir`);
    },

    /**
     * Verifica se usuario pode executar testes
     */
    podeExecutarTeste() {
        return this.pode('teste.executar');
    },

    /**
     * Aplica permissoes em elementos da UI
     * Usa atributos data-permissao para controle
     */
    aplicarNaUI() {
        // Elementos que requerem permissao para visualizacao
        // data-permissao="teste.criar" - esconde se nao tem permissao
        document.querySelectorAll('[data-permissao]').forEach(el => {
            const permissao = el.dataset.permissao;
            if (!this.pode(permissao)) {
                el.style.display = 'none';
            } else {
                el.style.display = '';
            }
        });

        // Elementos que requerem permissao para habilitacao
        // data-permissao-disabled="teste.editar" - desabilita se nao tem permissao
        document.querySelectorAll('[data-permissao-disabled]').forEach(el => {
            const permissao = el.dataset.permissaoDisabled;
            if (!this.pode(permissao)) {
                el.disabled = true;
                el.classList.add('sem-permissao');
                el.title = 'Voce nao tem permissao para esta acao';
            } else {
                el.disabled = false;
                el.classList.remove('sem-permissao');
                el.title = '';
            }
        });

        // Botoes de acao CRUD
        // data-acao="criar" data-entidade="teste"
        document.querySelectorAll('[data-acao][data-entidade]').forEach(el => {
            const acao = el.dataset.acao;
            const entidade = el.dataset.entidade;
            const permissao = `${entidade}.${acao}`;

            if (!this.pode(permissao)) {
                el.style.display = 'none';
            } else {
                el.style.display = '';
            }
        });
    },

    /**
     * Mostra elemento se usuario tem permissao
     */
    mostrarSe(elemento, permissao) {
        if (typeof elemento === 'string') {
            elemento = document.querySelector(elemento);
        }
        if (!elemento) return;

        if (this.pode(permissao)) {
            elemento.style.display = '';
        } else {
            elemento.style.display = 'none';
        }
    },

    /**
     * Desabilita elemento se usuario nao tem permissao
     */
    desabilitarSe(elemento, permissao) {
        if (typeof elemento === 'string') {
            elemento = document.querySelector(elemento);
        }
        if (!elemento) return;

        if (!this.pode(permissao)) {
            elemento.disabled = true;
            elemento.classList.add('sem-permissao');
        } else {
            elemento.disabled = false;
            elemento.classList.remove('sem-permissao');
        }
    },

    /**
     * Executa callback apenas se usuario tem permissao
     */
    sePode(permissao, callback) {
        if (this.pode(permissao)) {
            callback();
        }
    },

    /**
     * Retorna objeto com todas as permissoes agrupadas por entidade
     */
    getPermissoesAgrupadas() {
        const grupos = {};

        this.permissoes.forEach(p => {
            const [entidade, acao] = p.split('.');
            if (!grupos[entidade]) {
                grupos[entidade] = [];
            }
            grupos[entidade].push(acao);
        });

        return grupos;
    },

    /**
     * Verifica se usuario tem todas as permissoes listadas
     */
    podeTodas(...permissoes) {
        return permissoes.every(p => this.pode(p));
    },

    /**
     * Verifica se usuario tem alguma das permissoes listadas
     */
    podeAlguma(...permissoes) {
        return permissoes.some(p => this.pode(p));
    },

    /**
     * Inicializa gerenciador de permissoes
     */
    async init() {
        await this.carregar();

        // Recarregar quando projeto mudar
        window.addEventListener('projeto-alterado', () => {
            this.recarregar();
        });
    }
};

// CSS para elementos sem permissao
const permissoesCSS = `
    .sem-permissao {
        opacity: 0.5;
        cursor: not-allowed !important;
    }

    .sem-permissao:hover {
        opacity: 0.5;
    }

    [data-permissao].hidden-by-permission {
        display: none !important;
    }
`;

// Injetar CSS
if (typeof document !== 'undefined') {
    const style = document.createElement('style');
    style.textContent = permissoesCSS;
    document.head.appendChild(style);
}

// Exportar para uso global
window.BelgoPermissoes = BelgoPermissoes;
