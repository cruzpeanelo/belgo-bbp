// Middleware para garantir que arquivos estáticos sejam servidos corretamente
export async function onRequest(context) {
    const url = new URL(context.request.url);
    const path = url.pathname;

    // Rotas que devem ser servidas como arquivos estáticos (não passar para Functions)
    const staticPaths = [
        '/landing.html',
        '/config/',
        '/shared/',
        '/rede-ativa/',
        '/roadmap/'
    ];

    // Se é uma rota estática, deixar o Cloudflare Pages servir o arquivo
    for (const staticPath of staticPaths) {
        if (path === staticPath || path.startsWith(staticPath)) {
            return context.next();
        }
    }

    // Para outras rotas, continuar normalmente
    return context.next();
}
