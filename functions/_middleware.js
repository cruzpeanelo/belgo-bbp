// =====================================================
// BELGO BBP - Middleware Global
// Autenticacao e controle de acesso
// =====================================================

import { extractToken, validateSession, errorResponse } from './lib/auth.js';

// Rotas publicas (nao requerem autenticacao)
const PUBLIC_ROUTES = [
    '/api/auth/login',
    '/api/auth/activate'
];

// Rotas que requerem admin
const ADMIN_ROUTES = [
    '/api/admin/'
];

// Rotas estaticas (servidas pelo Cloudflare Pages)
const STATIC_PATHS = [
    '/landing.html',
    '/login.html',
    '/ativar.html',
    '/index.html',
    '/config/',
    '/shared/',
    '/rede-ativa/',
    '/roadmap/',
    '/admin/',
    '/js/',
    '/css/',
    '/data/',
    '/favicon'
];

export async function onRequest(context) {
    const url = new URL(context.request.url);
    const path = url.pathname;
    const method = context.request.method;

    // OPTIONS sempre permitido (CORS preflight)
    if (method === 'OPTIONS') {
        return context.next();
    }

    // Rotas estaticas - deixar passar
    for (const staticPath of STATIC_PATHS) {
        if (path === staticPath || path.startsWith(staticPath)) {
            return context.next();
        }
    }

    // Raiz redireciona para landing
    if (path === '/') {
        return context.next();
    }

    // Rotas de API
    if (path.startsWith('/api/')) {
        // Rotas publicas nao precisam de autenticacao
        for (const publicRoute of PUBLIC_ROUTES) {
            if (path === publicRoute || path.startsWith(publicRoute)) {
                return context.next();
            }
        }

        // Extrair e validar token para rotas protegidas
        const token = extractToken(context.request);

        if (!token) {
            return errorResponse('Autenticacao necessaria', 401);
        }

        const usuario = await validateSession(context.env.DB, token);

        if (!usuario) {
            return errorResponse('Sessao invalida ou expirada', 401);
        }

        // Verificar acesso admin
        for (const adminRoute of ADMIN_ROUTES) {
            if (path.startsWith(adminRoute) && !usuario.isAdmin) {
                return errorResponse('Acesso negado. Requer permissao de administrador.', 403);
            }
        }

        // Adicionar usuario ao contexto para uso nas funcoes
        context.data = context.data || {};
        context.data.usuario = usuario;

        return context.next();
    }

    // Outras rotas - deixar passar
    return context.next();
}
