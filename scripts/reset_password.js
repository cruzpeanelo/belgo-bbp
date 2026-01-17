const { execSync } = require('child_process');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

// Hash function similar to the one in auth.js
function hashPassword(password) {
    return crypto.createHash('sha256').update(password).digest('hex');
}

const newPassword = 'BelgoGTM2024';
const newHash = hashPassword(newPassword);

console.log(`Atualizando senha para: ${newPassword}`);
console.log(`Novo hash: ${newHash}`);

const sql = `UPDATE usuarios SET senha_hash = '${newHash}' WHERE email = 'leandro.pereira@belgo.com.br';`;

const tempFile = path.join(__dirname, '..', 'temp_reset.sql');
fs.writeFileSync(tempFile, sql);

try {
    execSync(`npx wrangler d1 execute belgo-bbp-db --remote --file="${tempFile}"`, {
        encoding: 'utf8',
        maxBuffer: 1024 * 1024 * 10,
        cwd: path.join(__dirname, '..'),
        stdio: ['pipe', 'pipe', 'pipe']
    });
    console.log('Senha atualizada com sucesso!');
    fs.unlinkSync(tempFile);
} catch (error) {
    console.error('Erro:', error.message);
}
