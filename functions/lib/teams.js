/**
 * Biblioteca para integracao com Microsoft Teams
 * Envia notificacoes via Incoming Webhook
 */

/**
 * Envia uma notificacao para o canal Teams via webhook
 * @param {string} webhookUrl - URL do Incoming Webhook do Teams
 * @param {Object} mensagem - Objeto com dados da mensagem
 * @param {string} mensagem.titulo - Titulo principal
 * @param {string} [mensagem.subtitulo] - Subtitulo opcional
 * @param {Array<{name: string, value: string}>} [mensagem.fatos] - Lista de fatos
 * @param {Array} [mensagem.acoes] - Acoes potenciais (botoes)
 * @returns {Promise<{success: boolean, error?: string}>}
 */
export async function enviarNotificacaoTeams(webhookUrl, mensagem) {
    if (!webhookUrl) {
        return { success: false, error: 'Webhook nao configurado' };
    }

    try {
        const payload = {
            "@type": "MessageCard",
            "@context": "http://schema.org/extensions",
            "themeColor": "003B4A", // Azul Belgo
            "summary": mensagem.titulo,
            "sections": [{
                "activityTitle": mensagem.titulo,
                "activitySubtitle": mensagem.subtitulo || '',
                "facts": mensagem.fatos || [],
                "markdown": true
            }]
        };

        // Adicionar acoes se houver
        if (mensagem.acoes && mensagem.acoes.length > 0) {
            payload.potentialAction = mensagem.acoes;
        }

        const res = await fetch(webhookUrl, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        if (!res.ok) {
            const text = await res.text();
            return { success: false, error: `HTTP ${res.status}: ${text}` };
        }

        return { success: true };
    } catch (error) {
        return { success: false, error: error.message };
    }
}

/**
 * Templates de notificacoes padrao
 */
export const TEMPLATES = {
    /**
     * Notificacao de novo membro adicionado ao projeto
     */
    novoMembro: (nome, papel, projeto) => ({
        titulo: `Novo membro: ${nome}`,
        subtitulo: `Adicionado ao projeto ${projeto}`,
        fatos: [
            { name: 'Papel', value: papel }
        ]
    }),

    /**
     * Notificacao de membro removido
     */
    membroRemovido: (nome, projeto) => ({
        titulo: `Membro removido: ${nome}`,
        subtitulo: `Removido do projeto ${projeto}`,
        fatos: []
    }),

    /**
     * Notificacao de novo documento enviado
     */
    novoDocumento: (nomeArquivo, usuario, pasta) => ({
        titulo: `Novo documento: ${nomeArquivo}`,
        subtitulo: `Enviado por ${usuario}`,
        fatos: [
            { name: 'Pasta', value: pasta }
        ]
    }),

    /**
     * Notificacao de status de teste atualizado
     */
    statusTeste: (nomeTeste, status, usuario) => ({
        titulo: `Teste atualizado: ${nomeTeste}`,
        subtitulo: `Por ${usuario}`,
        fatos: [
            { name: 'Status', value: status }
        ]
    }),

    /**
     * Notificacao de nova jornada criada
     */
    novaJornada: (nomeJornada, usuario, projeto) => ({
        titulo: `Nova jornada: ${nomeJornada}`,
        subtitulo: `Criada por ${usuario} no projeto ${projeto}`,
        fatos: []
    }),

    /**
     * Mensagem de teste de webhook
     */
    testeWebhook: (nomeProjeto) => ({
        titulo: `Teste de conexao - Belgo BBP`,
        subtitulo: `Webhook configurado com sucesso!`,
        fatos: [
            { name: 'Projeto', value: nomeProjeto },
            { name: 'Data/Hora', value: new Date().toLocaleString('pt-BR') }
        ]
    })
};

/**
 * Cria uma acao de botao para o MessageCard
 * @param {string} nome - Nome do botao
 * @param {string} url - URL de destino
 * @returns {Object} Acao formatada para o Teams
 */
export function criarAcaoBotao(nome, url) {
    return {
        "@type": "OpenUri",
        "name": nome,
        "targets": [
            { "os": "default", "uri": url }
        ]
    };
}
