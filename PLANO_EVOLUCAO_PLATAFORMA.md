# PLANO DE EVOLUÇÃO - PLATAFORMA BELGO BBP NO-CODE

> **Data**: Janeiro 2026
> **Objetivo**: Transformar a plataforma para que qualquer projeto novo (como GTM) possa ser criado e configurado 100% via interface administrativa, sem necessidade de escrever código.

---

## ✅ O QUE JÁ ESTÁ 100% PRONTO

### ✅ Página Universal de Entidade (`/pages/entidade.html`)
- URL: `entidade.html?e=testes`, `entidade.html?e=jornadas`, etc.
- Usa `App.initDynamicPage('#dynamicContent', entidadeCodigo)`
- Menu carregado dinamicamente via API `/api/projetos/{id}/menus`
- Links gerados automaticamente no formato `entidade.html?e={codigo}`

### ✅ App.js (`/js/app.js`)
- `loadProjetoInfo()` - Carrega ID do projeto
- `loadEntidade(codigo)` - Carrega entidade com cache em `entidadesCache`
- `loadEntidadeDados(codigo)` - Carrega dados da entidade via API
- `initDynamicPage(container, codigo)` - Inicializa com ConfigRenderer
- Integração com KVSync para sincronização de status

### ✅ ConfigRenderer (`/shared/js/config-renderer.js`)
- Renderização baseada em `config_funcionalidades`
- Layouts: tabela, cards, cards_grid, cards_agrupados, timeline
- Filtros dinâmicos (campos e botões)
- Métricas (total, contador, distinct, soma_array)
- Paginação, ordenação
- Modal de detalhes configurável
- Formulário de criação dinâmico
- Ações: marcar status, Teams, exportar CSV
- Responsividade mobile

### ✅ DynamicComponents (`/shared/js/dynamic-components.js`)
- DynamicTable, DynamicForm, DynamicPage
- Tipos de campo: text, textarea, number, date, select, multiselect, boolean, file, relation

### ✅ DynamicNav (`/shared/js/dynamic-nav.js`)
- Navegação dinâmica via banco
- Seletor de projetos

### ✅ Admin Completo
- `/admin/entidades.html` - CRUD de entidades e campos
- `/admin/menus.html` - CRUD de menus
- `/admin/projetos.html` - CRUD de projetos
- `/admin/projetos-membros.html` - Gerenciar membros por projeto
- `/admin/usuarios.html` - CRUD de usuários

### ✅ Sistema de Permissões (Estrutura)
- `papeis` - admin, gestor, key_user, executor, visualizador
- `permissoes` - permissões granulares por entidade/ação
- `papel_permissoes` - mapeamento papel -> permissões
- `usuario_projeto_papel` - vínculo usuário-projeto-papel

### ✅ Whitelabel (Parcial)
- Cor do projeto (paleta Belgo)
- Ícone do projeto
- Logo do projeto (upload)
- Integração Teams/SharePoint

### ✅ APIs Completas (`/functions/api/`)
- CRUD projetos, entidades, campos, dados, menus
- Importação de dados

### ✅ Banco de Dados (Migrations 001-004)
- projeto_entidades com config_funcionalidades
- projeto_entidade_campos, projeto_entidade_opcoes
- projeto_dados (JSON genérico)
- projeto_menus com entidade_id
- projeto_templates (estrutura básica)

---

## 🔧 O QUE FALTA PARA SER 100% NO-CODE

### RESUMO DOS REQUISITOS:
1. ✅ **Layout/Visualização** - `config_funcionalidades` existe, falta interface visual
2. ✅ **Funções/Ações** - ConfigRenderer tem ações, falta configuração via banco
3. ✅ **Whitelabel** - Cor, logo, ícone já existem no admin
4. ✅ **Perfis por projeto** - Estrutura completa existe, falta aplicar no frontend

---

### FASE 1: EDITOR VISUAL DE LAYOUT (config_funcionalidades)

**Problema**: O `config_funcionalidades` define layout, filtros, métricas, ações - mas é JSON manual

**Solução**: Interface visual no admin de entidades

#### 1.1 Expandir `/admin/entidades.html`

Adicionar botão "Configurar Layout" em cada entidade que abre modal com:

```
┌─────────────────────────────────────────────────────────┐
│ CONFIGURAR LAYOUT - Entidade: Testes                    │
├─────────────────────────────────────────────────────────┤
│ Layout: [Tabela ▼] [Cards] [Timeline] [Cards Agrupados] │
├─────────────────────────────────────────────────────────┤
│ COLUNAS/CAMPOS VISÍVEIS (drag to reorder):              │
│ ☑ codigo (largura: 80px)                                │
│ ☑ nome (largura: auto)                                  │
│ ☑ status (tipo: badge)                                  │
│ ☐ observacoes                                           │
├─────────────────────────────────────────────────────────┤
│ FILTROS:                                                │
│ + Adicionar filtro                                      │
│ [categoria] [select] [Categoria]                        │
│ [status] [select] [Status]                              │
│ [busca] [text] [Buscar...]                              │
├─────────────────────────────────────────────────────────┤
│ MÉTRICAS:                                               │
│ ☑ Habilitar métricas                                    │
│ + Adicionar card                                        │
│ [total] [📊] [Total]                                    │
│ [contador:status=Concluido] [✅] [Concluídos]           │
├─────────────────────────────────────────────────────────┤
│ AÇÕES DE LINHA:                                         │
│ ☑ ver_detalhes                                          │
│ ☑ marcar_concluido                                      │
│ ☑ compartilhar_teams                                    │
├─────────────────────────────────────────────────────────┤
│                        [Cancelar] [Salvar]              │
└─────────────────────────────────────────────────────────┘
```

