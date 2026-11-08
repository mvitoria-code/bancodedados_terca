-- =====================================================================
-- CONSULTAS - gestao_geradores (S. A. DE LIMA)
-- Executar DEPOIS de script.sql e 02_massa_dados.sql.
-- @hoje fixa a data de referencia da massa de dados (08/11/2026).
-- Em producao, troque por CURDATE().
-- v2: acrescenta G15 (MTBF) e G16 (First Fix Rate).
-- =====================================================================
USE gestao_geradores;
SET NAMES utf8mb4;
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
LEFT JOIN (SELECT id_manutencao, SUM(valor_aplicado * quantidade) AS total_servicos
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
SET status = 'Pago', data_pagamento = '2026-11-08', forma = 'PIX', valor_pago = valor_previsto
WHERE id_pagamento = 17;

-- U03 - Atualizar a leitura do horimetro do gerador 1 apos a visita
UPDATE Gerador
SET horimetro = 1069
WHERE id_gerador = 1;

-- U04 - Registrar a capacidade de oleo do gerador 31 (P5)
UPDATE Gerador
SET capacidade_oleo_litros = 10.00
WHERE id_gerador = 31 AND capacidade_oleo_litros IS NULL;

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
-- Atende: P6
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes,
       COUNT(*) AS qtd_pagamentos,
       SUM(valor_pago) AS faturamento
FROM Pagamento
WHERE status = 'Pago'
GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m')
ORDER BY mes;

-- G04 - Quais clientes tem parcelas em atraso e qual o valor em aberto?
-- Atende: P6, RF14
SELECT c.id_cliente, c.nome,
       COUNT(*) AS parcelas_em_atraso,
       SUM(p.valor_previsto - p.valor_pago) AS valor_em_aberto,
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
SELECT f.nome AS fornecedor,
       COUNT(*) AS contas_vencidas,
       SUM(cp.valor_total - cp.valor_pago) AS saldo_devedor,
       MIN(cp.data_vencimento) AS vencimento_mais_antigo
FROM Contas_a_pagar cp
JOIN Fornecedor f ON f.id_fornecedor = cp.id_fornecedor
WHERE cp.status IN ('Pendente', 'Atrasada')
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
-- Atende: KPI MTTR (secao 8 do README)
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
-- Atende: P6
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
-- Atende: KPI Receita por Contrato (P6)
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
-- Verifica: RN20 / processo 2.13
SELECT id_pagamento, id_contrato, id_manutencao, valor_previsto, valor_pago
FROM Pagamento
WHERE status = 'Pago' AND valor_pago < valor_previsto;

-- A03 - Existe manutencao concluida sem nota fiscal?
-- Verifica: processo 2.6 (registro da nota fiscal)
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
-- Verifica: processo 2.3 (vigencia do contrato)
SELECT ct.id_contrato, c.nome AS cliente, ct.data_fim, ct.status
FROM Contrato ct
JOIN Cliente c ON c.id_cliente = ct.id_cliente
WHERE ct.status = 'Ativo' AND ct.data_fim IS NOT NULL AND ct.data_fim < @hoje;

-- A07 - Existe conta a pagar vencida e nao paga que ainda esta como "Pendente"?
-- Verifica: RN24
SELECT id_conta_pagar, id_fornecedor, descricao, data_vencimento, status
FROM Contas_a_pagar
WHERE status = 'Pendente' AND data_vencimento < @hoje;

-- A08 - Existe acesso registrado de usuario inativo?
-- Verifica: RN25 / RN26
SELECT l.id_log, u.login, l.data_hora_acesso, l.acao, l.nome_tabela
FROM Log_acesso l
JOIN Usuario u ON u.id_usuario = l.id_usuario
WHERE u.status = 'Inativo';

-- A09 - Existe tecnico com escalas sobrepostas?
-- Verifica: RN18
SELECT e1.id_tecnico, t.nome AS tecnico,
       e1.id_escala AS escala_a, e2.id_escala AS escala_b
FROM Escala e1
JOIN Escala e2 ON e1.id_tecnico = e2.id_tecnico
              AND e1.id_escala < e2.id_escala
              AND e1.data_inicio <= e2.data_fim
              AND e2.data_inicio <= e1.data_fim
JOIN Tecnico t ON t.id_tecnico = e1.id_tecnico;

-- A10 - O status do gerador e coerente com as manutencoes abertas?
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

-- A11 - Existe contrato sem nenhum gerador vinculado?
-- Verifica: RN12 (contrato cobre pelo menos um gerador)
SELECT ct.id_contrato, c.nome AS cliente, ct.status
FROM Contrato ct
JOIN Cliente c ON c.id_cliente = ct.id_cliente
LEFT JOIN Gerador g ON g.id_contrato = ct.id_contrato
WHERE g.id_gerador IS NULL;
