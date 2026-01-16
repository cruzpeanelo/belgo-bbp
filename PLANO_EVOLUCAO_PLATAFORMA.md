# PLANO DE EVOLUÇÃO - PLATAFORMA BELGO BBP NO-CODE

> **Data**: Janeiro 2026
> **Objetivo**: Transformar a plataforma para que qualquer projeto novo (como GTM) possa ser criado e configurado 100% via interface administrativa, sem necessidade de escrever código.

---

## STATUS ATUAL: 🔧 EM PROGRESSO - FASE 8

### Resumo do Progresso
- **7 fases implementadas** no código
- **Migrations aplicadas** em produção
- **Template GTM exportado** com sucesso (6 entidades, 11 menus)
- **Projeto criado via template** com sucesso (GTM Clone - Teste No-Code)
- **UX/UI melhorado** - Menu admin contextual na sidebar
- **Seletor de projetos corrigido** - URLs normalizadas
- **🔧 PENDENTE**: Remover seletores duplicados nas páginas legadas

---

## O QUE JÁ FOI FEITO

### Código Implementado

#### FASE 1: EDITOR VISUAL DE LAYOUT
- Botão "Layout" em cada card de entidade em `/admin/entidades.html`
- Modal com 5 abas: Layout, Colunas, Filtros, Métricas, Ações
- Configuração visual de `config_funcionalidades`

#### FASE 2: AÇÕES CONFIGURÁVEIS VIA BANCO
- Tabela `projeto_entidade_acoes` criada
- Engine `/shared/js/action-engine.js` implementada
- API CRUD em `/api/projetos/[id]/entidades/[entidadeId]/acoes.js`

#### FASE 3: PERMISSÕES NO FRONTEND
- Funções `BelgoAuth.getPermissoes()` adicionadas em `/shared/js/auth.js`
- Verificação de permissões no `config-renderer.js`
- API `/api/projetos/[id]/permissoes.js`

#### FASE 4: SISTEMA DE TEMPLATES
- Colunas adicionadas em `projeto_templates`: `config_completo`, `projeto_origem_id`, `versao`, etc.
- API `/api/projetos/from-template.js` - criar projeto via template
- API `/api/projetos/[id]/export-template.js` - exportar projeto como template
- API `/api/templates.js` - listar templates
- UI em `/admin/projetos.html` com botão de exportar template

#### FASE 5: ADMIN DE MENUS MELHORADO
- Dropdown para vincular menu a entidade em `/admin/menus.html`
- URL gerada automaticamente para páginas dinâmicas

#### FASE 6: DASHBOARD DINÂMICO
- Tabela `projeto_dashboard_widgets` criada
- Engine `/shared/js/dashboard-renderer.js` com 7 tipos de widget
- CSS `/shared/css/dashboard-renderer.css`
- API `/api/projetos/[id]/dashboard.js`
- Página `/pages/dashboard.html`
- Admin `/admin/dashboard-config.html`

#### FASE 7: MELHORIAS DE UX/UI
- Seção "Administração" na sidebar para usuários admin
- Links contextuais para Entidades, Menus, Dashboard Config do projeto atual
- Link para Painel Admin Geral
- Footer com "Todos os Projetos" e botão "Sair"
- CSS para `.nav-divider`, `.nav-section-title`, `.nav-admin`, `.nav-footer`
- Atualizado: `entidade.html`, `dashboard.html`, `projeto-dinamico.html`
- Atualizado: `dynamic-nav.js` para incluir admin e footer

---

### Migrations Aplicadas em Produção

```sql
-- Colunas adicionadas em projeto_templates:
ALTER TABLE projeto_templates ADD COLUMN config_completo TEXT;
ALTER TABLE projeto_templates ADD COLUMN projeto_origem_id INTEGER;
ALTER TABLE projeto_templates ADD COLUMN versao TEXT DEFAULT '1.0';
ALTER TABLE projeto_templates ADD COLUMN criado_por INTEGER;
ALTER TABLE projeto_templates ADD COLUMN updated_at TEXT;
ALTER TABLE projeto_templates ADD COLUMN preview_url TEXT;

-- Colunas adicionadas em projeto_entidades:
ALTER TABLE projeto_entidades ADD COLUMN ativo INTEGER DEFAULT 1;
ALTER TABLE projeto_entidades ADD COLUMN ordem INTEGER DEFAULT 0;

-- Colunas adicionadas em projeto_entidade_campos:
ALTER TABLE projeto_entidade_campos ADD COLUMN config TEXT;
ALTER TABLE projeto_entidade_campos ADD COLUMN placeholder TEXT;
ALTER TABLE projeto_entidade_campos ADD COLUMN ajuda TEXT;
ALTER TABLE projeto_entidade_campos ADD COLUMN visivel_detalhe INTEGER DEFAULT 1;

-- Coluna adicionada em projeto_entidade_opcoes:
ALTER TABLE projeto_entidade_opcoes ADD COLUMN campo_id INTEGER;

-- Coluna adicionada em projetos:
ALTER TABLE projetos ADD COLUMN dashboard_config TEXT;

-- Tabela de ações dinâmicas:
CREATE TABLE projeto_entidade_acoes (...);

-- Tabela de widgets do dashboard:
CREATE TABLE projeto_dashboard_widgets (...);
```

