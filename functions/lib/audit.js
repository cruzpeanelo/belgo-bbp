// =====================================================
// BELGO BBP - Helpers de Auditoria
// =====================================================

/**
 * Registra ação na tabela de auditoria
 * @param {D1Database} db - Database D1
 * @param {Object} params - Parâmetros da auditoria
 * @param {number} params.usuarioId - ID do usuário (opcional)
 * @param {string} params.acao - Tipo da ação (login, logout, criar, editar, aprovar, excluir)
 * @param {string} params.entidade - Entidade afetada (usuário, teste, jornada, reunião)
 * @param {string} params.entidadeId - ID da entidade
 * @param {Object} params.detalhes - Detalhes adicionais (será convertido para JSON)
 * @param {string} params.ip - IP do cliente
 */
export async function registrarAuditoria(db, params) {
    const {
        usuarioId = null,
        acao,
        entidade = null,
        entidadeId = null,
        detalhes = null,
        ip = null
    } = params;

    try {
        await db.prepare(`
            INSERT INTO auditoria (usuario_id, acao, entidade, entidade_id, detalhes, ip)
            VALUES (?, ?, ?, ?, ?, ?)
        `).bind(
            usuarioId,
            acao,
            entidade,
            entidadeId,
            detalhes ? JSON.stringify(detalhes) : null,
            ip
        ).run();

        return true;
    } catch (error) {
        console.error('Erro ao registrar auditoria:', error);
        return false;
    }
}

/**
 * Extrai IP do cliente da requisição
 */
export function getClientIP(request) {
    return request.headers.get('CF-Connecting-IP') ||
           request.headers.get('X-Forwarded-For')?.split(',')[0] ||
           'unknown';
}

/**
 * Tipos de ações para auditoria
 */
export const ACOES = {
    LOGIN: 'login',
    LOGOUT: 'logout',
    LOGIN_FALHA: 'login_falha',
    CRIAR: 'criar',
    EDITAR: 'editar',
    EXCLUIR: 'excluir',
    APROVAR: 'aprovar',
    REPROVAR: 'reprovar',
    ATIVAR_CONTA: 'ativar_conta',
    TROCAR_SENHA: 'trocar_senha',
    RESET_SENHA: 'reset_senha',
    CRIAR_CONVITE: 'criar_convite'
};

/**
 * Tipos de entidades
 */
export const ENTIDADES = {
    USUARIO: 'usuario',
    TESTE: 'teste',
    JORNADA: 'jornada',
    REUNIAO: 'reuniao',
    GLOSSARIO: 'glossario',
    CONVITE: 'convite',
    SESSAO: 'sessao'
};
