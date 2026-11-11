-- =====================================================================
-- Sistema de gestao de manutencao de geradores - S. A. DE LIMA
-- SCRIPT UNIFICADO: estrutura (DDL) + consultas no final
-- SGBD: MySQL 8.0.16+ (necessario para CHECK)
-- Os codigos P (problemas), RN (regras de negocio) e RF (requisitos)
-- citados nos comentarios estao definidos no README.md.
--
-- Ordem interna: 1. CREATE TABLE -> 2. FKs -> 3. Triggers ->
--                (massa de dados, se houver) -> 4. Consultas
--
-- ATENCAO: a massa de dados (02_massa_dados.sql) NAO faz parte deste
-- arquivo. Para que as consultas retornem resultados, cole o conteudo
-- dela no ponto indicado "MASSA DE DADOS" antes da secao de consultas.
-- Sem dados, os SELECT retornam vazio e os UPDATE/DELETE nao afetam linhas.
-- =====================================================================

DROP DATABASE IF EXISTS gestao_geradores;
CREATE DATABASE gestao_geradores
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE gestao_geradores;
SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- 1. CREATE TABLE
-- ---------------------------------------------------------------------

-- RNF01: cpf_cnpj e endereco devem ser criptografados em repouso.
-- A criptografia e prevista e depende de configuracao no servidor
-- (ex.: AES_ENCRYPT); nesta massa de teste os dados estao em texto claro.
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf_cnpj VARCHAR(14) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    email VARCHAR(120) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    CONSTRAINT uq_cliente_cpf_cnpj UNIQUE (cpf_cnpj),                         -- RN01
    CONSTRAINT chk_cliente_doc CHECK (cpf_cnpj REGEXP '^([0-9]{11}|[0-9]{14})$'),   -- 11 (CPF) ou 14 (CNPJ) digitos
    CONSTRAINT chk_cliente_estado CHECK (estado IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO')),
    CONSTRAINT chk_cliente_email CHECK (email LIKE '%@%')
) ENGINE=InnoDB;

CREATE TABLE Contrato (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,                                                   -- RN12: um unico cliente
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,                                                        -- NULL = prazo indeterminado
    valor_mensal DECIMAL(10,2) NOT NULL,
    tipo_periodicidade VARCHAR(20) NOT NULL DEFAULT 'Mensal',
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',
    CONSTRAINT chk_contrato_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio),
    CONSTRAINT chk_contrato_encerrado CHECK (status <> 'Encerrado' OR data_fim IS NOT NULL),
    CONSTRAINT chk_contrato_valor CHECK (valor_mensal > 0),
    CONSTRAINT chk_contrato_period CHECK (tipo_periodicidade IN ('Mensal','Bimestral','Trimestral','Semestral','Anual')),
    CONSTRAINT chk_contrato_status CHECK (status IN ('Ativo','Encerrado','Cancelado'))
) ENGINE=InnoDB;

CREATE TABLE Gerador (
    id_gerador INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,                                                   -- RN02
    id_contrato INT NULL,                                                      -- gerador avulso nao tem contrato
    numero_serie VARCHAR(30) NOT NULL,
    marca VARCHAR(60) NOT NULL,
    modelo VARCHAR(60) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',
    potencia DECIMAL(8,2) NOT NULL,                                            -- em kVA
    horimetro INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_gerador_serie UNIQUE (numero_serie),                        -- RN03
    CONSTRAINT chk_gerador_status CHECK (status IN ('Ativo','Em manutencao','Inativo')),   -- RN04
    CONSTRAINT chk_gerador_potencia CHECK (potencia > 0),
    CONSTRAINT chk_gerador_horimetro CHECK (horimetro >= 0)
) ENGINE=InnoDB;

CREATE TABLE Peca (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome_peca VARCHAR(120) NOT NULL,
    descricao_peca VARCHAR(255),
    valor_venda DECIMAL(10,2) NOT NULL,
    prazo_troca_dias INT NULL,
    prazo_troca_horas INT NULL,
    estoque INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_peca_nome UNIQUE (nome_peca),
    CONSTRAINT chk_peca_valor CHECK (valor_venda >= 0),
    CONSTRAINT chk_peca_estoque CHECK (estoque >= 0),                         -- RN23
    CONSTRAINT chk_peca_prazos CHECK (
        (prazo_troca_dias IS NOT NULL OR prazo_troca_horas IS NOT NULL) AND
        (prazo_troca_dias IS NULL OR prazo_troca_dias > 0) AND
        (prazo_troca_horas IS NULL OR prazo_troca_horas > 0))                 -- RN08: ao menos um prazo
) ENGINE=InnoDB;

CREATE TABLE Cronograma_Preventivo (
    id_cronograma INT AUTO_INCREMENT PRIMARY KEY,
    id_gerador INT NOT NULL,
    id_peca INT NOT NULL,
    data_ultima_troca DATE NULL,                                               -- NULL ate a primeira intervencao
    horimetro_ultima_troca INT NULL,
    CONSTRAINT uq_cronograma_gerador_peca UNIQUE (id_gerador, id_peca),       -- um registro por peca em cada gerador
    CONSTRAINT chk_cronograma_horimetro CHECK (horimetro_ultima_troca IS NULL OR horimetro_ultima_troca >= 0)
) ENGINE=InnoDB;