---

### Testes Realizados

| Teste | Resultado |
|-------|-----------|
| Login na plataforma | ✅ OK |
| Acesso ao admin de projetos | ✅ OK |
| Exportar GTM como template | ✅ OK (6 entidades, 11 menus) |
| Criar projeto via template | ✅ OK (GTM Clone - 7 entidades, 12 menus) |
| Criar nova entidade | ✅ OK (Riscos criado com sucesso) |
| Adicionar campos à entidade | ✅ OK (4 campos com opções coloridas) |
| Criar menu vinculado à entidade | ✅ OK (Menu Riscos vinculado automaticamente) |
| Configurar layout de entidade | ✅ OK (Cards Grid + filtro por status) |
| Layout Builder - 5 abas | ✅ OK (Layout, Colunas, Filtros, Métricas, Ações) |

### Teste de Ponta a Ponta - Janeiro 2026 ✅

| Etapa | Resultado |
|-------|-----------|
| Login na landing page | ✅ OK |
| Acessar projeto GTM Clone | ✅ OK (página dinâmica de projeto) |
| Menu lateral carregado dinamicamente | ✅ OK (12 menus) |
| Navegar para Riscos via menu | ✅ OK |
| Entidade carregada corretamente | ✅ OK |
| Criar registro de risco | ✅ OK |
| Registro salvo e exibido na tabela | ✅ OK |
| Badges coloridos funcionando | ✅ OK |
| Criar segundo registro | ✅ OK |
| Ambos registros aparecem na listagem | ✅ OK (2 registros) |

### Teste do Dashboard Dinâmico - Janeiro 2026 ✅

| Etapa | Resultado |
|-------|-----------|
| Acessar admin de dashboard config | ✅ OK |
| Selecionar projeto GTM Clone | ✅ OK |
| Criar widget "Total de Riscos" (Métrica) | ✅ OK |
| Criar widget "Riscos por Status" (Gráfico Pizza) | ✅ OK |
| Acessar dashboard do projeto | ✅ OK |
| Widget métrica mostra contagem correta (2) | ✅ OK |
| Gráfico pizza mostra distribuição correta | ✅ OK |
| Cores e percentuais funcionando | ✅ OK |

**Widgets Testados:**
- **Métrica**: Contagem total de registros de uma entidade
- **Gráfico Pizza**: Agrupamento por campo com cores e percentuais

---

## ✅ TODOS OS TESTES CONCLUÍDOS

### 1. Criar Novo Projeto via Template ✅
- Projeto "GTM Clone - Teste No-Code" criado com sucesso
- Template "Template GTM - Go To Market" usado como base
- 6 entidades + 11 menus copiados automaticamente
- Usuário criador definido como admin do projeto

### 2. Adicionar Nova Entidade ✅
- Entidade "Riscos" criada no projeto clonado
- 4 campos configurados:
  - `titulo` (text, obrigatório)
  - `probabilidade` (select: Baixa/Média/Alta com cores)
  - `impacto` (select: Baixo/Médio/Alto com cores)
  - `status` (select: Identificado/Mitigado/Fechado com cores)

### 3. Criar Menu Dinâmico ✅
- Menu "Riscos" criado vinculado à entidade
- URL gerada automaticamente: `pages/entidade.html?e=riscos`
- Projeto agora tem 12 menus (11 do template + 1 novo)

### 4. Testar Layout Builder ✅
- Modal com 5 abas funcionando
- Layout alterado de Tabela para Cards Grid
- Filtro por Status adicionado
- Configuração salva com sucesso

---

## ARQUIVOS CRIADOS/MODIFICADOS

