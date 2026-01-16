-- =====================================================
-- Migration 018: Importar dados de Riscos/Pontos Críticos
-- Projeto 5 (GTM Clone) - Entidade ID 23
-- =====================================================

-- Limpar dados existentes de riscos do projeto 5
DELETE FROM projeto_dados WHERE entidade_id = 23 AND projeto_id = 5;

-- PC-01: Key Users não identificados
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 23, '{
    "titulo": "Key Users não identificados formalmente",
    "descricao": "Alguns usuários-chave designados não sabiam que eram key users, chegando despreparados para as responsabilidades de teste",
    "probabilidade": "Alta",
    "impacto": "Médio",
    "status": "Mitigado",
    "mitigacao": "Declarado requisito para todos os gerentes identificarem formalmente key users com 2h semanais dedicadas",
    "responsavel": "Thalita Rhein",
    "data_identificacao": "2025-12-04"
}');

-- PC-02: Gap de conhecimento AS IS / TO BE
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 23, '{
    "titulo": "Gap de conhecimento AS IS / TO BE",
    "descricao": "O que tenho que testar? O que muda no meu processo? Não sei, não participei, não tenho visão.",
    "probabilidade": "Alta",
    "impacto": "Alto",
    "status": "Mitigado",
    "mitigacao": "Workshops semanais de mapeamento AS IS - TO BE concluídos (4 sessões realizadas)",
    "responsavel": "Leandro Cruz / Thalita Rhein",
    "data_identificacao": "2025-12-04"
}');

-- PC-03: Gestão de Dados de Concorrentes
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 23, '{
    "titulo": "Gestão de Dados de Concorrentes",
    "descricao": "Informações de concorrentes são sazonais e dinâmicas. Dificuldade em vincular projetos perdidos a concorrentes específicos.",
    "probabilidade": "Média",
    "impacto": "Médio",
    "status": "Identificado",
    "mitigacao": "Discussão agendada com Edmundo. Normalização de concorrentes pela TI.",
    "responsavel": "Leandro Cruz",
    "data_identificacao": "2025-12-10"
}');

-- PC-04: Integração Portal Logístico pendente
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 23, '{
    "titulo": "Integração Portal Logístico pendente",
    "descricao": "Portal logístico atualmente não integrado com SAP, causando redundância de dados entre sistemas",
    "probabilidade": "Alta",
    "impacto": "Alto",
    "status": "Identificado",
    "mitigacao": "Reunião de follow-up agendada para verificar integração SAP - Portal Logístico",
    "responsavel": "Leandro Cruz",
    "data_identificacao": "2025-12-16"
}');

-- PC-05: Dados de contato incompletos
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 23, '{
    "titulo": "Dados de contato incompletos para autoatendimento",
    "descricao": "Funcionamento do autoatendimento depende de dados de contato atualizados, muitos cadastros estão incompletos",
    "probabilidade": "Alta",
    "impacto": "Alto",
    "status": "Em Tratamento",
    "mitigacao": "Campanha de atualização de cadastros iniciada",
    "responsavel": "Equipe Comercial",
    "data_identificacao": "2025-12-16"
}');

-- PC-06: Mudança de estrutura comercial
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 23, '{
    "titulo": "Reestruturação comercial em andamento",
    "descricao": "Nova estrutura com diretoria comercial e 4 macro setores requer migração de todos os 46 segmentos e clientes",
    "probabilidade": "Alta",
    "impacto": "Alto",
    "status": "Em Tratamento",
    "mitigacao": "Finalizar hierarquia comercial no ECC, montar lista de escritórios de vendas, migrar clientes para nova estrutura",
    "responsavel": "Gimenes/Ciorlia/Riqueti",
    "data_identificacao": "2025-12-22"
}');

-- PC-07: Não modificar escritórios até 30/01
INSERT INTO projeto_dados (projeto_id, entidade_id, dados)
VALUES (5, 23, '{
    "titulo": "Deadline crítico - Escritórios de vendas",
    "descricao": "Não modificar estrutura de escritórios até 30/01 para permitir migração correta",
    "probabilidade": "Média",
    "impacto": "Alto",
    "status": "Identificado",
    "mitigacao": "Comunicado para equipe sobre congelamento de alterações em escritórios",
    "responsavel": "Marcelo Almeida",
    "data_identificacao": "2025-12-29"
}');