CREATE TABLE Orcamento (
    id_orcamento INT AUTO_INCREMENT PRIMARY KEY,
    id_gerador INT NOT NULL,
    data_orcamento DATE NOT NULL,
    valor_orcado DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    data_aprovacao DATE NULL,
    CONSTRAINT chk_orcamento_valor CHECK (valor_orcado > 0),
    CONSTRAINT chk_orcamento_status CHECK (status IN ('Pendente','Aprovado','Recusado')),     -- RN11
    CONSTRAINT chk_orcamento_aprov CHECK (
        status <> 'Aprovado' OR (data_aprovacao IS NOT NULL AND data_aprovacao >= data_orcamento))
) ENGINE=InnoDB;

CREATE TABLE Manutencao (
    id_manutencao INT AUTO_INCREMENT PRIMARY KEY,
    id_gerador INT NOT NULL,                                                   -- RN05
    id_orcamento INT NULL,
    id_contrato INT NULL,
    data_manutencao DATE NOT NULL,
    tipo_manutencao VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Aberta',
    numero_nota_fiscal VARCHAR(20) NULL,
    descricao_problema VARCHAR(255),
    data_conclusao DATE NULL,
    CONSTRAINT uq_manutencao_orcamento UNIQUE (id_orcamento),                 -- um orcamento gera no maximo uma manutencao
    CONSTRAINT chk_manut_tipo CHECK (tipo_manutencao IN ('Preventiva','Corretiva')),
    CONSTRAINT chk_manut_status CHECK (status IN ('Aberta','Em andamento','Concluida')),      -- RN16
    CONSTRAINT chk_manut_conclusao CHECK (
        status <> 'Concluida' OR (data_conclusao IS NOT NULL AND data_conclusao >= data_manutencao)),
    CONSTRAINT chk_manut_corretiva CHECK (tipo_manutencao = 'Preventiva' OR id_orcamento IS NOT NULL)  -- RN10
) ENGINE=InnoDB;

CREATE TABLE Servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome_servico VARCHAR(120) NOT NULL,
    descricao VARCHAR(255),
    valor_base DECIMAL(10,2) NOT NULL,
    CONSTRAINT uq_servico_nome UNIQUE (nome_servico),                         -- RN19
    CONSTRAINT chk_servico_valor CHECK (valor_base >= 0)
) ENGINE=InnoDB;

CREATE TABLE Tecnico (
    id_tecnico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf CHAR(11) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(120),
    CONSTRAINT uq_tecnico_cpf UNIQUE (cpf),                                   -- RN17
    CONSTRAINT chk_tecnico_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),              -- RN17
    CONSTRAINT chk_tecnico_email CHECK (email IS NULL OR email LIKE '%@%')
) ENGINE=InnoDB;

CREATE TABLE Fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(120),
    CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj),                              -- RN22
    CONSTRAINT uq_fornecedor_telefone UNIQUE (telefone),
    CONSTRAINT chk_fornecedor_cnpj CHECK (cnpj REGEXP '^[0-9]{14}$'),
    CONSTRAINT chk_fornecedor_email CHECK (email IS NULL OR email LIKE '%@%')
) ENGINE=InnoDB;

CREATE TABLE Compra (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,                                                -- RN23
    data_compra DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pedida',
    numero_nota_fiscal VARCHAR(20) NULL,
    CONSTRAINT chk_compra_status CHECK (status IN ('Pedida','Recebida','Cancelada'))
) ENGINE=InnoDB;

CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_manutencao INT NULL,
    id_contrato INT NULL,
    numero_parcela INT NOT NULL DEFAULT 1,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE NULL,
    forma VARCHAR(20) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    valor_parcela DECIMAL(10,2) NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT uq_pag_manut_parcela UNIQUE (id_manutencao, numero_parcela),
    CONSTRAINT uq_pag_contrato_parcela UNIQUE (id_contrato, numero_parcela),
    -- RN20: exatamente uma origem (manutencao OU contrato)
    CONSTRAINT chk_pag_origem CHECK ((id_manutencao IS NULL AND id_contrato IS NOT NULL)
                                  OR (id_manutencao IS NOT NULL AND id_contrato IS NULL)),
    CONSTRAINT chk_pag_parcela CHECK (numero_parcela > 0),
    CONSTRAINT chk_pag_valores CHECK (valor_parcela > 0 AND valor_pago >= 0),
    CONSTRAINT chk_pag_forma CHECK (forma IS NULL OR forma IN ('Boleto','PIX','Cartao','Transferencia','Dinheiro')),
    CONSTRAINT chk_pag_status CHECK (status IN ('Pendente','Pago','Atrasado','Cancelado')),
    CONSTRAINT chk_pag_pago CHECK (status <> 'Pago' OR (data_pagamento IS NOT NULL AND forma IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE Escala (
    id_escala INT AUTO_INCREMENT PRIMARY KEY,
    id_tecnico INT NOT NULL,                                                   -- RN18
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    turno VARCHAR(20) NOT NULL,
    folga VARCHAR(20) NULL,
    CONSTRAINT chk_escala_datas CHECK (data_fim >= data_inicio),              -- RN18
    CONSTRAINT chk_escala_turno CHECK (turno IN ('Manha','Tarde','Noite','Integral'))
) ENGINE=InnoDB;

CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(60) NOT NULL,
    perfil VARCHAR(20) NOT NULL,                                               -- perfil Tecnico sem vinculo com a tabela Tecnico
    senha_hash VARCHAR(255) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,                                       -- exclusao logica (RF17)
    CONSTRAINT uq_usuario_login UNIQUE (login),                               -- RN25
    CONSTRAINT chk_usuario_perfil CHECK (perfil IN ('Administrador','Atendimento','Tecnico','Financeiro'))
) ENGINE=InnoDB;

CREATE TABLE Log_acesso (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,                                                   -- usuario obrigatorio; login de usuario inexistente nao e registrado
    data_hora_acesso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    acao VARCHAR(20) NOT NULL,
    nome_tabela VARCHAR(64) NULL,
    id_registro INT NULL,
    resultado VARCHAR(20) NOT NULL,
    finalidade_acesso VARCHAR(150) NULL,                                      -- LGPD
    CONSTRAINT chk_log_acao CHECK (acao IN ('LOGIN','LOGOUT','SELECT','INSERT','UPDATE','DELETE')),
    CONSTRAINT chk_log_resultado CHECK (resultado IN ('Sucesso','Negado'))
) ENGINE=InnoDB;

CREATE TABLE Aditivo_contrato (
    id_aditivo INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT NOT NULL,
    data_aditivo DATE NOT NULL,
    alteracao_realizada VARCHAR(500) NOT NULL,
    condicoes_anteriores VARCHAR(500) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Contas_a_pagar (
    id_conta_pagar INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,
    descricao VARCHAR(150) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    data_vencimento DATE NOT NULL,
    numero_boleto VARCHAR(48) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    data_pagamento DATE NULL,
    CONSTRAINT uq_cap_boleto UNIQUE (numero_boleto),                          -- RN24
    CONSTRAINT chk_cap_status CHECK (status IN ('Pendente','Paga')),
    CONSTRAINT chk_cap_valor CHECK (valor_total > 0),
    -- RN24: sem pagamento parcial; "Paga" somente com valor pago = valor total
    CONSTRAINT chk_cap_quitacao CHECK (
        (status = 'Paga' AND valor_pago = valor_total AND data_pagamento IS NOT NULL)
        OR (status <> 'Paga' AND valor_pago = 0 AND data_pagamento IS NULL))
) ENGINE=InnoDB;

-- ---- Tabelas associativas (chave primaria composta) ----

CREATE TABLE utiliza (                                                         -- Manutencao x Servico
    id_manutencao INT NOT NULL,
    id_servico INT NOT NULL,
    valor_unitario_aplicado DECIMAL(10,2) NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_manutencao, id_servico),
    CONSTRAINT chk_utiliza_qtd CHECK (quantidade > 0 AND valor_unitario_aplicado >= 0)   -- RN15
) ENGINE=InnoDB;

CREATE TABLE realizada_por (                                                   -- Manutencao x Tecnico
    id_manutencao INT NOT NULL,
    id_tecnico INT NOT NULL,
    PRIMARY KEY (id_manutencao, id_tecnico)
) ENGINE=InnoDB;

CREATE TABLE usa (                                                             -- Manutencao x Peca
    id_manutencao INT NOT NULL,
    id_peca INT NOT NULL,
    valor_unitario_aplicado DECIMAL(10,2) NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_manutencao, id_peca),
    CONSTRAINT chk_usa_qtd CHECK (quantidade > 0 AND valor_unitario_aplicado >= 0)
) ENGINE=InnoDB;

CREATE TABLE contem (                                                          -- Compra x Peca
    id_compra INT NOT NULL,
    id_peca INT NOT NULL,
    valor_custo DECIMAL(10,2) NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_compra, id_peca),
    CONSTRAINT chk_contem_qtd CHECK (quantidade > 0 AND valor_custo >= 0)
) ENGINE=InnoDB;

