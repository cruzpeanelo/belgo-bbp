// =====================================================
// BELGO BBP - ACTION ENGINE
// Executa acoes dinamicas configuradas no banco
// =====================================================

const ActionEngine = {
    acoes: [],
    projetoId: null,
    entidadeId: null,
    entidadeCodigo: null,
    permissoes: null,

    // =====================================================
    // INICIALIZACAO
    // =====================================================
    async init(options) {
        this.projetoId = options.projetoId;
        this.entidadeId = options.entidadeId;
        this.entidadeCodigo = options.entidadeCodigo;
        this.permissoes = options.permissoes || null;

        await this.carregarAcoes();
    },

    async carregarAcoes() {
        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(`/api/projetos/${this.projetoId}/entidades/${this.entidadeId}/acoes`, {
                headers: { 'Authorization': `Bearer ${token}` }
            });

            if (response.ok) {
                const result = await response.json();
                this.acoes = result.acoes || [];
            }
        } catch (error) {
            console.warn('Erro ao carregar acoes:', error);
            this.acoes = [];
        }
    },

    // =====================================================
    // FILTRAR ACOES POR POSICAO E CONDICAO
    // =====================================================
    getAcoes(posicao, registro = null) {
        return this.acoes.filter(acao => {
            // Filtrar por posicao
            if (acao.posicao !== posicao) return false;

            // Verificar permissao
            if (!this.temPermissaoAcao(acao)) return false;

            // Verificar condicao (se houver)
            if (acao.condicao && registro) {
                if (!this.avaliarCondicao(acao.condicao, registro)) return false;
            }

            return true;
        });
    },

    temPermissaoAcao(acao) {
        if (!acao.permissao_minima) return true;
        if (!this.permissoes) return true;

        // Admin sempre tem permissao
        if (this.permissoes.isAdmin || this.permissoes.isAdminGlobal) return true;

        // Hierarquia de papeis
        const hierarquia = ['visualizador', 'executor', 'key_user', 'gestor', 'admin'];
        const nivelMinimo = hierarquia.indexOf(acao.permissao_minima);
        const nivelUsuario = hierarquia.indexOf(this.permissoes.papel?.codigo || 'visualizador');

        return nivelUsuario >= nivelMinimo;
    },

    avaliarCondicao(condicao, registro) {
        const { campo, operador = '==', valor } = condicao;
        const valorCampo = registro[campo];

        switch (operador) {
            case '==':
            case '=':
                return valorCampo == valor;
            case '!=':
            case '<>':
                return valorCampo != valor;
            case '>':
                return valorCampo > valor;
            case '<':
                return valorCampo < valor;
            case '>=':
                return valorCampo >= valor;
            case '<=':
                return valorCampo <= valor;
            case 'contains':
                return String(valorCampo).toLowerCase().includes(String(valor).toLowerCase());
            case 'not_contains':
                return !String(valorCampo).toLowerCase().includes(String(valor).toLowerCase());
            case 'empty':
                return !valorCampo || valorCampo === '' || (Array.isArray(valorCampo) && valorCampo.length === 0);
            case 'not_empty':
                return valorCampo && valorCampo !== '' && (!Array.isArray(valorCampo) || valorCampo.length > 0);
            default:
                return true;
        }
    },

    // =====================================================
    // RENDERIZAR BOTOES DE ACAO
    // =====================================================
    renderBotoes(posicao, registro = null, options = {}) {
        const acoes = this.getAcoes(posicao, registro);
        if (acoes.length === 0) return '';

        const { tamanho = 'sm', classe = '' } = options;

        return acoes.map(acao => {
            const idParam = registro ? `'${registro._id || registro.codigo || registro.id}'` : 'null';
            const registroParam = registro ? encodeURIComponent(JSON.stringify(registro)) : 'null';

            return `
                <button class="btn btn-${tamanho} ${this.getClasseAcao(acao)} ${classe}"
                        onclick="ActionEngine.executar('${acao.codigo}', ${idParam}, '${registroParam}')"
                        title="${acao.nome}">
                    ${acao.icone ? `<span class="icon">${acao.icone}</span>` : ''}
                    ${options.mostrarNome !== false ? acao.nome : ''}
                </button>
            `;
        }).join(' ');
    },

    getClasseAcao(acao) {
        switch (acao.tipo) {
            case 'status_change':
                const config = acao.config || {};
                if (config.novo_valor === 'Concluido') return 'btn-success';
                if (config.novo_valor === 'Falhou') return 'btn-danger';
                return 'btn-warning';
            case 'teams':
                return 'btn-teams';
            case 'modal':
                return 'btn-primary';
            case 'link':
                return 'btn-outline';
            default:
                return 'btn-secondary';
        }
    },

    // =====================================================
    // EXECUTAR ACAO
    // =====================================================
    async executar(codigoAcao, registroId, registroJson = null) {
        const acao = this.acoes.find(a => a.codigo === codigoAcao);
        if (!acao) {
            console.error('Acao nao encontrada:', codigoAcao);
            return;
        }

        // Decodificar registro se passou como JSON
        let registro = null;
        if (registroJson && registroJson !== 'null') {
            try {
                registro = JSON.parse(decodeURIComponent(registroJson));
            } catch (e) {
                console.warn('Erro ao parsear registro:', e);
            }
        }

        const config = acao.config || {};

        switch (acao.tipo) {
            case 'status_change':
                await this.executarStatusChange(acao, registroId, registro, config);
                break;
            case 'teams':
                this.executarTeams(acao, registroId, registro, config);
                break;
            case 'modal':
                this.executarModal(acao, registroId, registro, config);
                break;
            case 'link':
                this.executarLink(acao, registroId, registro, config);
                break;
            case 'api_call':
                await this.executarApiCall(acao, registroId, registro, config);
                break;
            case 'custom':
                this.executarCustom(acao, registroId, registro, config);
                break;
            default:
                console.warn('Tipo de acao nao suportado:', acao.tipo);
        }
    },

    // =====================================================
    // EXECUTORES DE ACOES
    // =====================================================
    async executarStatusChange(acao, registroId, registro, config) {
        const { campo = 'status', novo_valor, confirmar, mensagem_confirmacao } = config;

        // Confirmar se necessario
        if (confirmar) {
            const msg = mensagem_confirmacao || `Deseja alterar ${campo} para "${novo_valor}"?`;
            if (!confirm(msg)) return;
        }

        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(`/api/projetos/${this.projetoId}/dados/${this.entidadeCodigo}/${registroId}`, {
                method: 'PUT',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    dados: { [campo]: novo_valor }
                })
            });

            if (response.ok) {
                this.showToast(`${acao.nome} executado com sucesso!`, 'success');
                // Disparar evento para atualizar a listagem
                window.dispatchEvent(new CustomEvent('actionExecuted', {
                    detail: { acao: acao.codigo, registroId, campo, valor: novo_valor }
                }));
            } else {
                const result = await response.json();
                this.showToast(result.error || 'Erro ao executar acao', 'error');
            }
        } catch (error) {
            console.error('Erro ao executar status_change:', error);
            this.showToast('Erro ao executar acao', 'error');
        }
    },

    executarTeams(acao, registroId, registro, config) {
        if (!registro) {
            console.warn('Registro necessario para compartilhar no Teams');
            return;
        }

        const { titulo, facts = [], cor_tema = '003B4A' } = config;

        // Substituir placeholders no titulo
        let tituloFinal = titulo || `${acao.icone || ''} ${registro.nome || registroId}`;
        tituloFinal = tituloFinal.replace(/\{(\w+)\}/g, (_, campo) => registro[campo] || '');

        // Montar facts
        const factsFormatados = facts.map(campo => {
            const valor = registro[campo];
            if (!valor) return null;
            const label = campo.charAt(0).toUpperCase() + campo.slice(1).replace(/([A-Z])/g, ' $1');
            return { name: label, value: Array.isArray(valor) ? valor.join(', ') : String(valor) };
        }).filter(Boolean);

        // Abrir Teams
        if (typeof Utils !== 'undefined' && Utils.openTeamsChannel) {
            Utils.openTeamsChannel();
        }

        // Enviar card
        const card = {
            "@type": "MessageCard",
            "@context": "https://schema.org/extensions",
            "themeColor": cor_tema,
            "summary": tituloFinal,
            "sections": [{
                "activityTitle": tituloFinal,
                "facts": factsFormatados,
                "markdown": true
            }],
            "potentialAction": [{
                "@type": "OpenUri",
                "name": "Abrir no Sistema",
                "targets": [{ "os": "default", "uri": window.location.href }]
            }]
        };

        if (typeof Utils !== 'undefined' && Utils.sendToTeams) {
            Utils.sendToTeams(card);
        }

        this.showToast('Compartilhado no Teams!', 'success');
    },

    executarModal(acao, registroId, registro, config) {
        if (!registro) {
            console.warn('Registro necessario para abrir modal');
            return;
        }

        // Se ConfigRenderer estiver disponivel, usar verDetalhe
        if (typeof ConfigRenderer !== 'undefined' && ConfigRenderer.verDetalhe) {
            ConfigRenderer.verDetalhe(registroId);
            return;
        }

        // Fallback: criar modal simples
        const { titulo } = config;
        let tituloFinal = titulo || registro.nome || registroId;
        tituloFinal = tituloFinal.replace(/\{(\w+)\}/g, (_, campo) => registro[campo] || '');

        alert(`Detalhe: ${tituloFinal}\n\n${JSON.stringify(registro, null, 2)}`);
    },

    executarLink(acao, registroId, registro, config) {
        const { url, nova_aba = false } = config;

        let urlFinal = url;
        urlFinal = urlFinal.replace(/\{(\w+)\}/g, (_, campo) => {
            if (campo === '_id') return registroId;
            return registro?.[campo] || '';
        });

        if (nova_aba) {
            window.open(urlFinal, '_blank');
        } else {
            window.location.href = urlFinal;
        }
    },

    async executarApiCall(acao, registroId, registro, config) {
        const { metodo = 'POST', endpoint, body = {}, sucesso_msg } = config;

        // Substituir placeholders no body
        const bodyFinal = JSON.parse(
            JSON.stringify(body).replace(/\{(\w+)\}/g, (_, campo) => {
                if (campo === '_id') return registroId;
                return registro?.[campo] || '';
            })
        );

        try {
            const token = sessionStorage.getItem('belgo_token');
            const response = await fetch(endpoint, {
                method: metodo,
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: metodo !== 'GET' ? JSON.stringify(bodyFinal) : undefined
            });

            if (response.ok) {
                this.showToast(sucesso_msg || 'Acao executada com sucesso!', 'success');
                window.dispatchEvent(new CustomEvent('actionExecuted', {
                    detail: { acao: acao.codigo, registroId }
                }));
            } else {
                const result = await response.json();
                this.showToast(result.error || 'Erro ao executar acao', 'error');
            }
        } catch (error) {
            console.error('Erro ao executar api_call:', error);
            this.showToast('Erro ao executar acao', 'error');
        }
    },

    executarCustom(acao, registroId, registro, config) {
        const { funcao, parametros = [] } = config;

        if (typeof window[funcao] === 'function') {
            const args = parametros.map(p => {
                if (p === '_id') return registroId;
                return registro?.[p];
            });
            window[funcao](...args);
        } else {
            console.warn('Funcao custom nao encontrada:', funcao);
        }
    },

    // =====================================================
    // UTILITARIOS
    // =====================================================
    showToast(message, type = 'info') {
        if (typeof Utils !== 'undefined' && Utils.showToast) {
            Utils.showToast(message, type);
        } else if (typeof ConfigRenderer !== 'undefined' && ConfigRenderer.showToast) {
            ConfigRenderer.showToast(message, type);
        } else {
            console.log(`[${type}] ${message}`);
        }
    }
};

// Exportar globalmente
window.ActionEngine = ActionEngine;
