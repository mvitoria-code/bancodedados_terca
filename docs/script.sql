-- =====================================================================
-- Sistema de gestao de manutencao de geradores - S. A. DE LIMA
-- SGBD: MySQL 8.0.16+ (necessario para CHECK)
-- Os codigos P (problemas), RN (regras de negocio) e RF (requisitos)
-- citados nos comentarios estao definidos no README.md.
-- Ordem de execucao: script.sql -> 02_massa_dados.sql -> 03_consultas.sql
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
-- A criptografia e aplicada pela camada da aplicacao / do SGBD
-- (ex.: AES_ENCRYPT); nesta massa de teste os dados estao em texto claro.
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(18) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    estado CHAR(2) NOT NULL,
    CONSTRAINT uq_cliente_cpf_cnpj UNIQUE (cpf_cnpj),                         -- RN01
    CONSTRAINT chk_cliente_estado CHECK (CHAR_LENGTH(estado) = 2),
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
    numero_serie VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',
    potencia DECIMAL(8,2) NOT NULL,                                            -- em kVA
    horimetro INT NOT NULL DEFAULT 0,
    capacidade_oleo_litros DECIMAL(6,2) NULL,                                  -- P5
    CONSTRAINT uq_gerador_serie UNIQUE (numero_serie),                        -- RN03
    CONSTRAINT chk_gerador_status CHECK (status IN ('Ativo','Em manutencao','Inativo')),   -- RN04
    CONSTRAINT chk_gerador_potencia CHECK (potencia > 0),
    CONSTRAINT chk_gerador_horimetro CHECK (horimetro >= 0),
    CONSTRAINT chk_gerador_oleo CHECK (capacidade_oleo_litros IS NULL OR capacidade_oleo_litros > 0)
) ENGINE=InnoDB;

CREATE TABLE Peca (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome_peca VARCHAR(100) NOT NULL,
    descricao_peca VARCHAR(255),
    valor_venda DECIMAL(10,2) NOT NULL,
    prazo_troca_dias INT NULL,
    prazo_troca_horas INT NULL,
    estoque INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_peca_nome UNIQUE (nome_peca),
    CONSTRAINT chk_peca_valor CHECK (valor_venda >= 0),
    CONSTRAINT chk_peca_estoque CHECK (estoque >= 0),                         -- RN23
    CONSTRAINT chk_peca_prazos CHECK (
        (prazo_troca_dias IS NULL OR prazo_troca_dias > 0) AND
        (prazo_troca_horas IS NULL OR prazo_troca_horas > 0))                 -- RN08
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
    CONSTRAINT chk_manut_tipo CHECK (tipo_manutencao IN ('Preventiva','Corretiva')),
    CONSTRAINT chk_manut_status CHECK (status IN ('Aberta','Em andamento','Concluida')),      -- RN16
    CONSTRAINT chk_manut_conclusao CHECK (
        status <> 'Concluida' OR (data_conclusao IS NOT NULL AND data_conclusao >= data_manutencao)),
    CONSTRAINT chk_manut_corretiva CHECK (tipo_manutencao = 'Preventiva' OR id_orcamento IS NOT NULL)  -- RN10
) ENGINE=InnoDB;

CREATE TABLE Servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome_servico VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    valor_base DECIMAL(10,2) NOT NULL,
    CONSTRAINT uq_servico_nome UNIQUE (nome_servico),                         -- RN19
    CONSTRAINT chk_servico_valor CHECK (valor_base >= 0)
) ENGINE=InnoDB;

CREATE TABLE Tecnico (
    id_tecnico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    CONSTRAINT uq_tecnico_cpf UNIQUE (cpf),                                   -- RN17
    CONSTRAINT chk_tecnico_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),              -- RN17
    CONSTRAINT chk_tecnico_email CHECK (email IS NULL OR email LIKE '%@%')
) ENGINE=InnoDB;

CREATE TABLE Fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
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
    valor_previsto DECIMAL(10,2) NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    -- RN20: exatamente uma origem (manutencao OU contrato)
    CONSTRAINT chk_pag_origem CHECK ((id_manutencao IS NULL AND id_contrato IS NOT NULL)
                                  OR (id_manutencao IS NOT NULL AND id_contrato IS NULL)),
    CONSTRAINT chk_pag_parcela CHECK (numero_parcela > 0),
    CONSTRAINT chk_pag_valores CHECK (valor_previsto > 0 AND valor_pago >= 0),
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
    id_tecnico INT NULL,                                                       -- vinculo 1:1 com Tecnico (perfil Tecnico)
    login VARCHAR(50) NOT NULL,
    perfil VARCHAR(20) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'Ativo',                               -- exclusao logica (RF17)
    CONSTRAINT uq_usuario_login UNIQUE (login),                               -- RN25
    CONSTRAINT uq_usuario_tecnico UNIQUE (id_tecnico),
    CONSTRAINT chk_usuario_perfil CHECK (perfil IN ('Administrador','Atendimento','Tecnico','Financeiro')),
    CONSTRAINT chk_usuario_status CHECK (status IN ('Ativo','Inativo'))
) ENGINE=InnoDB;

CREATE TABLE Log_acesso (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NULL,                                                       -- NULL em login negado de usuario inexistente
    data_hora_acesso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    acao VARCHAR(50) NOT NULL,
    nome_tabela VARCHAR(50) NOT NULL,
    id_registro INT NULL,
    resultado VARCHAR(20) NOT NULL,
    finalidade_acesso VARCHAR(100) NOT NULL,                                  -- LGPD
    login_informado VARCHAR(50) NULL,
    ip_origem VARCHAR(45) NULL,
    CONSTRAINT chk_log_acao CHECK (acao IN ('LOGIN','SELECT','INSERT','UPDATE','DELETE')),
    CONSTRAINT chk_log_resultado CHECK (resultado IN ('Sucesso','Negado','Erro')),
    CONSTRAINT chk_log_identificacao CHECK (id_usuario IS NOT NULL OR login_informado IS NOT NULL)
) ENGINE=InnoDB;

CREATE TABLE Aditivo_contrato (
    id_aditivo INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT NOT NULL,
    data_aditivo DATE NOT NULL,
    alteracao_realizada VARCHAR(255) NOT NULL,
    condicoes_anteriores VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Contas_a_pagar (
    id_conta_pagar INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    valor_pago DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    data_vencimento DATE NOT NULL,
    numero_boleto VARCHAR(50) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    data_pagamento DATE NULL,
    CONSTRAINT uq_cap_boleto UNIQUE (numero_boleto),                          -- RN24
    CONSTRAINT chk_cap_status CHECK (status IN ('Pendente','Atrasada','Paga')),
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
    valor_aplicado DECIMAL(10,2) NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_manutencao, id_servico),
    CONSTRAINT chk_utiliza_qtd CHECK (quantidade > 0 AND valor_aplicado >= 0)   -- RN15
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
ALTER TABLE Usuario ADD CONSTRAINT fk_usuario_tecnico FOREIGN KEY (id_tecnico) REFERENCES Tecnico (id_tecnico);
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