CREATE TABLE atualiza (                                                        -- Manutencao x Cronograma
    id_manutencao INT NOT NULL,
    id_cronograma INT NOT NULL,
    PRIMARY KEY (id_manutencao, id_cronograma)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. CHAVES ESTRANGEIRAS
-- ---------------------------------------------------------------------
ALTER TABLE Contrato ADD CONSTRAINT fk_contrato_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente);
ALTER TABLE Gerador ADD CONSTRAINT fk_gerador_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente);
ALTER TABLE Gerador ADD CONSTRAINT fk_gerador_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato (id_contrato);
ALTER TABLE Cronograma_Preventivo ADD CONSTRAINT fk_cronograma_gerador FOREIGN KEY (id_gerador) REFERENCES Gerador (id_gerador);
ALTER TABLE Cronograma_Preventivo ADD CONSTRAINT fk_cronograma_peca FOREIGN KEY (id_peca) REFERENCES Peca (id_peca);
ALTER TABLE Orcamento ADD CONSTRAINT fk_orcamento_gerador FOREIGN KEY (id_gerador) REFERENCES Gerador (id_gerador);
ALTER TABLE Manutencao ADD CONSTRAINT fk_manutencao_gerador FOREIGN KEY (id_gerador) REFERENCES Gerador (id_gerador);
ALTER TABLE Manutencao ADD CONSTRAINT fk_manutencao_orcamento FOREIGN KEY (id_orcamento) REFERENCES Orcamento (id_orcamento);
ALTER TABLE Manutencao ADD CONSTRAINT fk_manutencao_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato (id_contrato);
ALTER TABLE Compra ADD CONSTRAINT fk_compra_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor (id_fornecedor);
ALTER TABLE Pagamento ADD CONSTRAINT fk_pagamento_manutencao FOREIGN KEY (id_manutencao) REFERENCES Manutencao (id_manutencao);
ALTER TABLE Pagamento ADD CONSTRAINT fk_pagamento_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato (id_contrato);
ALTER TABLE Escala ADD CONSTRAINT fk_escala_tecnico FOREIGN KEY (id_tecnico) REFERENCES Tecnico (id_tecnico);
ALTER TABLE Log_acesso ADD CONSTRAINT fk_log_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario);
ALTER TABLE Aditivo_contrato ADD CONSTRAINT fk_aditivo_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato (id_contrato);
ALTER TABLE Contas_a_pagar ADD CONSTRAINT fk_cap_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor (id_fornecedor);
ALTER TABLE utiliza ADD CONSTRAINT fk_utiliza_manutencao FOREIGN KEY (id_manutencao) REFERENCES Manutencao (id_manutencao);
ALTER TABLE utiliza ADD CONSTRAINT fk_utiliza_servico FOREIGN KEY (id_servico) REFERENCES Servico (id_servico);
ALTER TABLE realizada_por ADD CONSTRAINT fk_realizada_manutencao FOREIGN KEY (id_manutencao) REFERENCES Manutencao (id_manutencao);
ALTER TABLE realizada_por ADD CONSTRAINT fk_realizada_tecnico FOREIGN KEY (id_tecnico) REFERENCES Tecnico (id_tecnico);
ALTER TABLE usa ADD CONSTRAINT fk_usa_manutencao FOREIGN KEY (id_manutencao) REFERENCES Manutencao (id_manutencao);
ALTER TABLE usa ADD CONSTRAINT fk_usa_peca FOREIGN KEY (id_peca) REFERENCES Peca (id_peca);
ALTER TABLE contem ADD CONSTRAINT fk_contem_compra FOREIGN KEY (id_compra) REFERENCES Compra (id_compra);
ALTER TABLE contem ADD CONSTRAINT fk_contem_peca FOREIGN KEY (id_peca) REFERENCES Peca (id_peca);
ALTER TABLE atualiza ADD CONSTRAINT fk_atualiza_manutencao FOREIGN KEY (id_manutencao) REFERENCES Manutencao (id_manutencao);
ALTER TABLE atualiza ADD CONSTRAINT fk_atualiza_cronograma FOREIGN KEY (id_cronograma) REFERENCES Cronograma_Preventivo (id_cronograma);

-- ---------------------------------------------------------------------
-- 3. TRIGGERS DE IMUTABILIDADE (RNF03, RN21, RN26, RN27, REST05)
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_log_sem_update BEFORE UPDATE ON Log_acesso FOR EACH ROW
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Log_acesso aceita apenas INSERT (RNF03)';
CREATE TRIGGER trg_log_sem_delete BEFORE DELETE ON Log_acesso FOR EACH ROW
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Log_acesso aceita apenas INSERT (RNF03)';
CREATE TRIGGER trg_aditivo_sem_delete BEFORE DELETE ON Aditivo_contrato FOR EACH ROW
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aditivos nao podem ser excluidos (RN27)';
CREATE TRIGGER trg_pagamento_sem_delete BEFORE DELETE ON Pagamento FOR EACH ROW
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pagamento nao e excluido: cancele ou corrija (RN21)';
CREATE TRIGGER trg_contrato_sem_delete BEFORE DELETE ON Contrato FOR EACH ROW
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Contrato nao pode ser excluido (REST05)';
CREATE TRIGGER trg_usuario_sem_delete BEFORE DELETE ON Usuario FOR EACH ROW
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario nao e excluido: desative (RF17)';


-- =====================================================================
-- CONSULTAS - gestao_geradores (S. A. DE LIMA)
-- @hoje fixa a data de referencia da massa de dados (08/11/2026).
-- Em producao, troque por CURDATE().
-- Inclui G15 (MTBF) e G16 (First Fix Rate).
-- =====================================================================
SET @hoje = DATE('2026-11-08');

-- ---------------------------------------------------------------------
-- 5. SELECT COM JOIN
-- ---------------------------------------------------------------------

-- S01 - Historico de manutencoes com cliente e gerador (RF02)
SELECT m.id_manutencao, c.nome AS cliente, g.numero_serie, g.marca, g.modelo,
       m.tipo_manutencao, m.status, m.data_manutencao
