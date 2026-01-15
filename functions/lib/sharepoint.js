/**
 * Biblioteca de utilitarios para Microsoft SharePoint
 *
 * NOTA: O upload de arquivos e feito no frontend via MSAL
 * Esta biblioteca apenas fornece funcoes auxiliares
 */

/**
 * Valida se uma URL e do SharePoint da Belgo
 * @param {string} url - URL para validar
 * @returns {boolean}
 */
export function isSharePointValido(url) {
    if (!url) return true; // URL vazia e permitida
    const urlLower = url.toLowerCase();
    return urlLower.includes('sharepoint.com') ||
           urlLower.includes('belgomineira.sharepoint.com');
}

/**
 * Gera a URL de download de um arquivo via Graph API
 * @param {string} driveId - ID do drive
 * @param {string} itemId - ID do item
 * @returns {string}
 */
export function gerarUrlDownload(driveId, itemId) {
    return `https://graph.microsoft.com/v1.0/drives/${driveId}/items/${itemId}/content`;
}

/**
 * Gera a URL de upload para um arquivo via Graph API
 * @param {string} driveId - ID do drive
 * @param {string} folderId - ID da pasta
 * @param {string} fileName - Nome do arquivo
 * @returns {string}
 */
export function gerarUrlUpload(driveId, folderId, fileName) {
    return `https://graph.microsoft.com/v1.0/drives/${driveId}/items/${folderId}:/${encodeURIComponent(fileName)}:/content`;
}

/**
 * Gera a URL de listagem de arquivos de uma pasta
 * @param {string} driveId - ID do drive
 * @param {string} folderId - ID da pasta
 * @returns {string}
 */
export function gerarUrlListarArquivos(driveId, folderId) {
    return `https://graph.microsoft.com/v1.0/drives/${driveId}/items/${folderId}/children`;
}

/**
 * Extrai o Drive ID de uma URL do SharePoint
 * NOTA: Esta funcao requer chamada a Graph API para ser precisa
 * @param {string} url - URL do SharePoint
 * @returns {string|null} Drive ID ou null se nao conseguir extrair
 */
export function extrairDriveId(url) {
    // O Drive ID nao pode ser extraido diretamente da URL
    // Precisa de uma chamada a Graph API
    // Esta funcao e um placeholder para documentacao
    return null;
}

/**
 * Scopes necessarios para o MSAL
 */
export const SCOPES_SHAREPOINT = [
    'Files.ReadWrite.All',  // Ler e escrever arquivos
    'Sites.Read.All'        // Ler informacoes do site
];

/**
 * Configuracao MSAL para upload no SharePoint
 * NOTA: Deve ser configurado no frontend com o Client ID da aplicacao Azure AD
 */
export const MSAL_CONFIG_TEMPLATE = {
    auth: {
        clientId: '{{CLIENT_ID}}', // Substituir pelo Client ID real
        authority: 'https://login.microsoftonline.com/{{TENANT_ID}}',
        redirectUri: '{{REDIRECT_URI}}'
    },
    cache: {
        cacheLocation: 'sessionStorage',
        storeAuthStateInCookie: false
    }
};

/**
 * Valida se o Drive ID tem formato valido
 * @param {string} driveId - ID do drive
 * @returns {boolean}
 */
export function isDriveIdValido(driveId) {
    if (!driveId) return true; // Vazio e permitido
    // Drive IDs do Graph geralmente comecam com b! ou sao GUIDs
    return driveId.startsWith('b!') || /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(driveId);
}

/**
 * Valida se o Folder ID tem formato valido
 * @param {string} folderId - ID da pasta
 * @returns {boolean}
 */
export function isFolderIdValido(folderId) {
    if (!folderId) return true; // Vazio e permitido
    // Folder IDs sao geralmente strings alfanumericas
    return /^[A-Z0-9]+$/i.test(folderId);
}
