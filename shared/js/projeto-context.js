// =====================================================
// BELGO BBP - Contexto do Projeto (White Label)
// Extensao do BelgoProjetos para suporte a logo, Teams e SharePoint
// =====================================================

const BelgoProjetoContext = {
    /**
     * Carrega detalhes completos do projeto atual
     * Inclui logo_url, teams_channel_url, sharepoint_folder_url
     */
    async carregarProjetoAtual() {
        const projetoId = localStorage.getItem('belgo_projeto_id');

        if (!projetoId) {
            console.warn('Nenhum projeto selecionado');
            return null;
        }

        try {
            const response = await BelgoAuth.request(`/api/projetos/${projetoId}`);
            if (!response || !response.ok) {
                // Projeto nao encontrado ou sem acesso
                localStorage.removeItem('belgo_projeto_id');
                console.warn('Projeto nao encontrado ou sem acesso');
                return null;
            }

            const data = await response.json();
            const projeto = data.projeto;

            // Atualizar BelgoProjetos se disponivel
            if (window.BelgoProjetos) {
                window.BelgoProjetos.projetoAtual = projeto;
            }

            return projeto;

        } catch (error) {
            console.error('Erro ao carregar projeto:', error);
            return null;
        }
    },

    /**
     * Renderiza o header do projeto no modulo atual
     * Mostra: logo/icone, nome, links Teams e SharePoint
     */
    async renderizarHeaderProjeto(containerId = 'projeto-header') {
        const container = document.getElementById(containerId);
        if (!container) {
            console.warn('Container do header do projeto nao encontrado:', containerId);
            return;
        }

        const projeto = await this.carregarProjetoAtual();

        if (!projeto) {
            container.innerHTML = `
                <div class="projeto-header-empty">
                    <a href="/landing.html">Selecione um projeto</a>
                </div>
            `;
            return;
        }

        const logoHtml = projeto.logo_url
            ? `<img src="${projeto.logo_url}" alt="${projeto.nome}" class="projeto-logo-sm" onerror="this.style.display='none'">`
            : `<span class="projeto-icone-sm">${projeto.icone || '📁'}</span>`;

        const teamsHtml = projeto.teams_channel_url
            ? `<a href="${projeto.teams_channel_url}" target="_blank" class="projeto-link-btn" title="Abrir canal no Teams">
                   <img src="/shared/icons/teams.svg" alt="Teams" class="link-icon">
               </a>`
            : '';

        const sharepointHtml = projeto.sharepoint_folder_url
            ? `<a href="${projeto.sharepoint_folder_url}" target="_blank" class="projeto-link-btn" title="Abrir documentos">
                   <img src="/shared/icons/sharepoint.svg" alt="SharePoint" class="link-icon">
               </a>`
            : '';

        container.innerHTML = `
            <div class="projeto-header-info">
                ${logoHtml}
                <span class="projeto-nome">${projeto.nome}</span>
            </div>
            <div class="projeto-header-links">
                ${teamsHtml}
                ${sharepointHtml}
            </div>
        `;

        // Aplicar cor do projeto como accent
        if (projeto.cor) {
            container.style.setProperty('--projeto-cor', projeto.cor);
        }
    },

    /**
     * Renderiza card de projeto para a landing page
     */
    renderCardProjeto(projeto) {
        const logoHtml = projeto.logo_url
            ? `<img src="${projeto.logo_url}" alt="${projeto.nome}" class="projeto-card-logo" onerror="this.parentElement.innerHTML='<span class=\\'projeto-card-icone\\'>${projeto.icone || '📁'}</span>'">`
            : `<span class="projeto-card-icone">${projeto.icone || '📁'}</span>`;

        const teamsHtml = projeto.teams_channel_url
            ? `<a href="${projeto.teams_channel_url}" target="_blank" class="projeto-card-link" title="Teams" onclick="event.stopPropagation()">
                   <img src="/shared/icons/teams.svg" alt="Teams">
               </a>`
            : '';

        const sharepointHtml = projeto.sharepoint_folder_url
            ? `<a href="${projeto.sharepoint_folder_url}" target="_blank" class="projeto-card-link" title="SharePoint" onclick="event.stopPropagation()">
                   <img src="/shared/icons/sharepoint.svg" alt="SharePoint">
               </a>`
            : '';

        return `
            <div class="projeto-card" style="--projeto-cor: ${projeto.cor || '#003B4A'}" onclick="BelgoProjetoContext.selecionarEAcessar(${projeto.id})">
                <div class="projeto-card-visual">
                    ${logoHtml}
                </div>
                <div class="projeto-card-content">
                    <h3 class="projeto-card-nome">${projeto.nome}</h3>
                    ${projeto.descricao ? `<p class="projeto-card-desc">${projeto.descricao}</p>` : ''}
                    ${projeto.papel_nome ? `<span class="projeto-card-papel">${projeto.papel_nome}</span>` : ''}
                </div>
                <div class="projeto-card-footer">
                    <div class="projeto-card-links">
                        ${teamsHtml}
                        ${sharepointHtml}
                    </div>
                    <button class="projeto-card-btn">Acessar</button>
                </div>
            </div>
        `;
    },

    /**
     * Renderiza secao de projetos na landing page
     */
    async renderSecaoProjetos(containerId = 'meusProjetos') {
        const container = document.getElementById(containerId);
        if (!container) return;

        // Verificar autenticacao
        if (!BelgoAuth || !BelgoAuth.isAuthenticated()) {
            container.style.display = 'none';
            return;
        }

        try {
            const response = await BelgoAuth.request('/api/projetos');
            if (!response || !response.ok) {
                container.style.display = 'none';
                return;
            }

            const data = await response.json();
            const projetos = data.projetos || [];

            if (projetos.length === 0) {
                container.style.display = 'none';
                return;
            }

            // Mostrar secao
            container.style.display = 'block';

            // Renderizar grid de projetos
            const gridHtml = projetos.map(p => this.renderCardProjeto(p)).join('');

            container.innerHTML = `
                <div class="projetos-section-header">
                    <h2>Meus Projetos</h2>
                </div>
                <div class="projetos-grid">
                    ${gridHtml}
                </div>
            `;

        } catch (error) {
            console.error('Erro ao carregar projetos:', error);
            container.style.display = 'none';
        }
    },

    /**
     * Seleciona um projeto e redireciona para o modulo principal
     */
    selecionarEAcessar(projetoId, redirectTo = '/index.html') {
        localStorage.setItem('belgo_projeto_id', projetoId);
        window.location.href = redirectTo;
    },

    /**
     * Verifica se usuario tem projeto selecionado, senao redireciona
     */
    async verificarProjetoObrigatorio(redirectTo = '/landing.html') {
        const projetoId = localStorage.getItem('belgo_projeto_id');

        if (!projetoId) {
            window.location.href = redirectTo;
            return false;
        }

        const projeto = await this.carregarProjetoAtual();
        if (!projeto) {
            window.location.href = redirectTo;
            return false;
        }

        return true;
    }
};

