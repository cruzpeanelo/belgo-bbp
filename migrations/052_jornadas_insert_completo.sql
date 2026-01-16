-- =====================================================
-- Migration 052: Jornadas - INSERT Completo
-- DELETA e INSERE todas as 14 jornadas com dados completos
-- extraídos dos arquivos data/jornadas/*.json
-- Projeto 5 (GTM Clone) - Entidade ID 18
-- =====================================================

-- Primeiro, deletar todos os registros de jornadas existentes
DELETE FROM projeto_dados WHERE entidade_id = 18 AND projeto_id = 5;

-- =============================================================================
-- Jornada 1: Cadastro de Cliente
-- Fonte: data/jornadas/cadastro-cliente.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Cadastro de Cliente",
  "icone": "👤",
  "ordem": 1,
  "status": "Em Andamento",
  "as_is": "Processo manual e fragmentado onde o vendedor coleta dados do cliente via formulários em papel ou planilhas Excel, envia para o SmartCenter por e-mail, que então digita manualmente no SAP. Validações de CNPJ/CPF são feitas manualmente através de consultas em sites externos, sem verificação automática de duplicidades, resultando em cadastros duplicados frequentes e dados inconsistentes.",
  "passos_as_is": "Vendedor visita cliente ou recebe contato comercial|Coleta dados em formulário físico ou planilha Excel (Razão Social, CNPJ, Endereço, Contatos)|Envia formulário preenchido para SmartCenter via e-mail|SmartCenter recebe e analisa a solicitação (pode levar horas ou dias)|SmartCenter consulta CNPJ manualmente em sites externos (Receita Federal, SINTEGRA)|SmartCenter digita os dados manualmente no SAP|Realiza verificação manual de duplicados na base (sujeita a erros humanos)|Cadastro finalizado após múltiplas interações e correções",
  "problemas_as_is": "Tempo excessivo para conclusão (2 a 3 dias úteis)|Erros de digitação frequentes na entrada manual|Cadastros duplicados na base de dados|Ausência de validação automática de CNPJ/CPF|CNAE não preenchido ou preenchido incorretamente|Dependência total do SmartCenter (gargalo operacional)|Dados incompletos ou inconsistentes chegam ao SAP|Sem notificação automática de cadastros pendentes|Informações de contato mal preenchidas ou desatualizadas|Impacto negativo no autoatendimento e outras áreas dependentes",
  "tempo_medio_as_is": "2 a 3 dias úteis",
  "to_be": "Cadastro automatizado via integração SINTEGRA diretamente no Salesforce. O vendedor digita apenas o CNPJ, clica no botão ''Integrar SINTEGRA'' e o sistema preenche automáticamente todos os dados oficiais (Razão Social, Endereço, Inscrição Estadual, CNAE com descrição completa). O sistema valida duplicidades automáticamente pelo campo ''Termo de Pesquisa'', impedindo cadastros duplicados. Após validação, ocorre integração automática com SAP via middleware.",
  "passos_to_be": "Vendedor acessa o Salesforce (aplicativo mobile ou desktop)|Clica em ''Criar Conta'' e seleciona o tipo: Pessoa Jurídica, Pessoa Física ou Parceiro Agrupador|Preenche o CNPJ do cliente|Sistema preenche automáticamente: Escritório de Vendas (conforme perfil) e Equipe de Vendas (conforme time)|Clica no botão ''Integrar SINTEGRA''|Sistema consulta SINTEGRA e preenche automáticamente: Razão Social, Endereço, Inscrição Estadual (IE), CNAE com descrição completa|Sistema exibe mensagem de sucesso no canto superior da tela|Sistema valida ''Termo de Pesquisa'' contra base existente para evitar duplicidade|Se duplicado: exibe mensagem ''Já existe um cliente com o mesmo termo de pesquisa'' e bloqueia|Se único: vendedor complementa dados comerciais (Contatos, Área de Vendas, Canal)|Clica no botão ''Enviar SAP'' para sincronização|Sistema sincroniza dados com SAP e exibe mensagem de confirmação|Se cadastro incompleto: sistema envia notificação automática de pendência",
  "beneficios_to_be": "Cadastro concluído em apróximadamente 5 minutos|Eliminação de erros de digitação manual|Dados validados automáticamente via SINTEGRA (fonte oficial)|Deduplicação automática por Termo de Pesquisa|CNAE sempre correto e com descrição completa|Preenchimento automático de Escritório e Equipe de Vendas|Dados de contato padronizados e validados|Habilitação correta do autoatendimento|Redução significativa da carga operacional do SmartCenter|Rastreabilidade completa de todas as operações|Notificação automática de cadastros pendentes",
  "tempo_medio_to_be": "5 minutos",
  "areas_impactadas": "Comercial|SmartCenter|TI|Atendimento|Financeiro|Logística",
  "sistemas_tecnicos": "Salesforce|SAP ECC|SINTEGRA|Middleware",
  "fonte_reuniao": "10/12/2025",
  "fontes_reuniao": "10/12/2025 - Sessao dedicada a Cadastro de Cliente|16/12/2025 - Revisão de Cadastro e Documentos Fiscais",
  "pendencias": "Integração com Portal Logístico pendente de definição para evitar redundância de dados|Padronização de celulares e bases de contatos (documento 901674)|Definição de regras para concorrentes sazonais|Definição de critérios automáticos para seleção de Canal baseado em CNAE|Validação de formato de telefone celular (padronização)|Integração com bureau de crédito para análise automática",
  "prerequisitos": "Acesso à API SINTEGRA configurado e operacional|Middleware Salesforce-SAP configurado e testado|Perfis de usuário configurados com escritório e time corretos|Usuários treinados no novo fluxo de cadastro",
  "campos_processo": [
    {
      "campo": "CNPJ",
      "descrição": "Cadastro Nacional de Pessoa Jurídica",
      "preenchimento": "Manual",
      "validação": "SINTEGRA",
      "obrigatório": true
    },
    {
      "campo": "CPF",
      "descrição": "Cadastro de Pessoa Física",
      "preenchimento": "Manual",
      "validação": "Algoritmo",
      "obrigatório": true
    },
    {
      "campo": "Razão Social",
      "descrição": "Nome oficial da empresa",
      "preenchimento": "Automático (SINTEGRA)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Nome Fantasia",
      "descrição": "Nome comercial da empresa",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Endereço",
      "descrição": "Endereço completo",
      "preenchimento": "Automático (SINTEGRA)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Inscrição Estadual (IE)",
      "descrição": "Registro estadual do contribuinte",
      "preenchimento": "Automático (SINTEGRA)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "CNAE",
      "descrição": "Classificação Nacional de Atividades Econômicas",
      "preenchimento": "Automático (SINTEGRA)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Termo de Pesquisa",
      "descrição": "Identificador único para evitar duplicidade",
      "preenchimento": "Manual",
      "validação": "Duplicidade",
      "obrigatório": true
    },
    {
      "campo": "Tipo de Conta",
      "descrição": "PJ, PF ou Parceiro Agrupador",
      "preenchimento": "Manual",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Escritório de Vendas",
      "descrição": "Escritório responsável pela conta",
      "preenchimento": "Automático (Perfil)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Equipe de Vendas",
      "descrição": "Time comercial responsável (antigo EV Alternativo)",
      "preenchimento": "Automático (Time)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Canal",
      "descrição": "Canal de venda: 20, 25, 30 ou 40",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Cluster",
      "descrição": "Classificação automática do cliente",
      "preenchimento": "Automático",
      "validação": "Workflow para exceção",
      "obrigatório": false
    },
    {
      "campo": "Atividade Principal",
      "descrição": "Descrição da atividade baseada no CNAE",
      "preenchimento": "Automático (CNAE)",
      "validação": "-",
      "obrigatório": false
    }
  ],
  "regras_negocio": [
    {
      "regra": "Validação de Duplicidade por Termo de Pesquisa",
      "descrição": "O sistema verifica se já existe outro cliente cadastrado com o mesmo ''Termo de Pesquisa''. Caso exista, a criação é bloqueada e uma mensagem de erro é exibida.",
      "mensagemErro": "Encontramos um obstáculo, já existe um cliente com o mesmo termo de pesquisa",
      "documento": "899139"
    },
    {
      "regra": "Preenchimento Automático via SINTEGRA",
      "descrição": "Após inserir o CNPJ e clicar no botão ''Integrar SINTEGRA'', o sistema consulta a base do SINTEGRA e preenche automáticamente: Inscrição Estadual, CNAE com descrição completa, Endereço e informações complementares.",
      "exemplos": [
        "ADUBOSREAL → ''Comércio atacadista de defensivos agrícolas, adubos, fertilizantes e corretivos''",
        "SANTA RITA → ''Produção de artefatos estampados de metal''",
        "DIVINO ANT → ''Obras de alvenaria''",
        "VALDIR FLOR → ''Criação de peixes em água doce''"
      ],
      "documento": "876268"
    },
    {
      "regra": "Preenchimento Automático de Escritório e Equipe",
      "descrição": "O campo ''Escritório de Vendas'' é preenchido automáticamente conforme o escritório do perfil do usuário logado. O campo ''Equipe de Vendas'' é preenchido conforme o time do usuário.",
      "nota": "Campo ''EV Alternativo'' foi renomeado para ''Equipe de Vendas''"
    },
    {
      "regra": "Canais de Venda",
      "descrição": "Cada cliente deve ser associado a um canal de venda específico que determina políticas comerciais, preços e condições.",
      "canais": {
        "20": "A definir",
        "25": "A definir",
        "30": "A definir",
        "40": "A definir"
      },
      "avisoVerificação": "ATENCAO: Os canais 20, 25, 30 e 40 foram MENCIONADOS na reunião de 10/12, mas as DEFINICOES de cada canal (critérios, CNAEs, etc.) NAO foram explicadas. Precisam ser validados com a equipe Comercial/TI.",
      "fonteReunião": "Reunião 10/12 - Leandro: ''Entao canal 30, 20, 30 e 40 e quando eles tem que ser aplicados. Falei tambem sobre o canal 25''",
      "nota": "Canal 25 mencionado como existente, mas critérios não detalhados"
    },
    {
      "regra": "Cluster Automático com Exceção",
      "descrição": "O sistema calcula automáticamente o Cluster do cliente baseado em regras de negócio. Para casos especiais, existe o campo ''Cluster Exceção'' que requer aprovação via workflow.",
      "fluxoAprovação": [
        "Usuário clica em ''Enviar para Aprovação''",
        "Status muda para ''Enviado''",
        "Aprovador recebe e-mail com solicitação",
        "Aprovador aprova dentro do Salesforce",
        "Sistema envia e-mail de confirmação",
        "Campo ''Cluster Exceção'' é marcado"
      ],
      "documento": "862865"
    },
    {
      "regra": "Notificação de Cadastro Pendente",
      "descrição": "O sistema identifica automáticamente cadastros que estão incompletos ou pendentes de ações complementares e envia notificações aos responsáveis.",
      "documento": "881196"
    },
    {
      "regra": "Sincronização com SAP",
      "descrição": "Após conclusão do cadastro no Salesforce, o usuário clica em ''Enviar SAP'' para sincronizar os dados. O sistema exibe a mensagem ''A conta está em sincronização com o SAP''.",
      "documento": "Interface Termo de Pesquisa (SAP ↔ Salesforce)"
    },
    {
      "regra": "Remoção de Botões Desnecessários",
      "descrição": "Os botões ''Descobrir Empresas'', ''Importar'' e ''Atribuir Rótulo'' foram removidos da tela de Contas para simplificar a interface.",
      "documento": "Roteiro de Teste - CNAE"
    },
    {
      "regra": "Qualidade de Dados de Contato",
      "descrição": "Os dados de contato devem ser preenchidos corretamente pois são críticos para o funcionamento do Autoatendimento e são utilizados por outras áreas da empresa."
    }
  ],
  "integracoes": [
    {
      "origem": "Salesforce",
      "destino": "SINTEGRA",
      "tipo": "API",
      "descrição": "Consulta de CNPJ para obter IE, CNAE e endereço",
      "acionamento": "Botão ''Integrar SINTEGRA''",
      "retorno": "Mensagem de sucesso no canto superior da tela"
    },
    {
      "origem": "Salesforce",
      "destino": "SAP",
      "tipo": "Middleware",
      "descrição": "Criação e atualização de conta no SAP",
      "acionamento": "Botão ''Enviar SAP''",
      "retorno": "Mensagem ''A conta está em sincronização com o SAP''"
    },
    {
      "origem": "SAP",
      "destino": "Salesforce",
      "tipo": "Middleware",
      "descrição": "Retorno de código SAP e confirmação de sincronização"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "876268",
      "título": "CNAE - Classificação Nacional de Atividades Econômicas",
      "status": "Pendente",
      "ciclo": "P1",
      "data": "21/10/2025",
      "cenarios": [
        "Validar preenchimento automático de CNAE via SINTEGRA",
        "Verificar descrição completa da atividade econômica",
        "Testar com diferentes tipos de empresa (comércio, indústria, serviços)"
      ],
      "contasTeste": [
        {
          "nome": "ADUBOSREAL",
          "cnaeDescrição": "Comércio atacadista de defensivos agrícolas, adubos, fertilizantes e corretivos"
        },
        {
          "nome": "SANTA RITA",
          "cnaeDescrição": "Produção de artefatos estampados de metal"
        },
        {
          "nome": "PERAM",
          "cnaeDescrição": "A verificar no sistema - descrição não documentada",
          "nota": "No documento 876268 aparece apenas como ''CNAE Principal'' com hyperlink"
        },
        {
          "nome": "DIVINO ANT",
          "cnaeDescrição": "Obras de alvenaria"
        },
        {
          "nome": "VALDIR FLOR",
          "cnaeDescrição": "Criação de peixes em água doce"
        }
      ],
      "testesRelacionados": [
        "CT-116",
        "CT-117"
      ]
    },
    {
      "documento": "899139",
      "título": "Validação do Campo Termo de Pesquisa no Cadastro de Cliente",
      "status": "Pendente",
      "ciclo": "P2",
      "data": "12/12/2025",
      "cenarios": [
        "Tentativa de cadastro com Termo de Pesquisa já existente",
        "Verificar mensagem de bloqueio de duplicidade",
        "Cadastro válido quando termo é único"
      ],
      "mensagemEsperada": "Encontramos um obstáculo, já existe um cliente com o mesmo termo de pesquisa",
      "testesRelacionados": [
        "CT-118",
        "CT-119"
      ]
    },
    {
      "documento": "895163",
      "título": "Automatização de Segmento e Subsegmento - Padronização de Base",
      "status": "Pendente",
      "ciclo": "P2",
      "data": "-",
      "cenarios": [
        "Automatização de campos de segmentação de clientes",
        "Validar regras de classificação automática"
      ],
      "testesRelacionados": [
        "CT-123"
      ]
    },
    {
      "documento": "881196",
      "título": "Notificar sobre Cadastro a Finalizar - Pendente",
      "status": "Pendente",
      "ciclo": "P2",
      "data": "17-24/10/2025",
      "cenarios": [
        "Identificação de cadastros incompletos",
        "Envio de notificação automática",
        "Verificar destinatários da notificação"
      ],
      "testesRelacionados": [
        "CT-122"
      ]
    },
    {
      "documento": "862865",
      "título": "Definição Automática de Cluster",
      "status": "Pendente",
      "ciclo": "P2",
      "data": "14/10/2025",
      "cenarios": [
        "Cálculo automático de Cluster",
        "Workflow de aprovação para Cluster Exceção",
        "Envio de e-mail para aprovador",
        "Marcação do campo após aprovação"
      ],
      "contasTeste": [
        "Mercbenz",
        "Leao",
        "FRUITTOOLS"
      ],
      "testesRelacionados": [
        "CT-120",
        "CT-121"
      ]
    },
    {
      "documento": "Roteiro de Teste - CNAE",
      "título": "Roteiro Completo de Teste de CNAE",
      "status": "Pendente",
      "ciclo": "P2",
      "data": "-",
      "cenarios": [
        "Remoção dos botões desnecessários (Descobrir Empresas, Importar, Atribuir Rótulo)",
        "Validação de duplicidade ao criar conta",
        "Preenchimento automático de Escritório e Equipe de Vendas",
        "Preenchimento de Atividade Principal baseado no CNAE"
      ],
      "testesRelacionados": [
        "CT-124",
        "CT-125"
      ]
    },
    {
      "documento": "902162",
      "título": "Separação entre Ocorrencia de Cliente e Belgo Flex",
      "status": "Pendente",
      "ciclo": "P2",
      "data": "-",
      "cenarios": [
        "Diferenciação entre tipos de Case (Ocorrencia vs Belgo Flex)",
        "Record Types de Case configurados corretamente",
        "Fluxo de criação de caso de condições flexiveis"
      ],
      "nota": "Belgo Flex usado para condições flexiveis especiais de venda"
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Integração SINTEGRA",
      "mensagem": "Mensagem de sucesso exibida no canto superior da tela"
    },
    {
      "tipo": "Sucesso",
      "contexto": "Sincronização SAP",
      "mensagem": "A conta está em sincronização com o SAP"
    },
    {
      "tipo": "Erro",
      "contexto": "Duplicidade de Termo de Pesquisa",
      "mensagem": "Encontramos um obstáculo, já existe um cliente com o mesmo termo de pesquisa"
    },
    {
      "tipo": "Erro",
      "contexto": "SINTEGRA - CNPJ Inválido",
      "mensagem": "CNPJ informado não é válido"
    },
    {
      "tipo": "Erro",
      "contexto": "SINTEGRA - CNPJ Não Encontrado",
      "mensagem": "CNPJ não encontrado na base SINTEGRA"
    },
    {
      "tipo": "Erro",
      "contexto": "Validação CPF",
      "mensagem": "CPF informado não é válido"
    },
    {
      "tipo": "Alerta",
      "contexto": "Contato Obrigatório",
      "mensagem": "E necessário informar pelo menos um contato para completar o cadastro"
    },
    {
      "tipo": "Alerta",
      "contexto": "Cadastro Incompleto",
      "mensagem": "O cadastro esta incompleto. Verifique os campos obrigatórios."
    }
  ],
  "abas_interface": [
    {
      "aba": "Detalhes",
      "descrição": "Exibe informações básicas da conta, dados do SINTEGRA (endereço, IE, CNAE)"
    },
    {
      "aba": "Relatório de Visitas",
      "descrição": "Permite criar e visualizar relatórios de visitas comerciais"
    },
    {
      "aba": "Financeiro",
      "descrição": "Exibe informações de crédito, partidas e ficha de crédito do cliente",
      "avisoVerificação": "ATENCAO: Os nomes das 4 áreas de crédito (ABBA, ADBA, Belgo Cash, Alpe) sao SUGESTOES - NAO foram mencionados na reunião. Leandro disse apenas ''4 áreas de crédito, que e o ASCP, Supplier''. Os nomes precisam ser verificados com a equipe de Crédito.",
      "áreasCrédito": [
        "Supplier (confirmado)",
        "Área 2 (a verificar)",
        "Área 3 (a verificar)",
        "Área 4 (a verificar)"
      ],
      "detalhes": {
        "fichaCrédito": "Exibe limite de crédito e partidas abertas",
        "supplier": "Mencionado por Leandro como uma das áreas"
      },
      "fonte": "Reunião 16/12/2025 - Leandro: ''as 4 áreas de crédito, que e o ASCP e basicamente aqui a gente tem a Supplier''"
    }
  ],
  "tipos_conta": [
    {
      "tipo": "Pessoa Jurídica (PJ)",
      "descrição": "Empresas com CNPJ - Business Account",
      "camposObrigatórios": [
        "CNPJ",
        "Razão Social",
        "Termo de Pesquisa",
        "CNAE"
      ],
      "recordType": "A verificar no Salesforce"
    },
    {
      "tipo": "Pessoa Física (PF)",
      "descrição": "Clientes individuais com CPF",
      "camposObrigatórios": [
        "CPF",
        "Nome",
        "Termo de Pesquisa"
      ],
      "recordType": "A verificar no Salesforce"
    },
    {
      "tipo": "Parceiro Agrupador",
      "descrição": "Grupos empresariais ou holdings",
      "camposObrigatórios": [
        "Nome",
        "Termo de Pesquisa"
      ],
      "recordType": "A verificar no Salesforce"
    }
  ],
  "detalhes": {
    "sintegra": "Integração automática para consulta de CNPJ, IE, CNAE e endereço",
    "deduplicação": "Validação automática por Termo de Pesquisa na organização Salesforce",
    "integração": "Salesforce → SAP via middleware com confirmação de sincronização",
    "notificações": "Sistema notifica automáticamente cadastros pendentes ou incompletos",
    "accountTypes": "Três tipos de conta: PJ, PF e Parceiro Agrupador (Record Type API Names a verificar)",
    "caseTypes": "Separação entre Ocorrência de Cliente e Belgo Flex (documento 902162)"
  },
  "participantes_reuniao": [
    {
      "nome": "Leandro Da Cruz",
      "papel": "Fácilitador do workshop, apresentou fluxo de cadastro"
    },
    {
      "nome": "Francine Gayer",
      "papel": "Participante, questionamentos sobre concorrentes"
    },
    {
      "nome": "Maria Luiza Gomes Chaves",
      "papel": "Participante, dúvidas sobre tabela de preços"
    },
    {
      "nome": "Bruno Machado",
      "papel": "Representante do segmento Agro"
    }
  ],
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador",
        "contribuição": "Explicou SINTEGRA, tipos de conta, canais"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      },
      {
        "nome": "Francine Gayer",
        "divisão": "Protec"
      },
      {
        "nome": "Bruno Nolasco Machado",
        "segmento": "Agro"
      },
      {
        "nome": "Maria Luiza Gomes Chaves",
        "papel": "Key User (nova)"
      }
    ],
    "feedback": {
      "autor": "Maria Luiza Gomes Chaves",
      "citação": "Primeiramente, queria agradecer. Todas essas sessoes tem sido muito didaticas. Eu entrei na Belgo ha 4 meses, entao aprendi muita coisa tambem de outros processos daqui.",
      "contexto": "Nova funcionaria expressando valor dos workshops"
    }
  },
  "discussao_reunioes": {
    "04dez2025": {
      "tipo": "Kickoff",
      "duração": "~1h51min",
      "contexto": "Alinhamento inicial do projeto GTM",
      "pontosChave": [
        "Projeto GTM (Go To Market) / CRM apresentado",
        "Transição de liderança: Dani Tamerao saiu, Audrey passou para Thalita",
        "TI ja terminou desenvolvimento, mas business não estava preparado para testar",
        "Key users (Chaves) não sabiam que eram key users"
      ],
      "problemasIdentificados": [
        "Usuários perguntando ''O que eu preciso testar?''",
        "Usuários perguntando ''O que mudou no meu processo?''",
        "Necessidade de workshops para educar sobre mudanças"
      ]
    },
    "10dez2025": {
      "tópico": "Detalhamento de Cadastro de Cliente",
      "status": "CONCLUIDO - zero duvidas pendentes",
      "citação": "A gente fez o Cadastro do Cliente, a gente passou, e fez ele automático la chama naquele botaozinho do sintegra.",
      "discussoes": [
        "Automação via SINTEGRA explicada",
        "Tipos de conta: PJ, PF, Parceiro Agrupador",
        "Canais 20, 25, 30, 40 diferenciados"
      ],
      "feedbackFrancine": "Muitas pessoas de diferentes áreas precisam se comunicar para o sistema funcionar 100%"
    },
    "16dez2025": {
      "tópico": "Recapitulação de cadastro e contexto para próximos temas",
      "citação": "Como de costume, eu sempre dou uma passada geral do que a gente ja viu, so para a gente relembrar algumas coisinhas."
    }
  },
  "citacoes_transcricoes": {
    "04dez2025_Kickoff": {
      "fonte": "2025-12-04_kickoff-workshops.txt",
      "tema": "Contextualização do Projeto GTM",
      "citacoes": [
        {
          "autor": "Vanessa",
          "timestamp": "N/A",
          "texto": "Se for um limite de crédito para a área da BBA, que é um limite interno"
        },
        {
          "autor": "Vanessa",
          "timestamp": "N/A",
          "texto": "Se for o da supplier vai para a área da CSP"
        }
      ]
    },
    "10dez2025_CadastroDetalhado": {
      "fonte": "2025-12-10_cadastro-areas.txt",
      "tema": "Detalhamento de Cadastro de Cliente",
      "citacoes": [
        {
          "autor": "Leandro Pereira",
          "timestamp": "0:45",
          "texto": "A gente fez o Cadastro do Cliente, a gente passou, e fez ele automático lá chama naquele botãozinho do sintegra."
        },
        {
          "autor": "Leandro Pereira",
          "timestamp": "1:05",
          "texto": "Tipos de conta: pessoa jurídica, pessoa física, parceiro agrupador"
        },
        {
          "autor": "Francine Gayer",
          "timestamp": "N/A",
          "texto": "Muitas pessoas de diferentes áreas precisam se comunicar para o sistema funcionar 100%"
        }
      ],
      "statusWorkshop": "CONCLUÍDO - zero dúvidas pendentes"
    },
    "03dez2025_AreaCredito": {
      "fonte": "2025-12-03_financeiro-controladoria.txt",
      "tema": "Áreas de Crédito",
      "citacoes": [
        {
          "autor": "Leandro Pereira",
          "timestamp": "8:30",
          "texto": "A BBA é a interna"
        },
        {
          "autor": "Leandro Pereira",
          "timestamp": "8:35",
          "texto": "A CSP é da supplier"
        },
        {
          "autor": "Leandro Pereira",
          "timestamp": "8:40",
          "texto": "DBA, ADBA essas coisas assim... é a da distribuição"
        },
        {
          "autor": "Leandro Pereira",
          "timestamp": "8:45",
          "texto": "ALPE, ABPE essas coisas... é o ALPE"
        }
      ],
      "areasCreditoConfirmadas": [
        "BBA - Interno",
        "CSP - Supplier/Belgo Cash",
        "DBA - Distribuição",
        "ALPE - Aços Longos PE"
      ]
    }
  }
}');

-- =============================================================================
-- Jornada 2: Áreas de Vendas
-- Fonte: data/jornadas/areas-vendas.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Áreas de Vendas",
  "icone": "🏢",
  "ordem": 2,
  "status": "Em Andamento",
  "as_is": "Processo manual onde o usuário deve definir canal de venda, escritório e equipe manualmente, consultando planilhas ou solicitando ao SmartCenter a classificação correta do cliente.",
  "passos_as_is": "Usuário identifica manualmente o tipo de cliente (indústria, revenda, consumidor final)|Consulta planilha ou solicita orientação sobre qual canal aplicar|Define canal de venda manualmente (20, 25, 30 ou 40)|Atribui escritório de vendas manualmente|Atribui equipe de vendas (antigo EV Alternativo) manualmente|Solicita ao SmartCenter validação da classificação|Aguarda confirmação ou correção|Configura dados no SAP",
  "problemas_as_is": "Erros frequentes de classificação de canal|Canais incorretos aplicados a clientes|Escritórios e equipes atribuídos incorretamente|Retrabalho frequente para correção de classificações|Dependência de conhecimento individual do vendedor|Falta de padronização nos critérios de classificação|Cluster calculado manualmente ou não calculado",
  "tempo_medio_as_is": "1 dia ou mais",
  "to_be": "Sistema automatizado de classificação de Área de Vendas. O Salesforce sugere automáticamente o canal baseado no CNAE do cliente, preenche escritório e equipe baseado no perfil do usuário, e calcula o cluster automáticamente com opção de exceção via workflow.",
  "passos_to_be": "Usuário cria conta no Salesforce e preenche CNPJ|Sistema consulta SINTEGRA e obtém CNAE do cliente|Sistema sugere canal de venda (20, 25, 30 ou 40) automáticamente baseado no CNAE [DEFINICOES DOS CANAIS AGUARDANDO RE-TRANSCRICAO]|Sistema preenche Escritório de Vendas automáticamente (conforme perfil do usuário)|Sistema preenche Equipe de Vendas automáticamente (conforme time do usuário)|Sistema calcula Cluster automáticamente baseado em regras de negócio|Usuário pode solicitar ''Cluster Exceção'' via workflow de aprovação|Usuário confirma ou ajusta classificação se necessário|Integração automática com SAP ao salvar",
  "beneficios_to_be": "Classificação de canal correta e padronizada|Eliminação de erros de classificação manual|Preenchimento automático de escritório e equipe|Cluster calculado automáticamente|Redução significativa de retrabalho|Processo padronizado para todos os vendedores|Rastreabilidade de exceções via workflow|Integração automática com SAP",
  "tempo_medio_to_be": "Imediato (automático)",
  "areas_impactadas": "Comercial|Operações|SmartCenter|TI",
  "fonte_reuniao": "10/12/2025",
  "fontes_reuniao": "10/12/2025 - Definição de canais e Área de Vendas",
  "pendencias": "Definição de critérios automáticos completos para seleção de Canal baseado em CNAE|Documentação das regras de cálculo de Cluster",
  "campos_processo": [
    {
      "campo": "Canal",
      "descrição": "Canal de venda associado ao cliente",
      "preenchimento": "Sugerido automáticamente (CNAE) / Manual",
      "validação": "CNAE",
      "valores": [
        "20",
        "25",
        "30",
        "40"
      ],
      "obrigatório": true
    },
    {
      "campo": "Escritório de Vendas",
      "descrição": "Escritório responsável pela conta",
      "preenchimento": "Automático (Perfil do usuário)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Equipe de Vendas",
      "descrição": "Time comercial responsável (antigo EV Alternativo)",
      "preenchimento": "Automático (Time do usuário)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Cluster",
      "descrição": "Classificação automática do cliente para políticas comerciais",
      "preenchimento": "Automático (Algoritmo)",
      "validação": "Regras de negócio",
      "obrigatório": false
    },
    {
      "campo": "Cluster Exceção",
      "descrição": "Campo marcado quando cluster foi alterado via workflow de aprovação",
      "preenchimento": "Via Workflow",
      "validação": "Workflow aprovação",
      "obrigatório": false
    }
  ],
  "regras_negocio": [
    {
      "regra": "Sugestão de Canal por CNAE",
      "descrição": "O sistema sugere o canal de venda baseado no CNAE do cliente obtido via SINTEGRA",
      "detalhes": {
        "industria": "CNAEs de fabricação, produção, transformação → Canal 20",
        "comércio": "CNAEs de comércio atacadista/varejista → Canal 30",
        "pessoaFisica": "Contas PF → Canal 40",
        "especial": "Casos aprovados pela diretoria → Canal 25"
      }
    },
    {
      "regra": "Preenchimento Automático de Escritório",
      "descrição": "O campo ''Escritório de Vendas'' é preenchido automáticamente baseado no escritório configurado no perfil do usuário logado"
    },
    {
      "regra": "Preenchimento Automático de Equipe",
      "descrição": "O campo ''Equipe de Vendas'' é preenchido automáticamente baseado no time configurado para o usuário logado",
      "nota": "Campo ''EV Alternativo'' foi renomeado para ''Equipe de Vendas''"
    },
    {
      "regra": "Cálculo Automático de Cluster",
      "descrição": "O sistema calcula automáticamente o Cluster do cliente baseado em regras de negócio internas",
      "documento": "862865"
    },
    {
      "regra": "Workflow para Cluster Exceção",
      "descrição": "Para casos especiais, o usuário pode solicitar alteração de cluster via workflow de aprovação",
      "fluxo": [
        "Usuário clica em ''Enviar para Aprovação''",
        "Status muda para ''Enviado''",
        "Aprovador recebe e-mail com solicitação",
        "Aprovador aprova dentro do Salesforce",
        "Sistema envia e-mail de confirmação",
        "Campo ''Cluster Exceção'' é marcado"
      ],
      "documento": "862865"
    }
  ],
  "integracoes": [
    {
      "origem": "Salesforce",
      "destino": "SINTEGRA",
      "tipo": "API",
      "descrição": "Obtém CNAE para sugerir canal de venda"
    },
    {
      "origem": "Salesforce",
      "destino": "SAP",
      "tipo": "Middleware",
      "descrição": "Sincroniza dados de área de vendas (canal, escritório, equipe)"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "862865",
      "título": "Definição Automática de Cluster",
      "status": "Pendente",
      "ciclo": "P2",
      "data": "14/10/2025",
      "cenarios": [
        "Cálculo automático de Cluster na criação de conta",
        "Workflow de aprovação para Cluster Exceção",
        "Envio de e-mail para aprovador",
        "Marcação do campo após aprovação"
      ],
      "contasTeste": [
        "Mercbenz",
        "Leao",
        "FRUITTOOLS"
      ],
      "testesRelacionados": [
        "CT-120",
        "CT-121"
      ]
    }
  ],
  "detalhes": {
    "canais": {
      "20": "Indústria",
      "25": "Casos Especiais",
      "30": "Distribuidores/Revenda",
      "40": "Consumidor Final"
    },
    "clusterAutomático": "Sistema define cluster baseado em regras de negócio",
    "workflowExceção": "Aprovação em 2 níveis para alteração de cluster",
    "preenchimentoAutomático": "Escritório e Equipe preenchidos pelo perfil do usuário"
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador",
        "contribuição": "Explicou canais 20, 25, 30, 40"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      }
    ]
  },
  "discussao_reunioes": {
    "10dez2025": {
      "apresentador": "Leandro da Cruz Pereira",
      "contexto": "Explicação dos canais de vendas e diferença entre eles",
      "citação": "eu falei sobre as áreas de vendas e a importância das áreas de vendas muito relacionado ao canal, né? Então canal 30, 20, 30 e 40 e quando eles têm que ser aplicados. Falei também sobre o canal 25",
      "canaisExplicados": {
        "avisoVerificação": "AGUARDANDO RE-TRANSCRICAO: A transcrição de 10/12/2025 tem uma LACUNA de 1h16min (timestamp 1:12 a 1:28:17). O usuário CONFIRMOU que as definições dos canais foram explicadas nas reuniões, porem esse conteudo não foi capturado na transcrição disponível.",
        "canal20": "Definição PERDIDA na lacuna da transcrição",
        "canal25": "Definição PERDIDA na lacuna da transcrição",
        "canal30": "Definição PERDIDA na lacuna da transcrição",
        "canal40": "Definição PERDIDA na lacuna da transcrição"
      },
      "lacunaTranscrição": {
        "início": "1:12",
        "fim": "1:28:17",
        "duração": "Apróximadamente 1h16min de conteudo não transcrito",
        "açãoPendente": "Usuário ira re-transcrever video MP4 completo"
      },
      "status": "AGUARDANDO RE-TRANSCRICAO para completar definições dos canais"
    }
  },
  "citacoes_transcricoes": {
    "12dez2025_Clusterizacao": {
      "fonte": "2025-12-12_regras-clusterizacao.json",
      "tema": "Definição de Clusters e Regras",
      "citacoes": [
        {
          "autor": "Maria L. Ciorlia",
          "timestamp": "0:17",
          "texto": "Visão geral do processo de clusterização, enfatizando tres dimensões principais: setor do cliente, atratividade e região"
        },
        {
          "autor": "Maria L. Ciorlia",
          "timestamp": "5:47",
          "texto": "Descrição dos quatro clusters principais: contas corporativas, contas especiais, contas regionais e contas dispersas"
        },
        {
          "autor": "Leandro Pereira",
          "timestamp": "10:36",
          "texto": "Sistema de cadastro de clientes agora inclui informações de segmentos e clusters com determinação automática"
        }
      ],
      "clustersDefinidos": {
        "corporativas": "Grandes clientes estratégicos com alto volume",
        "especiais": "Clientes com tratamento diferenciado",
        "regionais": "Clientes relevantes em regiões específicas",
        "dispersas": "Clientes de menor volume/frequência"
      },
      "dimensoesClusterizacao": [
        "Setor do cliente",
        "Atratividade (volume potencial)",
        "Região geográfica"
      ]
    },
    "10dez2025_Canais": {
      "fonte": "2025-12-10_cadastro-areas.txt",
      "tema": "Definição de Canais de Venda",
      "citacoes": [
        {
          "autor": "Leandro Pereira",
          "timestamp": "1:12",
          "texto": "Eu falei sobre as áreas de vendas e a importância das áreas de vendas muito relacionado ao canal, né? Então canal 30, 20, 30 e 40 e quando eles têm que ser aplicados. Falei também sobre o canal 25"
        },
        {
          "autor": "Leandro Pereira",
          "timestamp": "1:28",
          "texto": "O canal 25 possivelmente vai ser inativado em breve. O ideal é que vocês já façam uma revisão nos cadastros de vocês aqui nos canais que cada cliente tem que ter."
        }
      ],
      "canal25Status": "Em processo de inativação - revisar clientes atuais"
    },
    "03dez2025_ImpactoTributario": {
      "fonte": "2025-12-03_financeiro-controladoria.txt",
      "tema": "Impacto dos Canais na Tributação",
      "citacoes": [
        {
          "autor": "Leandro Pereira",
          "timestamp": "11:56",
          "texto": "Se um cliente colocou um pedido no canal 30, que tem distribuição, vai ter ICMSST. Se for canal 40, ele já não incide ICMSST."
        }
      ]
    }
  }
}');

-- =============================================================================
-- Jornada 3: Documentos Fiscais
-- Fonte: data/jornadas/documentos-fiscais.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Documentos Fiscais",
  "icone": "📄",
  "ordem": 3,
  "status": "Em Andamento",
  "as_is": "Processo manual e fragmentado de emissão de documentos fiscais onde o colaborador precisa gerar XML e DANFE manualmente no SAP, exportar arquivos, e enviar por email ao cliente. Certificados de qualidade são anexados separadamente, gerando atrasos e inconsistências.",
  "passos_as_is": "Faturamento é realizado no SAP pelo time fiscal|Colaborador acessa a transação de NF-e no SAP|Gera XML da nota fiscal manualmente|Exporta arquivo XML para pasta local|Gera DANFE (Documento Auxiliar) manualmente|Exporta DANFE em PDF|Anexa Certificado de Qualidade quando aplicável|Compõe email manualmente com todos os documentos|Envia email ao cliente com documentos anexados|Registra envio em planilha de controle",
  "problemas_as_is": "Processo lento - 30 minutos por nota em média|Erros de digitação no email do destinatário|Atrasos no envio - cliente não recebe no mesmo dia do faturamento|Dependência de pessoa específica para executar|Documentos podem ser enviados incompletos|Sem rastreabilidade de entrega|Certificados de qualidade frequentemente esquecidos|Retrabalho quando cliente solicita 2ª via|Dificuldade de auditar envios realizados|Cliente sem acesso autônomo aos documentos",
  "tempo_medio_as_is": "30 minutos por nota",
  "to_be": "Emissão e envio automático de documentos fiscais no SAP ECC. O faturamento dispara automáticamente a geração de XML e DANFE, que são enviados ao cliente por email e disponibilizados no Portal de Autoatendimento.",
  "passos_to_be": "Faturamento é realizado no SAP ECC|SAP ECC gera XML da NF-e automáticamente|SAP ECC transmite XML para SEFAZ e recebe autorização|SAP ECC gera DANFE em PDF automáticamente|Sistema identifica se há Certificado de Qualidade vinculado|Certificado é anexado automáticamente quando aplicável|Email é enviado automáticamente ao cliente com todos os documentos|Documentos são publicados no Portal de Autoatendimento|Sistema registra confirmação de envio|Cliente pode acessar 2ª via no portal a qualquer momento",
  "beneficios_to_be": "Processo instantâneo - documentos enviados segundos após faturamento|Eliminação de erros manuais|Cliente recebe documentos imediatamente|Rastreabilidade completa de todos os envios|Certificados sempre incluídos quando aplicável|Autoatendimento para 2ª via de documentos|Redução de carga operacional do time fiscal|Auditoria fácilitada com logs centralizados|Integração com Portal do Cliente|Disponibilidade 24/7 via portal",
  "tempo_medio_to_be": "Automático (segundos)",
  "areas_impactadas": "Fiscal|TI|Comercial|Atendimento|Logística",
  "sistemas_tecnicos": "SAP ECC|Salesforce|Portal Cliente|SEFAZ",
  "fonte_reuniao": "16/12/2025 + Caderno de Testes",
  "fontes_reuniao": "16/12/2025 - Sistema SAP ECC, XML automático, Certificados (mencionado na reunião)|Caderno de Testes CT-20 a CT-55 - Casos tributarios detalhados",
  "pendencias": "Configuração do template de email para envio automático|Integração completa com Portal de Autoatendimento|Definição de regras para certificados de qualidade por produto",
  "prerequisitos": "Sistema SAP ECC configurado e operacional|Integração SAP-SAP ECC testada|Emails de clientes cadastrados corretamente|Portal de Autoatendimento disponível",
  "campos_processo": [
    {
      "campo": "Número NF-e",
      "descrição": "Número da nota fiscal eletrônica",
      "preenchimento": "Automático (SAP)",
      "validação": "Sequencial",
      "obrigatório": true
    },
    {
      "campo": "Chave de Acesso",
      "descrição": "Chave de 44 dígitos da NF-e",
      "preenchimento": "Automático (SEFAZ)",
      "validação": "SEFAZ",
      "obrigatório": true
    },
    {
      "campo": "Email Destinatário",
      "descrição": "Email do cliente para envio dos documentos",
      "preenchimento": "Cadastro do Cliente",
      "validação": "Formato email",
      "obrigatório": true
    },
    {
      "campo": "Data Emissão",
      "descrição": "Data de emissão da nota fiscal",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Status Envio",
      "descrição": "Status do envio do documento ao cliente",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true
    }
  ],
  "regras_negocio": [
    {
      "regra": "Trigger de Faturamento",
      "descrição": "O faturamento no SAP dispara automáticamente o processo de geração de documentos no SAP ECC",
      "acionamento": "Evento de faturamento no SAP",
      "sla": "Documentos gerados em ate 5 minutos apos faturamento",
      "retryPolicy": "3 tentativas com intervalo de 1, 5 e 15 minutos",
      "alertaFalha": "Email para equipe Fiscal se falhar apos 3 tentativas"
    },
    {
      "regra": "Geração Automática de XML",
      "descrição": "O SAP ECC gera automáticamente o XML da NF-e conforme padrão SEFAZ e transmite para autorização"
    },
    {
      "regra": "Geração Automática de DANFE",
      "descrição": "Após autorização da NF-e, o DANFE é gerado automáticamente em formato PDF"
    },
    {
      "regra": "Vinculação de Certificado de Qualidade",
      "descrição": "Para produtos que exigem certificado de qualidade, o sistema identifica automáticamente e anexa o certificado correspondente",
      "critério": "Campo ''Requer_Certificado__c'' = true no cadastro do material no SAP",
      "açãoSeFaltaCertificado": "Alerta ao time Fiscal, documento enviado sem certificado com flag de pendência"
    },
    {
      "regra": "Envio Automático por Email",
      "descrição": "Documentos são enviados automáticamente para o email cadastrado do cliente"
    },
    {
      "regra": "Publicação no Portal",
      "descrição": "Todos os documentos ficam disponíveis no Portal de Autoatendimento para acesso do cliente"
    },
    {
      "regra": "Rastreabilidade de Envio",
      "descrição": "Sistema registra data/hora de envio, confirmação de entrega e eventuais erros"
    },
    {
      "regra": "Tratamento de Rejeição SEFAZ",
      "descrição": "Se SEFAZ rejeitar NF-e, sistema registra código de erro e notifica Fiscal",
      "ações": [
        "Registrar código e motivo de rejeição",
        "Notificar equipe Fiscal por email",
        "Marcar documento como ''Pendente Correção''",
        "Não enviar ao cliente ate autorização"
      ]
    }
  ],
  "integracoes": [
    {
      "origem": "SAP ECC",
      "destino": "SEFAZ",
      "tipo": "API",
      "descrição": "Transmissão de NF-e para autorização (modulo fiscal SAP)"
    },
    {
      "origem": "SAP ECC",
      "destino": "Email",
      "tipo": "SMTP",
      "descrição": "Envio automático de documentos por email apos autorização"
    },
    {
      "origem": "SAP ECC",
      "destino": "Portal Cliente",
      "tipo": "API/Middleware",
      "descrição": "Publicação de documentos no portal de autoatendimento"
    },
    {
      "origem": "Salesforce",
      "destino": "Portal Cliente",
      "tipo": "Integração",
      "descrição": "Vinculação de documentos ao registro do cliente no CRM"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "Caderno de Testes - Tributario",
      "título": "Testes Tributarios - Determinação de Impostos",
      "status": "Pendente",
      "data": "2026-01-12",
      "descrição": "36 casos de teste cobrindo determinação automática de impostos, códigos fiscais e calculos",
      "estatisticas": {
        "total": 36,
        "concluidos": 0,
        "pendentes": 36,
        "falhou": 0,
        "percentualConclusao": "0%"
      },
      "cenarios": [
        "Material importado - II (CT-20)",
        "Isenção Zona Franca - ZFM (CT-21)",
        "Isenção categoria fiscal (CT-22)",
        "Código I3 - Canal 20 Industria (CT-23)",
        "Código I3 - Canal 30 Distribuidores (CT-24)",
        "Código C3 - Consumidor Final (CT-25)",
        "Código C4 - Substituição Tributaria (CT-26)",
        "Validar calculo IPI na NF (CT-27)",
        "ICMS ST canal 30 - intraestadual (CT-28)",
        "Cliente isento ICMS (CT-29)",
        "DIFAL interestadual (CT-30)",
        "FCP - Fundo Combate Pobreza (CT-31)",
        "CFOP 5101 mesmo estado (CT-32)",
        "CFOP 6101 interestadual (CT-33)",
        "Diferimento ICMS MG (CT-34)",
        "NCM com exceção IPI (CT-35)",
        "Calculo completo impostos (CT-36-55)"
      ],
      "testesRelacionados": [
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
        46,
        47,
        48,
        49,
        50,
        51,
        52,
        53,
        54,
        55
      ],
      "códigosImposto": [
        {
          "código": "I0",
          "descrição": "Isento de impostos"
        },
        {
          "código": "I3",
          "descrição": "Industria - ICMS + IPI + PIS + COFINS"
        },
        {
          "código": "C3",
          "descrição": "Consumidor Final sem ST"
        },
        {
          "código": "C4",
          "descrição": "Consumidor Final com Substituição Tributaria"
        }
      ]
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Envio de Documentos",
      "mensagem": "Documentos fiscais enviados com sucesso para o cliente"
    },
    {
      "tipo": "Erro",
      "contexto": "Email Inválido",
      "mensagem": "Não foi possível enviar documentos - email do cliente inválido ou não cadastrado"
    },
    {
      "tipo": "Erro",
      "contexto": "Falha SEFAZ",
      "mensagem": "Falha na comunicação com SEFAZ - NF-e não autorizada"
    },
    {
      "tipo": "Alerta",
      "contexto": "Certificado Pendente",
      "mensagem": "Produto requer certificado de qualidade que não está vinculado"
    }
  ],
  "detalhes": {
    "trigger": "SAP dispara processo no SAP ECC após faturamento",
    "documentos": [
      "XML da NF-e",
      "DANFE",
      "Certificado de Qualidade"
    ],
    "envio": "Email automático + Portal de Autoatendimento",
    "rastreabilidade": "Logs de envio e confirmação de entrega"
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador",
        "contribuição": "Explicou fluxo de documentos fiscais"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      }
    ]
  },
  "discussao_reunioes": {
    "16dez2025": {
      "apresentador": "Leandro da Cruz Pereira",
      "contexto": "Explicação do fluxo automático de documentos fiscais",
      "citaçãoOriginal": "Falando sobre os documentos fiscais, que basicamente aqui ele tem aquele processo automatizado la de araujo, quando faz faturamento de emissao de XML, Daniel, certificado de produtos se tiver tambem para o cliente de forma automática dentro do Spa",
      "sistemasMencionados": {
        "daniel": {
          "nome": "Daniel",
          "descrição": "Sistema mencionado para certificados de qualidade",
          "nota": "Nome exato mencionado na reunião - sistema de certificados"
        },
        "spa": {
          "nome": "Spa",
          "descrição": "Plataforma mencionada para entrega de documentos ao cliente",
          "nota": "Nome exato mencionado na reunião - plataforma de entrega"
        }
      },
      "fluxoExplicado": "Faturamento -> SAP ECC gera XML -> Daniel gera certificado (se aplicavel) -> Enviado via Spa",
      "pontosChave": [
        "Processo e automático apos faturamento",
        "Certificado de qualidade vinculado automáticamente quando aplicavel",
        "Cliente recebe documentos automáticamente na plataforma Spa"
      ]
    }
  },
  "citacoes_transcricoes": {
    "16dez2025_DocsAutoatendimento": {
      "fonte": "2025-12-16_docs-fiscais-autoatendimento.txt",
      "tema": "Fluxo de Documentos Fiscais e Autoatendimento",
      "citacoes": [
        {
          "autor": "Leandro Pereira",
          "timestamp": "N/A",
          "texto": "Falando sobre os documentos fiscais, que basicamente aqui ele tem aquele processo automatizado lá de Araujo, quando faz faturamento de emissão de XML, Danfe, certificado de produtos se tiver também para o cliente de forma automática dentro do Spa"
        },
        {
          "autor": "Leandro Pereira",
          "timestamp": "N/A",
          "texto": "E hoje a gente vai falar sobre autoatendimento também e o autoatendimento. Vocês vão ver a importância desse dado preenchido corretamente."
        }
      ],
      "sistemasIdentificados": {
        "araujo": "Sistema de automação de documentos fiscais (XML, NF-e, certificados)",
        "spa": "Plataforma de entrega de documentos ao cliente"
      }
    },
    "03dez2025_ImpactoCanais": {
      "fonte": "2025-12-03_financeiro-controladoria.txt",
      "tema": "Impacto dos Canais na Tributação",
      "citacoes": [
        {
          "autor": "Leandro Pereira",
          "timestamp": "11:56",
          "texto": "Se um cliente colocou um pedido no canal 30, que tem distribuição, vai ter ICMSST. Se for canal 40, ele já não incide ICMSST."
        }
      ],
      "regrasTributarias": {
        "canal30": "Distribuição - incide ICMS-ST",
        "canal40": "Consumo - não incide ICMS-ST"
      }
    }
  }
}');

-- =============================================================================
-- Jornada 4: Gestão de Contatos
-- Fonte: data/jornadas/contatos.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Gestão de Contatos",
  "icone": "📞",
  "ordem": 4,
  "status": "Pendente",
  "as_is": "Cadastro manual e fragmentado de contatos onde o vendedor coleta dados de clientes por diversos canais e digita manualmente no sistema, sem validação de duplicados ou formato, resultando em dados incompletos e desatualizados que impactam outras áreas.",
  "passos_as_is": "Vendedor coleta dados de contato do cliente (telefone, email, nome)|Anota informações em papel ou planilha pessoal|Acessa Salesforce e navega até a conta do cliente|Digita dados de contato manualmente|Não há validação de formato de telefone ou email|Não há verificação de contatos duplicados|Contato é salvo mesmo com dados incompletos|Informações ficam desatualizadas ao longo do tempo|Diferentes vendedores cadastram o mesmo contato múltiplas vezes",
  "problemas_as_is": "Dados de contato incompletos (falta email ou telefone)|Contatos duplicados na base de dados|Informações desatualizadas (emails inválidos, telefones antigos)|Formato de telefone inconsistente (com/sem DDD, hífen, etc.)|Emails com erros de digitação|Sem histórico de interações com o contato|Impacto negativo no Autoatendimento - cliente não consegue acessar|Dificuldade de comunicação por email marketing|Sem validação de CPF/CNPJ do contato|Contatos órfãos - sem vínculo correto com a conta",
  "tempo_medio_as_is": "15 minutos",
  "to_be": "Gestão inteligente de contatos com auto-preenchimento, validação automática de formato, deduplicação por matching de email/telefone/nome, e histórico completo de interações. Dados de qualidade habilitam o funcionamento correto do Autoatendimento.",
  "passos_to_be": "Vendedor acessa a conta do cliente no Salesforce|Clica em ''Novo Contato'' ou sistema sugere contatos existentes|Sistema verifica se já existe contato com email/telefone similar|Se duplicado: exibe contato existente para vinculação|Se novo: vendedor preenche dados básicos|Sistema valida formato de email automáticamente|Sistema padroniza formato de telefone (com DDD)|Sistema valida CPF/CNPJ quando informado|Contato é salvo com dados completos e validados|Histórico de interações é mantido automáticamente",
  "beneficios_to_be": "Dados de contato sempre completos e validados|Eliminação de contatos duplicados|Formato padronizado de telefone e email|Histórico completo de interações com o contato|Habilitação correta do Autoatendimento|Comunicações por email chegam corretamente|Fácilita campanhas de marketing|Contatos sempre atualizados|Vinculação correta com contas|Redução de retrabalho de cadastro",
  "tempo_medio_to_be": "2 minutos",
  "areas_impactadas": "Comercial|Marketing|Atendimento|TI",
  "sistemas_tecnicos": "Salesforce",
  "fonte_reuniao": "16/12/2025",
  "fontes_reuniao": "16/12/2025 - Discussão sobre qualidade de dados de contato|10/12/2025 - Menção à criticidade para Autoatendimento",
  "pendencias": "Padronização de celulares e bases de contatos (documento 901674)|Definição de regras de matching para deduplicação|Validação de formato de telefone celular|Integração com ferramenta de email marketing",
  "prerequisitos": "Regras de validação configuradas no Salesforce|Processo de limpeza de base de contatos existente",
  "campos_processo": [
    {
      "campo": "Nome Completo",
      "descrição": "Nome completo do contato",
      "preenchimento": "Manual",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Email",
      "descrição": "Endereço de email do contato",
      "preenchimento": "Manual",
      "validação": "Formato de email",
      "obrigatório": true
    },
    {
      "campo": "Telefone",
      "descrição": "Telefone principal com DDD",
      "preenchimento": "Manual",
      "validação": "Formato padronizado",
      "obrigatório": true
    },
    {
      "campo": "Celular",
      "descrição": "Telefone celular com DDD",
      "preenchimento": "Manual",
      "validação": "Formato padronizado",
      "obrigatório": false
    },
    {
      "campo": "CPF/CNPJ",
      "descrição": "Documento de identificação do contato",
      "preenchimento": "Manual",
      "validação": "Algoritmo de validação",
      "obrigatório": false
    },
    {
      "campo": "Cargo",
      "descrição": "Cargo ou função do contato na empresa",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Conta Vinculada",
      "descrição": "Conta (cliente) à qual o contato está vinculado",
      "preenchimento": "Seleção",
      "validação": "Obrigatório",
      "obrigatório": true
    }
  ],
  "regras_negocio": [
    {
      "regra": "Validação de Formato de Email",
      "descrição": "O sistema valida automáticamente se o email informado está em formato válido (usuário@dominio.com)",
      "mensagemErro": "Email informado não é válido"
    },
    {
      "regra": "Padronização de Telefone",
      "descrição": "O sistema padroniza automáticamente o formato do telefone para (XX) XXXXX-XXXX, incluindo DDD",
      "documento": "901674"
    },
    {
      "regra": "Deduplicação por Email",
      "descrição": "O sistema verifica se já existe um contato com o mesmo email antes de permitir o cadastro"
    },
    {
      "regra": "Deduplicação por Telefone",
      "descrição": "O sistema verifica se já existe um contato com o mesmo telefone antes de permitir o cadastro"
    },
    {
      "regra": "Matching por Nome",
      "descrição": "O sistema sugere contatos similares quando detecta nomes parecidos na mesma conta"
    },
    {
      "regra": "Validação de CPF",
      "descrição": "Quando informado, o CPF é validado usando algoritmo padrão da Receita Federal"
    },
    {
      "regra": "Contato Obrigatório para Autoatendimento",
      "descrição": "Para habilitar o Autoatendimento do cliente, é necessário ter pelo menos um contato com email válido cadastrado",
      "criticidade": "Alta"
    }
  ],
  "integracoes": [
    {
      "origem": "Salesforce",
      "destino": "Email Marketing",
      "tipo": "API",
      "descrição": "Sincronização de contatos para campanhas de marketing"
    },
    {
      "origem": "Salesforce",
      "destino": "Portal Autoatendimento",
      "tipo": "Autenticação",
      "descrição": "Contato com email válido pode acessar o portal de autoatendimento"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "901674",
      "título": "Padronização de Bases de Contatos (Celulares)",
      "status": "Pendente",
      "data": "2025-12",
      "descrição": "Testes de padronização de formato de telefone celular",
      "cenarios": [
        "Validação de formato de celular com DDD",
        "Padronização automática de números existentes",
        "Bloqueio de formatos inválidos"
      ]
    },
    {
      "documento": "881196",
      "título": "Notificação de Cadastro Pendente",
      "status": "Pendente",
      "data": "17-24/10/2025",
      "descrição": "Sistema notifica sobre contatos com cadastro incompleto",
      "cenarios": [
        "Identificação de contatos incompletos",
        "Envio de notificação automática",
        "Verificar destinatarios da notificação"
      ]
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Erro",
      "contexto": "Email Inválido",
      "mensagem": "O email informado não é válido. Verifique o formato."
    },
    {
      "tipo": "Erro",
      "contexto": "Contato Duplicado",
      "mensagem": "Já existe um contato com este email/telefone cadastrado."
    },
    {
      "tipo": "Erro",
      "contexto": "CPF Inválido",
      "mensagem": "CPF informado não é válido."
    },
    {
      "tipo": "Alerta",
      "contexto": "Contato Obrigatório",
      "mensagem": "É necessário informar pelo menos um contato para completar o cadastro."
    }
  ],
  "detalhes": {
    "criticidade": "PRÉ-REQUISITO para Autoatendimento",
    "validações": [
      "Formato de email",
      "Formato de telefone",
      "CPF/CNPJ"
    ],
    "deduplicação": "Matching por email, telefone e nome",
    "padronização": "Telefone padronizado para (XX) XXXXX-XXXX"
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador",
        "contribuição": "Enfatizou criticidade dos dados de contato"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      }
    ]
  },
  "discussao_reunioes": {
    "16dez2025": {
      "apresentador": "Leandro da Cruz Pereira",
      "timestamp": "1:18",
      "contexto": "Discussão sobre importancia da qualidade dos dados de contato para o autoatendimento",
      "citaçãoCompleta": "A gente falou da parte de Contatos e a importancia de ter o dado bem certinho, justamente para voces, para que outras áreas utilizem. E hoje a gente vai falar sobre autoatendimento tambem e o autoatendimento. Voces vao ver a importancia desse dado preenchido corretamente.",
      "pontosChave": [
        "Dados de contato corretos sao fundamentais para outras áreas",
        "Dado bem preenchido e critico para autoatendimento"
      ],
      "nota": "Esta citação e da reunião 16/12, onde Leandro recapitulou os temas anteriores"
    }
  }
}');

-- =============================================================================
-- Jornada 5: Portal Logístico
-- Fonte: data/jornadas/logistica.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Portal Logístico",
  "icone": "🚚",
  "ordem": 5,
  "status": "Pendente",
  "as_is": "Portal logístico opera de forma separada do SAP, exigindo que operadores digitem dados em ambos os sistemas. Informações de rastreamento, status de entrega e dados de transporte sao gerênciados em sistemas paralelos sem sincronização automática.",
  "passos_as_is": "Operador recebe informação de despacho do SAP|Acessa o Portal Logístico separadamente|Digita manualmente dados da entrega no portal|Transportadora atualiza status no portal|Operador confere dados entre portal e SAP|Replica informações manualmente para SAP quando necessário|Cliente liga para vendedor para saber status|Vendedor consulta portal e retorna informação",
  "problemas_as_is": "Redundancia de dados entre sistemas|Inconsistencias entre Portal Logístico e SAP|Retrabalho constante para manter sistemas sincronizados|Cliente sem visibilidade autonoma do status de entrega|Erros de digitação ao replicar informações|Atraso na atualização de status|Dependência de operador para consultas basicas|Dificuldade de rastreabilidade end-to-end",
  "tempo_medio_as_is": "Variavel (depende da complexidade)",
  "to_be": "Integração completa entre Portal Logístico e SAP com sincronização automática bidirecional. Status de entrega atualizado em tempo real e visível tanto para operadores quanto para clientes atraves do Portal de Autoatendimento.",
  "passos_to_be": "Pedido faturado no SAP gera registro automático no Portal Logístico|Dados de transporte sincronizados automáticamente|Transportadora atualiza status no portal|Status refletido automáticamente no SAP|Cliente consulta status pelo Portal de Autoatendimento|Notificações automáticas de eventos relevantes|Histórico completo de movimentação disponível|Comprovante de entrega digitalizado e vinculado",
  "beneficios_to_be": "Eliminação de redundancia de dados|Dados consistentes entre todos os sistemas|Processo otimizado sem retrabalho|Cliente com visibilidade autonoma 24/7|Rastreabilidade completa da entrega|Redução de chamados ao vendedor|Notificações proativas de eventos|Histórico auditavel de entregas",
  "tempo_medio_to_be": "Automático (segundos)",
  "areas_impactadas": "Logística|TI|Comercial|Atendimento",
  "sistemas_tecnicos": "Portal Logístico|SAP ECC|Salesforce|Portal de Autoatendimento",
  "fonte_reuniao": "16/12/2025",
  "fontes_reuniao": "16/12/2025 - Menção a integração com Portal Logístico|10/12/2025 - Discussão sobre redundancia de dados",
  "pendencias": "Definição da integração bidirecional SAP-Portal Logístico|Mapeamento de status entre sistemas|Definição de regras de notificação automática|Integração com principais transportadoras",
  "prerequisitos": "API do Portal Logístico disponível e documentada|Middleware SAP configurado para comunicação|Portal de Autoatendimento operacional",
  "campos_processo": [
    {
      "campo": "Número do Pedido",
      "descrição": "Número do pedido de venda no SAP",
      "preenchimento": "Automático (SAP)",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Número NF-e",
      "descrição": "Número da nota fiscal de saida",
      "preenchimento": "Automático (SAP)",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Transportadora",
      "descrição": "Empresa responsável pelo transporte",
      "preenchimento": "Automático (SAP)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Status Entrega",
      "descrição": "Status atual da entrega",
      "preenchimento": "Automático (Portal)",
      "validação": "-",
      "obrigatório": true,
      "valores": [
        "Aguardando Coleta",
        "Em Transito",
        "Saiu para Entrega",
        "Entregue",
        "Tentativa de Entrega",
        "Devolvido"
      ]
    },
    {
      "campo": "Data Previsão",
      "descrição": "Data prevista para entrega",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Data Entrega Efetiva",
      "descrição": "Data real da entrega",
      "preenchimento": "Automático (Portal)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Código Rastreamento",
      "descrição": "Código para rastreamento na transportadora",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Comprovante Entrega",
      "descrição": "Documento de comprovação da entrega",
      "preenchimento": "Upload (Transportadora)",
      "validação": "-",
      "obrigatório": false
    }
  ],
  "regras_negocio": [
    {
      "regra": "Sincronização Automática SAP-Portal",
      "descrição": "Ao criar remessa no SAP, os dados sao enviados automáticamente para o Portal Logístico"
    },
    {
      "regra": "Atualização de Status em Tempo Real",
      "descrição": "Quando a transportadora atualiza o status no portal, a informação e refletida automáticamente no SAP e no Portal de Autoatendimento"
    },
    {
      "regra": "Notificação de Eventos",
      "descrição": "Cliente recebe notificação automática quando pedido sai para entrega e quando e entregue"
    },
    {
      "regra": "Vinculação de Comprovante",
      "descrição": "O comprovante de entrega digitalizado e vinculado automáticamente ao pedido e disponibilizado no Portal de Autoatendimento"
    },
    {
      "regra": "Calculo de SLA",
      "descrição": "Sistema calcula automáticamente o cumprimento do prazo de entrega comparando data prevista com data efetiva"
    }
  ],
  "integracoes": [
    {
      "origem": "SAP",
      "destino": "Portal Logístico",
      "tipo": "API",
      "descrição": "Envio de dados de remessa e transporte"
    },
    {
      "origem": "Portal Logístico",
      "destino": "SAP",
      "tipo": "API",
      "descrição": "Retorno de status de entrega e comprovantes"
    },
    {
      "origem": "Portal Logístico",
      "destino": "Portal Autoatendimento",
      "tipo": "API",
      "descrição": "Disponibilização de status para consulta do cliente"
    },
    {
      "origem": "Transportadora",
      "destino": "Portal Logístico",
      "tipo": "EDI/API",
      "descrição": "Atualização de status de rastreamento"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "Pendente",
      "título": "Testes de Integração Portal Logístico",
      "status": "A Definir",
      "data": "-",
      "descrição": "Testes de integração entre SAP e Portal Logístico ainda não definidos",
      "cenarios": [
        "Sincronização automática de remessa SAP -> Portal",
        "Atualização de status pelo transportador",
        "Notificação automática ao cliente",
        "Vinculação de comprovante de entrega",
        "Rastreamento em tempo real"
      ],
      "nota": "Casos de teste serao definidos apos específicação tecnica da integração"
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Entrega Confirmada",
      "mensagem": "Entrega realizada com sucesso"
    },
    {
      "tipo": "Alerta",
      "contexto": "Tentativa de Entrega",
      "mensagem": "Houve uma tentativa de entrega. Verificar endereco ou contato."
    },
    {
      "tipo": "Erro",
      "contexto": "Sincronização Falhou",
      "mensagem": "Falha na sincronização com Portal Logístico. Tente novamente."
    },
    {
      "tipo": "Info",
      "contexto": "Em Transito",
      "mensagem": "Seu pedido esta em transito. Previsão de entrega: {data}"
    }
  ],
  "detalhes": {
    "integração": "Sincronização bidirecional SAP <-> Portal Logístico",
    "rastreamento": "Código de rastreamento disponível para cliente",
    "comprovantes": "Digitalização e vinculação automática",
    "visibilidade": "Status em tempo real via Portal de Autoatendimento"
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador",
        "contribuição": "Identificou pendência de integração"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      }
    ]
  },
  "discussao_reunioes": {
    "16dez2025": {
      "apresentador": "Leandro da Cruz Pereira",
      "timestamp": "1:33",
      "contexto": "Recapitulação dos temas discutidos e identificação de pendência critica",
      "citação": "A gente falou sobre a parte de logística, ai ficou uma pendência depois para a gente fazer uma próxima reunião aqui e verificar la aquela integração com o portal logístico, uma vez que a gente ja integra com o SAP, tem que verificar essa questao do portal Logística, integrar com o SAP tambem para evitar e redundancia dos dados.",
      "problemasIdentificados": [
        "Portal Logístico opera separado do SAP",
        "Integração atual com SAP ja existe",
        "Portal Logístico NAO integrado ainda",
        "Risco de redundancia de dados entre os dois sistemas"
      ],
      "açãoDefinida": "Agendar próxima reunião para verificar integração com portal logístico",
      "statusAção": "Pendente"
    }
  }
}');

-- =============================================================================
-- Jornada 6: Financeiro/Crédito
-- Fonte: data/jornadas/financeiro.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Financeiro/Crédito",
  "icone": "💰",
  "ordem": 6,
  "status": "Em Andamento",
  "as_is": "Processo de análise de crédito manual e fragmentado onde o analista consulta diversas fontes de informação, preenche ficha de crédito em Excel ou papel, e envia por email para aprovação. Sem visibilidade do status e sem integração com sistemas de bureau de crédito.",
  "passos_as_is": "Vendedor solicita análise de crédito para novo cliente ou aumento de limite|Analista recebe solicitação por email ou telefone|Consulta manualmente bureaus de crédito (Serasa, SPC)|Verifica histórico de pagamentos no SAP|Preenche ficha de crédito em Excel com dados coletados|Calcula limite de crédito manualmente baseado em politica interna|Envia ficha para aprovação do gestor por email|Aguarda retorno do gestor (pode levar dias)|Se aprovado, configura limite no SAP manualmente|Comunica vendedor sobre resultado por email",
  "problemas_as_is": "Processo lento - 2 a 3 dias para conclusao|Sem visibilidade do status da análise|Consultas manuais a bureaus de crédito|Ficha de crédito em formato não padronizado|Risco de erros no calculo do limite|Aprovações dispersas por email sem rastreabilidade|Histórico de crédito fragmentado|Dificuldade de auditoria|Sem alertas de vencimento ou reavaliação|Dependência de conhecimento individual do analista",
  "tempo_medio_as_is": "2-3 dias",
  "to_be": "Gestão de crédito integrada com FSCM (Financial Supply Chain Management) do SAP. Análise automatizada com consulta a bureaus de crédito, calculo automático de limite baseado em scoring, workflow de aprovação digital em 3 niveis, e ficha de crédito centralizada no Salesforce.",
  "passos_to_be": "Vendedor acessa conta do cliente no Salesforce|Clica em ''Solicitar Análise de Crédito''|Sistema consulta automáticamente bureaus de crédito|Sistema recupera histórico de pagamentos do SAP via FSCM|Scoring de crédito calculado automáticamente|Limite sugerido baseado em regras de negócio|Ficha de crédito gerada automáticamente no Salesforce|Workflow de aprovação acionado conforme alcada|Nível 1: Analista de Crédito|Nível 2: Gestor de Crédito|Nível 3: Diretoria (para limites acima do teto)|Aprovador recebe notificação e aprova no Salesforce|Limite sincronizado automáticamente com SAP|Vendedor notificado do resultado",
  "beneficios_to_be": "Análise em tempo real (horas ao inves de dias)|Visibilidade total do status da solicitação|Consulta automática a bureaus de crédito|Scoring padronizado e auditavel|Workflow de aprovação rastreavel|Ficha de crédito centralizada|Histórico completo de análises|Auditoria fácilitada|Alertas automáticos de reavaliação|Processo auditavel e em conformidade",
  "tempo_medio_to_be": "Horas",
  "areas_impactadas": "Financeiro|Comercial|Crédito|TI",
  "sistemas_tecnicos": "Salesforce|SAP FSCM|SAP ECC|Bureaus de Crédito (Serasa, SPC)",
  "fonte_reuniao": "16/12/2025 + Caderno de Testes",
  "fontes_reuniao": "16/12/2025 - Menção a ficha de crédito e áreas de crédito|Caderno de Testes - CT-64 a CT-68, CT-78 a CT-80",
  "pendencias": "Integração com bureaus de crédito (Serasa, SPC)|Definição de alcadas de aprovação por valor|Configuração de regras de scoring no FSCM|Template de ficha de crédito no Salesforce",
  "prerequisitos": "SAP FSCM configurado e operacional|Contrato com bureaus de crédito para consulta via API|Workflow de aprovação configurado no Salesforce|Perfis de aprovadores definidos",
  "campos_processo": [
    {
      "campo": "Cliente",
      "descrição": "Conta do cliente no Salesforce",
      "preenchimento": "Automático",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "CNPJ/CPF",
      "descrição": "Documento do cliente",
      "preenchimento": "Automático (Conta)",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Área de Crédito",
      "descrição": "Área responsável pela análise",
      "preenchimento": "Automático/Manual",
      "validação": "ABBA, ADBA, Belgo Cash, ALPE",
      "obrigatório": true
    },
    {
      "campo": "Limite Solicitado",
      "descrição": "Valor do limite de crédito solicitado",
      "preenchimento": "Manual",
      "validação": "Numerico positivo",
      "obrigatório": true
    },
    {
      "campo": "Limite Atual",
      "descrição": "Limite de crédito vigente do cliente",
      "preenchimento": "Automático (SAP)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Limite Sugerido",
      "descrição": "Limite calculado pelo sistema baseado em scoring",
      "preenchimento": "Automático (FSCM)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Score de Crédito",
      "descrição": "Pontuação de risco do cliente",
      "preenchimento": "Automático (Bureau)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Partidas Abertas",
      "descrição": "Valor total de partidas em aberto do cliente",
      "preenchimento": "Automático (SAP)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Dias em Atraso",
      "descrição": "Maior quantidade de dias em atraso do cliente",
      "preenchimento": "Automático (SAP)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Status Análise",
      "descrição": "Status atual da solicitação de crédito",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true,
      "valores": [
        "Pendente",
        "Em Análise",
        "Aguardando Aprovação",
        "Aprovado",
        "Reprovado"
      ]
    },
    {
      "campo": "Justificativa",
      "descrição": "Motivo da solicitação ou observações",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": false
    }
  ],
  "regras_negocio": [
    {
      "regra": "Consulta Automática a Bureaus",
      "descrição": "O sistema consulta automáticamente Serasa e SPC para obter score de crédito e pendências financeiras"
    },
    {
      "regra": "Calculo Automático de Limite via FSCM",
      "descrição": "O SAP FSCM calcula o limite sugerido baseado em faturamento, histórico de pagamentos e score de crédito"
    },
    {
      "regra": "Workflow de Aprovação em 3 Niveis",
      "descrição": "Aprovação segue hierarquia: Analista -> Gestor -> Diretoria, conforme valor do limite solicitado",
      "alcadas": {
        "nível1": {
          "aprovador": "Analista de Crédito",
          "limiteAte": 50000
        },
        "nível2": {
          "aprovador": "Gestor de Crédito",
          "limiteAte": 200000
        },
        "nível3": {
          "aprovador": "Diretoria",
          "limiteAcima": 200000
        }
      }
    },
    {
      "regra": "Sincronização de Limite com SAP",
      "descrição": "Apos aprovação, o limite e sincronizado automáticamente com o SAP"
    },
    {
      "regra": "Reavaliação Periodica",
      "descrição": "Sistema gera alerta automático para reavaliação de limite a cada 12 meses"
    },
    {
      "regra": "Bloqueio por Inadimplencia",
      "descrição": "Cliente com mais de 30 dias de atraso tem limite bloqueado automáticamente"
    }
  ],
  "integracoes": [
    {
      "origem": "Salesforce",
      "destino": "SAP FSCM",
      "tipo": "API",
      "descrição": "Consulta de limite atual, partidas abertas e histórico de pagamentos"
    },
    {
      "origem": "Salesforce",
      "destino": "Bureaus de Crédito",
      "tipo": "API",
      "descrição": "Consulta de score e pendências financeiras"
    },
    {
      "origem": "Salesforce",
      "destino": "SAP ECC",
      "tipo": "Middleware",
      "descrição": "Atualização de limite de crédito apos aprovação"
    },
    {
      "origem": "SAP FSCM",
      "destino": "Salesforce",
      "tipo": "API",
      "descrição": "Retorno de calculo de limite sugerido"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "Caderno de Testes - Financeiro",
      "título": "Financeiro e Crédito - Validações",
      "status": "Pendente",
      "data": "2026-01-12",
      "descrição": "3 casos de teste para validação de regras de crédito",
      "estatisticas": {
        "total": 3,
        "concluidos": 0,
        "pendentes": 3,
        "falhou": 0,
        "percentualConclusao": "0%"
      },
      "cenarios": [
        "Bloqueio automático OV sem crédito (CT-78)",
        "Mensagem alerta crédito na cotação (CT-79)",
        "Consulta OV criada e dados (CT-80)"
      ],
      "testesRelacionados": [
        78,
        79,
        80
      ]
    },
    {
      "documento": "Caderno de Testes - Setup Crédito",
      "título": "Setup - Configuração de Crédito",
      "status": "Pendente",
      "data": "2026-01-12",
      "descrição": "Casos de teste de setup relacionados a crédito (CT-64 a CT-68)",
      "estatisticas": {
        "total": 5,
        "concluidos": 0,
        "pendentes": 5,
        "falhou": 0,
        "percentualConclusao": "0%"
      },
      "cenarios": [
        "Cadastro limite crédito FSCM (CT-64)",
        "Cliente com crédito bloqueado (CT-65)",
        "Cliente com crédito liberado (CT-66)",
        "Condições de pagamento (CT-67)",
        "Listagem materiais/clientes (CT-68)"
      ],
      "testesRelacionados": [
        64,
        65,
        66,
        67,
        68
      ]
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Crédito Aprovado",
      "mensagem": "Limite de crédito aprovado e sincronizado com SAP"
    },
    {
      "tipo": "Alerta",
      "contexto": "Score Baixo",
      "mensagem": "Score de crédito abaixo do mínimo. Análise manual necessaria."
    },
    {
      "tipo": "Erro",
      "contexto": "Consulta Bureau Falhou",
      "mensagem": "Não foi possível consultar o bureau de crédito. Tente novamente."
    },
    {
      "tipo": "Erro",
      "contexto": "Crédito Reprovado",
      "mensagem": "Solicitação de crédito reprovada. Motivo: {motivo}"
    },
    {
      "tipo": "Info",
      "contexto": "Aguardando Aprovação",
      "mensagem": "Solicitação enviada para aprovação do {aprovador}"
    },
    {
      "tipo": "Alerta",
      "contexto": "Reavaliação Necessaria",
      "mensagem": "Limite de crédito do cliente necessita reavaliação (vencido ha {dias} dias)"
    }
  ],
  "abas_interface": [
    {
      "aba": "Financeiro",
      "descrição": "Aba na tela de Conta que exibe informações financeiras",
      "campos": [
        "Limite de Crédito",
        "Partidas Abertas",
        "Ficha de Crédito",
        "Histórico de Análises"
      ]
    }
  ],
  "detalhes": {
    "áreasCrédito": [
      "ABBA",
      "ADBA",
      "Belgo Cash",
      "ALPE"
    ],
    "fscm": "Financial Supply Chain Management - modulo SAP para gestão financeira",
    "workflow": "Analista -> Gestor -> Diretoria",
    "scoring": "Calculo automático baseado em bureaus + histórico SAP"
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador",
        "contribuição": "Explicou sistema ASCP e áreas de crédito"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      }
    ]
  },
  "discussao_reunioes": {
    "16dez2025": {
      "apresentador": "Leandro da Cruz Pereira",
      "timestamp": "1:52",
      "contexto": "Recapitulação do tema Financeiro durante revisão geral dos tópicos",
      "citaçãoOriginal": "A gente falou brevemente aqui sobre sobre a aba financeira, brevemente porque eu falei sobre a ficha de crédito e na ficha de crédito aqui eu falei sobre as 4 áreas de crédito, que e o ASCP",
      "sistemaMencionado": {
        "nome": "ASCP",
        "nota": "Apenas o nome foi mencionado, sem detalhamento técnico"
      },
      "profundidade": "BREVEMENTE - Leandro usou a palavra ''brevemente'' duas vezes, indicando que não houve aprofundamento",
      "áreasCrédito": "Mencionou 4 áreas de crédito, mas não específicou quais (ABBA, ADBA, Belgo Cash, ALPE vem de outras fontes)"
    }
  }
}');

-- =============================================================================
-- Jornada 7: Rastreamento de Concorrentes
-- Fonte: data/jornadas/concorrentes.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Rastreamento de Concorrentes",
  "icone": "🎯",
  "ordem": 7,
  "status": "Pendente",
  "as_is": "Registro manual e esporadico de informações sobre concorrentes onde vendedores anotam dados em planilhas pessoais ou cadernos, sem padronização, consolidação ou análise sistematica. Informações ficam dispersas e perdem-se com a saida de vendedores.",
  "passos_as_is": "Vendedor identifica concorrente em visita ao cliente|Anota informações em papel ou planilha pessoal|Dados incluem: nome do concorrente, produto, preço, condições|Informações não sao compartilhadas sistematicamente|Quando solicitado, vendedor busca em suas anotações|Consolidação feita manualmente pelo gestor (quando feita)|Sem vinculação com oportunidades de venda|Dados ficam desatualizados rapidamente",
  "problemas_as_is": "Dados fragmentados entre varios vendedores|Informações desatualizadas sobre preços e condições|Sem análise sistematica de concorrencia|Perda de informações com rotatividade de vendedores|Sem vinculação com oportunidades perdidas|Dificuldade de identificar padroes de atuação|Sem histórico de atuação do concorrente|Decisoes comerciais sem base em dados|Concorrentes sazonais não mapeados|Falta de padronização nas informações coletadas",
  "tempo_medio_as_is": "N/A (esporadico)",
  "to_be": "Gestão sistematica de concorrentes no Salesforce com registro estruturado vinculado a contas e oportunidades. Permite análise de participação de mercado, acompanhamento de preços e identificação de padroes de concorrencia por região e segmento.",
  "passos_to_be": "Vendedor acessa conta do cliente no Salesforce|Clica em ''Adicionar Concorrente'' ou ''Registrar Perda''|Seleciona concorrente de lista padronizada|Se concorrente novo: cadastra com dados básicos|Preenche informações: produto, preço, condições, motivo de escolha|Vincula a oportunidade de venda (se aplicavel)|Sistema registra data e vendedor responsável|Relatórios automáticos consolidam informações|Alertas para concorrentes frequentes em determinada região",
  "beneficios_to_be": "Visão consolidada de todos os concorrentes|Análise de mercado baseada em dados reais|Histórico completo de atuação de cada concorrente|Vinculação com oportunidades ganhas e perdidas|Identificação de padroes por região e segmento|Decisoes comerciais embasadas|Relatórios automáticos de concorrencia|Mapeamento de concorrentes sazonais|Retenção de conhecimento independente de pessoas|Alertas proativos sobre ações de concorrentes",
  "tempo_medio_to_be": "5 minutos",
  "areas_impactadas": "Comercial|Marketing|Estrategia|Inteligencia de Mercado",
  "sistemas_tecnicos": "Salesforce",
  "fonte_reuniao": "10/12/2025",
  "fontes_reuniao": "10/12/2025 - Discussão sobre gestão de concorrentes|10/12/2025 - Questionamento de Francine sobre concorrentes sazonais",
  "pendencias": "Definição da lista padronizada de concorrentes|Definição de regras para concorrentes sazonais|Configuração de alertas de concorrencia|Relatórios de análise de mercado",
  "prerequisitos": "Lista de concorrentes conhecidos catalogada|Definição de campos obrigatórios validada pela área comercial|Treinamento de vendedores sobre importancia do registro",
  "campos_processo": [
    {
      "campo": "Nome do Concorrente",
      "descrição": "Nome da empresa concorrente",
      "preenchimento": "Seleção/Manual",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Tipo Concorrente",
      "descrição": "Classificação do tipo de concorrente",
      "preenchimento": "Seleção",
      "validação": "-",
      "obrigatório": true,
      "valores": [
        "Direto",
        "Indireto",
        "Substituto",
        "Sazonal"
      ]
    },
    {
      "campo": "Produto Concorrente",
      "descrição": "Produto oferecido pelo concorrente",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Preço Informado",
      "descrição": "Preço praticado pelo concorrente",
      "preenchimento": "Manual",
      "validação": "Numerico",
      "obrigatório": false
    },
    {
      "campo": "Condições Comerciais",
      "descrição": "Condições de pagamento e entrega",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Motivo da Escolha",
      "descrição": "Por que cliente escolheu o concorrente",
      "preenchimento": "Seleção/Manual",
      "validação": "-",
      "obrigatório": false,
      "valores": [
        "Preço",
        "Prazo",
        "Qualidade",
        "Relacionamento",
        "Marca",
        "Disponibilidade",
        "Outro"
      ]
    },
    {
      "campo": "Conta Relacionada",
      "descrição": "Cliente onde o concorrente foi identificado",
      "preenchimento": "Automático",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Oportunidade Relacionada",
      "descrição": "Oportunidade de venda vinculada (se houver)",
      "preenchimento": "Seleção",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Data do Registro",
      "descrição": "Data em que a informação foi coletada",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Vendedor Responsável",
      "descrição": "Vendedor que coletou a informação",
      "preenchimento": "Automático (Usuário)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Região",
      "descrição": "Região onde concorrente atua",
      "preenchimento": "Automático (Conta)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Observações",
      "descrição": "Informações adicionais sobre o concorrente",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": false
    }
  ],
  "regras_negocio": [
    {
      "regra": "Lista Padronizada de Concorrentes",
      "descrição": "Sistema mantem lista de concorrentes conhecidos para seleção rapida, evitando duplicações e padronizando nomenclatura"
    },
    {
      "regra": "Vinculação com Oportunidades Perdidas",
      "descrição": "Ao registrar uma oportunidade como perdida, sistema solicita informações sobre o concorrente vencedor"
    },
    {
      "regra": "Concorrentes Sazonais",
      "descrição": "Sistema permite marcar concorrentes como sazonais, indicando períodos de maior atuação",
      "nota": "Definição de regras pendente conforme questionamento na reunião"
    },
    {
      "regra": "Alertas de Concorrencia",
      "descrição": "Sistema gera alertas quando concorrente aparece frequentemente em determinada região ou cliente"
    },
    {
      "regra": "Histórico por Cliente",
      "descrição": "Na tela da conta, exibe histórico de concorrentes identificados para aquele cliente"
    }
  ],
  "integracoes": [
    {
      "origem": "Salesforce",
      "destino": "Relatórios BI",
      "tipo": "Exportação",
      "descrição": "Dados de concorrentes podem ser exportados para análise em ferramentas de BI"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "Pendente",
      "título": "Gestão de Concorrentes - Testes Funcionais",
      "status": "A Definir",
      "data": "-",
      "descrição": "Testes de funcionalidades de rastreamento de concorrentes ainda não definidos",
      "cenarios": [
        "Cadastro de novo concorrente",
        "Vinculação de concorrente a oportunidade perdida",
        "Registro de preços e condições do concorrente",
        "Classificação de concorrentes sazonais",
        "Relatórios de análise de mercado",
        "Alertas de concorrencia frequente"
      ],
      "nota": "Funcionalidade em status Pendente - testes serao definidos apos implementação"
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Concorrente Registrado",
      "mensagem": "Informação de concorrente registrada com sucesso"
    },
    {
      "tipo": "Alerta",
      "contexto": "Concorrente Duplicado",
      "mensagem": "Este concorrente ja esta cadastrado. Verifique antes de criar novo."
    },
    {
      "tipo": "Info",
      "contexto": "Perda para Concorrente",
      "mensagem": "Registre as informações do concorrente para ajudar na análise de mercado"
    },
    {
      "tipo": "Alerta",
      "contexto": "Concorrente Frequente",
      "mensagem": "Atenção: {concorrente} apareceu em {n} oportunidades nesta região no último mes"
    }
  ],
  "detalhes": {
    "objetivo": "Centralizar informações de concorrentes para tomada de decisão",
    "análises": [
      "Participação por região",
      "Preços praticados",
      "Motivos de perda",
      "Tendencias de mercado"
    ],
    "concorrentesSazonais": "Pendente definição de regras"
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Francine Gayer",
        "divisão": "Protec",
        "contribuição": "Levantou questao sobre concorrentes sazonais"
      },
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      }
    ]
  },
  "discussao_reunioes": {
    "10dez2025": {
      "participante": "Francine Gayer",
      "divisão": "Protec",
      "timestamp": "1:28:38",
      "contexto": "Discussão sobre como o sistema deveria tratar concorrentes e integrar com plataforma Share",
      "citaçãoSobreShare": "E ai ele ja linkar com essa outra plataforma do Share. Eu não sei se tem como amarrar os dados ali para depois eu não ter que ir la analisar tudo que eu perdi. Se ela 10 cotações, eu ganhei 7 e perdi 3. Como e que eu vou amarrar isso la no share do cliente e colocar esse outro concorrente la?",
      "citaçãoSobreSazonalidade": "Os concorrentes sao sazonais, ta? Eu não sei. Aqui a gente no Protec a nossa realidade e assim. De repente, tem alguns que estao sempre ali, e os nomes permanentes ali, peres, mas tem outros concorrentes que surgem ali, tipo vogue galinha, aparece ali, da uma dorzinha de cabeca, incomodou um pouquinho, daqui a pouco some.",
      "insights": [
        "Concorrentes podem ser permanentes (ex: Peres) ou sazonais",
        "Sazonais ''aparecem e somem'' - dificil rastrear",
        "Realidade varia por divisão (Protec tem essa dinamica)",
        "Expressao ''vogue galinha'' usada para descrever concorrente oportunista"
      ],
      "necessidadeIdentificada": "Sistema precisa diferenciar e tratar concorrentes sazonais de forma diferente dos permanentes",
      "respostaObtida": "Pendente - regras de sazonalidade a serem definidas"
    }
  },
  "citacoes_transcricoes": {
    "10dez2025_ConcorrentesSazonais": {
      "fonte": "2025-12-10_cadastro-areas.txt",
      "tema": "Concorrentes Sazonais e Integração Share",
      "citacoes": [
        {
          "autor": "Francine Gayer",
          "timestamp": "1:28:38",
          "texto": "E aí ele já linkar com essa outra plataforma do Share. Eu não sei se tem como amarrar os dados ali para depois eu não ter que ir lá analisar tudo que eu perdi."
        },
        {
          "autor": "Francine Gayer",
          "timestamp": "1:28:55",
          "texto": "Os concorrentes são sazonais, tá? Aqui a gente no Protec a nossa realidade é assim. De repente, tem alguns que estão sempre ali, os nomes permanentes ali, Peres, mas tem outros concorrentes que surgem ali, tipo vogue galinha, aparece ali, dá uma dorzinha de cabeça, incomodou um pouquinho, daqui a pouco some."
        }
      ],
      "insights": {
        "concorrentesPermanentes": [
          "Peres"
        ],
        "concorrentesSazonais": "Aparecem e somem - ex: ''vogue galinha''",
        "divisao": "Protec",
        "integracaoPendente": "Share - para análise de oportunidades perdidas"
      }
    }
  }
}');

-- =============================================================================
-- Jornada 8: Autoatendimento
-- Fonte: data/jornadas/autoatendimento.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Autoatendimento",
  "icone": "🖥️",
  "ordem": 8,
  "status": "Futuro",
  "as_is": "Atualmente o cliente não possui nenhum canal de autoatendimento digital. Para qualquer consulta sobre pedidos, notas fiscais, rastreamento ou documentos, o cliente precisa ligar ou enviar email para o vendedor, que por sua vez consulta os sistemas internos e retorna a informação.",
  "passos_as_is": "Cliente precisa de informação (status pedido, NF, rastreamento)|Liga para o vendedor ou envia email/WhatsApp|Vendedor recebe solicitação|Vendedor acessa SAP ou outros sistemas para buscar informação|Vendedor compila informações solicitadas|Retorna ao cliente por telefone ou email|Se cliente precisa de 2a via de documento, vendedor solicita ao fiscal|Fiscal gera documento e envia ao vendedor|Vendedor encaminha ao cliente",
  "problemas_as_is": "Dependência total do vendedor para qualquer consulta|Demora no atendimento (horas ou dias)|Cliente sem autonomia para consultas basicas|Vendedor gasta tempo com atividades operacionais|Sem acesso fora do horario comercial|Processo de 2a via lento e burocratico|Sobrecarga de chamados no time comercial|Cliente frustrado com falta de visibilidade|Retrabalho para consultas repetitivas",
  "tempo_medio_as_is": "Horas/Dias",
  "to_be": "Portal de Autoatendimento onde o cliente tem acesso autonomo 24/7 a todas as informações relevantes: status de pedidos, notas fiscais (XML e DANFE), rastreamento de entregas, 2a via de documentos e certificados de qualidade. Libera o vendedor para atividades comerciais.",
  "passos_to_be": "Cliente acessa Portal de Autoatendimento|Realiza login com email cadastrado|Visualiza dashboard com resumo de pedidos e entregas|Consulta status detalhado de pedidos em andamento|Acessa histórico de notas fiscais|Faz download de XML e DANFE|Acompanha rastreamento de entregas em tempo real|Solicita 2a via de documentos com um clique|Acessa certificados de qualidade dos produtos|Recebe notificações de eventos importantes",
  "beneficios_to_be": "Autonomia total do cliente - 24 horas por dia|Atendimento imediato sem depender de pessoas|Redução drastica de chamados ao vendedor|Vendedor focado em atividades comerciais|Documentos sempre disponiveis para download|Rastreamento em tempo real|Histórico completo de transações|Satisfação do cliente aumentada|Redução de carga operacional|Notificações proativas sobre pedidos",
  "tempo_medio_to_be": "Imediato (self-service)",
  "areas_impactadas": "Comercial|Atendimento|TI|Fiscal|Logística",
  "sistemas_tecnicos": "Portal de Autoatendimento|Salesforce|SAP ECC|SAP ECC|Portal Logístico",
  "fonte_reuniao": "16/12/2025",
  "fontes_reuniao": "16/12/2025 - Discussão sobre Portal de Autoatendimento|16/12/2025 - Criticidade dos dados de contato para acesso|10/12/2025 - Menção a necessidade de self-service",
  "pendencias": "Definição de interface/UX do portal|Integração com sistema SAP ECC para documentos|Integração com Portal Logístico para rastreamento|Definição de politica de senha|Processo de primeiro acesso/ativação|Configuração de notificações",
  "prerequisitos": "Gestão de Contatos implementada e operacional|Dados de email validados e atualizados|Integração SAP ECC funcionando para documentos fiscais|Portal Logístico integrado para rastreamento",
  "campos_processo": [
    {
      "campo": "Email de Acesso",
      "descrição": "Email do contato para login no portal",
      "preenchimento": "Cadastro de Contatos",
      "validação": "Email válido",
      "obrigatório": true
    },
    {
      "campo": "Senha",
      "descrição": "Senha de acesso ao portal",
      "preenchimento": "Definido pelo usuário",
      "validação": "Politica de senha",
      "obrigatório": true
    },
    {
      "campo": "Conta Vinculada",
      "descrição": "Cliente(s) vinculado(s) ao acesso",
      "preenchimento": "Automático (Cadastro)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Perfil de Acesso",
      "descrição": "Nível de acesso no portal",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true,
      "valores": [
        "Visualização",
        "Download",
        "Administrador"
      ]
    }
  ],
  "regras_negocio": [
    {
      "regra": "Contato com Email Válido Obrigatório",
      "descrição": "Para habilitar acesso ao portal, o cliente precisa ter pelo menos um contato com email válido cadastrado",
      "criticidade": "Alta",
      "dependência": "Gestão de Contatos",
      "fonteVerificação": "INFERENCIA - reunião mencionou importancia de ''dado bem certinho'' para autoatendimento, mas não específicou email como requisito"
    },
    {
      "regra": "Autenticação via Email Cadastrado",
      "descrição": "O login no portal e feito com o email do contato cadastrado no Salesforce"
    },
    {
      "regra": "Visibilidade por Conta",
      "descrição": "Usuário visualiza apenas informações da(s) conta(s) a qual esta vinculado como contato"
    },
    {
      "regra": "Disponibilidade Imediata de Documentos",
      "descrição": "XML e DANFE ficam disponiveis no portal imediatamente apos faturamento (integração com SAP ECC)"
    },
    {
      "regra": "Notificações Automáticas",
      "descrição": "Sistema envia notificações por email quando: pedido e faturado, mercadoria sai para entrega, entrega e realizada"
    },
    {
      "regra": "Histórico Disponível",
      "descrição": "Cliente tem acesso ao histórico dos últimos 24 meses de transações"
    }
  ],
  "integracoes": [
    {
      "origem": "Salesforce",
      "destino": "Portal Autoatendimento",
      "tipo": "API",
      "descrição": "Autenticação e dados de contato/conta"
    },
    {
      "origem": "SAP ECC",
      "destino": "Portal Autoatendimento",
      "tipo": "API",
      "descrição": "Disponibilização de XML, DANFE e certificados"
    },
    {
      "origem": "SAP",
      "destino": "Portal Autoatendimento",
      "tipo": "API",
      "descrição": "Status de pedidos e histórico de compras"
    },
    {
      "origem": "Portal Logístico",
      "destino": "Portal Autoatendimento",
      "tipo": "API",
      "descrição": "Status de rastreamento de entregas"
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Login",
      "mensagem": "Bem-vindo ao Portal de Autoatendimento"
    },
    {
      "tipo": "Erro",
      "contexto": "Login Inválido",
      "mensagem": "Email ou senha inválidos. Tente novamente."
    },
    {
      "tipo": "Erro",
      "contexto": "Acesso Não Habilitado",
      "mensagem": "Seu acesso ao portal ainda não foi habilitado. Entre em contato com seu vendedor."
    },
    {
      "tipo": "Info",
      "contexto": "Documento Disponível",
      "mensagem": "Novo documento disponível para download: NF-e {número}"
    },
    {
      "tipo": "Info",
      "contexto": "Pedido em Transito",
      "mensagem": "Seu pedido {número} saiu para entrega"
    },
    {
      "tipo": "Sucesso",
      "contexto": "Entrega Realizada",
      "mensagem": "Seu pedido {número} foi entregue com sucesso"
    }
  ],
  "detalhes": {
    "prerequisito": "Depende de dados de contato corretos - criticidade ALTA",
    "funcionalidades": [
      "Status pedidos",
      "Download XML/DANFE",
      "Rastreamento",
      "2a via de documentos",
      "Certificados de qualidade"
    ],
    "disponibilidade": "24/7",
    "autenticação": "Email cadastrado no Salesforce"
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador",
        "contribuição": "Explicou criticidade de contatos para autoatendimento"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      },
      {
        "nome": "Maria Luiza Gomes Chaves",
        "papel": "Key User",
        "contribuição": "Perguntou sobre próximas sessoes e tabela de preços"
      }
    ],
    "feedback": {
      "autor": "Maria Luiza Gomes Chaves",
      "citação": "Primeiramente, queria agradecer. Todas essas sessoes tem sido muito didaticas. Eu entrei na Belgo ha 4 meses, entao aprendi muita coisa tambem de outros processos daqui.",
      "contexto": "Nova funcionaria (4 meses) expressando valor dos workshops"
    }
  },
  "discussao_reunioes": {
    "10dez2025": {
      "apresentador": "Leandro da Cruz Pereira",
      "contexto": "Menção inicial a necessidade de canal self-service para cliente",
      "pontosChave": [
        "Cliente precisa de autonomia para consultas basicas",
        "Dependência de vendedor para informações simples e problema",
        "Self-service e objetivo do projeto"
      ]
    },
    "16dez2025": {
      "apresentador": "Leandro da Cruz Pereira",
      "contexto": "Discussão detalhada sobre Portal de Autoatendimento",
      "citação": "E hoje a gente vai falar sobre autoatendimento tambem e o autoatendimento. Voces vao ver a importancia desse dado preenchido corretamente.",
      "dependênciaCritica": {
        "requisito": "Email válido no cadastro de contatos",
        "regra": "Cliente SEM email válido NAO consegue acessar o portal",
        "impacto": "Bloqueio total da funcionalidade de self-service"
      },
      "vinculoContatos": {
        "explicação": "Portal de Autoatendimento valida acesso usando email do contato",
        "fluxo": "Login com email -> Validação no Salesforce -> Acesso ao portal",
        "seFalhar": "Cliente fica dependente do vendedor para TODAS as consultas"
      }
    }
  },
  "citacoes_transcricoes": {
    "07jan2026_BotEinstein": {
      "fonte": "2026-01-07_bot-einstein-logistica.json",
      "tema": "Bot Einstein para Autoatendimento via WhatsApp",
      "resumo": "Reunião sobre o Bot Einstein MVP com consulta de conta, status de pedidos e documentos fiscais. Autenticação por email, transbordo para Smart Center.",
      "citacoes": [
        {
          "autor": "Fabricio Franca",
          "timestamp": "0:36",
          "texto": "Equipe GTM atende comercial, marketing e planejamento. Duas soluções: relatório Power BI + autoatendimento WhatsApp"
        },
        {
          "autor": "Fabricio Franca",
          "timestamp": "1:57",
          "texto": "Conversa guiada para informações de conta, criado como MVP"
        },
        {
          "autor": "Fabricio Franca",
          "timestamp": "3:38",
          "texto": "Projeto iniciou em outubro, entregue em dezembro. 400.000 BRL aprovados para 2026"
        },
        {
          "autor": "Fabricio Franca",
          "timestamp": "11:16",
          "texto": "Validação por email para segurança"
        },
        {
          "autor": "Fabricio Franca",
          "timestamp": "19:24",
          "texto": "Casos para consultas não resolvidas tratados pelo Smart Center"
        },
        {
          "autor": "Fabricio Franca",
          "timestamp": "23:59",
          "texto": "Número único de WhatsApp para todas as interações"
        }
      ],
      "funcionalidadesMVP": [
        "Consulta de conta/cliente",
        "Status de pedidos",
        "Documentos fiscais (XML, DANFE)",
        "Autenticação por email cadastrado",
        "Transbordo para Smart Center quando não resolvido"
      ],
      "orcamento2026": "R$ 400.000 aprovados para continuidade"
    },
    "10dez2025_NotificacoesWhatsApp": {
      "fonte": "2025-12-10_cadastro-areas.txt",
      "tema": "Notificações WhatsApp para Clientes",
      "citacoes": [
        {
          "autor": "Bruno Machado",
          "timestamp": "N/A",
          "texto": "Todas as vezes que registra um pedido, uma OV para o cliente, ele está recebendo no WhatsApp dele que está cadastrado aí"
        }
      ],
      "segmentosAtivos": [
        "Agro",
        "Protec"
      ]
    }
  }
}');

-- =============================================================================
-- Jornada 9: Workflow Pricing
-- Fonte: data/jornadas/workflow-pricing.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Workflow Pricing",
  "icone": "💲",
  "ordem": 9,
  "status": "Em Andamento",
  "as_is": "Processo de concessão de descontos sem controle centralizado onde vendedores negociam descontos diretamente com clientes, solicitam aprovação informalmente por email ou telefone, e aplicam manualmente no pedido. Sem vigencia definida, sem rastreabilidade e sem integração com SAP.",
  "passos_as_is": "Vendedor negocia desconto especial com cliente|Solicita aprovação ao gerente por email ou telefone|Gerente avalia de forma informal (sem padrão)|Se aprovado: vendedor anota desconto em planilha|Ao criar pedido, aplica desconto manualmente|Desconto não tem vigencia definida|Sem registro centralizado de descontos concedidos|Dificil auditar descontos aplicados|Margens podem ser corroidas sem controle",
  "problemas_as_is": "Sem controle centralizado de descontos|Aprovações informais sem rastreabilidade|Descontos sem vigencia definida|Margens corroidas sem visibilidade|Impossibilidade de auditar descontos|Sem padronização de niveis de aprovação|Vendedor pode esquecer desconto negociado|Cliente pode reivindicar desconto expirado|Sem integração com politica de preços do SAP",
  "tempo_medio_as_is": "Variavel",
  "to_be": "Workflow estruturado de aprovação de descontos no Salesforce com integração ao SAP via condition YDCF. Vendedor navega hierarquia de materiais (6 niveis), define percentual de desconto e vigencia, submete para aprovação em 2 niveis (Time Pricing e Gerente), e apos aprovação o desconto e criado automáticamente no SAP.",
  "passos_to_be": "Vendedor acessa Pricing no Salesforce|Seleciona cliente para aplicar desconto|Navega hierarquia de materiais (6 niveis)|Nível 1: Unidades|Nível 2: Macro Segmentos|Nível 3: Macro Detalhado|Nível 4: Segmento|Nível 5: Grupo Mercadoria|Nível 6: Material (SKU específico)|Define percentual de desconto|Define período de vigencia (data início e fim)|Submete solicitação para aprovação|Nível 1: Time Pricing avalia e aprova/rejeita|Nível 2: Gerente do Escritorio aprova/rejeita|Se aprovado: sistema cria condition YDCF no SAP|Desconto aplicado automáticamente em pedidos no período de vigencia",
  "beneficios_to_be": "Controle total de descontos concedidos|Rastreabilidade completa de aprovações|Workflow estruturado em 2 niveis|Vigencia automática com data início e fim|Integração automática com SAP (YDCF)|Desconto aplicado automáticamente nos pedidos|Histórico completo de descontos por cliente|Auditoria fácilitada|Proteção de margens|Visibilidade de descontos vigentes",
  "tempo_medio_to_be": "1-2 dias (dependendo de aprovações)",
  "areas_impactadas": "Comercial|Marketing|Pricing|TI|Financeiro",
  "sistemas_tecnicos": "Salesforce|SAP ECC",
  "fonte_reuniao": "Caderno de Testes + Tester TI",
  "fontes_reuniao": "Caderno de Testes - CT-01 a CT-19 (casos detalhados)|Tester TI 791093 - Cabos de Aco (28/10/2025)|Tester TI 880788 - Agro Lisos (20/10/2025)",
  "pendencias": "Mapeamento completo da hierarquia de materiais|Definição de limites de desconto por nível de aprovação|Configuração de notificações para aprovadores|Testes de integração com SAP (YDCF)",
  "prerequisitos": "Hierarquia de materiais carregada no Salesforce|Workflow de aprovação configurado|Integração SAP para criação de YDCF testada|Perfis de aprovadores definidos",
  "campos_processo": [
    {
      "campo": "Cliente",
      "descrição": "Conta do cliente que recebera o desconto",
      "preenchimento": "Seleção",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Nível Hierarquia",
      "descrição": "Nível da hierarquia de materiais selecionado",
      "preenchimento": "Seleção",
      "validação": "Obrigatório",
      "obrigatório": true,
      "valores": [
        "Unidade",
        "Macro Segmento",
        "Macro Detalhado",
        "Segmento",
        "Grupo Mercadoria",
        "Material"
      ]
    },
    {
      "campo": "Item Selecionado",
      "descrição": "Item específico da hierarquia",
      "preenchimento": "Seleção",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Percentual Desconto",
      "descrição": "Percentual de desconto a ser aplicado",
      "preenchimento": "Manual",
      "validação": "Numerico (0-100%)",
      "obrigatório": true
    },
    {
      "campo": "Data Início Vigencia",
      "descrição": "Data de início da vigencia do desconto",
      "preenchimento": "Manual",
      "validação": "Data >= hoje",
      "obrigatório": true
    },
    {
      "campo": "Data Fim Vigencia",
      "descrição": "Data de termino da vigencia do desconto",
      "preenchimento": "Manual",
      "validação": "Data > Data Início",
      "obrigatório": true
    },
    {
      "campo": "Justificativa",
      "descrição": "Motivo da solicitação de desconto",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Status",
      "descrição": "Status atual da solicitação",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true,
      "valores": [
        "Rascunho",
        "Pendente Aprovação N1",
        "Pendente Aprovação N2",
        "Aprovado",
        "Rejeitado",
        "Expirado"
      ]
    },
    {
      "campo": "Código YDCF",
      "descrição": "Código da condition criada no SAP",
      "preenchimento": "Automático (SAP)",
      "validação": "-",
      "obrigatório": false
    }
  ],
  "regras_negocio": [
    {
      "regra": "Navegação Hierarquica",
      "descrição": "Usuário navega pelos 6 niveis de hierarquia de materiais para selecionar o escopo do desconto",
      "nota": "Desconto no nível mais alto afeta todos os materiais abaixo"
    },
    {
      "regra": "Aprovação em 2 Niveis",
      "descrição": "Toda solicitação passa por aprovação do Time Pricing (N1) e do Gerente do Escritorio (N2)"
    },
    {
      "regra": "Vigencia Obrigatoria",
      "descrição": "Toda solicitação deve ter data de início e fim de vigencia definidas"
    },
    {
      "regra": "Criação Automática de YDCF",
      "descrição": "Apos aprovação final, sistema cria automáticamente a condition YDCF no SAP com os parametros definidos",
      "conditionSAP": "YDCF - Desconto de Cliente"
    },
    {
      "regra": "Aplicação Automática em Pedidos",
      "descrição": "Desconto aprovado e aplicado automáticamente em todos os pedidos do cliente dentro da vigencia"
    },
    {
      "regra": "Expiração Automática",
      "descrição": "Ao atingir a data fim de vigencia, o desconto e desativado automáticamente"
    },
    {
      "regra": "Notificação de Aprovadores",
      "descrição": "Aprovadores recebem email quando ha solicitação pendente de aprovação"
    }
  ],
  "integracoes": [
    {
      "origem": "Salesforce",
      "destino": "SAP",
      "tipo": "Middleware",
      "descrição": "Criação de condition YDCF apos aprovação"
    },
    {
      "origem": "SAP",
      "destino": "Salesforce",
      "tipo": "Middleware",
      "descrição": "Retorno do código YDCF criado"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "Caderno de Testes - WF Pricing",
      "título": "Workflow Pricing - Ciclo Completo",
      "status": "Em Andamento",
      "data": "2026-01-12",
      "descrição": "19 casos de teste cobrindo todo o fluxo de Workflow Pricing",
      "estatisticas": {
        "total": 19,
        "concluidos": 14,
        "pendentes": 3,
        "falhou": 2,
        "percentualConclusao": "73.7%"
      },
      "cenarios": [
        "Criação de WF Pricing para material específico (CT-01)",
        "Vigencia individual por linha (CT-02)",
        "Validação de canal (CT-03)",
        "Consulta de histórico (CT-04)",
        "Input manual de desconto % (CT-05)",
        "WF para grupo de mercadoria (CT-06)",
        "Aprovação Time Pricing (CT-07)",
        "Aprovação Gerente (CT-08)",
        "Rejeição de WF (CT-09)",
        "Multiplos materiais (CT-10)",
        "Conta sem código SAP (CT-11) - FALHOU",
        "Criação YDCF no SAP (CT-12)",
        "Segmento de Produto (CT-13)",
        "Desconto inválido (CT-14) - FALHOU",
        "Vigencia retroativa (CT-15)",
        "Canal específico (CT-16)",
        "Notificação email (CT-17)",
        "Navegação hierarquia (CT-18)",
        "Aprovador alternativo (CT-19)"
      ],
      "testesRelacionados": [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19
      ]
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Solicitação Enviada",
      "mensagem": "Solicitação de desconto enviada para aprovação"
    },
    {
      "tipo": "Sucesso",
      "contexto": "Aprovação N1",
      "mensagem": "Solicitação aprovada pelo Time Pricing. Aguardando aprovação do Gerente."
    },
    {
      "tipo": "Sucesso",
      "contexto": "Aprovação Final",
      "mensagem": "Desconto aprovado e criado no SAP. Código YDCF: {código}"
    },
    {
      "tipo": "Erro",
      "contexto": "Rejeitado",
      "mensagem": "Solicitação de desconto rejeitada. Motivo: {motivo}"
    },
    {
      "tipo": "Alerta",
      "contexto": "Vigencia Expirando",
      "mensagem": "Desconto para cliente {cliente} expira em {dias} dias"
    },
    {
      "tipo": "Info",
      "contexto": "Pendente Aprovação",
      "mensagem": "Voce tem {n} solicitações de desconto pendentes de aprovação"
    }
  ],
  "detalhes": {
    "hierarquiaMateriais": [
      "Unidades",
      "Macro Segmentos",
      "Macro Detalhado",
      "Segmento",
      "Grupo Mercadoria",
      "Material"
    ],
    "conditionSAP": "YDCF - Desconto de Cliente",
    "fluxoAprovação": [
      "Time Pricing",
      "Gerente Escritorio"
    ],
    "vigencia": "Obrigatoria com data início e fim"
  },
  "fluxo_aprovacao": [
    {
      "nível": 1,
      "aprovador": "Time Pricing",
      "descrição": "Equipe de pricing avalia politica comercial e impacto na margem",
      "prazoSLA": "24 horas"
    },
    {
      "nível": 2,
      "aprovador": "Gerente do Escritorio",
      "descrição": "Gerente comercial avalia estrategia de cliente",
      "prazoSLA": "24 horas"
    }
  ],
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      },
      {
        "nome": "Maria Luiza Gomes Chaves",
        "papel": "Key User",
        "contribuição": "Perguntou sobre tabela de preços"
      }
    ],
    "discussãoWorkflowPricing": {
      "fonte": "Reunião 16/12/2025",
      "status": "Não foi discutido em detalhe por falta de tempo",
      "citação": "Faltou workflow Pricing fica para amanha",
      "próximaDiscussão": "Agendada para 17/12/2025"
    }
  },
  "citacoes_transcricoes": {
    "17dez2025_RelatoriosWF": {
      "fonte": "2025-12-17_relatorios-workflow.json",
      "tema": "Detalhamento do Workflow Pricing e Relatórios",
      "nota": "Reunião específica sobre WF Pricing realizada em 17/12",
      "topicosAbordados": [
        "Workflow de aprovação em 2 níveis",
        "Integração com condition YDCF no SAP",
        "Hierarquia de materiais (6 níveis)",
        "Vigência de descontos"
      ]
    },
    "16dez2025_TabelaPrecos": {
      "fonte": "2025-12-16_docs-fiscais-autoatendimento.txt",
      "tema": "Dúvida sobre Tabela de Preços",
      "citacoes": [
        {
          "autor": "Maria Luiza Gomes Chaves",
          "timestamp": "Final da reunião",
          "texto": "Eu também queria saber em qual momento abordam a tabela de preço?"
        }
      ],
      "contexto": "Key User nova (4 meses) questionou sobre quando seria abordado pricing"
    },
    "03dez2025_MargensEBITDA": {
      "fonte": "2025-12-03_financeiro-controladoria.txt",
      "tema": "Custo de Servir e Margens",
      "citacoes": [
        {
          "autor": "Leandro Pereira",
          "timestamp": "N/A",
          "texto": "Custo de Servir é a métrica de margem de serviço - meta de 36.2M definida pela Integration"
        }
      ],
      "impactoNegocio": "Descontos impactam diretamente o Custo de Servir e EBITDA"
    }
  }
}');

-- =============================================================================
-- Jornada 10: Cotação e Ordem de Vendas
-- Fonte: data/jornadas/cotacao-ov.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Cotação e Ordem de Vendas",
  "icone": "📋",
  "ordem": 10,
  "status": "Em Andamento",
  "as_is": "Processo manual de criação de cotações onde vendedor consulta preços em planilhas ou no SAP, verifica estoque manualmente, monta cotação em Excel, e apos aceite do cliente digita o pedido manualmente no SAP. Sem verificação de disponibilidade em tempo real (ATP).",
  "passos_as_is": "Cliente solicita cotação por telefone ou email|Vendedor acessa SAP para consultar preços|Verifica estoque manualmente em outra transação|Monta cotação em planilha Excel|Envia cotação por email ao cliente|Cliente aceita cotação|Vendedor acessa SAP para criar pedido|Digita todos os itens manualmente|Verifica crédito do cliente|Se bloqueio de crédito: aciona financeiro|Pedido criado e enviado para faturamento",
  "problemas_as_is": "Processo lento e manual|Preços podem estar desatualizados na planilha|Sem verificação de disponibilidade em tempo real (ATP)|Retrabalho ao digitar pedido no SAP|Risco de erros de digitação|Cliente sem visibilidade de prazo de entrega|Verificação de crédito apenas no momento do pedido|Cotações dispersas em emails e planilhas|Sem histórico centralizado de cotações",
  "tempo_medio_as_is": "Horas",
  "to_be": "Criação de cotações diretamente no Salesforce com integração em tempo real ao SAP para preços, verificação de disponibilidade (ATP) e aplicação automática de descontos YDCF. Cotação aprovada e convertida automáticamente em Ordem de Venda no SAP.",
  "passos_to_be": "Vendedor acessa conta do cliente no Salesforce|Clica em ''Nova Cotação''|Sistema verifica crédito disponível do cliente|Adiciona produtos a cotação|Sistema busca preços atualizados do SAP|Sistema aplica automáticamente descontos YDCF vigentes|Sistema consulta ATP (disponibilidade) em tempo real|ATP retorna data prevista de entrega|Vendedor visualiza resumo com preços e prazos|Envia cotação ao cliente pelo sistema|Cliente aceita cotação|Vendedor converte cotação em Ordem de Venda (OV)|Sistema cria OV automáticamente no SAP|Status da OV visível no Salesforce (Farol)",
  "beneficios_to_be": "Processo ágil e integrado|Preços sempre atualizados do SAP|Descontos YDCF aplicados automáticamente|ATP em tempo real (disponibilidade e prazo)|Conversão automática para OV no SAP|Visibilidade de status via Farol|Histórico centralizado de cotações|Eliminação de digitação manual no SAP|Verificação de crédito proativa|Cliente informado de prazos reais",
  "tempo_medio_to_be": "Minutos",
  "areas_impactadas": "Comercial|Logística|Financeiro|TI",
  "fonte_reuniao": "10/12/2025",
  "fontes_reuniao": "10/12/2025 - Discussão sobre Cotação e OV|16/12/2025 - Revisão de integração com SAP",
  "pendencias": "Integração com API de preços do SAP|Integração com ATP para disponibilidade|Configuração do Farol de status|Definição de prazo padrão de validade de cotação",
  "prerequisitos": "APIs SAP de preços e ATP disponiveis|Workflow Pricing implementado (YDCF)|Middleware SAP configurado para criação de OV|Catalogo de produtos sincronizado",
  "campos_processo": [
    {
      "campo": "Cliente",
      "descrição": "Conta do cliente para cotação",
      "preenchimento": "Seleção",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Número Cotação",
      "descrição": "Identificador único da cotação",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Data Cotação",
      "descrição": "Data de criação da cotação",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Validade",
      "descrição": "Data de validade da cotação",
      "preenchimento": "Automático/Manual",
      "validação": "Data > hoje",
      "obrigatório": true
    },
    {
      "campo": "Itens",
      "descrição": "Lista de produtos cotados",
      "preenchimento": "Manual",
      "validação": "Mínimo 1 item",
      "obrigatório": true
    },
    {
      "campo": "Preço Unitario",
      "descrição": "Preço do produto (do SAP)",
      "preenchimento": "Automático (SAP)",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Desconto YDCF",
      "descrição": "Desconto aplicado via condition YDCF",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Preço Final",
      "descrição": "Preço apos descontos",
      "preenchimento": "Calculado",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Data Disponibilidade (ATP)",
      "descrição": "Data prevista de disponibilidade",
      "preenchimento": "Automático (ATP)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Valor Total",
      "descrição": "Soma de todos os itens",
      "preenchimento": "Calculado",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Status",
      "descrição": "Status da cotação",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true,
      "valores": [
        "Rascunho",
        "Enviada",
        "Aceita",
        "Convertida em OV",
        "Expirada",
        "Cancelada"
      ]
    },
    {
      "campo": "Número OV SAP",
      "descrição": "Número da OV criada no SAP",
      "preenchimento": "Automático (SAP)",
      "validação": "-",
      "obrigatório": false
    },
    {
      "campo": "Status OV (Farol)",
      "descrição": "Status visual da OV no SAP",
      "preenchimento": "Automático (SAP)",
      "validação": "-",
      "obrigatório": false,
      "valores": [
        "Verde (OK)",
        "Amarelo (Atenção)",
        "Vermelho (Bloqueado)"
      ]
    },
    {
      "campo": "Pessoa de Contato",
      "descrição": "Contato do cliente associado à cotação",
      "preenchimento": "Seleção",
      "validação": "Deve ser Contato cadastrado na Conta (NÃO Tipo de Contato/Docs Fiscais)",
      "obrigatório": true,
      "fonte": "PDF Oficial - Página 5"
    },
    {
      "campo": "INCOTERMS",
      "descrição": "Modalidade de frete (EXW ou CIF)",
      "preenchimento": "Seleção",
      "validação": "-",
      "obrigatório": false,
      "valores": [
        "EXW",
        "Custo, Seguro & Frete (CIF)"
      ],
      "fonte": "PDF Oficial - Página 6"
    },
    {
      "campo": "Dias Adicionais",
      "descrição": "Dias adicionais para entrega",
      "preenchimento": "Manual",
      "validação": "Numérico",
      "obrigatório": false,
      "fonte": "PDF Oficial - Página 6"
    },
    {
      "campo": "Nº do Pedido do Cliente",
      "descrição": "Número do pedido informado pelo cliente",
      "preenchimento": "Manual",
      "validação": "-",
      "obrigatório": false,
      "fonte": "PDF Oficial - Página 6"
    }
  ],
  "regras_negocio": [
    {
      "regra": "Consulta de Preços em Tempo Real",
      "descrição": "Ao adicionar produto, sistema consulta preço atualizado no SAP"
    },
    {
      "regra": "Aplicação Automática de YDCF",
      "descrição": "Sistema verifica se cliente possui descontos YDCF vigentes e aplica automáticamente"
    },
    {
      "regra": "ATP - Available to Promise",
      "descrição": "Sistema consulta SAP para verificar disponibilidade de estoque e retorna data prevista de entrega",
      "nota": "ATP considera estoques em todos os centros de distribuição"
    },
    {
      "regra": "Verificação de Crédito",
      "descrição": "Sistema verifica crédito disponível do cliente antes de permitir criação da cotação"
    },
    {
      "regra": "Conversão Automática para OV",
      "descrição": "Cotação aceita pode ser convertida em OV com um clique, criando pedido automáticamente no SAP"
    },
    {
      "regra": "Farol de Status da OV",
      "descrição": "Status da OV no SAP e exibido como farol no Salesforce: Verde (liberado), Amarelo (pendência), Vermelho (bloqueado)"
    },
    {
      "regra": "Validade da Cotação",
      "descrição": "Cotações possuem data de validade, apos a qual preços e condições não sao mais garantidos"
    }
  ],
  "integracoes": [
    {
      "origem": "Salesforce",
      "destino": "SAP",
      "tipo": "API",
      "descrição": "Consulta de preços de produtos"
    },
    {
      "origem": "Salesforce",
      "destino": "SAP",
      "tipo": "API",
      "descrição": "Consulta de ATP (disponibilidade)"
    },
    {
      "origem": "Salesforce",
      "destino": "SAP",
      "tipo": "API",
      "descrição": "Consulta de descontos YDCF vigentes"
    },
    {
      "origem": "Salesforce",
      "destino": "SAP",
      "tipo": "Middleware",
      "descrição": "Criação de Ordem de Venda"
    },
    {
      "origem": "SAP",
      "destino": "Salesforce",
      "tipo": "Middleware",
      "descrição": "Retorno de número da OV e status"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "Caderno de Testes - Cotação e OV",
      "título": "Cotação e Ordem de Vendas - Ciclo Completo",
      "status": "Pendente",
      "data": "2026-01-12",
      "descrição": "22 casos de teste cobrindo o fluxo de Cotação e Ordem de Vendas",
      "avisoVerificação": "Cenarios listados referênciam Caderno de Testes Excel. Verificar arquivo GTM Vendas - Caderno de Testes.xlsx para confirmação.",
      "estatisticas": {
        "total": 22,
        "concluidos": 0,
        "pendentes": 22,
        "falhou": 0,
        "percentualConclusao": "0%"
      },
      "cenarios": [
        "Aplicação automática YDCF (CT-81)",
        "Busca por código de material (CT-82)",
        "Material sem parametrização SAP (CT-83)",
        "Mensagem de disponibilidade (CT-84)",
        "Material sem estoque (CT-85)",
        "Indicadores de pricing (CT-86)",
        "Preço sugerido vs SAP (CT-87)",
        "Área de Vendas na cotação (CT-88)",
        "Lista de produtos multiplos (CT-89)",
        "Upload de planilha template (CT-90)",
        "Validação Canal 20 + I3 (CT-91)",
        "ATP data de entrega (CT-92)",
        "Sincronização com expansao (CT-93)",
        "Cotação completa (CT-94)",
        "Cliente PF com CPF (CT-95)",
        "Sincronização e precificação (CT-96)",
        "Desconto manual e sincronização (CT-97)",
        "Bloqueios na OV (CT-98)",
        "Farol de Status OV (CT-99)",
        "Indicadores com permissão (CT-100)",
        "Atualização automática OV (CT-101)",
        "Conditions SAP YAC1 (CT-102)"
      ],
      "testesRelacionados": [
        81,
        82,
        83,
        84,
        85,
        86,
        87,
        88,
        89,
        90,
        91,
        92,
        93,
        94,
        95,
        96,
        97,
        98,
        99,
        100,
        101,
        102
      ]
    },
    {
      "documento": "Caderno de Testes - Conditions SAP",
      "título": "Conditions Pricing SAP",
      "status": "Pendente",
      "data": "2026-01-12",
      "descrição": "7 casos de teste para conditions de pricing no SAP",
      "estatisticas": {
        "total": 7,
        "concluidos": 0,
        "pendentes": 7,
        "falhou": 0,
        "percentualConclusao": "0%"
      },
      "cenarios": [
        "Cadastrar YAC1 com sequencias (CT-102)",
        "Cadastrar YPOL e YESC (CT-103)",
        "Cadastrar YACR sequencia 021 (CT-104)",
        "Renomeação YDFC (CT-105)",
        "YDFC cross-company (CT-106)",
        "Aplicação conditions OV (CT-107)",
        "Calculo preço liquido (CT-108)"
      ],
      "testesRelacionados": [
        102,
        103,
        104,
        105,
        106,
        107,
        108
      ]
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Cotação Criada",
      "mensagem": "Cotação {número} criada com sucesso"
    },
    {
      "tipo": "Sucesso",
      "contexto": "OV Criada",
      "mensagem": "Ordem de Venda {número} criada no SAP"
    },
    {
      "tipo": "Alerta",
      "contexto": "Crédito Insuficiente",
      "mensagem": "Cliente possui crédito insuficiente. Limite disponível: R$ {valor}"
    },
    {
      "tipo": "Alerta",
      "contexto": "Produto Indisponível",
      "mensagem": "Produto {código} indisponível. Previsão de disponibilidade: {data}"
    },
    {
      "tipo": "Erro",
      "contexto": "Cotação Expirada",
      "mensagem": "Esta cotação expirou em {data}. Crie uma nova cotação."
    },
    {
      "tipo": "Info",
      "contexto": "ATP",
      "mensagem": "Data prevista de entrega: {data}"
    },
    {
      "tipo": "Info",
      "contexto": "Desconto Aplicado",
      "mensagem": "Desconto YDCF de {percentual}% aplicado automáticamente"
    }
  ],
  "detalhes": {
    "atp": "Available to Promise - disponibilidade em tempo real do SAP",
    "farol": "Status visual da OV: Verde (OK), Amarelo (Atenção), Vermelho (Bloqueado)",
    "ydcf": "Descontos aprovados via workflow sao aplicados automáticamente",
    "conversão": "Cotação -> OV com criação automática no SAP"
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      },
      {
        "nome": "Maria Luiza Gomes Chaves",
        "papel": "Key User",
        "contribuição": "Perguntou sobre tabela de preços e próximas sessoes"
      }
    ]
  },
  "discussao_reunioes": {
    "16dez2025": {
      "contexto": "Tema planejado mas não discutido por falta de tempo",
      "citação": "Sessao de Preço seria hoje esta, mas a gente comecaria a falar de pricing, cotação e ordem de vendas, mas não vai dar tempo.",
      "próximaDiscussão": "Agendada para 17/12/2025"
    },
    "interaçãoMariaLuiza": {
      "participante": "Maria Luiza Gomes Chaves",
      "pergunta": "Vao ter mais sessoes? Porque eu queria saber se a gente vai falar um pouco mais sobre tabela de preços.",
      "resposta": "Thalita: A gente tem mais 2 encontros. O próximo vai ser amanha das 4 as 5:30."
    }
  }
}');

-- =============================================================================
-- Jornada 11: Hub de Gestão OC
-- Fonte: data/jornadas/hub-gestao.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Hub de Gestão OC",
  "icone": "⚙️",
  "ordem": 11,
  "status": "Em Andamento",
  "as_is": "Gestão descentralizada de grupos de ocorrencias de clientes onde solicitações de inclusao ou exclusão de membros sao feitas por email para TI, que configura manualmente no sistema. Sem visibilidade de quem pertence a cada grupo, sem self-service, e logs de alterações dispersos dificultando auditorias.",
  "passos_as_is": "Gestor identifica necessidade de adicionar/remover membro de grupo|Envia email para TI solicitando alteração|TI recebe e-mail e acessa configurações do Salesforce|Realiza configuração manual de membros no grupo|Responde email confirmando alteração|Sem registro centralizado de quem fez a solicitação|Histórico de alterações disperso em logs do sistema",
  "problemas_as_is": "Processo manual e dependente de TI|Sem self-service para gestores|Dificil auditar alterações em grupos|Logs dispersos em diferentes locais|Demora no atendimento de solicitações|Sem visibilidade de membros atuais de cada grupo|Risco de grupos desatualizados|Sobrecarga de TI com tarefas operacionais",
  "tempo_medio_as_is": "Dias",
  "to_be": "Hub centralizado de gestão de grupos de Ocorrencias de Clientes (OC) implementado como Lightning Web Component (LWC) no Salesforce. Permite que gestores faca manutenção de grupos em self-service, com busca por email/nome, adição/remocao de membros, e logs centralizados de todas as alterações.",
  "passos_to_be": "Gestor acessa o Hub de Gestão OC no Salesforce|Visualiza lista de grupos disponiveis para gestão|Seleciona grupo desejado (Comercial, Qualidade, Sistemas, etc)|Visualiza membros atuais do grupo|Busca usuário por email ou nome para adicionar|Adiciona ou remove membros com um clique|Sistema registra automáticamente a alteração com data/hora/usuário|Gestor visualiza histórico de alterações do grupo|Notificações enviadas aos membros afetados",
  "beneficios_to_be": "Self-service completo sem depender de TI|Visibilidade de todos os membros de cada grupo|Controle de perfis e acessos centralizado|Logs centralizados de todas as alterações|Auditoria fácilitada com histórico completo|Redução de carga operacional de TI|Ágilidade nas alterações de grupo|Notificações automáticas de inclusao/exclusão|Interface moderna via LWC",
  "tempo_medio_to_be": "Minutos",
  "areas_impactadas": "TI|Comercial|Qualidade|Atendimento|Todas as áreas com grupos de OC",
  "sistemas_tecnicos": "Salesforce|Lightning Web Component (LWC)",
  "fonte_reuniao": "Documentos de teste",
  "fontes_reuniao": "889851 - Hub de gestão OC (Dez/2025)|891121 - Redesign/revamp das telas de replicação de dados mestres",
  "pendencias": "Definição de perfis com permissão de gestão|Configuração de notificações por email|Testes de integração com grupos existentes|Documentação de usuário final",
  "prerequisitos": "LWC Hub Gestão desenvolvido e implantado|Grupos de OC configurados no Salesforce|Perfis de gestores definidos|Usuários ativos no sistema",
  "campos_processo": [
    {
      "campo": "Grupo",
      "descrição": "Nome do grupo de OC",
      "preenchimento": "Seleção",
      "validação": "Obrigatório",
      "obrigatório": true
    },
    {
      "campo": "Membro",
      "descrição": "Usuário membro do grupo",
      "preenchimento": "Busca por email/nome",
      "validação": "Usuário ativo no Salesforce",
      "obrigatório": true
    },
    {
      "campo": "Data Inclusao",
      "descrição": "Data em que membro foi adicionado",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Incluido Por",
      "descrição": "Usuário que adicionou o membro",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true
    },
    {
      "campo": "Status",
      "descrição": "Status do membro no grupo",
      "preenchimento": "Automático",
      "validação": "-",
      "obrigatório": true,
      "valores": [
        "Ativo",
        "Inativo"
      ]
    }
  ],
  "regras_negocio": [
    {
      "regra": "Acesso por Perfil",
      "descrição": "Apenas usuários com perfil de gestor podem adicionar/remover membros de grupos"
    },
    {
      "regra": "Busca por Email ou Nome",
      "descrição": "Sistema permite buscar usuários por email completo ou parte do nome"
    },
    {
      "regra": "Log de Alterações",
      "descrição": "Todas as alterações (adição, remocao) sao registradas com data/hora e usuário responsável"
    },
    {
      "regra": "Notificação de Membros",
      "descrição": "Ao ser adicionado ou removido de um grupo, membro recebe notificação por email"
    },
    {
      "regra": "Prevenção de Duplicidade",
      "descrição": "Sistema não permite adicionar o mesmo usuário duas vezes ao mesmo grupo"
    }
  ],
  "integracoes": [
    {
      "origem": "LWC Hub Gestão",
      "destino": "Salesforce Groups",
      "tipo": "Apex",
      "descrição": "Gerênciamento de membros via classes Apex"
    },
    {
      "origem": "Hub Gestão",
      "destino": "Email",
      "tipo": "Workflow",
      "descrição": "Notificações automáticas para membros"
    }
  ],
  "ciclos_teste": [
    {
      "documento": "889851",
      "título": "Hub de Gestão OC",
      "status": "Pendente",
      "data": "2025-12",
      "descrição": "Testes do componente LWC de gestão de grupos de OC",
      "cenarios": [
        "Visualização de grupos disponiveis",
        "Adição de membro por busca de email",
        "Adição de membro por busca de nome",
        "Remocao de membro existente",
        "Tentativa de adição duplicada",
        "Visualização de logs de alterações",
        "Validação de permissoes de gestor"
      ]
    },
    {
      "documento": "891121",
      "título": "Redesign das Telas de Replicação de Dados Mestres",
      "status": "Pendente",
      "data": "2025-12",
      "descrição": "Revamp de interface relacionada a gestão de dados mestres",
      "cenarios": [
        "Novo layout das telas de dados mestres",
        "Navegação entre telas de replicação",
        "Validação de campos obrigatórios",
        "Sincronização de dados entre sistemas"
      ]
    }
  ],
  "mensagens_sistema": [
    {
      "tipo": "Sucesso",
      "contexto": "Membro Adicionado",
      "mensagem": "Usuário {nome} adicionado ao grupo {grupo} com sucesso"
    },
    {
      "tipo": "Sucesso",
      "contexto": "Membro Removido",
      "mensagem": "Usuário {nome} removido do grupo {grupo}"
    },
    {
      "tipo": "Erro",
      "contexto": "Usuário Duplicado",
      "mensagem": "Usuário ja pertence a este grupo"
    },
    {
      "tipo": "Erro",
      "contexto": "Usuário Não Encontrado",
      "mensagem": "Nenhum usuário encontrado com os critérios informados"
    },
    {
      "tipo": "Alerta",
      "contexto": "Sem Permissão",
      "mensagem": "Voce não tem permissão para gerênciar este grupo"
    }
  ],
  "detalhes": {
    "lwc": "Lightning Web Component - componente moderno do Salesforce",
    "grupos": [
      "Comercial",
      "Qualidade",
      "Sistemas"
    ],
    "funcionalidades": [
      "Visualização de membros",
      "Busca por email/nome",
      "Adição/remocao de membros",
      "Histórico de alterações",
      "Notificações automáticas"
    ]
  },
  "contexto_reuniao": {
    "projeto": "GTM (Go To Market) / CRM",
    "liderança": {
      "business": "Thalita Merisio Rhein",
      "técnico": "Leandro da Cruz Pereira"
    },
    "timeline": {
      "workshops": "04/12 a 22/12/2025",
      "posWorkshop": "Responsabilidade passa para usuários (Castro)",
      "entregaveis": [
        "Planilha de cenarios",
        "Manual de orientação"
      ]
    },
    "participantes": [
      {
        "nome": "Leandro da Cruz Pereira",
        "papel": "TI/Apresentador"
      },
      {
        "nome": "Thalita Merisio Rhein",
        "papel": "Project Lead Business"
      }
    ],
    "nota": "Hub de Gestão OC não foi discutido diretamente nas reuniões de 04/12, 10/12 ou 16/12. Informações baseadas exclusivamente nos documentos do Tester TI."
  }
}');

-- =============================================================================
-- Jornada 12: Restrições Logísticas
-- Fonte: data/jornadas/restricoes-logisticas.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Restrições Logísticas",
  "icone": "🚛",
  "ordem": 12,
  "status": "Pendente",
  "as_is": "Restrições de entrega gerenciadas em sistemas separados sem integração, causando problemas de comunicação entre áreas",
  "passos_as_is": "Informações de restrição registradas no Portal Logístico|Dados duplicados manualmente no SAP|Vendedor consulta XD03 para ver restrições|Sem visibilidade em tempo real para o cliente|Agendamentos feitos por telefone ou email",
  "problemas_as_is": "Redundância de dados entre Portal Logístico e SAP|Inconsistências nas informações de restrição|Cliente não tem visibilidade das restrições|Agendamentos manuais sujeitos a erros|Sem integração em tempo real",
  "tempo_medio_as_is": "Variável",
  "to_be": "Integração Salesforce → SAP → Portal Logístico em tempo real para gestão centralizada de restrições de entrega",
  "passos_to_be": "Vendedor registra restrições no Salesforce|Sistema sincroniza automaticamente com SAP|Integração em tempo real com Portal Logístico|Cliente visualiza restrições no autoatendimento|Agendamentos online com confirmação automática",
  "beneficios_to_be": "Dados unificados em todos os sistemas|Visibilidade em tempo real|Cliente com autonomia para consultar restrições|Eliminação de redundância de dados|Processo de agendamento otimizado",
  "tempo_medio_to_be": "Imediato",
  "areas_impactadas": "Logística|Comercial|TI|Atendimento",
  "sistemas_tecnicos": "Salesforce|SAP ECC|Portal Logístico",
  "fonte_reuniao": "10/12/2025",
  "pendencias": "Integração Portal Logístico com SAP pendente|Definição de campos obrigatórios de restrição|Reunião específica agendada com equipe de logística",
  "detalhes": {
    "tiposRestrição": [
      {
        "tipo": "Veículo",
        "descrição": "Restrições de tipo de veículo para entrega",
        "exemplos": [
          "3/4",
          "Truque",
          "Sider",
          "Carreta"
        ]
      },
      {
        "tipo": "Janela de Entrega",
        "descrição": "Horários permitidos para recebimento",
        "exemplos": [
          "08:00-12:00",
          "14:00-17:00",
          "Somente manhã"
        ]
      },
      {
        "tipo": "Agendamento",
        "descrição": "Necessidade de agendamento prévio",
        "opções": [
          "Obrigatório",
          "Recomendado",
          "Não necessário"
        ]
      },
      {
        "tipo": "Descarga",
        "descrição": "Condições especiais de descarga",
        "exemplos": [
          "Empilhadeira própria",
          "Doca necessária",
          "Paletizado"
        ]
      }
    ],
    "transaçãoSAP": "XD03 - Exibir Cliente (Restrições na ordem de embarque)",
    "integração": "Portal Logístico ↔ SAP ↔ Salesforce"
  }
}');

-- =============================================================================
-- Jornada 13: Market Share e Concorrentes
-- Fonte: data/jornadas/market-share.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "Market Share e Concorrentes",
  "icone": "📊",
  "ordem": 13,
  "status": "Pendente",
  "as_is": "Informações de concorrentes e market share dispersas, sem gestão centralizada ou análise sistemática",
  "passos_as_is": "Vendedor coleta informações de concorrentes informalmente|Dados registrados em planilhas individuais|Projetos perdidos não vinculados a concorrentes|Sem histórico de market share por cliente|Análise de mercado feita manualmente",
  "problemas_as_is": "Informações de concorrentes sazonais e dinâmicas|Dificuldade em vincular projetos perdidos a concorrentes específicos|Sem visão consolidada de share of wallet|Dados fragmentados e inconsistentes|Impossível rastrear tendências de mercado",
  "tempo_medio_as_is": "N/A",
  "to_be": "Gestão centralizada de concorrentes e market share no Salesforce com análise automatizada",
  "passos_to_be": "Cadastro normalizado de concorrentes no Salesforce|Registro de share of wallet por cliente|Vinculação de oportunidades perdidas a concorrentes|Dashboard de análise de mercado automático|Histórico de evolução de market share",
  "beneficios_to_be": "Visão consolidada de concorrentes por região/segmento|Análise de share of wallet por cliente|Identificação de tendências de mercado|Decisões estratégicas baseadas em dados|Rastreamento de projetos perdidos para concorrência",
  "tempo_medio_to_be": "5 minutos por registro",
  "areas_impactadas": "Comercial|Marketing|Estratégia|Inteligência de Mercado",
  "sistemas_tecnicos": "Salesforce|Power BI",
  "fonte_reuniao": "10/12/2025",
  "pendencias": "Normalização de cadastro de concorrentes pela TI|Definição de critérios para vinculação de projetos perdidos|Discussão com Edmundo sobre gestão de dados de concorrentes",
  "detalhes": {
    "shareOfWallet": {
      "descrição": "Percentual de compra do cliente na Belgo versus concorrentes",
      "cálculo": "Volume Belgo / Volume Total Cliente",
      "objetivo": "Identificar potencial de crescimento em cada conta"
    },
    "concorrentes": {
      "cadastro": "Lista normalizada pela TI",
      "desafio": "Concorrentes são sazonais e dinâmicos por região",
      "responsável": "Discussão agendada com Edmundo"
    },
    "marketShareTipos": {
      "estratégico": "Visão de longo prazo por segmento",
      "tático": "Visão de curto prazo por oportunidade"
    }
  }
}');

-- =============================================================================
-- Jornada 14: AMD Cross Company
-- Fonte: data/jornadas/amd-cross-company.json
-- =============================================================================
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 18, '{
  "nome": "AMD Cross Company",
  "icone": "🔄",
  "ordem": 14,
  "status": "Pendente",
  "as_is": "Processo de vendas entre empresas do grupo ArcelorMittal não contemplado no Salesforce atual",
  "passos_as_is": "AMD (ArcelorMittal Distribuição) gerencia vendas em sistema próprio|Transações cross company processadas manualmente|Sem integração com Salesforce|Visibilidade limitada para equipe comercial",
  "problemas_as_is": "Processo AMD não tem funcionalidades no Salesforce|Processo Cross Company não contemplado|Falta de rastreabilidade de vendas intercompany|Dificuldade de consolidação de resultados",
  "tempo_medio_as_is": "Variável",
  "to_be": "Integração do processo AMD Cross Company no Salesforce para gestão unificada de vendas intercompany",
  "passos_to_be": "Registro de transações AMD no Salesforce|Workflow de aprovação para vendas cross company|Integração com SAP para contabilização|Relatórios consolidados de vendas intercompany|Visibilidade completa para equipe comercial",
  "beneficios_to_be": "Gestão unificada de vendas do grupo|Rastreabilidade completa de transações intercompany|Consolidação de resultados facilitada|Visibilidade para todas as áreas|Processo padronizado e auditável",
  "tempo_medio_to_be": "A definir",
  "areas_impactadas": "Comercial|Financeiro|Controladoria|AMD",
  "sistemas_tecnicos": "Salesforce|SAP ECC|Sistema AMD",
  "fonte_reuniao": "10/12/2025",
  "pendencias": "Reunião específica agendada com Renata Mello e Victoria|Definição de escopo de funcionalidades AMD no Salesforce|Mapeamento de processo cross company",
  "detalhes": {
    "amd": {
      "nome": "ArcelorMittal Distribuição",
      "descrição": "Empresa do grupo para distribuição de produtos",
      "processo": "Vendas entre empresas do grupo (intercompany)"
    },
    "crossCompany": {
      "descrição": "Transações de venda entre diferentes empresas do grupo ArcelorMittal",
      "desafio": "Contabilização e rastreamento entre entidades legais distintas"
    },
    "responsável": "Renata Mello e Victoria"
  }
}');


-- Verificar resultado
SELECT
  json_extract(dados, '$.nome') as nome,
  json_extract(dados, '$.ordem') as ordem,
  json_extract(dados, '$.status') as status,
  length(dados) as tamanho_dados
FROM projeto_dados
WHERE entidade_id = 18 AND projeto_id = 5
ORDER BY json_extract(dados, '$.ordem');
