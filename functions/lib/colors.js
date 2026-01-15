/**
 * Paleta de cores oficial Belgo BBP
 * Usada para validar cores de projetos (white label)
 */

export const PALETA_BELGO = {
    '#003B4A': 'Azul Escuro',      // Cor principal Belgo
    '#00A799': 'Verde Agua',        // Secundaria
    '#ED1C24': 'Vermelho',          // Destaque
    '#333333': 'Cinza Escuro',      // Texto principal
    '#666666': 'Cinza Medio',       // Texto secundario
    '#F5F5F5': 'Cinza Claro',       // Background alternativo
    '#FFFFFF': 'Branco',            // Background padrao
    '#E3F2FD': 'Azul Claro',        // Highlight info
    '#E8F5E9': 'Verde Claro',       // Highlight sucesso
    '#FFF3CD': 'Amarelo',           // Highlight alerta
    '#FF6B35': 'Laranja'            // Accent alternativo
};

/**
 * Verifica se uma cor e valida (pertence a paleta Belgo)
 * @param {string} cor - Codigo hex da cor (ex: #003B4A)
 * @returns {boolean} true se a cor e valida
 */
export function isCorValida(cor) {
    if (!cor) return true; // Cor nula e permitida (usa padrao)
    return Object.keys(PALETA_BELGO).includes(cor.toUpperCase());
}

/**
 * Retorna o nome da cor
 * @param {string} cor - Codigo hex da cor
 * @returns {string|null} Nome da cor ou null se invalida
 */
export function getNomeCor(cor) {
    if (!cor) return null;
    return PALETA_BELGO[cor.toUpperCase()] || null;
}

/**
 * Retorna a paleta como array para uso em selects
 * @returns {Array<{hex: string, nome: string}>}
 */
export function getPaletaArray() {
    return Object.entries(PALETA_BELGO).map(([hex, nome]) => ({ hex, nome }));
}

/**
 * Cor padrao para projetos
 */
export const COR_PADRAO = '#003B4A';