FROM Manutencao m
JOIN Gerador g ON g.id_gerador = m.id_gerador
JOIN Cliente c ON c.id_cliente = g.id_cliente
ORDER BY m.data_manutencao DESC;

-- S02 - Valor total (servicos + pecas) de cada manutencao (RF11 / RN15)
SELECT m.id_manutencao, c.nome AS cliente,
       COALESCE(sv.total_servicos, 0) AS total_servicos,
       COALESCE(pc.total_pecas, 0) AS total_pecas,
       COALESCE(sv.total_servicos, 0) + COALESCE(pc.total_pecas, 0) AS total_manutencao
FROM Manutencao m
JOIN Gerador g ON g.id_gerador = m.id_gerador
JOIN Cliente c ON c.id_cliente = g.id_cliente
LEFT JOIN (SELECT id_manutencao, SUM(valor_unitario_aplicado * quantidade) AS total_servicos
           FROM utiliza GROUP BY id_manutencao) sv ON sv.id_manutencao = m.id_manutencao
LEFT JOIN (SELECT id_manutencao, SUM(valor_unitario_aplicado * quantidade) AS total_pecas
           FROM usa GROUP BY id_manutencao) pc ON pc.id_manutencao = m.id_manutencao
ORDER BY total_manutencao DESC;

-- S03 - Tecnicos que executaram cada manutencao (RN06)
SELECT m.id_manutencao, t.nome AS tecnico, m.tipo_manutencao, m.status
FROM realizada_por rp
JOIN Tecnico t ON t.id_tecnico = rp.id_tecnico
JOIN Manutencao m ON m.id_manutencao = rp.id_manutencao
ORDER BY m.id_manutencao, t.nome;

-- S04 - Quantidade de geradores por cliente (inclui clientes sem gerador)
SELECT c.id_cliente, c.nome, COUNT(g.id_gerador) AS qtd_geradores
FROM Cliente c
LEFT JOIN Gerador g ON g.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY qtd_geradores DESC, c.nome;

-- ---------------------------------------------------------------------
-- 6. UPDATE
-- ---------------------------------------------------------------------

-- U01 - Concluir a manutencao preventiva 392 (RN16: exige data de conclusao)
UPDATE Manutencao
SET status = 'Concluida', data_conclusao = '2026-11-08', numero_nota_fiscal = 'NF-000691'
WHERE id_manutencao = 392;

-- U02 - Dar baixa no pagamento 17 (parcela do contrato 51 recebida via PIX)
UPDATE Pagamento
SET status = 'Pago', data_pagamento = '2026-11-08', forma = 'PIX', valor_pago = valor_parcela
WHERE id_pagamento = 17;

-- U03 - Atualizar a leitura do horimetro do gerador 1 apos a visita
UPDATE Gerador
SET horimetro = 1069
WHERE id_gerador = 1;

-- ---------------------------------------------------------------------
-- 7. DELETE
-- ---------------------------------------------------------------------

-- D01 - Remover a peca 11 (descontinuada, sem estoque e nunca utilizada).
-- Pecas com historico nao podem ser apagadas: as FKs bloqueiam a exclusao.
DELETE FROM Peca
WHERE id_peca = 11 AND estoque = 0;

-- ---------------------------------------------------------------------
-- 8. CONSULTAS GERENCIAIS
-- ---------------------------------------------------------------------

-- G01 - Quais trocas de pecas estao vencidas (por prazo em dias ou por horimetro)?
-- Atende: P2, RF05, RN08
SELECT c.nome AS cliente, g.numero_serie, p.nome_peca,
       cp.data_ultima_troca,
       DATE_ADD(cp.data_ultima_troca, INTERVAL p.prazo_troca_dias DAY) AS vence_por_data,
       (g.horimetro - cp.horimetro_ultima_troca) AS horas_desde_troca,
       p.prazo_troca_horas,
       CASE
           WHEN DATE_ADD(cp.data_ultima_troca, INTERVAL p.prazo_troca_dias DAY) < @hoje
                AND (g.horimetro - cp.horimetro_ultima_troca) >= p.prazo_troca_horas THEN 'Prazo e horimetro'
           WHEN DATE_ADD(cp.data_ultima_troca, INTERVAL p.prazo_troca_dias DAY) < @hoje THEN 'Prazo em dias'
           ELSE 'Horimetro'
       END AS motivo
FROM Cronograma_Preventivo cp
JOIN Gerador g ON g.id_gerador = cp.id_gerador
JOIN Cliente c ON c.id_cliente = g.id_cliente
JOIN Peca p ON p.id_peca = cp.id_peca
WHERE g.status <> 'Inativo'
  AND (DATE_ADD(cp.data_ultima_troca, INTERVAL p.prazo_troca_dias DAY) < @hoje
       OR (g.horimetro - cp.horimetro_ultima_troca) >= p.prazo_troca_horas)
ORDER BY c.nome, g.numero_serie;

-- G02 - Quais pecas estao com estoque baixo (10 unidades ou menos)?
-- Atende: RF15, RN23
SELECT id_peca, nome_peca, estoque, valor_venda
FROM Peca
WHERE estoque <= 10
ORDER BY estoque, nome_peca;

