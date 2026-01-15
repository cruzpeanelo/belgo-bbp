// =====================================================
// BELGO BBP - Helpers de Autenticação
// =====================================================

// Domínios permitidos para login
const ALLOWED_DOMAINS = ['belgo.com.br', 'arcelormittal.com.br'];

// Duração da sessão em horas
const SESSION_DURATION_HOURS = 24;

/**
 * Gera hash SHA-256 de uma string
 */
export async function hashPassword(password) {
    const encoder = new TextEncoder();
    const data = encoder.encode(password);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

/**
 * Gera token aleatório para sessão
 */
export function generateToken() {
    const array = new Uint8Array(32);
    crypto.getRandomValues(array);
    return Array.from(array, b => b.toString(16).padStart(2, '0')).join('');
}

/**
 * Valida se o email pertence a um domínio permitido
 */
export function isValidDomain(email) {
    if (!email || !email.includes('@')) return false;
    const domain = email.split('@')[1].toLowerCase();
    return ALLOWED_DOMAINS.includes(domain);
}

/**
 * Calcula data de expiração da sessão
 */
export function getSessionExpiry() {
    const expiry = new Date();
    expiry.setHours(expiry.getHours() + SESSION_DURATION_HOURS);
    return expiry.toISOString();
}

/**
 * Verifica se uma sessão expirou
 */
export function isSessionExpired(expiresAt) {
    return new Date(expiresAt) < new Date();
}

/**
 * Extrai token do header Authorization
 */
export function extractToken(request) {
    const authHeader = request.headers.get('Authorization');
    if (!authHeader) return null;

    if (authHeader.startsWith('Bearer ')) {
        return authHeader.substring(7);
    }
    return null;
}

/**
 * Cria resposta JSON padrão
 */
export function jsonResponse(data, status = 200) {
    return new Response(JSON.stringify(data), {
        status,
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization'
        }
    });
}

/**
 * Cria resposta de erro padrão
 */
export function errorResponse(message, status = 400) {
    return jsonResponse({ error: message, success: false }, status);
}

/**
 * Valida usuário a partir do token
 */
export async function validateSession(db, token) {
    if (!token) return null;

    const result = await db.prepare(`
        SELECT s.*, u.id as user_id, u.email, u.nome, u.nome_completo,
               u.area, u.cargo, u.is_admin, u.primeiro_acesso
        FROM sessoes s
        JOIN usuarios u ON s.usuario_id = u.id
        WHERE s.token = ? AND u.ativo = 1
    `).bind(token).first();

    if (!result) return null;

    if (isSessionExpired(result.expires_at)) {
        // Limpar sessão expirada
        await db.prepare('DELETE FROM sessoes WHERE token = ?').bind(token).run();
        return null;
    }

    return {
        id: result.user_id,
        email: result.email,
        nome: result.nome,
        nomeCompleto: result.nome_completo,
        area: result.area,
        cargo: result.cargo,
        isAdmin: result.is_admin === 1,
        primeiroAcesso: result.primeiro_acesso === 1,
        sessionId: result.id
    };
}

/**
 * Busca módulos do usuário
 */
export async function getUserModules(db, userId) {
    const results = await db.prepare(`
        SELECT m.codigo, m.nome, m.icone, m.cor
        FROM usuario_modulos um
        JOIN modulos m ON um.modulo_id = m.id
        WHERE um.usuario_id = ? AND m.ativo = 1
    `).bind(userId).all();

    return results.results || [];
}
