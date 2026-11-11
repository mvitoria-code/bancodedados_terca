# Banco de Dados da S. A. de Lima (Limas Energia Geradores)
### Gestão de manutenção preventiva e corretiva de geradores de energia

# 1. Relatório Técnico Final

## 1.1 Revisão do Modelo Conceitual

## Integrantes

| Nome | RGM | GitHub |
| :--- | :---: | :--- |
| Kauan José da Silva | 47346850 | [`@kauan221107-netizen`](https://github.com/kauan221107-netizen) |
| Kauê Romaneto Machado | 47357304 | [`@MACHAD0Z`](https://github.com/MACHAD0Z) |
| Kaylany Thayna de Oliveira de Paula | 47039035 | [`@kaayllany`](https://github.com/kaayllany) |
| Maria Vitória Pereira Alves | 47230720 | [`@mvitoria-code`](https://github.com/mvitoria-code) |

### Caracterização da organização

**Nome e natureza:** S. A. de Lima, que opera como **Limas Energia Geradores** — manutenção preventiva e corretiva de geradores de energia. Empresa privada **com fins lucrativos**.

**Contexto e porte (números):**

| Indicador | Valor informado |
| :--- | :--- |
| Funcionários | 15 |
| Clientes fixos | 96 |
| Manutenções em geradores | média de 33 por mês (≈ 400 por ano) |
| Regime de atendimento | plantão de 24 horas (emergências a qualquer hora) |
| Controle atual dos dados | papel: fichas e relatórios físicos (clientes, atendimentos, contratos) |

**Problemas e necessidades identificados**

| ID | Problema (crise operacional) | Evidência | Onde o modelo o resolve |
| :--- | :--- | :--- | :--- |
| **P1** | Fichas em papel sujeitas a perda ou ilegibilidade | Entrevista | `Cliente`, `Gerador`, `Manutencao` (RF01, RF03, RF08) |
| **P2** | Histórico e última troca de peças só são achados folheando relatórios | Entrevista | `Cronograma_Preventivo`, `Peca`, `Manutencao_*` (RF02, RF04, RF05) |
| **P3** | Contrato relido a cada atendimento para checar cobertura | Entrevista | `Contrato`, `Gerador.id_contrato`, `Manutencao.id_contrato` (RF06, RN12–RN15) |
| **P4** | Alterações de contrato por e-mail, sem registro garantido | Entrevista | `Aditivo_contrato` (RF19, RN27) |
| **P5** | Faturamento estimado e reajustes refeitos à mão | Entrevista | `Contrato`, `Aditivo_contrato`, `Pagamento` (RF14, RF19) |
| **P6** | Não se sabe se a peça existe em estoque, é preciso ficar procurando e já houve compra de peça que já se tinha | Entrevista | `Peca` (atributo `estoque`), `Compra`, relacionamento `contem` (RF15, RF16, RN23) |
| **P7** | Dados de fornecedores em documentos impressos, sujeitos a deterioração | Entrevista | `Fornecedor`, `Compra`, `Peca` (RF16) |


Nos dias atuais, a empresa não tem um controle digital para a organização dos seus dados em geral: os dados são mantidos de maneira física, em fichas e papéis. Desde as informações dos atendimentos, até às informações dos clientes. 
Com um banco de dados adequado, essas informações ficarão muito mais seguras, além de estarem organizadas e reservadas somente num lugar, facilitando as buscas, consultas e alterações.
A organização foi escolhida de acordo com as dificuldades relatadas. A partir disso foram encontradas possibilidades reais de implantar um plano de ação e renovação de fluxos de armazenamento de dados. Além de que o fácil acesso a empresa e contato com o dono contribuiram com a escolha do grupo.

**Escopo do sistema:** o banco cobre **toda** a operação da empresa, não só um setor: clientes e contratos (com aditivos), geradores, orçamentos, manutenções (técnicos, serviços e peças), cronograma preventivo, escala dos técnicos, recebimentos (pagamentos), compras de peças e fornecedores, contas a pagar e controle de acesso/auditoria (22 tabelas).

**Justificativa da escolha:** a empresa relatou dificuldades reais de organização de dados (todo o controle é em papel), tem processos variados (atendimento, contratos, estoque, financeiro) que rendem um modelo rico, e o grupo tem fácil acesso à empresa e ao dono. 

**Vínculo com a organização:** o integrante **Kauan José da Silva** trabalha na S. A. de Lima (Limas Energia Geradores) e é sobrinho do dono da empresa, que é o responsável que atendeu o grupo. Na foto da entrevista, os dois aparecem juntos, e a camisa com o logotipo da empresa é a do Kauan. O vínculo facilitou o acesso à empresa e o contato com o responsável. A entrevista foi feita no ambiente da organização e não depende apenas desse vínculo: ela está comprovada pela foto e pelo relato da seção seguinte.

**Responsável pela organização:** 
- Nome: Sandro aparecido de lima
- Telefone: +55 (11) 98373-9556
- E-mail: sandrolima@limasenergia.com.br


---

**Evidências da organização**

- Endereço e perfil da empresa no Google Maps: Av. Adriano Bertozzi, 815 - Jardim Helian, São Paulo - SP, 08265-000 https://maps.app.goo.gl/XExBHSXrFvbUNv8Y6?g_st=aw
- Telefone: +55 (11) 98373-9556  
- E-mail: sandrolima@limasenergia.com.br
- site: https://limasenergia.com.br/
- Foto da empresa: [Limas Energia Grupos Geradores](imagem%20empresa.jpg)

---

### Relato da entrevista
-  **Quem:** Sandro Aparecido de Lima, dono da empresa e responsável pela organização. Participou da entrevista o integrante **Kauan José da Silva**, que trabalha na empresa e é sobrinho do entrevistado (vínculo declarado na caracterização). Os demais integrantes não estiveram presentes e trabalharam a partir do relato e do levantamento do Kauan.
- **Quando e onde:** 07/11/2026, na sede da empresa (Av. Adriano Bertozzi, 815 - Jardim Helian, São Paulo - SP).
- **Comprovação:** foto do integrante com o responsável, no local: [Foto da entrevista](evidencias/foto-nova-visita.jpeg)

---

### O que foi levantado (resumo):
- **Achados da observação presencial (separados do que foi dito):**
  - Documentos impressos guardados soltos e empilhados em gaveta, vários com manchas e sujeira, o que mostra o risco de deterioração do papel (P1, P7).
  - Notas fiscais (DANFE) e boletos em pilhas sobre a mesa e em prancheta, misturados, sem sistema para consulta (P6, P7).
  - Orçamento em papel com carimbo "ORÇAMENTO" e anotações à caneta.
  - Contrato de prestação de serviço em papel, com visita preventiva mensal, valor mensal e o roteiro de manutenção preventiva como anexo (P3).
- **Nova visita (Entrega 2):** 07/11/2026, na sede da empresa. Foram fotografados os documentos de compras e fornecedores (notas fiscais e boletos), o orçamento em papel, o contrato e a gaveta de arquivo. O que foi conversado com o Sandro: A empresa ainda utiliza muitos registros em papel, o que dificulta a organização e a consulta das informações. Por isso, vimos a necessidade de criar um banco de dados para facilitar o controle das manutenções, clientes, geradores e demais processos da empresa.
- **Levantamento completo:** [`levantamento.md`](levantamento.md)
---

### Processos de negócio

Processos mapeados (a correção da E1 apontou cobertura de 63%; os processos de **contratos, preventiva, escala, compras, fornecedores, estoque e contas a pagar**):

| # | Processo | Tabelas principais |
| :--- | :--- | :--- |
| 1 | Cadastro de clientes | `Cliente` |
| 2 | Cadastro de geradores | `Gerador` |
| 3 | Formalização de contratos (e aditivos) | `Contrato`, `Aditivo_contrato` |
| 4 | Planejamento da manutenção preventiva | `Cronograma_Preventivo`, `Peca` |
| 5 | Solicitação de atendimento e orçamento | `Orcamento` |
| 6 | Registro de manutenções | `Manutencao`, `utiliza`, `usa`, `realizada_por`, `atualiza` |
| 7 | Cadastro de serviços | `Servico` |
| 8 | Cadastro de técnicos | `Tecnico` |
| 9 | Escalas dos técnicos | `Escala` |
| 10 | Cadastro de peças e estoque | `Peca` |
| 11 | Cadastro de fornecedores | `Fornecedor` |
| 12 | Registro de compras | `Compra`, `contem` |
| 13 | Controle de pagamentos (contas a receber) | `Pagamento` |
| 14 | Contas a pagar | `Contas_a_pagar` |
| 15 | Controle de acesso e auditoria | `Usuario`, `Log_acesso` |

---

### Nível de detalhe — processos, requisitos e regras de negócio

Frases genéricas são superficiais e não bastam. Em todos os requisitos, regras e processos deste trabalho indicamos quais dados estão envolvidos, com os mesmos campos do DER, do dicionário de dados e do modelo lógico. Exemplos:

| Superficial | Detalhado (como está neste trabalho) |
| :--- | :--- |
| O sistema deve permitir cadastrar cliente. | **RF01** — O sistema deve permitir cadastrar clientes com nome (ou razão social), CPF/CNPJ, telefone, endereço, e-mail, cidade e estado, todos obrigatórios. |
| O sistema deve permitir cadastrar geradores. | **RF03** — O sistema deve permitir cadastrar geradores vinculados a um cliente, registrando número de série, marca, modelo, status operacional, potência em kVA e horímetro atual. |
| O sistema deve registrar as manutenções. | **RF08** — O sistema deve registrar manutenções preventivas e corretivas vinculadas ao gerador, ao contrato vigente e ao orçamento (quando aplicável), com data, tipo, status, número da nota fiscal, problema relatado e data de conclusão. **RF09** — Cada manutenção deve ter ao menos um técnico, ao menos um serviço e, opcionalmente, peças, informando valor unitário aplicado e quantidade. |
| O sistema controla os pagamentos. | **RF14** — O sistema deve gerar e controlar parcelas de pagamento de manutenções avulsas e de contratos, registrando número da parcela, vencimento, valor previsto, data de pagamento, forma de pagamento, status e valor pago. |
| O sistema avisa quando é hora de trocar peças. | **RF05** — O sistema deve listar, para cada gerador, as peças com troca vencida ou próxima do vencimento, exibindo o nome da peça, a data e o horímetro da última troca e o prazo de troca em dias e/ou horas. |
| O cliente precisa estar cadastrado. | **RN01** — Todo cliente deve ter um CPF ou CNPJ único no sistema; não é permitido cadastrar documentos duplicados. Nome, telefone, endereço, e-mail, cidade e estado são obrigatórios (RF01). |
| O pagamento precisa ter uma origem. | **RN20** — Cada pagamento deve estar ligado a exatamente uma origem de cobrança: uma manutenção (`id_manutencao`) ou um contrato (`id_contrato`), nunca as duas nem nenhuma. |
| O gerador precisa ter um número de identificação. | **RN03** — Cada gerador deve ter um número de série único, com caracteres alfanuméricos, e pertencer a exatamente um cliente (RN02). |
| O técnico faz a manutenção. | No registro da manutenção constam a data, o tipo (preventiva ou corretiva), o status (aberta, em andamento ou concluída), o número da nota fiscal, o problema relatado e a data de conclusão; para cada serviço, a quantidade e o valor unitário aplicado; para cada peça trocada, a quantidade e o valor unitário aplicado (RF08, RF09). |

---

## Fluxograma do atendimento:
<img width="2760" height="5480" alt="fluxograma" src="fluxograma.png" />

#### PN 1 — cadastrar clientes
- Objetivo: preservar as informações dos clientes e permitir consultar o histórico de cada um.
- Quando ocorre: no primeiro atendimento de um cliente novo.
- Dados: nome (ou razão social), CPF/CNPJ, telefone, endereço, e-mail, cidade e estado.
- Regras: todos os campos são obrigatórios; o CPF/CNPJ não pode se repetir; CPF/CNPJ e endereço são protegidos por criptografia em repouso.
Resultado: cliente disponível para vincular geradores e contratos.

#### PN 2 — cadastrar geradores
- Objetivo: controlar os geradores supervisionados pela empresa.
- Quando ocorre: quando o cliente possui um gerador ainda não registrado.
- Dados: número de série, marca, modelo, status (ativo, em manutenção ou inativo), potência em kVA, horímetro e, quando houver, o contrato que cobre o gerador.
- Regras: todo gerador pertence a um cliente; o número de série é único; um cliente pode ter mais de um gerador; o contrato deve pertencer ao mesmo cliente do gerador; todo gerador deve ter um cronograma de inspeção preventiva.
- Resultado: equipamento identificado, com cronograma criado e pronto para receber manutenções.

#### PN 3 — formalizar contratos de manutenção
- Objetivo: formalizar o atendimento recorrente dos clientes fixos, com cobrança periódica.
- Quando ocorre: quando um cliente fixo passa a ter um acordo de manutenção e a cada alteração das condições do contrato.
Dados:
- Contrato: cliente, data de início, data de fim (opcional), valor mensal, periodicidade (mensal a anual) e status (ativo, encerrado ou cancelado).
- Aditivo: contrato, data do aditivo, descrição da alteração e condições anteriores.
- Regras: o contrato pertence a um único cliente e cobre pelo menos um gerador dele; sem data de fim, o prazo é indeterminado; contrato encerrado exige data de fim; as preventivas previstas  são pagas pela mensalidade e itens fora do previsto são cobrados à parte; toda alteração é registrada por aditivo, que nunca é excluído.
- Resultado: contrato ativo, que gera as cobranças periódicas e enquadra as manutenções dos geradores cobertos.

#### PN 4 — planejar a manutenção preventiva
- Objetivo: acompanhar os prazos de troca ou limpeza das peças de cada gerador (bateria, óleo, filtros e tanque).
- Quando ocorre: no cadastro do gerador e a cada troca ou limpeza feita em uma manutenção.
- Dados: gerador, peça, data da última troca e horímetro da última troca (opcionais até a primeira intervenção).
- Regras: um registro por peça em cada gerador; o prazo vem da peça (dias e/ou horas), vencendo o que for atingido primeiro (RN08); a manutenção que troca ou limpa a peça atualiza data e horímetro (RN09).
- Resultado: lista de peças vencidas ou a vencer.

#### PN 5 — solicitar atendimento e elaborar orçamento
- Objetivo: registrar o pedido do cliente e estimar o valor antes da execução.
- Quando ocorre: a cada pedido de atendimento fora de contrato.
- Dados: ID do orçamento, gerador, data, valor orçado, status (pendente, aprovado ou recusado) e data de aprovação.
- Regras: orçamento aprovado pode originar uma manutenção, recusado não; o valor final pode diferir do orçado; na emergência o orçamento também precisa ser aprovado antes da execução, mas o pagamento pode vir depois; preventiva prevista em contrato não passa por orçamento.
- Resultado: orçamento aprovado e ligado à manutenção, ou encerrado sem atendimento.

#### PN 6 — registrar manutenções
- Objetivo: registrar cada atendimento, preventivo ou corretivo.
- Quando ocorre: após a aprovação de um orçamento; na preventiva prevista em contrato (sem orçamento); ou na preventiva gerada pelo cronograma.
- Dados: ID, gerador, contrato e orçamento (quando houver), data, tipo, status, nota fiscal, problema relatado, data de conclusão e, para cada serviço e peça, valor unitário aplicado e quantidade.
- Regras:
  - Cada manutenção está vinculada a exatamente um gerador.
  - Tem pelo menos um técnico responsável e um serviço; peças são opcionais.
  - Status: Aberta → Em andamento → Concluída.
  - Serviços, peças e técnicos só podem ser alterados enquanto a manutenção não estiver concluída.
  - Depois de concluída, só usuários autorizados alteram, com registro no histórico (RN16).
  - O valor total não é armazenado: é a soma de (valor unitário × quantidade) dos serviços e peças.
  - Manutenção coberta por contrato registra os itens com valor zero.
  - Ao registrar uma peça, o sistema dá baixa no estoque; se ela for removida ou alterada antes da conclusão, a baixa é estornada ou ajustada.
  - O sistema impede estoque negativo.
- Resultado: histórico completo das manutenções por gerador e cliente.

#### PN 7 — cadastrar serviços
- Objetivo: definir os tipos de serviço oferecidos e seus valores base.
- Quando ocorre: quando a empresa passa a oferecer um novo tipo de serviço.
- Dados: nome, descrição e valor base.
- Regras: o nome é único; um serviço pode ser usado em várias manutenções; o valor aplicado pode diferir do valor base, inclusive ser zero quando coberto por contrato; os serviços seguem as normas NR-10, NR-12, NR-20 e NR-6.
- Resultado: catálogo que alimenta o cálculo do valor das manutenções.

#### PN 8 — cadastrar técnicos
- Objetivo: manter os técnicos cadastrados.
- Quando ocorre: após a contratação do técnico.
- Dados: nome, CPF, telefone e e-mail.
- Regras: CPF único, com 11 dígitos numéricos.
- Resultado: técnicos disponíveis com seus dados cadastrais.

#### PN 9 — gerenciar escalas dos técnicos
- Objetivo: manter a escala de trabalho de cada técnico.
- Quando ocorre: após a contratação do técnico e a cada mudança de escala.
- Dados: ID da escala, período (início e fim), turno (manhã, tarde, noite ou integral) e dia da folga.
- Regras: a data final não pode ser anterior à inicial; um técnico pode ter várias escalas e participar de várias manutenções.
- Resultado: técnicos disponíveis para alocação e plantão coberto.

#### PN 10 — cadastrar peças
- Objetivo: manter o catálogo de peças usadas nas manutenções e nos cronogramas, incluindo baterias, óleos e filtros.
- Quando ocorre: quando a empresa passa a usar uma peça nova ou precisa atualizar uma já cadastrada.
- Dados: ID, nome, descrição, valor, prazo de troca em dias e/ou em horas (opcionais) e quantidade em estoque.
- Regras:
  - O nome da peça é único.
  - Os prazos de troca servem de referência para os cronogramas.
  - A entrada no estoque ocorre após a confirmação do recebimento da compra, sem entradas duplicadas.
  - O uso da peça em uma manutenção gera baixa automática no estoque.
  - O sistema impede quantidade negativa.
  - Ajustes manuais de estoque só por usuários autorizados, com registro de auditoria.
- Resultado: catálogo atualizado, com entradas e saídas de estoque controladas.

#### PN 11 — cadastrar fornecedores
- Objetivo: registrar os dados de cada fornecedor.
- Quando ocorre: quando houver compra de algum insumo diretamente com a organização.
- Dados: nome, CNPJ, telefone e e-mail.
- Regras: CNPJ e telefone únicos.
- Resultado: fornecedores sempre atualizados.

#### PN 12 — registrar compras
- Objetivo: registrar as compras de peças feitas a fornecedores.
- Quando ocorre: quando é preciso adquirir peças para manutenções ou uso interno.
- Dados: ID, data, fornecedor, situação (pedida, recebida ou cancelada), nota fiscal e itens (quantidade e custo unitário).
- Regras: toda compra tem pelo menos um item e um fornecedor cadastrado; a situação só muda enquanto a compra não estiver recebida; o recebimento atualiza o estoque automaticamente, sem segunda entrada; o estoque nunca fica negativo.
- Resultado: compras rastreáveis por fornecedor e estoque atualizado.

#### PN 13 — controlar pagamentos
- Objetivo: controlar as cobranças de manutenções e de contratos (contas a receber).
- Quando ocorre: ao fechar o valor da manutenção e a cada período de cobrança do contrato.
- Dados: número da parcela, vencimento, valor da parcela, data e forma de pagamento, status (pendente, pago, atrasado ou cancelado) e valor pago.
- Regras:
  - Cada parcela tem exatamente uma origem: uma manutenção ou um contrato (RN20).
  - A soma das parcelas é igual ao valor calculado da origem.
  - Só há cobrança de manutenção se o valor calculado for maior que zero.
  - Fora de contrato, a preventiva é paga antes da execução; a corretiva pode ser executada antes do pagamento se houver orçamento aprovado.
  - A parcela fica "paga" quando o valor pago quita o valor da parcela.
  - O pagamento nunca é excluído: é cancelado ou corrigido por usuário autorizado, com registro no log.
- Resultado: contas a receber controladas.

#### PN 14 — controlar contas a pagar
- Objetivo: manter o histórico de contas pendentes e pagas da empresa.
- Quando ocorre: quando houver contas em aberto ou pagas pela empresa.
- Dados: fornecedor, descrição da despesa, valor total, valor pago, vencimento, número do boleto (quando aplicável), situação (paga ou não) e data de pagamento.
- Regras: toda conta está vinculada a um fornecedor cadastrado; cada boleto tem numeração única; a conta só é dada como paga quando o valor pago é igual ao valor total, e a situação muda automaticamente para "Paga"; não há pagamentos parciais.
- Resultado: controle dos custos e pagamentos da empresa.

#### PN 15 — controlar acesso e auditoria
- Objetivo: controlar quem acessa o sistema e proteger dados pessoais (LGPD).
- Quando ocorre: na criação de cada conta de usuário e a cada acesso ou operação no sistema.
- Dados: usuário (login e perfil) e log de acesso (data/hora, ação, tabela, registro afetado, resultado e finalidade).
- Regras: perfis administrador, atendimento, técnico e financeiro; o usuário nunca é excluído; o log só recebe inserções, inclusive de tentativas negadas.
- Resultado: acessos rastreáveis e permissões por perfil.

---

###  Requisitos do Sistema

####  Requisitos Funcionais (RF)

- RF01 - Cadastro de clientes: O sistema deve permitir cadastrar clientes com nome (ou razão social), CPF/CNPJ, telefone, endereço, e-mail, cidade e estado, todos obrigatórios.
  
- RF02 - Consulta de clientes e histórico: O sistema deve permitir consultar e buscar clientes, exibindo em seu perfil o histórico completo de manutenções vinculadas.
  
- RF03 - Cadastro de Geradores: O sistema deve permitir cadastrar geradores vinculados a um cliente, registrando número de série, marca, modelo, status operacional, potência em kVA e horímetro atual. Um cliente pode possuir um ou mais geradores cadastrados.
  
- RF04 - Cronograma Preventivo: O sistema deve gerar automaticamente, no cadastro do gerador, um cronograma de inspeção preventiva por peça crítica (ex: bateria, óleo, filtros, tanque) e atualizar a data e o horímetro da última troca sempre que uma manutenção substituir ou limpar o item.
  
- RF05 - Alerta de Peças Vencidas/A Vencer: O sistema deve listar as peças com manutenção preventiva vencida ou próxima do vencimento para cada gerador
  
- RF06 - Cadastro de Contratos de Manutenção: O sistema deve permitir cadastrar contratos de manutenção vinculados a um cliente, informando data de início, data de término (opcional), valor mensal, tipo de periodicidade e status, permitindo associar múltiplos geradores do mesmo cliente ao contrato.
  
- RF07 - Registro de Orçamentos: O sistema deve permitir registrar orçamentos por gerador, detalhando data, valor orçado, status (ex: pendente, aprovado, rejeitado) e data de aprovação.

- RF08 - Gestão de Ordens de Manutenção: O sistema deve permitir registrar manutenções preventivas e corretivas vinculadas ao gerador, ao contrato vigente e ao orçamento (quando aplicável), registrando data, tipo, status, número da nota fiscal, problema relatado e data de conclusão. O código identificador da manutenção deve ser gerado automaticamente pelo sistema.
  
- RF09 - Composição da Manutenção: O sistema deve permitir vincular a cada manutenção ao menos um técnico responsável, ao menos um serviço executado e, opcionalmente, peças aplicadas (informando valor unitário aplicado e quantidade).
  
- RF10 - Controle de Ciclo de Vida da Manutenção: O sistema deve controlar os status da manutenção (Aberta, Em andamento, Concluída) e permitir a alteração de serviços, peças e técnicos apenas enquanto ela estiver aberta ou em andamento. Após a conclusão, as alterações somente poderão ser feitas por usuários autorizados, com registro do histórico, conforme a RN16.
  
- RF11 - Cálculo Dinâmico de Valores: O sistema deve calcular o valor total da manutenção somando (valor unitário × quantidade) dos serviços e peças aplicados, mantendo o cálculo dinâmico sem gravá-lo de forma estática; manutenções cobertas por contrato ativo devem ter valor final zerado para o cliente.
  
- RF12 - Catálogo de Serviços: O sistema deve manter um catálogo de serviços contendo nome, descrição detalhada e valor base.
  
- RF13 - Cadastro de Técnicos e Escalas: O sistema deve permitir cadastrar técnicos (nome, CPF, telefone, e-mail) e gerenciar suas escalas de plantão e folga (definindo período e turno de atendimento).
  
- RF14 - Gestão de Parcelas de Pagamento: O sistema deve gerar e controlar parcelas financeiras referentes a manutenções avulsas e contratos (registrando vencimento, valor previsto, data de pagamento, forma de pagamento, status e valor pago), permitindo cancelamentos ou correções estritamente por usuários com perfil de administrador.
  
- RF15 - Controle de Estoque de Peças: O sistema deve permitir cadastrar peças com seus prazos de troca em dias e/ou em horas, e controlar o saldo de estoque em tempo real, bloqueando movimentações que resultem em saldo negativo, conforme a RN23.
  
- RF16 - Gestão de Fornecedores e Compras: O sistema deve permitir cadastrar fornecedores e registrar compras de peças por itens; a confirmação de recebimento da compra deve atualizar o estoque automaticamente, assim como o uso em manutenções deve dar baixa.
  
- RF17 - Gestão de Usuários e Perfis: O sistema deve gerenciar usuários do sistema associados a perfis de acesso (Administrador, Atendimento, Técnico ou Financeiro), adotando exclusão lógica (desativação) em vez de remoção física do banco de dados.
  
- RF18 - Trilha de Auditoria (Logs): O sistema deve registrar em log de auditoria imutável todas as tentativas de acesso, operações de escrita e tentativas de login negadas de usuários cadastrados.
  
- RF19 – Aditivos Contratuais: O sistema deve permitir registrar aditivos sempre que as condições de um contrato forem alteradas, informando o contrato, a data do aditivo, a descrição da alteração e as condições anteriores. Um contrato pode ter vários aditivos, e o histórico não pode ser excluído, conforme a RN27.
  
- RF20 - Gestão de Contas a Pagar: O sistema deve permitir registrar contas a pagar vinculadas a um fornecedor cadastrado, informando descrição, valor total, valor pago, vencimento, número do boleto (quando houver) e data de pagamento, e alterar a situação da conta para paga somente quando o valor pago for igual ao valor total, conforme a RN24.

---

####  Requisitos Não Funcionais (RNF)

- RNF01 - Segurança e criptografia: CPF/CNPJ e endereço dos clientes devem ser protegidos por criptografia em repouso no banco de dados, com acesso restrito a usuários autorizados, conforme as diretrizes da LGPD.
 
- RNF02 - Controle de acesso e LGPD:  sistema deverá permitir o acesso às funcionalidades e informações conforme o nível de autorização de cada usuário. As operações realizadas deverão ser registradas em um histórico de auditoria, contendo identificação do usuário, data, horário e ação executada.

- RNF03 - Integridade e imutabilidade de Auditoria: o log de acesso só recebe inserções; nenhum perfil pode alterá-lo ou excluí-lo.
  
- RNF04 - Integridade relacional: o banco deve garantir chaves estrangeiras, unicidades e restrições de valores (InnoDB, CHECK e transações).
  
- RNF05 - Disponibilidade 24/7: o sistema deve aceitar registros em qualquer horário, por causa do plantão de 24 h.
  
- RNF06 - Desempenho do sistema: cadastros e consultas devem responder em até 5 segundos em qualquer dispositivo.
  
- RNF07 - Acessibilidade: o sistema deve seguir a WCAG 2.1 nível AA em todas as páginas.
  
- RNF08 - Portabilidade e compatibilidade: o sistema deve funcionar nos sistemas operacionais populares, da instalação às atualizações.
  
- RNF09 - Usabilidade: a interface deve ser simples e compreensível para todos os perfis de usuário.

####  Restrições organizacionais:

- REST01 - Conformidade com Normas Regulamentadoras: A execução e a parametrização do catálogo de serviços do sistema devem estar adequadas às diretrizes de segurança da NR-10 (Segurança em Instalações Elétricas), NR-12 (Segurança no Trabalho em Máquinas e Equipamentos), NR-20 (Manuseio de Inflamáveis e Combustíveis) e NR-6 (Equipamentos de Proteção Individual - EPI).

- REST02 - Regime de Operação Ininterrupto: Devido à natureza dos serviços de emergência e ao regime de plantão 24/7 da empresa, o sistema não poderá passar por rotinas de manutenção programada que bloqueiem a inserção de dados em horários comerciais ou noturnos.

- REST03 - Diretrizes de Manutenção Preventiva: O sistema avisa quando peças importantes (como bateria, óleo, filtros e tanque) precisam ser trocadas ou limpas, baseando-se no desgaste natural de uso.

- REST04 - Suporte a Operação Offline em Campo: Como o técnico pode atender em locais sem sinal (como subsolos), o sistema permite anotar os dados da manutenção e sincroniza tudo com o servidor assim que a internet voltar.

- REST05 - Imutabilidade e Rastreabilidade Financeira: Contas pagas e contratos não podem ser apagados do sistema; se houver algum erro, o administrador deve fazer um registro de correção para manter a contabilidade certa.

- REST06 - Priorização de Chamados de Emergência: O sistema ajuda a identificar e priorizar os chamados mais urgentes para acionar rapidamente o técnico que estiver de plantão no turno.

### Regras de negócio

As regras de negócio estabelecem os critérios, procedimentos e restrições que deverão ser respeitados pelo sistema de gerenciamento de manutenções preventivas e corretivas de grupos geradores da empresa S. A. de Lima.

- RN01 – Identificação de clientes: Cada cliente deverá possuir um CPF ou CNPJ único no sistema, não sendo permitido cadastrar documentos duplicados.

- RN02 – Vinculação de geradores: Todo gerador cadastrado deverá estar obrigatoriamente vinculado a um único cliente.

- RN03 – Identificação de geradores: Cada gerador deverá possuir um número de série único, composto por caracteres alfanuméricos.

- RN04 – Situação cadastral dos geradores: Cada gerador deverá possuir uma situação cadastral que permita identificar sua condição, podendo ser classificado como ativo, em manutenção ou inativo.

- RN05 – Vinculação de manutenções: Toda manutenção deverá estar vinculada a exatamente um gerador.

- RN06 – Responsabilidade técnica: Toda manutenção deverá possuir pelo menos um técnico responsável, podendo contar com a participação de vários técnicos.

- RN07 – Serviços realizados: Toda manutenção deverá possuir pelo menos um serviço associado, podendo conter vários serviços e peças utilizadas. Os serviços e as peças deverão ser registrados individualmente.

- RN08 – Matriz de manutenção preventiva: O cronograma de manutenção preventiva deverá considerar os intervalos de utilização e o tempo de vida útil dos componentes do gerador, respeitando os seguintes critérios de referência:
- Óleo lubrificante: troca, em média, a cada 150 horas de funcionamento ou 12 meses desde a última troca, prevalecendo o critério atingido primeiro.
- Filtros de óleo e combustível: substituição durante a realização da troca de óleo lubrificante.
- Filtro de ar: substituição a cada 200 horas de funcionamento.
- Bateria: substituição, em média, a cada 2 anos.
- Tanque de combustível: limpeza e inspeção a cada 12 meses.
Os intervalos deverão considerar as recomendações do fabricante, quando disponíveis, e poderão ser ajustados conforme as condições de operação do gerador.

- RN09 – Atualização do cronograma: Após a realização de uma manutenção ou substituição de componente, deverão ser atualizados os registros da data da última intervenção e do horímetro correspondente para cada componente, permitindo calcular os próximos prazos de manutenção preventiva.

- RN10 – Elaboração e aprovação de orçamentos: Toda manutenção corretiva deverá possuir um orçamento elaborado e apresentado ao cliente, vinculado ao respectivo cliente e gerador. A execução somente poderá ser iniciada após a aprovação do orçamento pelo cliente, inclusive em situações de emergência.

- RN11 – Situação dos orçamentos: Cada orçamento deverá possuir um status que identifique sua situação, podendo ser classificado como pendente, aprovado ou recusado. Somente orçamentos aprovados poderão autorizar a execução de manutenções corretivas.

- RN12 – Vinculação de contratos: Cada contrato deverá estar vinculado a um único cliente e poderá abranger um ou mais geradores pertencentes a esse mesmo cliente.

- RN13 – Abrangência contratual: Os serviços e componentes incluídos na manutenção preventiva deverão ser definidos individualmente em cada contrato. Os itens que não estiverem contemplados poderão ser cobrados separadamente.

- RN14 – Condições de cobrança e pagamento: As manutenções preventivas contempladas pelo contrato serão cobradas conforme as condições estabelecidas no próprio contrato. Os serviços e componentes não incluídos poderão gerar cobranças adicionais. As manutenções preventivas realizadas fora de contrato deverão ser pagas antes da execução. Nas manutenções corretivas, a execução poderá ocorrer antes da confirmação do pagamento, desde que o orçamento tenha sido previamente aprovado pelo cliente.

- RN15 – Cálculo do valor da manutenção: O valor final de uma manutenção deverá ser calculado com base na soma dos serviços realizados e das peças utilizadas, considerando suas respectivas quantidades e valores aplicados. Itens cobertos pelo contrato poderão possuir valor aplicado igual a zero.

- RN16 – Situação da manutenção: Uma manutenção deverá seguir as etapas de abertura, execução e conclusão. Os serviços e componentes registrados poderão ser alterados enquanto a manutenção estiver aberta ou em execução. Após a conclusão, alterações deverão ser realizadas somente por usuários autorizados, preservando o histórico das modificações.

- RN17 – Identificação de técnicos: Cada técnico deverá possuir um CPF único, composto por 11 dígitos numéricos.

- RN18 – Escalas de trabalho: Cada escala deverá estar vinculada a um técnico, e sua data de término não poderá ser anterior à data de início.

- RN19 – Cadastro de serviços: Cada serviço deverá possuir um nome único, descrição e valor-base cadastrado. O valor aplicado poderá variar conforme as condições da manutenção ou do contrato.

- RN20 – Registro de pagamentos: Cada pagamento deverá estar relacionado a uma única origem de cobrança, podendo ser referente a uma manutenção ou a um contrato. Quando houver parcelamento, a soma das parcelas deverá corresponder ao valor total devido após a quitação integral.

- RN21 – Histórico financeiro: Os registros de pagamentos não deverão ser excluídos fisicamente. Em caso de erro, deverão ser cancelados ou corrigidos por um usuário autorizado, mantendo o histórico da alteração.

- RN22 – Cadastro de fornecedores: Cada fornecedor deverá possuir um CNPJ único no sistema.

- RN23 – Compra de peças e controle de estoque: Toda compra deverá estar vinculada a um fornecedor cadastrado e registrar os itens adquiridos, suas respectivas quantidades e valores. Após a confirmação do recebimento físico da compra, o sistema deverá atualizar automaticamente a quantidade disponível em estoque, impedindo que a mesma compra gere entradas duplicadas. A utilização de peças em manutenções deverá gerar automaticamente a baixa da quantidade correspondente no estoque. O sistema deverá impedir movimentações que resultem em saldo negativo. Ajustes manuais somente poderão ser realizados por usuários autorizados, com registro no histórico de auditoria.

- RN24 – Contas a pagar: Cada conta a pagar deve possuir um identificador único de boleto, quando aplicável. O pagamento deve corresponder ao valor total da conta, e seu status deve ser atualizado para "Paga" após a quitação integral.

- RN25 – Controle de usuários: Cada usuário deverá possuir um login único, credenciais próprias e um perfil de acesso definido conforme sua função no sistema.

- RN26 – Auditoria: As ações realizadas pelos usuários deverão ser registradas em histórico de auditoria, permitindo identificar quem realizou cada operação e quando ela ocorreu.

- RN27 – Alterações contratuais: As alterações nas condições dos contratos deverão ser registradas por meio de aditivos contratuais, preservando o histórico das condições anteriormente estabelecidas e permitindo identificar as modificações realizadas.

---

### Notação do DER

- **Software:** brModelo Web (<https://app.brmodeloweb.com>), modelo conceitual.
- Identificadores como círculos preenchidos; atributos comuns como círculos vazios; atributos de relacionamento ligados ao losango; **sem chaves estrangeiras**.

| Elemento | Como aparece | No nosso DER |
| :--- | :--- | :--- |
| **Entidade** | retângulo | `Cliente`, `Contrato`, `Aditivo_contrato`, `Gerador`, `Orçamento`, `Manutenção`, `Serviço`, `Técnico`, `Escala`, `Peça`, `Cronograma_Preventivo`, `Pagamento`, `Fornecedor`, `Compra`, `Contas_a_pagar`, `Usuario`, `Log_acesso` (17 entidades) |
| **Relacionamento** | losango | `possui` (Cliente–Gerador), `firma` (Cliente–Contrato), `cobre` (Contrato–Gerador), `recebe` (Gerador–Manutenção), `realizada por` (Manutenção–Técnico) |
| **Cardinalidade mínima e máxima** | par `(mín, máx)` dos dois lados de cada relacionamento | `(0, n)` e `(1, 1)` em `Cliente` **possui** `Gerador`; `(0, 1)` e `(0, 1)` em `Orçamento` **origina** `Manutenção`; `(1, n)` em `Compra` **contém** `Peça` |
| **Autorrelacionamento** | losango ligado duas vezes à mesma entidade | não utilizado: nenhuma entidade se relaciona com ela mesma |
| **Atributo identificador (chave)** | círculo **preenchido** | `id_cliente`, `id_gerador`, `id_contrato`, `id_manutencao`, `id_pagamento` (um por entidade) |
| **Identificador composto** | mais de um círculo preenchido na mesma entidade | não utilizado no DER: todas as entidades têm identificador simples. A chave composta aparece só nas tabelas associativas do modelo lógico |
| **Atributo comum** | círculo **vazio** | `nome`, `cpf_cnpj`, `telefone`, `valor_mensal`, `status`, `data_manutencao` |
| **Atributo multivalorado** | círculo vazio com a cardinalidade do atributo | não utilizado: os dados que se repetem viraram entidades ou relacionamentos (peças, serviços, técnicos e parcelas) |
| **Atributo composto** | atributo com subatributos ligados a ele | não utilizado: o endereço do cliente é representado por atributos simples (`endereco`, `cidade`, `estado`) |
| **Atributo de relacionamento** | círculo vazio ligado ao losango | `valor_unitario_aplicado` e `quantidade` em `utiliza` e `usa`; `quantidade` e `valor_custo` em `contém` |
| **Generalização/especialização** | triângulo ligando a entidade genérica às especializadas | não utilizado: o perfil do usuário é um atributo (`perfil`), não uma especialização |
| **Entidade associativa** | retângulo envolvendo o losango do relacionamento | não utilizado: os relacionamentos N:N (`utiliza`, `usa`, `contém`) são desenhados como losangos com atributos, e viram tabelas associativas no modelo lógico (seção 1.2) |

---

### DER conceitual revisado (Caso A — mesma organização da Entrega 1)

![DER conceitual revisado](<DER (1).png>)

**Apontamentos da correção da Entrega 1 e o que mudou**

| Apontamento da correção da E1 | O que mudou no trabalho | Por quê |
| :--- | :--- | :--- |
| DER sem `PECA/MATERIAL` (essencial): trocas de bateria, óleo e filtro não podiam ser registradas | Criada a entidade `Peça` (nome, descrição, valor de venda, prazos de troca em dias/horas, estoque) e os relacionamentos `usa` (com valor unitário aplicado e quantidade) e `contém` | Sem ela não há como registrar as peças usadas por manutenção nem controlar estoque |
| DER sem `PAGAMENTO` (essencial): regra de pagamento antes/depois da execução sem onde registrar | Criada a entidade `Pagamento` (parcela, vencimento, valor, data, forma, status, valor pago), ligada a `Manutenção` (`gera`) ou a `Contrato` (`gera_mensalidade`) | Permite registrar o recebimento e aplicar as regras RN14 e RN20 |
| Sugestão: `ORCAMENTO` | Criada `Orçamento`, ligada a `Gerador` (`solicita`) e 0..1:0..1 a `Manutenção` (`origina`) | Corretiva exige orçamento aprovado (RN10, RN11) |
| Sugestão: `PLANO/CRONOGRAMA PREVENTIVO` ("nada no modelo sustenta a regra do cronograma") | Criada `Cronograma_Preventivo` (data e horímetro da última troca), ligada a `Gerador`, `Peça` e atualizada por `Manutenção` (`atualiza`) | Sustenta RN08/RN09 e o problema P2 |
| Sugestão: `CONTRATO` | Criadas `Contrato` e `Aditivo_contrato`, ligadas a cliente, geradores, manutenções e pagamentos | Processo ausente na E1; resolve P3, P4 e P5 |
| Sugestão: `FORNECEDOR` e ciclo de compras ausente | Criadas `Fornecedor`, `Compra` (com `contém` → peça) e `Contas_a_pagar` | Cobre compra de peças, recebimento/estoque e contas a pagar |
| Escala do plantão 24h só citada como restrição | Criada `Escala` (período, turno, folga), ligada a `Técnico` (`cumpre`) | Plantão passa a ser dado do banco |
| Atributo `servico_realizado` (texto) em `Manutenção` redundante com `utiliza` | Atributo removido; serviços ficam só no relacionamento `utiliza` | Evita redundância e perda de quantidade/valor aplicado |
| N:N sem atributos próprios (`Manutenção`×`Serviço`) | `utiliza`, `usa` e `contém` agora têm atributos (valor unitário aplicado, quantidade, valor de custo) | O valor da manutenção é calculado a partir deles (RN15) |
| Dicionário sem SGBD/engine, collation, versão/data, notação completa, log e LGPD | Dicionário v6.0 (08/11/2026) com ficha técnica (MySQL 8.0.16+, InnoDB, utf8mb4_unicode_ci), notação completa, seção `LOG_ACESSO` e seção `LGPD` | CPF, CNPJ e endereço são dados pessoais; a justificativa anterior estava equivocada. `Usuario` e `Log_acesso` entraram no DER |
| Prefixos impróprios (`QT_VALOR`, `QT_VALOR_BASE`, `QT_POTENCIA`, `ID_CPF_CNPJ`) | Renomeados para `VL_*`, `MD_POTENCIA` e `NR_CPF_CNPJ`, com prefixos `VL_`, `MD_` e `NR_` explicados no dicionário | `QT_` é quantidade; valor e potência têm prefixos próprios |
| RF falava em "mais de um serviço por cliente" | RF09 passou a ligar serviços à manutenção | O modelo liga serviço à manutenção, não ao cliente |
| Alguns RF eram regras de unicidade | RFs reescritos como funcionalidades, com unicidades nas RNs | RF descreve o que o sistema faz; unicidade é regra |
| Entrevista sem relato; foto não referenciada no README | Seção "Relato da entrevista" com quem, quando e onde, e foto da entrevista referenciada | Exigência da E2 |
| README só com nomes, sem RGM | Tabela de integrantes com RGM e usuário do GitHub | Identificação dos autores |
| Possível conflito de interesse (camisa da empresa na foto) | Vínculo declarado na caracterização: o integrante Kauan José da Silva trabalha na empresa e é sobrinho do dono | Transparência exigida pela E2 |
| Regras ausentes: compras de fornecedor cadastrado e conferência das peças | Criadas RN22 (fornecedor com CNPJ único), RN23 (compra ligada a fornecedor, com itens, quantidades e valores; o estoque só é atualizado após a confirmação do recebimento) e RN24 (contas a pagar) | Cobre o ciclo de compras que faltava |
| Regra ausente: emissão de nota fiscal | O número da nota fiscal é guardado em `Manutenção` e em `Compra` (`numero_nota_fiscal`); a emissão da nota em si fica fora do sistema | O sistema registra a nota, não a emite |
| Regra parcial: LGPD (só criptografia) | Seção LGPD no dicionário, trilha de auditoria (`Usuario`, `Log_acesso`, RN26) e requisitos de segurança (RNF) | CPF, CNPJ e endereço são dados pessoais |
| Regra parcial: técnico habilitado (NR-10) | Mantida fora do modelo; as NRs aparecem como restrição organizacional (REST01) | O sistema não controla cursos nem certificados dos técnicos; a habilitação é conferida pela empresa fora do banco |
| Regra ausente: garantia legal do serviço (CDC) | Mantida fora do modelo | A empresa não registra garantia do serviço hoje; o assunto é tratado diretamente com o cliente |
| Uso 2 de IA com prompt e resposta genéricos | Item 2 da seção 6 completado com o que foi rejeitado e a reflexão crítica; o prompt original foi mantido | Apontamento da correção |

O grupo manteve fora do modelo a garantia do serviço e a habilitação NR-10, pelos motivos registrados acima; os demais apontamentos foram aplicados.

---

## 1.2 Conversão do Modelo Conceitual para o Modelo Lógico

- **Entidades → Tabelas:** cada uma das 17 entidades do DER virou uma tabela com o mesmo nome (`Cliente`, `Contrato`, `Aditivo_contrato`, `Gerador`, `Orcamento`, `Manutencao`, `Servico`, `Tecnico`, `Escala`, `Peca`, `Cronograma_Preventivo`, `Pagamento`, `Fornecedor`, `Compra`, `Contas_a_pagar`, `Usuario`, `Log_acesso`). O DER final tem **17 entidades**, mais **5 relacionamentos N:N** que viraram tabelas associativas, totalizando **22 tabelas**.
- **Atributos → Colunas:** cada atributo virou coluna; o identificador virou `PK` com `AUTO_INCREMENT`. Atributos de relacionamento foram para a tabela associativa. O dicionário e o script usam os mesmos tipos e tamanhos (INT, DECIMAL(10,2) para valores em dinheiro, DECIMAL(8,2) para potência, VARCHAR, CHAR, DATE, DATETIME); exemplos de tamanho: VARCHAR(120), CHAR(11). Listas fechadas de valores (status, tipo, turno, perfil etc.) são `VARCHAR(20)` com `CHECK ... IN (...)`.
- **Relacionamentos → Chaves:**
  - **1:N** — a chave do lado "1" vai como `FK` para a tabela do lado "N" (ex.: `Gerador.id_cliente`, `Manutencao.id_gerador`, `Compra.id_fornecedor`, `Escala.id_tecnico`).
  - **0,1 : 0,1** (`Orçamento` origina `Manutenção`) — `FK` opcional `Manutencao.id_orcamento` com índice `UNIQUE`, para que um orçamento origine no máximo uma manutenção.
  - **Origem exclusiva do pagamento** — `Pagamento` tem `id_manutencao` e `id_contrato`, ambos opcionais, com `CHECK` de que exatamente um é preenchido (RN20).
- **Cardinalidades N:N → tabelas associativas** com PK composta:

| Relacionamento | Tabela associativa | PK composta | Atributos próprios |
| :--- | :--- | :--- | :--- |
| Manutenção × Serviço | `utiliza` (`MANUTENCAO_SERVICO`) | `id_manutencao`, `id_servico` | `valor_unitario_aplicado`, `quantidade` |
| Manutenção × Peça | `usa` (`MANUTENCAO_PECA`) | `id_manutencao`, `id_peca` | `valor_unitario_aplicado`, `quantidade` |
| Manutenção × Técnico | `realizada_por` (`MANUTENCAO_TECNICO`) | `id_manutencao`, `id_tecnico` | — |
| Manutenção × Cronograma | `atualiza` (`MANUTENCAO_CRONOGRAMA`) | `id_manutencao`, `id_cronograma` | — |
| Compra × Peça | `contem` (`COMPRA_PECA`) | `id_compra`, `id_peca` | `quantidade`, `valor_custo` |

- **Generalização/especialização:** o DER **não tem** generalização. O perfil do usuário (administrador, atendimento, técnico, financeiro) é um `VARCHAR(20)` com `CHECK`, e não subtipos, porque os perfis não têm atributos diferentes.

---

## 1.3 Definição de Chaves Primárias e Estrangeiras

| Tabela | Chave primária | Chaves estrangeiras |
| :--- | :--- | :--- |
| `Cliente` | `id_cliente` | — |
| `Contrato` | `id_contrato` | `id_cliente` → `Cliente` |
| `Aditivo_contrato` | `id_aditivo` | `id_contrato` → `Contrato` |
| `Gerador` | `id_gerador` | `id_cliente` → `Cliente`; `id_contrato` → `Contrato` (opcional) |
| `Orcamento` | `id_orcamento` | `id_gerador` → `Gerador` |
| `Manutencao` | `id_manutencao` | `id_gerador` → `Gerador`; `id_contrato` → `Contrato` (opc.); `id_orcamento` → `Orcamento` (opc., único) |
| `Servico` | `id_servico` | — |
| `Tecnico` | `id_tecnico` | — |
| `Escala` | `id_escala` | `id_tecnico` → `Tecnico` |
| `Peca` | `id_peca` | — |
| `Cronograma_Preventivo` | `id_cronograma` | `id_gerador` → `Gerador`; `id_peca` → `Peca` |
| `Pagamento` | `id_pagamento` | `id_manutencao` → `Manutencao` (opc.); `id_contrato` → `Contrato` (opc.) |
| `Fornecedor` | `id_fornecedor` | — |
| `Compra` | `id_compra` | `id_fornecedor` → `Fornecedor` |
| `Contas_a_pagar` | `id_conta_pagar` | `id_fornecedor` → `Fornecedor` |
| `Usuario` | `id_usuario` | — |
| `Log_acesso` | `id_log` | `id_usuario` → `Usuario` |
| `utiliza` | (`id_manutencao`, `id_servico`) | ambas → `Manutencao`, `Servico` |
| `usa` | (`id_manutencao`, `id_peca`) | ambas → `Manutencao`, `Peca` |
| `realizada_por` | (`id_manutencao`, `id_tecnico`) | ambas → `Manutencao`, `Tecnico` |
| `atualiza` | (`id_manutencao`, `id_cronograma`) | ambas → `Manutencao`, `Cronograma_Preventivo` |
| `contem` | (`id_compra`, `id_peca`) | ambas → `Compra`, `Peca` |

---

## 1.4 Processo de Normalização (1FN, 2FN e 3FN)

- **1FN (sem grupos repetitivos nem multivalorados):** a manutenção tem vários serviços, peças e técnicos. Se fossem colunas ou listas dentro de `Manutencao` haveria grupos repetitivos; por isso viraram as tabelas `utiliza`, `usa` e `realizada_por`, com uma linha por item. O texto `servico_realizado` da E1 foi removido pelo mesmo motivo. Cada gerador tem várias peças acompanhadas: virou `Cronograma_Preventivo`, uma linha por peça. As parcelas de pagamento são linhas de `Pagamento`, não colunas "parcela1, parcela2".
- **2FN (sem dependências parciais):** nas tabelas com chave composta, todo atributo depende da chave inteira. Em `utiliza`, `valor_unitario_aplicado` e `quantidade` dependem do par (manutenção, serviço) — o mesmo serviço tem valor diferente em manutenções diferentes. Nome, descrição e valor-base do serviço ficam em `Servico`, e não repetidos em `utiliza`. O mesmo vale para `usa` (dados da peça ficam em `Peca`) e `contem`.
- **3FN (sem dependências transitivas):** os dados do cliente não se repetem em `Gerador` ou `Manutencao` (basta `id_cliente`); os dados do fornecedor ficam fora de `Compra` e `Contas_a_pagar`; o prazo de troca fica em `Peca`, não em `Cronograma_Preventivo`. O **valor total da manutenção não é gravado** (seria dependente de itens), é calculado por consulta. Exceção consciente: `Cliente` mantém `cidade` e `estado` juntos (a cidade determina o estado); não se criou tabela de cidades porque o ganho seria pequeno para 96 clientes e os valores seguem um domínio fechado (`CHAR(2)` no estado). 
- **Justificativa do processo:** a 1FN era necessária porque o atendimento combina muitos itens; a 2FN, porque os valores praticados variam por manutenção; a 3FN, para que uma alteração de cadastro (telefone do cliente, preço-base do serviço) seja feita em um só lugar, o que resolve a inconsistência das fichas em papel (P1).

---

## 1.5 Justificativas Técnicas das Decisões

- **Chaves primárias:** inteiros `AUTO_INCREMENT` (substitutas) em todas as entidades, pois os identificadores naturais (CPF/CNPJ, número de série) são sensíveis, longos ou podem mudar. Os naturais ficam com `UNIQUE`. Em associativas, PK composta impede repetir o mesmo item na mesma manutenção.
- **Chaves estrangeiras:** implementam os relacionamentos da seção 1.3, com `InnoDB` para garantir a integridade referencial (RNF04). Colunas opcionais (`Gerador.id_contrato`, `Manutencao.id_contrato`, `Manutencao.id_orcamento`) correspondem às cardinalidades mínimas 0 do DER.
- **Restrições e as regras que implementam:**

| Restrição | Regra |
| :--- | :--- |
| `Cliente.cpf_cnpj` `UNIQUE NOT NULL` | RN01 |
| `Gerador.id_cliente` `NOT NULL` | RN02 |
| `Gerador.numero_serie` `UNIQUE`, alfanumérico | RN03 |
| `Gerador.status` `CHECK (status IN ('ativo','em_manutencao','inativo'))` | RN04 |
| `Manutencao.id_gerador` `NOT NULL` | RN05 |
| Ao menos um técnico / serviço por manutenção (aplicação + consulta de auditoria) | RN06, RN07 |
| `Manutencao.status` `CHECK (status IN ('aberta','em_andamento','concluida'))`, padrão `'aberta'`; `data_conclusao ≥ data_manutencao` | RN16 |
| `Orcamento.status` `CHECK (status IN ('pendente','aprovado','recusado'))`; `Manutencao.id_orcamento` `UNIQUE` | RN10, RN11 |
| `Contrato.id_cliente` `NOT NULL`; contrato do gerador do mesmo cliente (aplicação + auditoria) | RN12 |
| `valor_unitario_aplicado ≥ 0` (zero se coberto por contrato) | RN15 |
| `Tecnico.cpf` `CHAR(11)` `UNIQUE` | RN17 |
| `Escala.data_fim ≥ data_inicio` | RN18 |
| `Servico.nome_servico` `UNIQUE` | RN19 |
| `Pagamento`: exatamente uma origem (`CHECK`); parcela única por origem; nunca excluído | RN20, RN21 |
| `Fornecedor.cnpj` `UNIQUE` | RN22 |
| `Peca.estoque ≥ 0`; ao menos um prazo de troca | RN23, RN08 |
| `Contas_a_pagar.numero_boleto` `UNIQUE`; paga só se `valor_pago = valor_total` | RN24 |
| `Usuario.login` `UNIQUE`; perfil `CHECK (perfil IN ('administrador','atendimento','tecnico','financeiro'))` | RN25 |
| `Log_acesso` só recebe `INSERT` | RN26, RNF03 |
| `Aditivo_contrato` nunca excluído | RN27 |

> **Nota sobre os valores das listas fechadas.** Na tabela acima, os valores aparecem em minúsculas e com `_` (por exemplo `em_manutencao`) para indicar o conceito de cada regra. No script SQL (`docs/script.sql`), os mesmos valores são gravados com a inicial maiúscula e sem acento, que é o formato usado na massa de dados e nas consultas:
>
> | Coluna | Valores no script |
> | :--- | :--- |
> | `Gerador.status` | `'Ativo'`, `'Em manutencao'`, `'Inativo'` |
> | `Manutencao.status` | `'Aberta'`, `'Em andamento'`, `'Concluida'` |
> | `Manutencao.tipo_manutencao` | `'Preventiva'`, `'Corretiva'` |
> | `Orcamento.status` | `'Pendente'`, `'Aprovado'`, `'Recusado'` |
> | `Compra.status` | `'Pedida'`, `'Recebida'`, `'Cancelada'`|
> | `Usuario.perfil` | `'Administrador'`, `'Atendimento'`, `'Tecnico'`, `'Financeiro'` |
>
> Além do que a tabela lista, o script também garante:
> - `Peca`: ao menos um prazo de troca (`prazo_troca_dias` ou `prazo_troca_horas`) preenchido, ambos maiores que zero quando informados (RN08).
> - `Pagamento`: parcela única por origem, por meio de `UNIQUE (id_manutencao, numero_parcela)` e `UNIQUE (id_contrato, numero_parcela)` (RN20).

- **Auditoria (RN26, RNF03):** `Log_acesso` pertence sempre a um usuário cadastrado (cardinalidade `Usuário (0,n) — realiza — (1,1) Log_acesso`) e só recebe inserções. Registra ações permitidas e negadas de usuários existentes (`resultado = 'Negado'`); login com usuário inexistente não é registrado, pois não identifica ninguém e a trilha existe para rastrear quem acessou dados pessoais (LGPD).
- **Decisões arquiteturais gerais:** valor da manutenção calculado e não gravado (RN15); exclusão lógica de usuário e histórico financeiro imutável (RN21, RN25); tabela de log única para auditoria e LGPD; `utf8mb4_unicode_ci` para acentos em nomes e endereços; criptografia em repouso prevista (ver dicionário, seção LGPD).

---

## 1.6 Proposta de Arquitetura Analítica para BI e IA

###  Informações Estratégicas

A partir do banco de dados relacional e do monitoramento dos indicadores de desempenho, a gestão da empresa consegue extrair informações estratégicas cruciais para a tomada de decisão no suporte 24h:

- Agilidade no Atendimento Corretivo (MTTR): Permite monitorar com precisão o tempo médio que a equipe leva para solucionar falhas emergenciais, garantindo que o tempo de indisponibilidade dos geradores dos clientes seja minimizado e mantido abaixo da meta de 3 horas.

- Confiabilidade e Desempenho dos Equipamentos (MTBF): Avalia a durabilidade e o tempo médio de funcionamento dos geradores entre uma quebra e outra, auxiliando na identificação de modelos mais desgastados ou na necessidade de intervenções mais profundas.

- Equilíbrio Operacional (preventivas x corretivas): Fornece uma visão clara sobre a eficiência da operação de campo, permitindo verificar se a empresa está atuando de forma proativa (antecipando falhas por meio das manutenções preventivas acima de 70%) ou se está apenas reativa (apagando incêndios com corretivas).

- Previsibilidade Financeira e de Caixa (receita por contrato): Consolida de forma exata o faturamento mensal recorrente gerado pelos contratos ativos de manutenção, garantindo segurança financeira para a manutenção da estrutura e dos plantões 24/7.

- Assertividade e Qualidade Técnica em Campo (first fix rate): Mede a eficácia dos técnicos nas visitas aos clientes, assegurando que a grande maioria dos problemas seja resolvida logo no primeiro atendimento (acima de 85%), evitando retornos desnecessários por falta de peças ou diagnóstico incorreto.

---
### Indicadores e Métricas Gerenciais (KPIs)



| KPI (Indicador) | Fórmula de Cálculo | Período de Apuração | Meta Desejada |
| :--- | :--- | :--- | :--- |
| **MTTR (Tempo Médio de Reparo)** | Soma do tempo (início até o fim) dos chamados corretivos / Total de atendimentos corretivos | Mensal | Menor que 3 horas para emergências (no modelo atual é medido em dias, pois o banco guarda apenas a data) |
| **MTBF (Tempo Médio Entre Falhas)** | Horas totais de funcionamento dos geradores / Número total de falhas corretivas | Mensal / Trimestral | Maximizar a vida útil entre as quebras |
| **Taxa de Atendimento Preventivo vs. Corretivo** | (Total de Manutenções Preventivas / Total Geral de Manutenções) * 100 | Mensal | Acima de 70% (preventivas dominando as corretivas) |
| **Receita por Contrato** | Soma dos valores mensais gerados pelos contratos ativos. | Mensal | Garantir previsibilidade financeira fixa. |
| **Índice de Primeira Visita (First Fix Rate)** | (Chamados resolvidos na 1ª visita do técnico / Total de chamados) * 100 | Mensal | Acima de 85% (evitar voltar ao cliente por falta de peça) |

---

### Potencial dos Dados para Business Inteligence (BI)

A arquitetura relacional estruturada no DER — integrando entidades como Cliente, Gerador, Contrato, Manutencao, Pagamento e Peca — suporta perfeitamente a extração de relatórios e a construção de painéis gerenciais (dashboards) dinâmicos:

- **Painel operacional de campo:** manutenções abertas, geradores em manutenção e técnicos em escala (`Manutencao`, `Gerador`, `Tecnico`, `Escala`). Conecta as tabelas para monitorar chamados abertos em tempo real, o status dos geradores em atendimento e a disponibilidade dos técnicos pela tabela `Escala`.

- **Painel de confiabilidade e desempenho (MTTR/MTBF/FFR):** tempo de reparo, MTBF, índice de primeira visita e peças vencidas (`Manutencao`, `Gerador`, `Cronograma_Preventivo`, `Peca`). Usa o histórico de `Manutencao` e o horímetro de `Gerador` para medir a velocidade de reparo, a solução na primeira visita e a frequência de falhas.

- **Painel financeiro e de contratos:** receita por contrato, parcelas a receber e atrasadas, contas a pagar (`Contrato`, `Pagamento`, `Manutencao`, `Contas_a_pagar`). Apresenta a receita recorrente dos contratos ativos e o faturamento geral da empresa.

---

### Aplicações analíticas e de IA
O histórico armazenado nas tabelas do sistema serve como base para alimentar modelos preditivos e sistemas inteligentes:

- **Manutenção preditiva baseada em horímetro:** estimar a data da próxima troca de peça cruzando o horímetro de `Gerador` com o histórico de `Cronograma_Preventivo` e `Manutencao`. Um modelo pode estimar o desgaste de peças (como baterias e filtros) e abrir ordens preventivas antes de uma pane no plantão 24h.

- **Risco de inadimplência e renovação de contratos:** classificar contratos a partir do histórico de `Pagamento` e dos dados de `Contrato`, para prever atrasos e identificar padrões que melhorem a retenção e a receita por contrato.

- **Previsão de demanda de peças:** projetar o consumo (`usa`) para orientar compras (`contem`).

---
### Tabela de Rastreabilidade (Problemas e KPIs)

| Problema ou KPI | Tabelas envolvidas | Consulta |
| :--- | :--- | :--- |
| P1 — fichas em papel: histórico de atendimentos por cliente e gerador | `Cliente`, `Gerador`, `Manutencao` | S01, S04 |
| P2 — última troca e peças vencidas/a vencer | `Cronograma_Preventivo`, `Peca`, `Gerador` | G01 |
| P3 — contratos vigentes e vencendo, coerência gerador × contrato e itens com valor zerado por cobertura | `Contrato`, `Gerador`, `Manutencao`, `utiliza`, `usa` | S02, G09, A01, A11 |
| P4 — aditivos e condições anteriores por contrato | `Contrato`, `Aditivo_contrato` | G14 |
| P5 — faturamento, recebimentos, inadimplência e reajustes contratuais | `Contrato`, `Aditivo_contrato`, `Pagamento`, `Manutencao`, `Gerador`, `Cliente` | G03, G04, G11, G12, G14 |
| KPI — receita recorrente por contrato | `Contrato` | G12 |
| KPI — taxa de preventivas | `Manutencao` | G13 |
| KPI — tempo médio de reparo (MTTR, em dias) | `Manutencao` | G08 |
| KPI — MTBF aproximado | `Gerador`, `Manutencao` | G15 |
| KPI — índice de primeira visita (First Fix Rate) | `Manutencao` | G16 |
| KPI — inadimplência | `Pagamento`, `Contrato`, `Manutencao`, `Cliente` | G04 |
| KPI — peças vencidas ou a vencer | `Cronograma_Preventivo`, `Peca`, `Gerador` | G01 |
| Estoque baixo | `Peca` | G02 |
| Custos: contas a pagar por fornecedor | `Fornecedor`, `Contas_a_pagar` | G05 |
| Custos: margem de cada peça (venda x custo de compra) | `Peca`, `Compra`, `contem` | G10 |
| Carga de trabalho dos técnicos | `Tecnico`, `realizada_por`, `Manutencao` | G06 |
| Taxa de aprovação de orçamentos | `Orcamento` | G07 |

Observações: o MTTR (G08) é medido em dias porque o schema guarda apenas `DATE`; a meta de 3 horas não é verificável com o modelo atual. O MTBF (G15) usa o horímetro acumulado dividido pelas falhas do período registrado, por isso é aproximado. O First Fix Rate (G16) considera resolvida na 1ª visita a corretiva sem nova corretiva no mesmo gerador em 30 dias.

**Consultas de auditoria**

Resultado vazio = dados consistentes com a regra.

| Código | Pergunta | Regra |
| :--- | :--- | :--- |
| A01 | Há gerador ligado a um contrato de outro cliente? | RN12 |
| A02 | Há pagamento "Pago" que não quitou o valor da parcela? | RN20 |
| A03 | Há manutenção concluída sem nota fiscal? | Processo 6 |
| A04 | Há manutenção em andamento ou concluída sem técnico? | RN06 |
| A05 | Há corretiva iniciada sem orçamento aprovado? | RN10, RN11 |
| A06 | Há contrato "Ativo" com data de fim já vencida? | Processo 3 |
| A07 | Há acesso registrado de usuário inativo? | RN25, RN26 |
| A08 | Há técnico com escalas sobrepostas? | RN18|
| A09 | O status do gerador é coerente com as manutenções abertas? | RN04 |
| A10 | Há contrato sem nenhum gerador vinculado? | RN12 |

Não há consulta de auditoria para a RN07 (manutenção sem serviço), que fica a cargo da aplicação. A RN16 (conclusão exige `data_conclusao`) e a RN23 (estoque negativo) são impedidas pelo próprio banco, por `CHECK`.

---

# 2. Modelo Lógico Relacional

**Software:** brModelo Web (<https://app.brmodeloweb.com>).

![Modelo lógico](<Modelo Logico.png>)
Observação sobre os tipos no diagrama. O brModelo Web não tem o tipo DECIMAL, então o modelo lógico (PNG) mostra FLOAT nas colunas de valor monetário e de potência. No script SQL esses campos foram implementados como DECIMAL(10,2) (valores em dinheiro) e DECIMAL(8,2) (potência em kVA), porque FLOAT é aproximado e pode gerar erros de arredondamento em cálculos financeiros. Da mesma forma, os tamanhos de VARCHAR e CHAR não aparecem no diagrama. O script e o dicionário de dados são a referência oficial dos tipos.

O modelo tem **17 tabelas de entidades e 5 tabelas associativas** (22 no total), com PK, FK e cardinalidades `(mín, máx)` nas pontas. `NOT NULL`, `UNIQUE`, `CHECK` e `DEFAULT` não aparecem no diagrama; estão no [dicionário de dados](dicionariodre.html) e no script SQL.

| Grupo | Tabelas |
| :--- | :--- |
| Relacionamento com o cliente | `Cliente`, `Contrato`, `Aditivo_contrato`, `Gerador` |
| Atendimento | `Orcamento`, `Manutencao`, `Servico`, `Tecnico`, `Escala` |
| Peças e preventiva | `Peca`, `Cronograma_Preventivo` |
| Financeiro e suprimentos | `Pagamento`, `Fornecedor`, `Compra`, `Contas_a_pagar` |
| Segurança | `Usuario`, `Log_acesso` |
| Associativas (N:N) | `utiliza`, `usa`, `realizada_por`, `atualiza`, `contem` |
---

# 3. Script SQL Completo
**SGBD:** MySQL 8.0 (a partir da 8.0.16, por causa dos `CHECK`), mecanismo InnoDB, conjunto de caracteres `utf8mb4` e collation `utf8mb4_unicode_ci`.

**Arquivo:** [`docs/script.sql`](docs/script.sql) 

---

# 4. Massa de Dados

| Tabela | Volume na massa | Justificativa |
| :--- | :--- | :--- |
| `Cliente` | 102 (96 fixos com contrato + 6 avulsos) | 96 clientes fixos informados |
| `Contrato` | 96 | cada cliente fixo tem um contrato |
| `Aditivo_contrato` | 92 | alterações contratuais |
| `Gerador` | 196 | cliente pode ter mais de um gerador |
| `Manutencao` | 408 (nov/2025 a nov/2026) | média de 33 por mês |
| `Pagamento` | 1.091 | mensalidades e manutenções avulsas |
| `Tecnico` / `Escala` | 10 / 130 | 10 técnicos entre os 15 funcionários; escalas semanais |
| `Peca` / `Fornecedor` / `Compra` | 11 / 6 / 33 | bateria, óleo, filtros, tanque etc. |
| `Usuario` / `Log_acesso` | 16 (1 inativo) / 293 | 15 funcionários + conta extra; logs de usuários cadastrados |

---

# 5. Repositório GitHub

| Artefato | Arquivo |
| :--- | :--- |
| Relatório (README) | `README.md`, na raiz da branch `main` |
| Dicionário de dados (HTML, v6.0) | [dicionariodre.html](dicionariodre.html) |
| Diagrama DER conceitual revisado (brModelo Web) | [DER (1).png](DER%20%281%29.png) |
| Levantamento completo | [levantamento/levantamento.md](levantamento/levantamento.md) |
| Script SQL (MySQL) | [docs/script.sql](docs/script.sql) |
| Consultas gerenciais e de auditoria | [docs/03_consultas_.sql](docs/03_consultas_.sql) |
| Histórico de commits e colaboração | [Ver commits](../../commits/main) |
| Evidências (fotos) | [imagem empresa](evidencias/foto-empresa.jpeg) e [entrevista](evidencias/foto-nova-visita.jpeg) |
| Modelo lógico (brModelo Web) | [Modelo Logico.png](Modelo%20Logico.png) |
| Fluxograma do atendimento | [fluxograma.png](fluxograma.png) |
| Massa de dados | [docs/02_massa_dados.sql](docs/massa_de_dados.sql) |
| Apresentação (slides) |  **PREENCHER link dos slides** |

---

## 6. Uso de Inteligência Artificial
| Item | Registro |
|------|------------------|
| Ferramenta e etapa 1 | Gemini Flash, usada durante a etapa de levantamento dos Requisitos Não Funcionais (RNF) do sistema de controle de geradores e manutenções.|
| *Motivação* | Precisávamos de ajuda para acrescentar mais alguns Requisitos Não Funcionais para compor o dicionário de dados e utilizamos a IA como um ponto de partida. O objetivo foi identificar quais categorias de RNF são mais comuns, como desempenho, segurança e disponibilidade, além de obter exemplos de como esses requisitos poderiam ser descritos. |
| *Prompt(s) utilizados* | "Cite alguns Requisitos Não Funcionais"|
| *Resposta recebida* | A IA explicou que os Requisitos Não Funcionais estão relacionados à forma como o sistema deve funcionar, estabelecendo características, restrições e critérios de qualidade, em vez de descrever funcionalidades específicas. Em seguida, apresentou algumas categorias e exemplos. Entre elas, foram citadas Desempenho e Eficiência, com exemplos relacionados ao tempo de resposta e à capacidade de processamento do sistema, e Segurança, com exemplos como a criptografia de dados sensíveis e a utilização de autenticação de dois fatores (2FA). A resposta também mencionava uma terceira categoria, relacionada à disponibilidade, mas essa parte não chegou a ser analisada completamente	 |
| *Fontes consultadas e verificadas* | Não foram utilizadas fontes externas. As informações vieram do próprio material produzido pelo grupo, com base na visita e na pesquisa de campo realizadas na empresa. |
| *Trechos rejeitados ou corrigidos* | Os exemplos numéricos relacionados ao desempenho, como o tempo de resposta de até 2 segundos e o processamento de 1.000 transações por segundo, foram ajustados. Esses valores eram genéricos e não representavam a realidade da empresa estudada, que possui 96 clientes fixos e uma média de 33 manutenções por mês.	 |
| *Justificativa da escolha final* |Decidimos aproveitar as categorias sugeridas pela IA, principalmente desempenho/eficiência e segurança, pois elas são importantes para o sistema que está sendo desenvolvido. Porém, os exemplos foram adaptados de acordo com a realidade da empresa. Também foram incluídos requisitos relacionados à segurança dos dados e à autenticação. |
| *Reflexão crítica* | O uso da IA ajudou a ter uma ideia inicial de quais Requisitos Não Funcionais poderiam ser utilizados no sistema. Porém, percebemos que nem todos os exemplos apresentados serviam para a realidade da empresa, principalmente os valores relacionados ao desempenho. Por isso, foi necessário analisar as sugestões e fazer as adaptações. Com isso, entendemos que a IA é uma boa ferramenta para ajudar no desenvolvimento do trabalho, mas não devemos aceitar tudo o que ela apresenta sem verificar. É importante usar nosso próprio conhecimento e considerar as necessidades reais da empresa.	|

| Item | Registro |
|------|------------------|
| Ferramenta e etapa 2 |Claude, utilizada como apoio para organizar o dicionário de dados (DER) de acordo com o modelo apresentado. |
| *Motivação* | Organizar as informações do rascunho no formato do exemplo solicitado. |
| *Prompt(s) utilizados* | "Poderia me ajudar a revisar o arquivo".|
| *Resposta recebida* | 	Documento reorganizado com tabelas de atributos, descrição, e regra de negócio associada. |
| *Fontes consultadas e verificadas* | Não foram utilizadas fontes externas. As informações vieram do próprio material produzido pelo grupo, com base na visita e na pesquisa de campo realizadas na empresa.|
| *Trechos rejeitados ou corrigidos* | Mantivemos o Log_acesso com cardinalidade (1,1). Mantivemos o perfil técnico sem vínculo com a tabela Técnico. Adotamos a sugestão de DECIMAL para valores em dinheiro e potência: o dicionário passou a usar DECIMAL(10,2) nos valores e DECIMAL(8,2) na potência, de acordo com a seção 1.2 e com o script SQL. Corrigimos o total de entidades para 17 e restauramos a RN01. |
| *Justificativa da escolha final* | A estrutura do exemplo foi aproveitada porque atendia ao formato solicitado, mas algumas partes foram retiradas para que o documento ficasse adequado ao contexto da empresa e às informações levantadas. |
| *Reflexão crítica* | O prompt que usamos na E1 era genérico e a resposta da IA foi igualmente genérica. Descartar partes do modelo sem verificar se se aplicavam ao nosso caso foi um erro nosso, não da IA. |

| Item | Registro |
|------|------------------|
| Ferramenta e etapa 3 | Claude, utilizada durante a elaboração da etapa das regras de negócio, para a realização de correções gramaticais do conteúdo.  |
| *Motivação* | Correção do texto contido na etapa 4 (Regras de negócio). |
| *Prompt(s) utilizados* |  [Problema]: O texto pode conter erros.<br>[Condição]: Pode ter qualquer estilo.<br>[Desafio]: Corrigir sem alterar o sentido.<br>[Tarefa]: Corrija gramática, ortografia, pontuação e acentuação, mantendo o estilo original. Retorne apenas o texto corrigido. |
| *Resposta recebida* | Texto corrigido e mantendo concordância e as regras gramáticais. |
| *Fontes consultadas e verificadas* | Não foram utilizadas fontes externas. As informações vieram do próprio material produzido pelo grupo, com base na visita e na pesquisa de campo realizadas na empresa. |
| *Trechos rejeitados ou corrigidos* | Foi decidido inserir a parte "justamente por envolver riscos elétricos, uso de máquinas e manuseio de combustível.", justamente pra existir uma justificativa dessa restrições organizacionais |
| *Justificativa da escolha final* | A IA analisa os detalhes do texto para realizar as correções necessárias |
| *Reflexão crítica* | A correção foi prática e eficaz, porém foi necessário conferir as informações e analisar se era necessário realizar alguma alteração ou adicionar alguma informação. |

| Item | Registro |
|------|------------------|
| Ferramenta e etapa 4 | ChatGPT, utilizado como apoio durante a etapa de Modelagem Conceitual do sistema de controle de geradores e manutenções.|
| *Motivação* |  Tivemos dificuldade para organizar as entidades, seus atributos e principalmente as cardinalidades dos relacionamentos entre Cliente, Gerador, Manutenção, Técnico e Serviço. Utilizamos a IA como apoio para revisar a estrutura que já havia sido definida pelo grupo e verificar se os relacionamentos estavam de acordo com os requisitos e regras de negócio levantados. |
| *Prompt(s) utilizados* | “Com base nos requisitos, regras de negócio e dicionário de dados do projeto, ajude a identificar as entidades, atributos, relacionamentos e cardinalidades da modelagem conceitual.” |
| *Resposta recebida* | A IA organizou as principais entidades do sistema e explicou os relacionamentos entre elas. Foi indicado que Cliente e Gerador possuem uma relação 1:N, Gerador e Manutenção possuem uma relação 1:N, enquanto Manutenção e Técnico e Manutenção e Serviço possuem relações N:N. Também foram apresentadas justificativas para as cardinalidades com base nas regras de negócio.	 |
| *Fontes consultadas e verificadas* |Não foram utilizadas fontes externas. As informações vieram do próprio material produzido pelo grupo, com base na visita e na pesquisa de campo realizadas na empresa.|
| *Trechos rejeitados ou corrigidos* | 	Algumas sugestões da IA foram analisadas e não foram utilizadas diretamente, principalmente sugestões relacionadas à criação de entidades associativas. Como o objetivo dessa etapa era representar o modelo conceitual, mantivemos os relacionamentos N:N entre Manutenção e Técnico e entre Manutenção e Serviço conforme a estrutura adotada pelo grupo. |
| *Justificativa da escolha final* | A IA foi utilizada apenas como apoio para revisar e organizar o modelo. A decisão final sobre as entidades, atributos e cardinalidades foi feita pelo grupo, considerando os requisitos e as regras de negócio da empresa estudada. |
| *Reflexão crítica* | A utilização da IA ajudou principalmente a visualizar possíveis problemas na modelagem e entender melhor as cardinalidades. Porém, percebemos que uma sugestão gerada automaticamente não deve ser aplicada sem análise. Foi necessário comparar as sugestões com as regras de negócio e com o modelo que já havia sido desenvolvido pelo grupo. Dessa forma, a IA serviu como ferramenta de apoio e revisão, e não como responsável pela definição final do modelo.	|

| Item | Registro |
|------|------------------|
| Ferramenta e etapa 5 | Gemini Flash, utilizado para auxiliar o entendimento a respeito de KPI's.|
| *Motivação* | Procuramos saber de maneira mais aprofundadas os KPI's e durações relacionados a uma empresa de manutenção de geradores. |
| *Prompt(s) utilizados* | “Cite alguns exemplos de KPI's e a sua duração, de uma empresa que presta serviços de manutenções corretivas e preventivas de geradores de energia.” |
| *Resposta recebida* | A IA apresentou algumas sugestões de KPI's para serem utlizados, visando a base de solicitação e area da empresa escolhida|
| *Trechos rejeitados ou corrigidos* | 	Rejeitamos as sugestões genericas, que possivelmente a maioria das empresas que são fora do ramo teriam como KPI's também. Corrigimos essas sugestões com outras mais especificas, apresentadas pela própria IA posteriormente. |
| *Justificativa da escolha final* | A IA foi utilizada com o intuito de clarear os pensamentos a respeitos dos KPI's, entender melhor quais são as metricas da empresa em questão, com sugestões, apontamentos e observações importantes para darmos mais realismo ao trabalho academico. |
| *Reflexão crítica* | A partir da utilização da IA conseguimos relacionar a necessidade dos KPI's especificos para realizar as metricas e gerar resultados dentro da organização, utilizando os dados armazenados dentro do banco.|

| Item | Registro |
|------|------------------|
| Ferramenta e etapa 6 | Gemini Flash, utilizado formatar a apresentação dos requisitos funcionais e não funcionais.|
| *Motivação* | Após a observação do professor a respeito da formatação incorreta dos requisitos e restrições organizacionais (Nomeclaturas), solicitamos a IA sugestões de como poderiamos melhorar, comparando a apresentação dos FUNCIONAIS com os NÃO FUNCIONAIS. |
| *Prompt(s) utilizados* |“Nos auxilie com a formatação correta dos requisitos e restrições organizacionais seguindo as observações do professor, destacando mudanças opcicionais que podemos realizar para aprimorar mais o trabalho. ” |
| *Resposta recebida* | A IA destacou a importância de inserir a numeração de cada requisito/restrição, junto com uma pequena identificação antes da descrição de cada um deles.|
| *Trechos rejeitados ou corrigidos* | 	Não houveram rejeições, apenas correções para que coubessem corretamente no cenário e no que já estava pronto na entrega 1. |
| *Justificativa da escolha final* | As observações e sugestões aplicadas pela IA auxiliaram o entendimento do grupo para a importância da numeração e identificação, para realizar a interligação com os problemas e resultados, assim cedendo a oportunidade do grupo apresentar metricas reais, sempre ligando as partes importantes com soluções. |
| *Reflexão crítica* | Após a utilização da IA nesse processo, o grupo conseguiu entender e identificar o uso das identificações, assim tendo a oportunidade de utiliza-los em outros tópicos, mantendo o trabalho mais organizado.|

| Item | Registro |
|------|------------------|
| Ferramenta e etapa 7 | Gemini Flash, utilizado para pedir sugestões de formatações markdown.|
| *Motivação* | O auxilio foi solicitado para melhorar a apresentação do README com ferramentas de texto que a plataforma oferece. |
| *Prompt(s) utilizados* |“Envie alguns codigos e caracteres para a formatação de textos e tabelas no markdown no github ” |
| *Resposta recebida* | Recebemos da IA algumas dicas a respeito da formatação dos textos com os caracteres especiais (#) (##) (*) e outros. Também a respeito das tabelas e como podemos deixar o conteúdo mais apresentável, separado e agradável para ser lido.|
| *Trechos rejeitados ou corrigidos* | 	Não houveram rejeições, pois se tratou apenas da estética opcional da estetica do documento apresentado aqui. |
| *Justificativa da escolha final* | Conseguimos conhecer estratégias e macetes para manter o documento mais bonito e em distribuido. |
| *Reflexão crítica* | Nesse uso, conseguimos administrar melhor a maneira como iriamos organizar os documentos e o que seria destacado durante a leitura, para melhor entendimento. Além de deixá-lo mais limpo e organizado com prioridades.|

| Item | Registro |
|------|------------------|
| Ferramenta e etapa 8 | Claude, usado na Entrega 2 para reestruturar o README conforme o esqueleto, conferir a consistência entre README, DER, modelo lógico e dicionário, e atualizar o dicionário (tipos, versão 6.0 e seção LOG_ACESSO). |
| *Motivação* | A ferramenta foi utilizada para identificar possíveis divergências entre os documentos e modelos do projeto, garantindo maior consistência entre as informações apresentadas nos diferentes artefatos. |
| *Prompt(s) utilizados* | "Preciso que você realize uma análise técnica e detalhada do projeto, comparando o conteúdo do README com o Diagrama Entidade-Relacionamento (DER)." Também enviamos o esqueleto da Entrega 2, os slides do professor, o repositório e a correção da Entrega 1, e pedimos o README reestruturado e ajustes pontuais (tabela de apontamentos, tabela de notação do DER, nível de detalhe, links e seção de IA). |
| *Resposta recebida* | A IA  apontou algumas divergências entre os artefatos:; a cardinalidade do `Log_acesso` com o `Usuario` era (0,1) no README antigo e (1,1) no DER e no dicionário; a relação Usuário–Técnico existia no README antigo mas não nos diagramas; os tipos do diagrama lógico (`FLOAT`, `VARCHAR`) eram diferentes dos do dicionário (`DECIMAL`, `ENUM`); o README dizia 15 entidades, mas o DER tem 17; a RN01 tinha ficado de fora da lista de regras. |
| *Fontes consultadas e verificadas* | README, Diagrama Entidade-Relacionamento (DER), modelo lógico e dicionário de dados da Entrega 2. Conferimos cada divergência abrindo os arquivos. |
| *Trechos rejeitados ou corrigidos* | Mantivemos o `Log_acesso` com cardinalidade (1,1). Mantivemos o perfil técnico sem vínculo com a tabela Técnico. Alinhamos os tipos do dicionário aos do diagrama lógico, apesar de a IA ter sugerido `DECIMAL` para valores em dinheiro. Corrigimos o total de entidades para 17 e restauramos a RN01. |
| *Justificativa da escolha final* | A análise foi utilizada como apoio para comparar os diferentes artefatos e identificar inconsistências. As recomendações foram consideradas conforme sua compatibilidade com os requisitos e as regras de negócio do projeto, mantendo a decisão final de alteração baseada na conferência dos documentos. |
| *Reflexão crítica* | A IA ajudou a achar divergências que passaram despercebidas, mas também cometeu erros: deixou a RN01 de fora na primeira montagem do README e o total de entidades estava errado no texto antigo.  |

| Item | Registro |
|------|------------------|
| Ferramenta e etapa 9 | Claude, conferência das cardinalidades do DER conceitual contra o modelo lógico gerado no brModelo.       |
| *Motivação* | Garantir que a conversão do conceitual para o lógico não perdeu nem alterou cardinalidades, chaves estrangeiras ou entidades associativas.      |
| *Prompt(s) utilizados* |[Problema]: Conferir cardinalidades, atributos e relacionamentos entre o DER conceitual e o modelo lógico.|
| *Resposta recebida* |A IA devolveu uma lista com as divergências encontradas entre o DER conceitual e o modelo lógico (cardinalidades, atributos e relacionamentos).      |
| *Trechos rejeitados ou corrigidos* |Rejeitei algumas sugestões da IA sobre FKs opcionais, mantendo-as como estavam no modelo, pois a opcionalidade segue a cardinalidade mínima definida no DER conceitual e as regras de negócio da empresa. 	       |
| *Justificativa da escolha final* |Aceitei apenas as correções que faziam sentido para o modelo e adaptei o que precisava de ajuste, mantendo o que já estava coerente com o DER conceitual e as regras de negócio da empresa. A decisão final foi do grupo, e não apenas da IA.       |
| *Reflexão crítica* |A IA é muito útil para conferir detalhes mínimos que passariam despercebidos numa revisão manual, como atributos faltando ou cardinalidades diferentes entre os modelos. Porém, ela não conhece as regras de negócio da empresa e sugeriu mudanças que não faziam sentido (como as FKs opcionais). Por isso é importante não confiar só nela: cada apontamento precisou ser validado pelo grupo antes de ser aplicado.             |

---

# 7. Apresentação Corporativa Final

Pitch de 8 minutos: problema → solução → modelo lógico → SQL rodando → consultas G/A → BI e IA → benefícios.
** PREENCHER:** link/arquivo dos slides.

---