```
BACKEND (Functions):
  functions/api/templates.js                              - NOVO
  functions/api/projetos/from-template.js                 - NOVO
  functions/api/projetos/[id]/export-template.js          - NOVO
  functions/api/projetos/[id]/dashboard.js                - NOVO
  functions/api/projetos/[id]/permissoes.js               - NOVO
  functions/api/projetos/[id]/entidades/[entidadeId]/acoes.js - NOVO

FRONTEND (Shared):
  shared/js/action-engine.js                              - NOVO
  shared/js/dashboard-renderer.js                         - NOVO
  shared/css/dashboard-renderer.css                       - NOVO
  shared/js/auth.js                                       - MODIFICADO
  shared/js/config-renderer.js                            - MODIFICADO

PÁGINAS:
  pages/dashboard.html                                    - NOVO
  admin/dashboard-config.html                             - NOVO
  admin/projetos.html                                     - MODIFICADO (botão exportar)
  admin/entidades.html                                    - MODIFICADO (layout builder)
  admin/menus.html                                        - MODIFICADO (vincular entidade)
  admin/index.html                                        - MODIFICADO (link dashboard config)

MIGRATIONS:
  migrations/005_templates_completo.sql
  migrations/006_acoes_dinamicas.sql
  migrations/007_dashboard_config.sql
```

---

## COMMITS REALIZADOS

1. `b16b8f3` - Feat: Plataforma 100% no-code - 6 fases completas
2. `73dffba` - Fix: Corrigir autenticação das APIs novas + atualizar plano
3. `686ae4f` - Fix: Ajustar API export-template para estrutura real do banco

---

## PRÓXIMOS PASSOS (OPCIONAL)

1. ~~**AGORA**: Criar novo projeto via template GTM~~ ✅ FEITO
2. ~~Testar todas as funcionalidades do novo projeto~~ ✅ FEITO
3. ~~Testar configuração de layout visual~~ ✅ FEITO
4. ~~**Teste de ponta a ponta completo**~~ ✅ FEITO (Janeiro 2026)
5. ~~**Testar dashboard dinâmico (widgets)**~~ ✅ FEITO (Janeiro 2026)
6. Documentar processo para administradores

---

## FLUXO DE USO ESPERADO

```
1. Admin acessa /admin/projetos.html
   └─ Clica "Novo Projeto"
   └─ Seleciona template "Template GTM"
   └─ Define: codigo, nome, cor, responsável
   └─ Clica "Criar Projeto"
   ↓
2. Sistema cria automaticamente:
   └─ Projeto com cor/ícone do template
   └─ 6 entidades (testes, jornadas, etc.)
   └─ Campos de cada entidade
   └─ 11 menus vinculados às entidades
   └─ Usuário criador como admin do projeto
   ↓
3. Admin personaliza (opcional):
   └─ Adiciona/remove entidades
   └─ Clica "Layout" para configurar visualmente
   └─ Configura dashboard (widgets)
   └─ Gerencia membros e papéis
   ↓
4. Usuários acessam:
   └─ Veem apenas menus com permissão
   └─ Dados renderizados conforme config
   └─ Dashboard dinâmico
```

---

## OBSERVAÇÕES TÉCNICAS

### Estrutura do Banco vs API
Durante os testes, foram identificadas diferenças entre a estrutura esperada pela API e a estrutura real do banco em produção:

- `projeto_entidade_opcoes` usa `entidade_id` + `campo_codigo` (não `campo_id`)
- `projeto_entidades` não tinha `ativo` e `ordem` (adicionados)
- `projeto_entidade_campos` não tinha `config`, `placeholder`, `ajuda`, `visivel_detalhe` (adicionados)

As correções foram feitas tanto no banco quanto na API para garantir compatibilidade.

### Template Exportado
O template "Template GTM - Go To Market" foi exportado com sucesso e contém:
- 6 entidades
- 11 menus
- Configurações de campos e opções
- Pode ser usado para criar novos projetos com a mesma estrutura

---

## CORREÇÕES REALIZADAS (Janeiro 2026)

### 1. Página Dinâmica de Projeto
**Problema**: Projetos criados via template não tinham uma página dedicada, caindo no dashboard geral.

**Solução**:
- Criada `/pages/projeto-dinamico.html` - página que exibe:
  - Header do projeto com nome, descrição e ícone
  - Estatísticas (entidades e menus)
  - Grid de acesso rápido aos menus
  - Menu lateral dinâmico
- API `from-template.js` modificada para definir `url_modulo` automaticamente

### 2. URLs Absolutas nos Menus
**Problema**: URLs relativas como `pages/entidade.html?e=riscos` causavam duplicação de path quando a página já estava em `/pages/`.