-- G03 - Qual o faturamento recebido por mes?
-- Atende: P5
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes,
       COUNT(*) AS qtd_pagamentos,
       SUM(valor_pago) AS faturamento
FROM Pagamento
WHERE status = 'Pago'
GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m')
ORDER BY mes;

-- G04 - Quais clientes tem parcelas em atraso e qual o valor em aberto?
-- Atende: P5, RF14
SELECT c.id_cliente, c.nome,
       COUNT(*) AS parcelas_em_atraso,
       SUM(p.valor_parcela - p.valor_pago) AS valor_em_aberto,
       MIN(p.data_vencimento) AS vencimento_mais_antigo
FROM Pagamento p
LEFT JOIN Contrato ct ON ct.id_contrato = p.id_contrato
LEFT JOIN Manutencao m ON m.id_manutencao = p.id_manutencao
LEFT JOIN Gerador g ON g.id_gerador = m.id_gerador
JOIN Cliente c ON c.id_cliente = COALESCE(ct.id_cliente, g.id_cliente)
WHERE p.status IN ('Pendente', 'Atrasado')
  AND p.data_vencimento < @hoje
GROUP BY c.id_cliente, c.nome
ORDER BY valor_em_aberto DESC;

-- G05 - Quanto a empresa deve a cada fornecedor em contas vencidas?
-- Atende: RF20, RN24
-- Conta a pagar so tem status Pendente ou Paga; vencida = Pendente com
-- vencimento anterior a @hoje.
SELECT f.nome AS fornecedor,
       COUNT(*) AS contas_vencidas,
       SUM(cp.valor_total - cp.valor_pago) AS saldo_devedor,
       MIN(cp.data_vencimento) AS vencimento_mais_antigo
FROM Contas_a_pagar cp
JOIN Fornecedor f ON f.id_fornecedor = cp.id_fornecedor
WHERE cp.status = 'Pendente'
  AND cp.data_vencimento < @hoje
GROUP BY f.id_fornecedor, f.nome
ORDER BY saldo_devedor DESC;

-- G06 - Quantas manutencoes cada tecnico concluiu por mes?
-- Atende: RF13 (carga de trabalho dos tecnicos)
SELECT t.nome AS tecnico,
       DATE_FORMAT(m.data_conclusao, '%Y-%m') AS mes,
       COUNT(*) AS manutencoes_concluidas
FROM realizada_por rp
JOIN Tecnico t ON t.id_tecnico = rp.id_tecnico
JOIN Manutencao m ON m.id_manutencao = rp.id_manutencao
WHERE m.status = 'Concluida'
GROUP BY t.id_tecnico, t.nome, DATE_FORMAT(m.data_conclusao, '%Y-%m')
ORDER BY mes, manutencoes_concluidas DESC;

-- G07 - Qual a taxa de aprovacao dos orcamentos por mes?
-- Atende: RF07, RN11
SELECT DATE_FORMAT(data_orcamento, '%Y-%m') AS mes,
       COUNT(*) AS total_orcamentos,
       SUM(status = 'Aprovado') AS aprovados,
       SUM(status = 'Recusado') AS recusados,
       SUM(status = 'Pendente') AS pendentes,
       ROUND(100 * SUM(status = 'Aprovado') / COUNT(*), 1) AS taxa_aprovacao_pct,
       SUM(CASE WHEN status = 'Aprovado' THEN valor_orcado ELSE 0 END) AS valor_aprovado
FROM Orcamento
GROUP BY DATE_FORMAT(data_orcamento, '%Y-%m')
ORDER BY mes;

-- G08 - Qual o tempo medio (em dias) para concluir cada tipo de manutencao?
-- Atende: KPI MTTR
-- Obs.: o schema guarda apenas DATE, por isso o resultado e em dias e nao
-- permite medir a meta de "menos de 3 horas" para emergencias.
SELECT tipo_manutencao,
       COUNT(*) AS qtd_concluidas,
       ROUND(AVG(DATEDIFF(data_conclusao, data_manutencao)), 1) AS dias_medios
FROM Manutencao
WHERE status = 'Concluida'
GROUP BY tipo_manutencao;

-- G09 - Quais contratos ativos com prazo definido vencem nos proximos 60 dias?
-- Atende: P3, P4 (contratos sem data_fim sao indeterminados e nao entram)
SELECT c.nome AS cliente, ct.id_contrato, ct.data_fim,
       DATEDIFF(ct.data_fim, @hoje) AS dias_restantes,
       ct.valor_mensal
FROM Contrato ct
JOIN Cliente c ON c.id_cliente = ct.id_cliente
WHERE ct.status = 'Ativo'
  AND ct.data_fim IS NOT NULL
  AND ct.data_fim BETWEEN @hoje AND DATE_ADD(@hoje, INTERVAL 60 DAY)
ORDER BY ct.data_fim;

-- G10 - Qual a margem de cada peca (preco de venda x custo medio de compra)?
-- Atende: RF15, RF16
SELECT x.nome_peca, x.valor_venda, x.custo_medio,
       ROUND(100 * (x.valor_venda - x.custo_medio) / x.valor_venda, 1) AS margem_pct
