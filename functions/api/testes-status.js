// =====================================================
// BELGO GTM - Cloudflare Pages Function
// Rota: /api/testes-status
// Persistencia de status de testes no Cloudflare KV
// =====================================================

// GET - Carregar todos os status
export async function onRequestGet(context) {
    try {
        const data = await context.env.BELGO_TESTES.get('status', 'json');
        return new Response(JSON.stringify(data || { testes: [], updatedAt: null }), {
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Cache-Control': 'no-cache'
            }
        });
    } catch (error) {
        return new Response(JSON.stringify({ error: error.message, testes: [] }), {
            status: 500,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        });
    }
}

// POST - Salvar status de testes
export async function onRequestPost(context) {
    try {
        const body = await context.request.json();

        // Validar dados
        if (!body.testes || !Array.isArray(body.testes)) {
            return new Response(JSON.stringify({ error: 'Formato invalido: testes deve ser um array' }), {
                status: 400,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                }
            });
        }

        // Adicionar timestamp
        const dataToSave = {
            testes: body.testes,
            updatedAt: new Date().toISOString(),
            updatedBy: body.updatedBy || 'unknown'
        };

        await context.env.BELGO_TESTES.put('status', JSON.stringify(dataToSave));

        return new Response(JSON.stringify({
            success: true,
            count: body.testes.length,
            updatedAt: dataToSave.updatedAt
        }), {
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        });
    } catch (error) {
        return new Response(JSON.stringify({ error: error.message }), {
            status: 500,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        });
    }
}

// OPTIONS - CORS preflight
export async function onRequestOptions() {
    return new Response(null, {
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Max-Age': '86400'
        }
    });
}