#### 1.2 Arquivos a modificar/criar

- [ ] Modificar `/admin/entidades.html` - Adicionar botão "Configurar Layout"
- [ ] Criar `/admin/js/layout-builder.js` - Lógica do builder
- [ ] Criar `/admin/css/layout-builder.css` - Estilos

---

### FASE 2: AÇÕES CONFIGURÁVEIS VIA BANCO

**Problema**: Ações estão hardcoded no ConfigRenderer (`marcar_concluido`, `teams`, etc.)

**Solução**: Tabela de ações e ActionEngine

#### 2.1 Migration 005 - Tabela de Ações

```sql
CREATE TABLE projeto_entidade_acoes (
    id INTEGER PRIMARY KEY,
    entidade_id INTEGER NOT NULL,
    codigo TEXT NOT NULL,
    nome TEXT NOT NULL,
    icone TEXT,
    tipo TEXT NOT NULL,  -- 'status_change', 'api_call', 'modal', 'teams', 'exportar'
    config TEXT NOT NULL,
    posicao TEXT,        -- 'linha', 'header', 'modal', 'bulk'
    permissao_minima TEXT,
    ordem INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    FOREIGN KEY (entidade_id) REFERENCES projeto_entidades(id)
);
```

#### 2.2 Arquivos a criar

- [ ] Migration `005_acoes_dinamicas.sql`
- [ ] `/shared/js/action-engine.js` - Engine de execução de ações
- [ ] Migrar ações do GTM para registros no banco
- [ ] Refatorar ConfigRenderer para carregar ações do banco

---

### FASE 3: APLICAR PERMISSÕES NO FRONTEND

**Problema**: Estrutura de permissões existe no banco mas não é aplicada no frontend

**Já existe**:
- `papeis` - admin, gestor, key_user, executor, visualizador
- `permissoes` - permissões granulares por entidade/ação
- `papel_permissoes` - mapeamento papel -> permissões
- `usuario_projeto_papel` - vínculo usuário-projeto-papel
- `/admin/projetos-membros.html` - Gerenciar membros por projeto

**Falta**:
- Carregar permissões do usuário no frontend
- Ocultar/desabilitar botões conforme permissão
- Validar permissões nas APIs

#### 3.1 Arquivos a modificar

- [ ] `/shared/js/auth.js` - Adicionar `BelgoAuth.getPermissoes(projetoId)`
- [ ] `/shared/js/config-renderer.js` - Verificar permissões antes de mostrar ações
- [ ] `/functions/lib/permissions.js` - Middleware de validação

---

### FASE 4: SISTEMA DE TEMPLATES COMPLETO

**Problema**: Tabela `projeto_templates` existe mas não está ativa

**Solução**: Ativar criação de projetos via templates

#### 4.1 Migration 006 - Expandir Templates

```sql
ALTER TABLE projeto_templates ADD COLUMN config_completo TEXT;
-- JSON com: entidades, campos, menus, dashboard, ações
```

#### 4.2 Arquivos a criar

- [ ] `POST /api/projetos/from-template` - API de criação via template
- [ ] Botão "Exportar como Template" em `/admin/projetos.html`
- [ ] Modal de criação de projeto com seleção de template
- [ ] Exportar GTM como template inicial

---

### FASE 5: MELHORAR ADMIN DE MENUS

**Problema**: Form de menu não mostra vinculação com entidade

**Solução**: Adicionar campo entidade_id no form

#### 5.1 Modificar `/admin/menus.html`

```html
<div class="form-group">
    <label for="menuEntidade">Vincular a Entidade</label>
    <select id="menuEntidade">
        <option value="">Nenhuma (URL personalizada)</option>
        <option value="testes">Testes</option>
        <option value="jornadas">Jornadas</option>
        <!-- Carregado dinamicamente -->
    </select>
</div>
```

Quando vinculado a entidade:
- URL gerada automaticamente: `entidade.html?e={codigo}`
- Permissões herdadas da entidade

---

### FASE 6: DASHBOARD DINÂMICO POR PROJETO

**Problema**: `DynamicPage.renderDashboard()` mostra apenas "em construção"

**Solução**: Widgets configuráveis no banco

#### 6.1 Migration 007 - Dashboard Config

```sql
ALTER TABLE projetos ADD COLUMN dashboard_config TEXT;
```

#### 6.2 Arquivos a criar