FROM (SELECT p.id_peca, p.nome_peca, p.valor_venda,
             ROUND(SUM(ct.valor_custo * ct.quantidade) / SUM(ct.quantidade), 2) AS custo_medio
      FROM Peca p
      JOIN contem ct ON ct.id_peca = p.id_peca
      JOIN Compra co ON co.id_compra = ct.id_compra
      WHERE co.status = 'Recebida'
      GROUP BY p.id_peca, p.nome_peca, p.valor_venda) x
ORDER BY margem_pct DESC;

-- G11 - Quais clientes geraram mais receita recebida?
-- Atende: P5
SELECT c.nome AS cliente, COUNT(*) AS pagamentos, SUM(p.valor_pago) AS receita_total
FROM Pagamento p
LEFT JOIN Contrato ct ON ct.id_contrato = p.id_contrato
LEFT JOIN Manutencao m ON m.id_manutencao = p.id_manutencao
LEFT JOIN Gerador g ON g.id_gerador = m.id_gerador
JOIN Cliente c ON c.id_cliente = COALESCE(ct.id_cliente, g.id_cliente)
WHERE p.status = 'Pago'
GROUP BY c.id_cliente, c.nome
ORDER BY receita_total DESC;

-- G12 - Receita mensal recorrente dos contratos ativos
-- Atende: KPI Receita por Contrato (P5)
SELECT ct.id_contrato, c.nome AS cliente, ct.tipo_periodicidade, ct.valor_mensal,
       SUM(ct.valor_mensal) OVER () AS receita_mensal_total
FROM Contrato ct
JOIN Cliente c ON c.id_cliente = ct.id_cliente
WHERE ct.status = 'Ativo'
ORDER BY ct.valor_mensal DESC;

-- G13 - Percentual de manutencoes preventivas por mes
-- Atende: KPI Taxa Preventivo x Corretivo (meta acima de 70%)
SELECT DATE_FORMAT(data_manutencao, '%Y-%m') AS mes,
       COUNT(*) AS total,
       SUM(tipo_manutencao = 'Preventiva') AS preventivas,
       SUM(tipo_manutencao = 'Corretiva') AS corretivas,
       ROUND(100 * SUM(tipo_manutencao = 'Preventiva') / COUNT(*), 1) AS pct_preventivas
FROM Manutencao
GROUP BY DATE_FORMAT(data_manutencao, '%Y-%m')
ORDER BY mes;

-- G14 - Contratos com a quantidade de aditivos registrados
-- Atende: P4, RF19, RN27
SELECT ct.id_contrato, c.nome AS cliente, ct.valor_mensal,
       COUNT(ad.id_aditivo) AS qtd_aditivos,
       MAX(ad.data_aditivo) AS ultimo_aditivo
FROM Contrato ct
JOIN Cliente c ON c.id_cliente = ct.id_cliente
LEFT JOIN Aditivo_contrato ad ON ad.id_contrato = ct.id_contrato
GROUP BY ct.id_contrato, c.nome, ct.valor_mensal
ORDER BY qtd_aditivos DESC, ct.id_contrato;

-- G15 - Qual o tempo medio entre falhas (MTBF) de cada gerador?
-- Atende: KPI MTBF
-- Formula: horas de funcionamento (horimetro) / numero de falhas corretivas.
-- Limitacao: o horimetro e acumulado desde que o gerador foi instalado, mas
-- as falhas cobrem apenas o historico registrado (nov/2025 a nov/2026), entao
-- o valor e uma aproximacao. Menor MTBF = gerador mais problematico.
SELECT g.id_gerador, g.numero_serie, g.marca, g.modelo, g.horimetro,
       COUNT(m.id_manutencao) AS falhas_corretivas,
       ROUND(g.horimetro / COUNT(m.id_manutencao), 1) AS mtbf_horas
FROM Gerador g
JOIN Manutencao m ON m.id_gerador = g.id_gerador
                 AND m.tipo_manutencao = 'Corretiva'
GROUP BY g.id_gerador, g.numero_serie, g.marca, g.modelo, g.horimetro
ORDER BY mtbf_horas;

-- G16 - Qual o indice de primeira visita (First Fix Rate) por mes?
-- Atende: KPI Indice de Primeira Visita (meta acima de 85%)
-- O schema nao registra visitas nem retornos. Regra adotada: corretiva
-- concluida conta como resolvida na 1a visita se o mesmo gerador nao teve
-- nova corretiva nos 30 dias seguintes a conclusao.
SELECT DATE_FORMAT(m.data_conclusao, '%Y-%m') AS mes,
       COUNT(*) AS corretivas_concluidas,
       SUM(NOT EXISTS (SELECT 1 FROM Manutencao r
                       WHERE r.id_gerador = m.id_gerador
                         AND r.tipo_manutencao = 'Corretiva'
                         AND r.id_manutencao <> m.id_manutencao
                         AND r.data_manutencao > m.data_conclusao
                         AND r.data_manutencao <= DATE_ADD(m.data_conclusao, INTERVAL 30 DAY))) AS resolvidas_1a_visita,
       ROUND(100 * SUM(NOT EXISTS (SELECT 1 FROM Manutencao r
                       WHERE r.id_gerador = m.id_gerador
                         AND r.tipo_manutencao = 'Corretiva'
                         AND r.id_manutencao <> m.id_manutencao
                         AND r.data_manutencao > m.data_conclusao
                         AND r.data_manutencao <= DATE_ADD(m.data_conclusao, INTERVAL 30 DAY))) / COUNT(*), 1) AS first_fix_pct