// CSS para header e cards de projeto
const projetoContextCSS = `
    /* Barra de header do projeto nos modulos */
    .projeto-header-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 16px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-radius: 8px;
        margin-bottom: 20px;
        border-left: 4px solid var(--projeto-cor, #003B4A);
    }

    .projeto-header-bar:empty {
        display: none;
    }

    /* Header do projeto nos modulos */
    .projeto-header-info {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .projeto-logo-sm {
        width: 32px;
        height: 32px;
        object-fit: contain;
        border-radius: 4px;
    }

    .projeto-icone-sm {
        font-size: 24px;
    }

    .projeto-nome {
        font-weight: 600;
        color: var(--projeto-cor, #003B4A);
    }

    .projeto-header-links {
        display: flex;
        gap: 8px;
    }

    .projeto-link-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        border-radius: 8px;
        background: var(--bg-tertiary, #f0f0f0);
        border: 1px solid var(--border-color, #ddd);
        transition: all 0.2s;
    }

    .projeto-link-btn:hover {
        background: var(--bg-secondary, #e8e8e8);
        transform: translateY(-2px);
    }

    .projeto-link-btn .link-icon {
        width: 20px;
        height: 20px;
    }

    /* Secao de projetos na landing */
    .projetos-section-header {
        text-align: center;
        margin-bottom: 24px;
    }

    .projetos-section-header h2 {
        color: var(--text-primary, #333);
        font-size: 24px;
        font-weight: 600;
    }

    .projetos-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 24px;
        max-width: 1200px;
        margin: 0 auto;
    }

    /* Cards de projeto */
    .projeto-card {
        background: white;
        border-radius: 12px;
        padding: 24px;
        border-left: 4px solid var(--projeto-cor, #003B4A);
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        transition: all 0.2s;
        cursor: pointer;
        display: flex;
        flex-direction: column;
    }

    .projeto-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 4px 16px rgba(0,0,0,0.12);
    }

    .projeto-card-visual {
        margin-bottom: 16px;
    }

    .projeto-card-logo {
        width: 64px;
        height: 64px;
        object-fit: contain;
        border-radius: 8px;
    }

    .projeto-card-icone {
        font-size: 48px;
        line-height: 1;
    }

    .projeto-card-content {
        flex: 1;
    }

    .projeto-card-nome {
        font-size: 18px;
        font-weight: 600;
        color: var(--text-primary, #333);
        margin: 0 0 8px 0;
    }

    .projeto-card-desc {
        font-size: 14px;
        color: var(--text-secondary, #666);
        margin: 0 0 12px 0;
        line-height: 1.4;
    }

    .projeto-card-papel {
        display: inline-block;
        font-size: 11px;
        padding: 4px 10px;
        background: var(--bg-tertiary, #f0f0f0);
        border-radius: 12px;
        color: var(--text-secondary, #666);
    }

    .projeto-card-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 16px;
        padding-top: 16px;
        border-top: 1px solid var(--border-color, #eee);
    }

    .projeto-card-links {
        display: flex;
        gap: 8px;
    }

    .projeto-card-link {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        border-radius: 6px;
        background: var(--bg-tertiary, #f0f0f0);
        transition: all 0.2s;
    }

    .projeto-card-link:hover {
        background: var(--bg-secondary, #e8e8e8);
    }

    .projeto-card-link img {
        width: 18px;
        height: 18px;
    }

    .projeto-card-btn {
        padding: 8px 16px;
        background: var(--projeto-cor, #003B4A);
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
    }

    .projeto-card-btn:hover {
        opacity: 0.9;
        transform: translateY(-1px);
    }

    .projeto-header-empty {
        padding: 8px 16px;
    }

    .projeto-header-empty a {
        color: var(--primary-color, #003B4A);
        text-decoration: none;
    }

    .projeto-header-empty a:hover {
        text-decoration: underline;
    }
`;

// Injetar CSS
if (typeof document !== 'undefined') {
    const style = document.createElement('style');
    style.textContent = projetoContextCSS;
    document.head.appendChild(style);
}

// Exportar para uso global
window.BelgoProjetoContext = BelgoProjetoContext;