**Solução**:
- API `from-template.js` modificada para gerar URLs absolutas: `/pages/entidade.html?e=riscos`
- URLs existentes no banco corrigidas para usar prefixo `/`

### 3. Vinculação de Menu à Entidade
**Problema**: Menu "Riscos" criado manualmente não estava vinculado à entidade correspondente.

**Solução**:
- Menu corrigido com `entidade_id` apontando para a entidade correta
- API agora define `entidade_id` automaticamente quando `pagina_dinamica` está ativo

### Arquivos Modificados Nesta Correção
```
pages/projeto-dinamico.html                  - NOVO (dashboard dinâmico por projeto)
functions/api/projetos/from-template.js      - MODIFICADO (url_modulo + URLs absolutas)
```

### Comandos SQL Executados
```sql
-- Corrigir url_modulo do projeto GTM Clone
UPDATE projetos SET url_modulo = 'pages/projeto-dinamico.html?projeto=gtm-clone' WHERE id = 5;

-- Corrigir URLs dos menus para absolutas
UPDATE projeto_menus SET url = '/pages/entidade.html?e=' || codigo WHERE entidade_id IS NOT NULL;

-- Vincular menu Riscos à entidade
UPDATE projeto_menus SET entidade_id = 23, url = '/pages/entidade.html?e=riscos' WHERE id = 46;
```

---

## FASE 8: UNIFICAÇÃO DE NAVEGAÇÃO (EM PROGRESSO)

### Problema Identificado
As páginas legadas (index.html, rede-ativa/index.html, roadmap/index.html) têm **seletor de módulos estático hardcoded** no HTML, além do seletor dinâmico que o DynamicNav adiciona. Resultado: **dois seletores aparecem na sidebar**.

### O que já foi feito ✅

#### 8.1. Correção de URLs no Seletor de Projetos
**Problema**: URLs relativas como `index.html` causavam navegação para path errado quando usuário estava em subpasta (ex: `/pages/index.html` em vez de `/index.html`).

**Solução implementada**:
- Função `normalizeUrl()` adicionada em `dynamic-nav.js`
- Garante que todas URLs comecem com `/`
- `event.preventDefault()` no onclick para controlar navegação via JS

**Commits**:
- `abca80d` - Fix: Normalizar URLs relativas no seletor de projetos
- `36e669b` - Fix: Prevenir comportamento padrao do link no seletor de projetos

**Arquivos modificados**:
- `shared/js/dynamic-nav.js`
- `pages/entidade.html`
- `pages/dashboard.html`

### O que falta fazer 🔧

#### 8.2. Remover Seletor Estático das Páginas Legadas
**Arquivos a modificar**:
- `index.html` - Remover `.module-selector` hardcoded
- `rede-ativa/index.html` - Remover `.module-selector` hardcoded
- `roadmap/index.html` - Remover `.module-selector` hardcoded

**Opção A**: Remover o HTML estático e deixar o DynamicNav renderizar
**Opção B**: Impedir DynamicNav de adicionar seletor se já existir um

#### 8.3. Padronizar Menu Lateral nas Páginas Legadas
As páginas legadas têm menu estático no HTML. Duas opções:
- **Opção A**: Converter para usar DynamicNav (menu 100% dinâmico)
- **Opção B**: Manter menu estático mas sem duplicação

### Páginas Afetadas

| Página | Seletor Estático | Menu Estático | DynamicNav |
|--------|------------------|---------------|------------|
| `/index.html` | ✅ Sim (module-selector) | ✅ Sim | ✅ Sim (duplica) |
| `/rede-ativa/index.html` | ✅ Sim | ✅ Sim | ✅ Sim (duplica) |
| `/roadmap/index.html` | ✅ Sim | ✅ Sim | ✅ Sim (duplica) |
| `/pages/projeto-dinamico.html` | ❌ Não | ❌ Não | ✅ Sim (correto) |
| `/pages/entidade.html` | ❌ Não | ❌ Não | ✅ Sim (correto) |
| `/pages/dashboard.html` | ❌ Não | ❌ Não | ✅ Sim (correto) |

### Decisão Necessária
**Pergunta**: Como proceder com as páginas legadas (index.html, rede-ativa, roadmap)?

1. **Migrar para 100% dinâmico** - Remover HTML estático e usar DynamicNav
2. **Manter híbrido** - Apenas remover o seletor duplicado, manter menu estático
3. **Desabilitar DynamicNav nas legadas** - Só usar DynamicNav em páginas novas