- [ ] `/shared/js/dashboard-renderer.js` - Engine de dashboard
- [ ] `/pages/dashboard.html` - Página de dashboard universal
- [ ] Widgets: metrica, grafico_pizza, grafico_barras, lista, progresso

---

## PRIORIDADE DE IMPLEMENTAÇÃO

| Prioridade | Fase | Impacto |
|------------|------|---------|
| 🔴 Alta | 1. Editor de Layout | Admin configura visualmente como dados aparecem |
| 🔴 Alta | 4. Templates | Criar projetos novos a partir do GTM |
| 🟡 Média | 2. Ações dinâmicas | Remove código hardcoded, mais flexibilidade |
| 🟡 Média | 3. Permissões frontend | Aplicar controle de acesso real |
| 🟢 Baixa | 5. Menus melhorados | Vincular menu a entidade visualmente |
| 🟢 Baixa | 6. Dashboard | Melhora visualização inicial |

---

## ⚠️ IMPORTANTE: NÃO PERDER DADOS DO GTM

O projeto GTM tem dados em produção. Durante a evolução:

1. **Não alterar estrutura de tabelas existentes** - apenas adicionar novas
2. **Manter compatibilidade** com `config_funcionalidades` atual
3. **Exportar GTM como template** antes de qualquer mudança estrutural
4. **Backup** antes de rodar migrations em produção

---

## ARQUIVOS A CRIAR/MODIFICAR

```
FASE 1 - Editor de Layout:
  /admin/entidades.html          # Modificar: adicionar botão "Configurar Layout"
  /admin/js/layout-builder.js    # CRIAR: lógica do builder visual
  /admin/css/layout-builder.css  # CRIAR: estilos do builder

FASE 2 - Ações Dinâmicas:
  /migrations/005_acoes_dinamicas.sql  # CRIAR: tabela projeto_entidade_acoes
  /shared/js/action-engine.js          # CRIAR: engine de execução
  /shared/js/config-renderer.js        # MODIFICAR: usar ActionEngine

FASE 3 - Permissões Frontend:
  /shared/js/auth.js             # MODIFICAR: adicionar getPermissoes()
  /shared/js/config-renderer.js  # MODIFICAR: verificar permissões
  /functions/lib/permissions.js  # MODIFICAR: middleware

FASE 4 - Templates:
  /migrations/006_templates.sql         # CRIAR: expandir projeto_templates
  /functions/api/projetos/from-template.js  # CRIAR: API
  /admin/projetos.html                  # MODIFICAR: adicionar wizard

FASE 5 - Menus:
  /admin/menus.html              # MODIFICAR: campo entidade_id

FASE 6 - Dashboard:
  /migrations/007_dashboard.sql       # CRIAR: campo dashboard_config
  /shared/js/dashboard-renderer.js    # CRIAR: engine
  /pages/dashboard.html               # CRIAR: página
```

---

## VERIFICAÇÃO FINAL (Critérios de Aceite)

1. [ ] Admin cria projeto novo selecionando template GTM
2. [ ] Projeto novo tem todas as entidades/menus do GTM
3. [ ] Admin configura layout de entidade sem editar JSON
4. [ ] Ações são carregadas do banco (não hardcoded)
5. [ ] Usuário só vê botões que tem permissão
6. [ ] GTM continua funcionando com todos os dados
7. [ ] Funciona em mobile

---

## FLUXO DESEJADO (APÓS IMPLEMENTAÇÃO)

```
1. Admin cria projeto
   └─ Seleciona template (ex: GTM)
   └─ Define nome, cor, logo (whitelabel)
   ↓
2. Sistema cria automaticamente:
   └─ Entidades do template
   └─ Campos de cada entidade
   └─ Menus vinculados
   └─ config_funcionalidades padrão
   └─ Ações padrão
   ↓
3. Admin customiza (se quiser):
   └─ Adiciona/remove entidades
   └─ Configura layout visualmente (botão "Configurar Layout")
   └─ Adiciona/remove ações
   └─ Gerencia membros e papéis
   ↓
4. Usuário acessa projeto:
   └─ Vê apenas menus que tem permissão
   └─ Vê apenas ações que pode executar
   └─ Dados renderizados conforme config
```

---

## STATUS ATUAL vs DESEJADO

| Item | Atual | Desejado |
|------|-------|----------|
| Página de entidade | ✅ Dinâmica | ✅ OK |
| Menu dinâmico | ✅ Via API | ✅ OK |
| Entidades/Campos | ✅ Admin | ✅ OK |
| config_funcionalidades | ⚠️ JSON manual | Visual builder |
| Ações | ⚠️ Hardcoded | Banco + engine |
| Permissões | ⚠️ Só backend | Frontend + backend |
| Templates | ❌ Inativo | Criar projeto via template |
| Dashboard | ❌ Placeholder | Widgets configuráveis |
| Whitelabel | ✅ Cor/Logo | ✅ OK |
| Perfis/Papéis | ✅ Estrutura OK | Aplicar no frontend |

**Conclusão**: Core 85% pronto. Faltam 6 fases para 100% no-code.