FROM Manutencao m
WHERE m.tipo_manutencao = 'Corretiva' AND m.status = 'Concluida'
GROUP BY DATE_FORMAT(m.data_conclusao, '%Y-%m')
ORDER BY mes;

-- ---------------------------------------------------------------------
-- 9. CONSULTAS DE AUDITORIA
-- (resultado vazio = dados consistentes com a regra)
-- ---------------------------------------------------------------------

-- A01 - Existe gerador ligado a um contrato de outro cliente?
-- Verifica: RN12
SELECT g.id_gerador, g.numero_serie, g.id_cliente AS cliente_do_gerador,
       ct.id_contrato, ct.id_cliente AS cliente_do_contrato
FROM Gerador g
JOIN Contrato ct ON ct.id_contrato = g.id_contrato
WHERE g.id_cliente <> ct.id_cliente;

-- A02 - Existe pagamento "Pago" que nao quitou o valor da parcela?
-- Verifica: RN20 / Processo 13
SELECT id_pagamento, id_contrato, id_manutencao, valor_parcela, valor_pago
FROM Pagamento
WHERE status = 'Pago' AND valor_pago < valor_parcela;

-- A03 - Existe manutencao concluida sem nota fiscal?
-- Verifica: Processo 6 (registro da nota fiscal)
SELECT id_manutencao, id_gerador, data_conclusao
FROM Manutencao
WHERE status = 'Concluida'
  AND (numero_nota_fiscal IS NULL OR numero_nota_fiscal = '');

-- A04 - Existe manutencao em andamento ou concluida sem nenhum tecnico?
-- Verifica: RN06
SELECT m.id_manutencao, m.id_gerador, m.status, m.data_manutencao
FROM Manutencao m
LEFT JOIN realizada_por rp ON rp.id_manutencao = m.id_manutencao
WHERE m.status IN ('Em andamento', 'Concluida')
  AND rp.id_manutencao IS NULL;

-- A05 - Existe manutencao corretiva iniciada sem orcamento aprovado?
-- Verifica: RN10 e RN11
SELECT m.id_manutencao, m.id_gerador, m.status, o.id_orcamento, o.status AS status_orcamento
FROM Manutencao m
LEFT JOIN Orcamento o ON o.id_orcamento = m.id_orcamento
WHERE m.tipo_manutencao = 'Corretiva'
  AND m.status IN ('Em andamento', 'Concluida')
  AND (o.id_orcamento IS NULL OR o.status <> 'Aprovado');

-- A06 - Existe contrato "Ativo" com data de fim ja vencida?
-- Verifica: Processo 3 (vigencia do contrato)
SELECT ct.id_contrato, c.nome AS cliente, ct.data_fim, ct.status
FROM Contrato ct
JOIN Cliente c ON c.id_cliente = ct.id_cliente
WHERE ct.status = 'Ativo' AND ct.data_fim IS NOT NULL AND ct.data_fim < @hoje;

-- A07 - Existe acesso registrado de usuario inativo?
-- Verifica: RN25 / RN26
SELECT l.id_log, u.login, l.data_hora_acesso, l.acao, l.nome_tabela
FROM Log_acesso l
JOIN Usuario u ON u.id_usuario = l.id_usuario
WHERE u.ativo = FALSE;

-- A08 - Existe tecnico com escalas sobrepostas?
-- Verifica: RN18
SELECT e1.id_tecnico, t.nome AS tecnico,
       e1.id_escala AS escala_a, e2.id_escala AS escala_b
FROM Escala e1
JOIN Escala e2 ON e1.id_tecnico = e2.id_tecnico
              AND e1.id_escala < e2.id_escala
              AND e1.data_inicio <= e2.data_fim
              AND e2.data_inicio <= e1.data_fim
JOIN Tecnico t ON t.id_tecnico = e1.id_tecnico;

-- A09 - O status do gerador e coerente com as manutencoes abertas?
-- Verifica: RN04
SELECT g.id_gerador, g.numero_serie, g.status
FROM Gerador g
WHERE (g.status = 'Em manutencao'
       AND NOT EXISTS (SELECT 1 FROM Manutencao m
                       WHERE m.id_gerador = g.id_gerador
                         AND m.status IN ('Aberta', 'Em andamento')))
   OR (g.status <> 'Em manutencao'
       AND EXISTS (SELECT 1 FROM Manutencao m
                   WHERE m.id_gerador = g.id_gerador
                     AND m.status = 'Em andamento'));

-- A10 - Existe contrato sem nenhum gerador vinculado?
-- Verifica: RN12 (contrato cobre pelo menos um gerador)
SELECT ct.id_contrato, c.nome AS cliente, ct.status
FROM Contrato ct
JOIN Cliente c ON c.id_cliente = ct.id_cliente
LEFT JOIN Gerador g ON g.id_contrato = ct.id_contrato
WHERE g.id_gerador IS NULL;
