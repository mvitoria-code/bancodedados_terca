Nomes:

Kauan José da SIlva / RGM: 47346850

Kauê Romaneto Machado / RGM: 47357304

Kaylany Thayna de Oliveira de Paula / RGM: 47039035

Maria Vitória Pereira Alves / RGM: 47230720



## 1. Caracterização da Organização

<img width="2760" height="5480" alt="empresa" src= "imagem empresa.jpg">

- S. A DE LIMA - Manutenção preventiva e corretiva de geradores.
- Telefone:+55 11 98373-9556
- E-mail: sandrolima@limasenergia.com.br

Com fins lucrativos, a empresa conta com 15 funcionários e 96 clientes fixos, somando uma média de 33 manutenções em geradores de energia por mês. 
Nos dias atuais, a empresa não tem um controle digital para a organização dos seus dados em geral: os dados são mantidos de maneira física, em fichas e papéis. Desde as informações dos atendimentos, até às informações dos clientes. 
Com um banco de dados adequado, essas informações ficarão muito mais seguras, além de estarem organizadas e reservadas somente num lugar, facilitando as buscas, consultas e alterações.
A organização foi escolhida de acordo com as dificuldades relatadas. A partir disso foram encontradas possibilidades reais de implantar um plano de ação e renovação de fluxos de armazenamento de dados. Além de que o fácil acesso a empresa e contato com o dono contribuiram com a escolha do grupo.


- Endereço da empresa: https://maps.app.goo.gl/XExBHSXrFvbUNv8Y6?g_st=aw
---

## 2. Processos de Negócio
Cadastro de clientes:
- Objetivo: preservar as informações dos clientes da empresa e permitir cadastrar, consultar e buscar o histórico de cada um.
- Quando ocorre: no primeiro atendimento de um cliente novo.
- Dados registrados: nome (ou razão social), CPF/CNPJ, telefone, endereço, e-mail, cidade e estado.
- Regras: todos os campos são obrigatórios; o CPF/CNPJ não pode se repetir; por serem dados pessoais, CPF/CNPJ e endereço são protegidos por criptografia em repouso no banco de dados.
- Resultado: cliente disponível para vincular geradores e contratos e consultar o histórico.


Contrato de manutenção:
- Objetivo: formalizar o atendimento recorrente dos clientes fixos, com cobrança periódica.
- Quando ocorre:quando um cliente fixo passa a ter um acordo de manutenção e, depois, a cada alteração das condições do contrato.
- Dados registrados:
 1. Contrato: cliente, data de início, data de fim (opcional), valor mensal, periodicidade (mensal a anual) e status (ativo, encerrado ou cancelado).
  2. Aditivo: contrato, data do aditivo, descrição da alteração e condições anteriores.
- Regras: O contrato pertence a um único cliente e cobre pelo menos um gerador desse mesmo cliente. Sem data de fim, o prazo é indeterminado. Contrato encerrado exige data de fim. As manutenções preventivas previstas no contrato são pagas pela mensalidade e não geram cobrança à parte. Itens fora do previsto são cobrados normalmente.
Toda alteração das condições do contrato é registrada por aditivo. O contrato pode ter vários aditivos. O aditivo preserva o histórico das condições anteriores e nunca é excluído.
- Resultado: contrato ativo, que gera as cobranças periódicas (ver Faturamento e pagamento) e enquadra as manutenções dos geradores cobertos.


Cadastro de geradores:
- Objetivo: controlar os geradores supervisionados pela empresa, mantendo a assertividade nas manutenções.
- Quando ocorre: quando o cliente possui um gerador ainda não registrado.
- Dados registrados: número de série, marca, modelo, status (ativo, em manutenção ou inativo), potência em kVA, horímetro (horas de operação acumuladas) e, quando houver, o contrato que cobre o gerador.
- Regras: todo gerador pertence a um cliente; o número de série é único (aceita letras e números); um cliente pode ter mais de um gerador, conforme o porte e a necessidade; o contrato que cobre o gerador deve pertencer ao mesmo cliente do gerador; todo gerador deve ter um cronograma de inspeção preventiva.
- Resultado: equipamento identificado, com cronograma de inspeção preventiva criado e pronto para receber manutenções.


Cronograma de manutenção preventiva:
- Objetivo: acompanhar os prazos de troca ou limpeza das peças de cada gerador (bateria, óleo do motor, filtros e tanque).
Quando ocorre: no cadastro do gerador, quando o cronograma é criado, e a cada troca ou limpeza realizada em uma manutenção.
Dados registrados: gerador, peça, data da última troca e horímetro da última troca (ambos opcionais até a primeira intervenção).
Regras: O cronograma é cadastrado para cada gerador, com um registro por peça. O prazo vem da peça: prazo de troca em dias e/ou em horas, vencendo o que for atingido primeiro (RN08). Quando uma manutenção troca ou limpa a peça, o sistema atualiza a data e o horímetro da última troca (RN09).
Resultado: lista de peças vencidas ou a vencer, que orienta as manutenções preventivas.


Solicitação de atendimento e orçamento:
- Objetivo: registrar o pedido do cliente e estimar o valor antes da execução.
- Quando ocorre: a cada pedido de atendimento fora de contrato. Na emergência (corretiva com o gerador inoperante), o orçamento também é emitido e precisa ser aprovado pelo cliente antes da execução; o que a emergência dispensa é o pagamento antes da execução. Manutenção preventiva prevista em contrato não passa por orçamento.
- Dados registrados: id orçamento, gerador, data, valor orçado (estimativa total, sem itens), status (pendente, aprovado ou recusado) e data de aprovação.
- Regras: orçamento aprovado pode originar uma manutenção; recusado não origina; o valor final da manutenção pode diferir do orçado.
- Resultado: orçamento aprovado e ligado à manutenção, ou encerrado sem atendimento.


Manutenção
- Objetivo: registrar cada atendimento, preventivo ou corretivo.
- Quando ocorre: em três situações:
   1. Após a aprovação de um orçamento, inclusive em emergência. A execução pode ocorrer antes do pagamento.
   2. Na manutenção preventiva prevista em contrato, sem orçamento, pois já está coberta pela mensalidade.
   3. Na manutenção preventiva gerada pelo cronograma, quando uma peça precisa ser trocada ou limpa.
- Dados registrados: ID (gerado automaticamente), gerador, contrato e orçamento (quando houver), data, tipo, status, nota fiscal, problema relatado, data de conclusão e, para cada serviço e peça aplicada, o valor unitário aplicado e a quantidade.
- Regras:
  1. Cada manutenção está vinculada a exatamente um gerador.
  2. Tem pelo menos um técnico responsável e pelo menos um serviço. O uso de peças é     opcional.
  3. Status: Aberta → Em andamento → Concluída.
  4. Serviços, peças e técnicos podem ser alterados enquanto a manutenção estiver aberta ou em andamento.
  5. Depois de concluída, só usuários autorizados podem alterar, e a alteração fica   registrada no histórico (RN16).
  6. O valor total não é armazenado. É calculado pela soma de (valor unitário ×     quantidade) dos serviços e peças.
  7. Manutenção coberta por contrato registra os itens com valor aplicado zero, então não há cobrança adicional.
  8. Ao registrar uma peça utilizada, o sistema dá baixa automática no estoque. Se a peça for removida ou alterada antes da conclusão, a baixa é estornada ou ajustada.
  9. O sistema verifica a disponibilidade antes da baixa e impede estoque negativo.
- Resultado: histórico completo das manutenções por gerador e cliente, com serviços, peças, responsáveis e valores.


Serviço (catálogo):
- Objetivo: definir o tipo de serviço que será feito, incluindo os valores base.
- Quando ocorre: quando a empresa passa a oferecer um novo tipo de serviço.
- Dados registrados: nome, descrição e valor base.
- Regras: o nome do serviço é único; um serviço pode ser usado em várias manutenções; o valor aplicado em cada manutenção pode diferir do valor base, inclusive ser zero quando o item é coberto por contrato; os serviços seguem as normas NR-10, NR-12, NR-20 e NR-6.
- Resultado: catálogo que alimenta o cálculo do valor de cada manutenção.


Técnicos:
- Objetivo: Manter os tecnicos cadastrados.
- Quando ocorre: após a contratação do técnico e a cada mudança de escala.
- Dados registrados: nome, CPF, telefone e e-mail; da escala, período (início e fim) e turno (manhã, tarde, noite ou integral), dia da folga.
- Regras: CPF único, 11 dígitos numéricos; 
- Resultado: técnicos disponiveis serão apresentados, assim como seus dados cadastrais. 

Escala:
- Objetivo: Manter a escala correta de trabalho de cada tecnico.
- Quando ocorre: após a contratação de cada tecnico, a sua escala de trabalho é montada.
- Dados registrados: id escala, período (início e fim) e turno (manhã, tarde, noite ou integral) e folga. 
- Regras: a data final da escala não pode ser anterior à inicial; um técnico pode ter várias escalas e participar de várias manutenções.
- Resultado: técnicos disponíveis para alocação e plantão coberto com limite de horário.


Cadastro de peças
- Objetivo: Manter o catálogo das peças utilizadas nas manutenções dos geradores e nos cronogramas preventivos, incluindo baterias, óleos, filtros de ar e outros componentes.
- Quando ocorre: Quando a empresa passa a utilizar uma peça nova ou precisa atualizar as informações de uma peça já cadastrada.
- Dados registrados: ID da peça, nome, descrição, valor, prazo de troca em dias, prazo de troca em horas (ambos opcionais) e quantidade disponível em estoque.
- Regras:
  1. O nome da peça deverá ser único.
  2. Os prazos de troca (em dias e/ou em horas) deverão servir de referência para a elaboração dos cronogramas preventivos.
  3. A entrada de peças no estoque deverá ocorrer automaticamente após a confirmação do recebimento físico da compra, sem permitir entradas duplicadas para uma mesma compra.
  4. A utilização de uma peça em uma manutenção deverá gerar automaticamente a baixa da quantidade correspondente no estoque.
  5. O sistema deverá impedir movimentações que resultem em quantidade negativa no estoque.
  6. Apenas usuários autorizados poderão realizar ajustes manuais nas quantidades disponíveis em estoque, com registro no histórico de auditoria.
- Resultado: Catálogo de peças atualizado, utilizado como referência para os cronogramas preventivos, registros de manutenção e processos de compra, com controle automatizado das entradas e saídas do estoque.


Controle de acesso e auditoria:
- Objetivo: controlar quem acessa o sistema e proteger dados pessoais (LGPD).
- Quando ocorre: na criação de cada conta de usuário e a cada acesso ou operação realizada no sistema.
- Dados registrados: usuário (login e perfil) e log de acesso (data/hora, ação, tabela, registro afetado, resultado e finalidade).
- Regras: perfis administrador, atendimento, técnico e financeiro; usuário nunca é excluído; o log só recebe inserções, inclusive de tentativas negadas de usuários existentes.
- Resultado: acessos rastreáveis e permissões por perfil.


Pagamento:
- Objetivo: controlar as cobranças de manutenções e de contratos.
- Quando ocorre: ao fechar o valor da manutenção e a cada período de cobrança do contrato.
- Dados registrados: número da parcela, vencimento, valor da parcela, data e forma de pagamento, status (pendente, pago, atrasado ou cancelado) e valor pago.
- Regras:
  1. Cada parcela tem exatamente uma origem: uma manutenção ou um contrato (RN20).
  2. A soma das parcelas é igual ao valor calculado da origem.
  3. Só há cobrança de manutenção se o valor calculado for maior que zero.
  4. Fora de contrato, a preventiva é paga antes da execução. Na corretiva, a execução pode vir antes do pagamento se houver orçamento aprovado.
  5. A parcela passa a “pago” quando o valor pago quita o valor da parcela.
  6. O pagamento nunca é excluído. É cancelado ou corrigido por usuário autorizado, com registro no log.
- Resultado: contas a receber controladas.


Compra:
- Objetivo: registrar as compras de peças feitas a fornecedores.
- Quando ocorre: Quando existe a necessidade de adquirir peças para as atividades da empresa, incluindo manutenções de geradores e uso interno.
- Dados registrados: ID da compra, data da compra, fornecedor, situação (não recebido ou recebido), número da nota fiscal e itens adquiridos, incluindo quantidade e custo unitário.
- Regras:
  1. Toda compra deverá conter pelo menos um item e um fornecedor cadastrado.
  2. A situação só pode ser alterada enquanto a compra não estiver recebida.
  3. Ao confirmar o recebimento, o sistema atualiza o estoque automaticamente.
  4. Uma compra já recebida não gera segunda entrada dos mesmos itens.
  5. A quantidade disponível em estoque nunca poderá ser negativa.
- Resultado: compras rastreáveis por fornecedor e estoque atualizado.


Fornecedor:
- Objetivo: Registrados os dados de cada fornecedor da empresa.
- Quando ocorre: Quando houver a compra de algum insumo diretamente a orgaização.
- Dados registrados: nome, CNPJ, telefone e e-mail;
- Regras: CNPJ e telefone unicos. 
- Resultado: Controle e registros de fornecedores sempre atualizados.


Contas a pagar:
- Objetivo: Manter registrado o histórico de contas pendentes e pagas da empresa.
- Quando ocorre: Quando houver contas em aberto ou pagas pela empresa.
- Dados registrados: Fornecedor cadastrado relacionado à conta, descrição da despesa, valor total, valor pago, data de vencimento, número do boleto (quando aplicável), situação (paga ou não) e data de pagamento (quando houver).
- Regras: Toda conta está vinculada a um fornecedor cadastrado. Cada boleto possui numeração única. A conta só poderá ser dada como paga quando o valor pago for igual ao valor total e, nesse caso, sua situação deverá ser atualizada automaticamente para "Paga". Não há controle de pagamentos parciais.
- Resultado: Controlar os custos e pagamentos da empresa.






<img width="2760" height="5480" alt="fluxograma" src="fluxograma.png" />





---

## 3. Requisitos do Sistema

### 3.1 Requisitos Funcionais

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
  
- RF18 - Trilha de Auditoria (Logs): O sistema deve registrar em log de auditoria imutável todas as tentativas de acesso, operações de escrita e tentativas de login negadas.
  
- RF19 – Aditivos Contratuais: O sistema deve permitir registrar aditivos sempre que as condições de um contrato forem alteradas, informando o contrato, a data do aditivo, a descrição da alteração e as condições anteriores. Um contrato pode ter vários aditivos, e o histórico não pode ser excluído, conforme a RN27.
  
- RF20 - Gestão de Contas a Pagar: O sistema deve permitir registrar contas a pagar vinculadas a um fornecedor cadastrado, informando descrição, valor total, valor pago, vencimento, número do boleto (quando houver) e data de pagamento, e alterar a situação da conta para paga somente quando o valor pago for igual ao valor total, conforme a RN24.
  
### 3.2 Requisitos Não Funcionais

- RNF01 - Segurança e criptografia: CPF/CNPJ e endereço dos clientes devem ser protegidos por criptografia em repouso no banco de dados, com acesso restrito a usuários autorizados, conforme as diretrizes da LGPD.
 
- RNF02 - Controle de acesso e LGPD:  sistema deverá permitir o acesso às funcionalidades e informações conforme o nível de autorização de cada usuário. As operações realizadas deverão ser registradas em um histórico de auditoria, contendo identificação do usuário, data, horário e ação executada.

- RNF03 - Integridade e imutabilidade de Auditoria: o log de acesso só recebe inserções; nenhum perfil pode alterá-lo ou excluí-lo.
  
- RNF04 - Integridade relacional: o banco deve garantir chaves estrangeiras, unicidades e restrições de valores (InnoDB, CHECK e transações).
  
- RNF05 - Disponibilidade 24/7: o sistema deve aceitar registros em qualquer horário, por causa do plantão de 24 h.
  
- RNF06 - Desempenho do sistema: cadastros e consultas devem responder em até 5 segundos em qualquer dispositivo.
  
- RNF07 - Acessibilidade: o sistema deve seguir a WCAG 2.1 nível AA em todas as páginas.
  
- RNF08 - Portabilidade e compatibilidade: o sistema deve funcionar nos sistemas operacionais populares, da instalação às atualizações.
  
- RNF09 - Usabilidade: a interface deve ser simples e compreensível para todos os perfis de usuário.

### 3.3 Restrições organizacionais:
- REST01 - Conformidade com Normas Regulamentadoras: A execução e a parametrização do catálogo de serviços do sistema devem estar adequadas às diretrizes de segurança da NR-10 (Segurança em Instalações Elétricas), NR-12 (Segurança no Trabalho em Máquinas e Equipamentos), NR-20 (Manuseio de Inflamáveis e Combustíveis) e NR-6 (Equipamentos de Proteção Individual - EPI).

- REST02 - Regime de Operação Ininterrupto: Devido à natureza dos serviços de emergência e ao regime de plantão 24/7 da empresa, o sistema não poderá passar por rotinas de manutenção programada que bloqueiem a inserção de dados em horários comerciais ou noturnos.

- REST03 - Diretrizes de Manutenção Preventiva: O sistema avisa quando peças importantes (como bateria, óleo, filtros e tanque) precisam ser trocadas ou limpas, baseando-se no desgaste natural de uso.

- REST04 - Suporte a Operação Offline em Campo: Como o técnico pode atender em locais sem sinal (como subsolos), o sistema permite anotar os dados da manutenção e sincroniza tudo com o servidor assim que a internet voltar.

- REST05 - Imutabilidade e Rastreabilidade Financeira: Contas pagas e contratos não podem ser apagados do sistema; se houver algum erro, o administrador deve fazer um registro de correção para manter a contabilidade certa.

- REST06 - Priorização de Chamados de Emergência: O sistema ajuda a identificar e priorizar os chamados mais urgentes para acionar rapidamente o técnico que estiver de plantão no turno.

4. REGRAS DE NEGÓCIO
As regras de negócio estabelecem os critérios, procedimentos e restrições que deverão ser respeitados pelo sistema de gerenciamento de manutenções preventivas e corretivas de grupos geradores da empresa S. A. de Lima.

5.1 Regras operacionais (RN)
RN01 – Identificação de clientes: Cada cliente deverá possuir um CPF ou CNPJ único no sistema, não sendo permitido cadastrar documentos duplicados.

RN02 – Vinculação de geradores: Todo gerador cadastrado deverá estar obrigatoriamente vinculado a um único cliente.

RN03 – Identificação de geradores: Cada gerador deverá possuir um número de série único, composto por caracteres alfanuméricos.

RN04 – Situação cadastral dos geradores: Cada gerador deverá possuir uma situação cadastral que permita identificar sua condição, podendo ser classificado como ativo, em manutenção ou inativo.

RN05 – Vinculação de manutenções: Toda manutenção deverá estar vinculada a exatamente um gerador.

RN06 – Responsabilidade técnica: Toda manutenção deverá possuir pelo menos um técnico responsável, podendo contar com a participação de vários técnicos.

RN07 – Serviços realizados: Toda manutenção deverá possuir pelo menos um serviço associado, podendo conter vários serviços e peças utilizadas. Os serviços e as peças deverão ser registrados individualmente.

RN08 – Matriz de manutenção preventiva: O cronograma de manutenção preventiva deverá considerar os intervalos de utilização e o tempo de vida útil dos componentes do gerador, respeitando os seguintes critérios de referência:
- Óleo lubrificante: troca, em média, a cada 150 horas de funcionamento ou 12 meses desde a última troca, prevalecendo o critério atingido primeiro.
- Filtros de óleo e combustível: substituição durante a realização da troca de óleo lubrificante.
- Filtro de ar: substituição a cada 200 horas de funcionamento.
- Bateria: substituição, em média, a cada 2 anos.
- Tanque de combustível: limpeza e inspeção a cada 12 meses.
Os intervalos deverão considerar as recomendações do fabricante, quando disponíveis, e poderão ser ajustados conforme as condições de operação do gerador.

RN09 – Atualização do cronograma: Após a realização de uma manutenção ou substituição de componente, deverão ser atualizados os registros da data da última intervenção e do horímetro correspondente para cada componente, permitindo calcular os próximos prazos de manutenção preventiva.

RN10 – Elaboração e aprovação de orçamentos: Toda manutenção corretiva deverá possuir um orçamento elaborado e apresentado ao cliente, vinculado ao respectivo cliente e gerador. A execução somente poderá ser iniciada após a aprovação do orçamento pelo cliente, inclusive em situações de emergência.

RN11 – Situação dos orçamentos: Cada orçamento deverá possuir um status que identifique sua situação, podendo ser classificado como pendente, aprovado ou recusado. Somente orçamentos aprovados poderão autorizar a execução de manutenções corretivas.

RN12 – Vinculação de contratos: Cada contrato deverá estar vinculado a um único cliente e poderá abranger um ou mais geradores pertencentes a esse mesmo cliente.

RN13 – Abrangência contratual: Os serviços e componentes incluídos na manutenção preventiva deverão ser definidos individualmente em cada contrato. Os itens que não estiverem contemplados poderão ser cobrados separadamente.

RN14 – Condições de cobrança e pagamento: As manutenções preventivas contempladas pelo contrato serão cobradas conforme as condições estabelecidas no próprio contrato. Os serviços e componentes não incluídos poderão gerar cobranças adicionais. As manutenções preventivas realizadas fora de contrato deverão ser pagas antes da execução. Nas manutenções corretivas, a execução poderá ocorrer antes da confirmação do pagamento, desde que o orçamento tenha sido previamente aprovado pelo cliente.

RN15 – Cálculo do valor da manutenção: O valor final de uma manutenção deverá ser calculado com base na soma dos serviços realizados e das peças utilizadas, considerando suas respectivas quantidades e valores aplicados. Itens cobertos pelo contrato poderão possuir valor aplicado igual a zero.

RN16 – Situação da manutenção: Uma manutenção deverá seguir as etapas de abertura, execução e conclusão. Os serviços e componentes registrados poderão ser alterados enquanto a manutenção estiver aberta ou em execução. Após a conclusão, alterações deverão ser realizadas somente por usuários autorizados, preservando o histórico das modificações.

RN17 – Identificação de técnicos: Cada técnico deverá possuir um CPF único, composto por 11 dígitos numéricos.

RN18 – Escalas de trabalho: Cada escala deverá estar vinculada a um técnico, e sua data de término não poderá ser anterior à data de início.

RN19 – Cadastro de serviços: Cada serviço deverá possuir um nome único, descrição e valor-base cadastrado. O valor aplicado poderá variar conforme as condições da manutenção ou do contrato.

RN20 – Registro de pagamentos: Cada pagamento deverá estar relacionado a uma única origem de cobrança, podendo ser referente a uma manutenção ou a um contrato. Quando houver parcelamento, a soma das parcelas deverá corresponder ao valor total devido após a quitação integral.

RN21 – Histórico financeiro: Os registros de pagamentos não deverão ser excluídos fisicamente. Em caso de erro, deverão ser cancelados ou corrigidos por um usuário autorizado, mantendo o histórico da alteração.

RN22 – Cadastro de fornecedores: Cada fornecedor deverá possuir um CNPJ único no sistema.

RN23 – Compra de peças e controle de estoque: Toda compra deverá estar vinculada a um fornecedor cadastrado e registrar os itens adquiridos, suas respectivas quantidades e valores. Após a confirmação do recebimento físico da compra, o sistema deverá atualizar automaticamente a quantidade disponível em estoque, impedindo que a mesma compra gere entradas duplicadas. A utilização de peças em manutenções deverá gerar automaticamente a baixa da quantidade correspondente no estoque. O sistema deverá impedir movimentações que resultem em saldo negativo. Ajustes manuais somente poderão ser realizados por usuários autorizados, com registro no histórico de auditoria.

RN24 – Contas a pagar: Cada conta a pagar deve possuir um identificador único de boleto, quando aplicável. O pagamento deve corresponder ao valor total da conta, e seu status deve ser atualizado para "Paga" após a quitação integral.

RN25 – Controle de usuários: Cada usuário deverá possuir um login único, credenciais próprias e um perfil de acesso definido conforme sua função no sistema.

RN26 – Auditoria: As ações realizadas pelos usuários deverão ser registradas em histórico de auditoria, permitindo identificar quem realizou cada operação e quando ela ocorreu.

RN27 – Alterações contratuais: As alterações nas condições dos contratos deverão ser registradas por meio de aditivos contratuais, preservando o histórico das condições anteriormente estabelecidas e permitindo identificar as modificações realizadas.

---

## 6. Modelagem Conceitual (Entidades, Atributos, Relacionamentos)

A modelagem conceitual foi elaborada a partir dos processos de negócio, requisitos funcionais e regras de negócio levantados na empresa S. A DE LIMA. O modelo representa os clientes e seus contratos, os geradores, os orçamentos e as manutenções (com técnicos, serviços e peças), o cronograma de manutenção preventiva, o controle financeiro (pagamentos), o abastecimento de peças (fornecedores e compras), a escala dos técnicos e o controle de acesso ao sistema.

## 6.1 Entidades reconhecidas

Foram identificadas quinze entidades, organizadas em cinco grupos.

## Relacionamento com o cliente

### Cliente:
pessoa física ou jurídica que contrata os serviços da empresa.
Contrato: acordo firmado com um cliente fixo, com cobrança periódica e vigência definida.
Gerador: equipamento de geração de energia de propriedade do cliente e supervisionado pela empresa.

## Atendimento

### Orçamento:
proposta de valor total estimado para um gerador; quando aprovada, origina uma manutenção.

### Manutenção: 
atendimento preventivo ou corretivo realizado em um gerador.

### Serviço: 
catálogo de serviços que podem ser prestados em uma manutenção.

### Técnico: 
profissional que executa as manutenções.

### Escala:
período e turno de plantão cumprido por um técnico.


## Peças e manutenção preventiva

### Peça:
item de reposição (bateria, óleo, filtro de ar, tanque etc.) mantido em estoque.

### Cronograma_Preventivo:
controle da troca preventiva de uma peça em um gerador específico.


## Financeiro e suprimentos

### Pagamento: 
parcela de cobrança, originada de uma manutenção ou da mensalidade de um contrato.

### Fornecedor: 
empresa que fornece peças.

### Compra: 
aquisição de peças junto a um fornecedor.


## Segurança

### Usuário: 
conta de acesso ao sistema, com perfil de permissões.

### Log_acesso:
registro de cada acesso e operação realizada no sistema.

### 6.2 Atributos e classificações

Os atributos foram definidos de acordo com as informações necessárias para identificar e controlar cada entidade.

Cliente

| Atributo | Classificação |
|---|---|
| `id_cliente` | Identificador |
| `nome` | Descritivo |
| `cpf_cnpj` | Identificação / único |
| `telefone` | Contato |
| `endereco` | Localização |
| `email` | Contato |
| `cidade` | Localização |
| `estado` | Localização |

O id_cliente identifica exclusivamente cada cliente. O cpf_cnpj deve ser único e obrigatório. Essas informações já estão definidas no dicionário de dados do projeto.


Contrato

| Atributo | Classificação |
|---|---|
| `id_contrato` | Identificador |
| `data_inicio` | Temporal |
| `data_fim` | Temporal |
| `valor_mensal` | Quantitativo |
| `tipo_periodicidade` | Classificação |
| `status` | Classificação |

A data_fim é opcional, pois um contrato ativo pode ter prazo indeterminado. O tipo_periodicidade define quantos meses cada cobrança abrange (mensal, bimestral, trimestral, semestral ou anual).

Gerador

| Atributo | Classificação |
|---|---|
| `id_gerador` | Identificador |
| `numero_serie` | Identificação / único |
| `marca` | Descritivo |
| `modelo` | Descritivo |
| `status` | Classificação |
| `potencia` | Quantitativo |
| `horimetro` | Quantitativo |

O numero_serie é um identificador único do equipamento. A potencia é medida em kVA e o horimetro registra as horas de operação acumuladas.

Orçamento

| Atributo | Classificação |
|---|---|
| `id_orcamento` | Identificador |
| `data_orcamento` | Temporal |
| `valor_orcado` | Quantitativo |
| `status` | Classificação |
| `data_aprovacao` | Temporal |

O valor_orcado é uma estimativa do valor total, sem detalhar serviços e peças. A data_aprovacao só é preenchida quando o orçamento é aprovado.

Manutenção

| Atributo | Classificação |
|---|---|
| `id_manutencao` | Identificador |
| `data_manutencao` | Temporal |
| `tipo_manutencao` | Classificação |
| `status` | Classificação |
| `numero_nota_fiscal` | Identificação |
| `descricao_problema` | Descritivo |
| `data_conclusao` | Temporal |

A entidade registra o atendimento realizado em um gerador e permite diferenciar manutenções preventivas e corretivas. O valor da manutenção não é armazenado: ele é calculado pela soma dos serviços e peças aplicados.

Serviço

| Atributo | Classificação |
|---|---|
| `id_servico` | Identificador |
| `nome_servico` | Descritivo / único |
| `descricao` | Descritivo |
| `valor_base` | Quantitativo |

Os atributos permitem identificar o serviço, explicar o que será realizado e estabelecer seu valor de referência.

Técnico

| Atributo | Classificação |
|---|---|
| `id_tecnico` | Identificador |
| `nome` | Descritivo |
| `cpf` | Identificação / único |
| `telefone` | Contato |
| `email` | Contato |

O cpf é único para cada técnico, conforme a regra estabelecida para o sistema.

Escala

| Atributo | Classificação |
|---|---|
| `id_escala` | Identificador |
| `data_inicio` | Temporal |
| `data_fim` | Temporal |
| `turno` | Classificação |

O turno pode ser manhã, tarde, noite ou integral, e a data_fim não pode ser anterior à data_inicio.

Peça

| Atributo | Classificação |
|---|---|
| `id_peca` | Identificador |
| `nome_peca` | Descritivo / único |
| `descricao_peca` | Descritivo |
| `valor_venda` | Quantitativo |
| `prazo_troca_dias` | Quantitativo |
| `estoque` | Quantitativo |

O prazo_troca_dias indica a cada quantos dias a peça deve ser trocada ou limpa e orienta o cronograma preventivo.

Cronograma_Preventivo

| Atributo | Classificação |
|---|---|
| `id_cronograma` | Identificador |
| `data_ultima_troca` | Temporal |

Cada gerador tem no máximo um cronograma por peça. A data_ultima_troca é opcional, pois a peça pode ainda não ter sido trocada.

Pagamento

| Atributo | Classificação |
|---|---|
| `id_pagamento` | Identificador |
| `numero_parcela` | Identificação |
| `data_vencimento` | Temporal |
| `valor_previsto` | Quantitativo |
| `data_pagamento` | Temporal |
| `forma` | Classificação |
| `status` | Classificação |
| `valor_pago` | Quantitativo |

O valor_previsto é o valor devido na parcela e o valor_pago é o efetivamente quitado, podendo diferir por juros ou desconto. A data_pagamento, a forma e o valor_pago só são preenchidos quando a parcela é paga.

Fornecedor

| Atributo | Classificação |
|---|---|
| `id_fornecedor` | Identificador |
| `nome` | Descritivo |
| `cnpj` | Identificação / único |
| `telefone` | Contato |
| `email` | Contato |

O cnpj é único para cada fornecedor e é gravado somente com números.

Compra

| Atributo | Classificação |
|---|---|
| `id_compra` | Identificador |
| `data_compra` | Temporal |
| `status` | Classificação |
| `numero_nota_fiscal` | Identificação |

O status da compra pode ser pedida, recebida ou cancelada, e a nota fiscal é opcional.

Usuário

| Atributo | Classificação |
|---|---|
| `id_usuario` | Identificador |
| `login` | Identificação / único |
| `perfil` | Classificação |
| `status` | Classificação |

O perfil pode ser administrador, atendimento, técnico ou financeiro. O usuário não é excluído, e sim desativado, para preservar o histórico.

Log_acesso

| Atributo | Classificação |
|---|---|
| `id_log` | Identificador |
| `data_hora_acesso` | Temporal |
| `acao` | Classificação |
| `nome_tabela` | Descritivo |
| `numero_registro` | Referência |
| `resultado` | Classificação |
| `finalidade_acesso` | Descritivo |
| `login_informado` | Descritivo |
| `ip_origem` | Localização |

O log só recebe inserções. O login_informado é usado quando a tentativa de acesso não identifica um usuário cadastrado, e a finalidade_acesso registra o motivo do acesso a dado pessoal.

Atributos dos relacionamentos

| Relacionamento | Atributos |
|---|---|
| Manutenção utiliza Serviço | `valor_aplicado`, `quantidade` |
| Manutenção usa Peça | `valor_unitario_aplicado`, `quantidade` |
| Compra contém Peça | `quantidade`, `valor_custo` |

Esses atributos pertencem à ligação entre as entidades, e não a uma delas isoladamente.


### 6.3 Relacionamentos pertinentes

Foram identificados vinte relacionamentos entre as entidades.

# Cliente — possui — Gerador

Cardinalidade: 1:N

Um cliente pode possuir zero ou vários geradores, enquanto cada gerador pertence obrigatoriamente a um único cliente.

CLIENTE (0,n) ─── possui ─── (1,1) GERADOR

Essa relação representa a regra de negócio de que todo gerador cadastrado deve estar vinculado a um cliente.

# Cliente — firma — Contrato

Cardinalidade: 1:N

Um cliente pode firmar zero ou vários contratos, enquanto cada contrato é firmado por um único cliente.

CLIENTE (0,n) ─── firma ─── (1,1) CONTRATO

Essa relação permite manter o histórico contratual de cada cliente.

# Contrato — cobre — Gerador

Cardinalidade: 1:N

Um contrato cobre pelo menos um gerador e pode cobrir vários, enquanto um gerador é coberto por zero ou um contrato.

CONTRATO (1,n) ─── cobre ─── (0,1) GERADOR

O contrato que cobre o gerador deve pertencer ao mesmo cliente do gerador.

# Contrato — enquadra — Manutenção

Cardinalidade: 1:N

Um contrato pode enquadrar zero ou várias manutenções, enquanto cada manutenção se enquadra em zero ou um contrato.

CONTRATO (0,n) ─── enquadra ─── (0,1) MANUTENÇÃO

Nem toda manutenção ocorre dentro de um contrato, como as corretivas avulsas.

# Contrato — gera_mensalidade — Pagamento

Cardinalidade: 1:N

Um contrato pode gerar zero ou várias mensalidades, enquanto cada pagamento é gerado por zero ou um contrato.

CONTRATO (0,n) ─── gera_mensalidade ─── (0,1) PAGAMENTO

O lado (0,1) existe porque a parcela pode, em vez disso, ter origem em uma manutenção.

# Gerador — solicita — Orçamento

Cardinalidade: 1:N

Um gerador pode ter zero ou vários orçamentos, enquanto cada orçamento é solicitado para um único gerador.

GERADOR (0,n) ─── solicita ─── (1,1) ORÇAMENTO

Essa relação permite guardar o histórico de propostas feitas para cada equipamento.

# Gerador — recebe — Manutenção

Cardinalidade: 1:N

Um gerador pode receber zero ou várias manutenções durante sua utilização. Cada manutenção, entretanto, deve estar obrigatoriamente relacionada a um único gerador.

GERADOR (0,n) ─── recebe ─── (1,1) MANUTENÇÃO

Essa relação permite manter o histórico de atendimentos realizados em cada equipamento.

# Gerador — tem — Cronograma_Preventivo

Cardinalidade: 1:N

Um gerador pode ter zero ou vários cronogramas, um para cada peça acompanhada, enquanto cada cronograma pertence a um único gerador.

GERADOR (0,n) ─── tem ─── (1,1) CRONOGRAMA_PREVENTIVO

Essa relação representa a regra de que os geradores precisam ter um cronograma de inspeção preventiva.

# Peça — define prazo — Cronograma_Preventivo

Cardinalidade: 1:N

Uma peça pode definir o prazo de zero ou vários cronogramas, enquanto cada cronograma tem o prazo definido por uma única peça.

PEÇA (0,n) ─── define prazo ─── (1,1) CRONOGRAMA_PREVENTIVO

O prazo de troca da peça orienta quando a próxima troca preventiva deve ocorrer.

# Orçamento — origina — Manutenção

Cardinalidade: 1:1

Um orçamento pode originar zero ou uma manutenção, e uma manutenção pode ter sido originada por zero ou um orçamento.

ORÇAMENTO (0,1) ─── origina ─── (0,1) MANUTENÇÃO

Um orçamento recusado não gera manutenção, e uma emergência pode ser atendida sem orçamento prévio.

# Manutenção — atualiza — Cronograma_Preventivo

Cardinalidade: N:N

Uma manutenção pode atualizar zero ou vários cronogramas, e um cronograma pode ser atualizado por zero ou várias manutenções.

MANUTENÇÃO (0,n) ─── atualiza ─── (0,n) CRONOGRAMA_PREVENTIVO

Ao trocar uma peça, a manutenção atualiza a data da última troca no cronograma correspondente.

# Manutenção — usa — Peça

Cardinalidade: N:N

Uma manutenção pode usar zero ou várias peças, e uma peça pode ser usada em zero ou várias manutenções.

MANUTENÇÃO (0,n) ─── usa ─── (0,n) PEÇA

Atributos da relação: valor_unitario_aplicado e quantidade.

# Manutenção — realizada por — Técnico

Cardinalidade: N:N

Uma manutenção pode envolver um ou vários técnicos, enquanto um técnico pode participar de zero ou várias manutenções.

MANUTENÇÃO (1,n) ─── realizada por ─── (0,n) TÉCNICO

A cardinalidade foi definida dessa forma porque o sistema deve permitir que uma mesma manutenção tenha mais de um técnico vinculado.

# Manutenção — utiliza — Serviço

Cardinalidade: N:N

Uma manutenção pode utilizar um ou vários serviços, enquanto um serviço pode ser utilizado em zero ou várias manutenções.

MANUTENÇÃO (1,n) ─── utiliza ─── (0,n) SERVIÇO

Essa relação foi definida porque uma manutenção pode envolver mais de um serviço e o valor final pode ser composto pelos serviços realizados. Atributos da relação: valor_aplicado e quantidade.

# Manutenção — gera — Pagamento

Cardinalidade: 1:N

Uma manutenção pode gerar zero ou várias parcelas de pagamento, enquanto cada pagamento é gerado por zero ou uma manutenção.

MANUTENÇÃO (0,n) ─── gera ─── (0,1) PAGAMENTO

Cada parcela tem exatamente uma origem: uma manutenção ou um contrato.

# Técnico — cumpre — Escala

Cardinalidade: 1:N

Um técnico pode cumprir zero ou várias escalas, enquanto cada escala é cumprida por um único técnico.

TÉCNICO (0,n) ─── cumpre ─── (1,1) ESCALA

Essa relação apoia o plantão de 24 horas da empresa.

# Fornecedor — fornece — Compra

Cardinalidade: 1:N

Um fornecedor pode fornecer zero ou várias compras, enquanto cada compra é feita de um único fornecedor.

FORNECEDOR (0,n) ─── fornece ─── (1,1) COMPRA

Essa relação permite rastrear de quem cada peça foi comprada.

# Compra — contém — Peça

Cardinalidade: N:N

Uma compra contém uma ou várias peças, e uma peça pode estar em zero ou várias compras.

COMPRA (1,n) ─── contém ─── (0,n) PEÇA

Atributos da relação: quantidade e valor_custo. As compras recebidas repõem o estoque das peças.

# Usuário — realiza — Log_acesso

Cardinalidade: 1:N

Um usuário pode realizar zero ou vários acessos, enquanto cada log pertence a zero ou um usuário.

USUÁRIO (0,n) ─── realiza ─── (0,1) LOG_ACESSO

O lado (0,1) existe porque tentativas de login negadas podem não identificar um usuário cadastrado.

# Usuário — vincula-se a — Técnico

Cardinalidade: 1:1

Um usuário com perfil técnico é vinculado a exatamente um técnico, e um técnico pode ter zero ou uma conta de usuário.

USUÁRIO (0,1) ─── vincula-se a ─── (0,1) TÉCNICO

Essa relação permite aplicar a permissão de acesso apenas às manutenções em que o técnico está alocado.
### 6.4 Restrições e políticas organizacionais

O modelo conceitual considera as principais regras de negócio identificadas durante o levantamento da empresa.

Todo gerador deve estar vinculado a um cliente.
Toda manutenção deve estar vinculada a um gerador.
O número de série do gerador deve ser único.
O CPF do técnico deve ser único.
Uma manutenção deve possuir pelo menos um técnico.
Uma manutenção deve possuir pelo menos um serviço.
Uma manutenção pode possuir vários técnicos.
Uma manutenção pode possuir vários serviços.
O sistema deve manter o histórico das manutenções realizadas nos geradores.
O tipo de manutenção pode ser preventiva ou corretiva.
Os geradores devem possuir um cronograma de inspeção preventiva.
O atendimento não deve possuir limitação de horário devido ao plantão de 24 horas da empresa.

---

## 7. Diagrama Entidade-Relacionamento (DER)

<img width="2048" height="920" alt="image" src="DER_1.png" />

---

## 8. Proposta de Arquitetura Analítica para BI e IA

### A. Informações Estratégicas
A partir dos dados cadastrados no sistema de gestão de geradores e contratos, a diretoria e os gestores da empresa conseguem extrair informações cruciais para a tomada de decisão, tais como:

- O volume de atendimentos de emergência realizados no plantão 24h por região e período.

- O controle rigoroso do desgaste de peças críticas para evitar falhas em campo.

- A saúde financeira do negócio com base no recebimento de contratos fixos e manutenções avulsas.

- O desempenho e a carga de trabalho dos técnicos escalados nos plantões.

### B. Indicadores e Métricas Gerenciais (KPIs)

| KPI (Indicador) | Fórmula de Cálculo | Período de Apuração | Meta Desejada |
| :--- | :--- | :--- | :--- |
| **MTTR (Tempo Médio de Reparo)** | Soma do tempo (início até o fim) dos chamados corretivos / Total de atendimentos corretivos | Mensal | Menor que 3 horas para emergências |
| **MTBF (Tempo Médio Entre Falhas)** | Horas totais de funcionamento dos geradores / Número total de falhas corretivas | Mensal / Trimestral | Maximizar a vida útil entre as quebras |
| **Taxa de Atendimento Preventivo vs. Corretivo** | (Total de Manutenções Preventivas / Total Geral de Manutenções) * 100 | Mensal | Acima de 70% (preventivas dominando as corretivas) |
| **Receita por Contrato** | Soma dos valores mensais gerados pelos contratos ativos. | Mensal | Garantir previsibilidade financeira fixa. |
| **Índice de Primeira Visita (First Fix Rate)** | (Chamados resolvidos na 1ª visita do técnico / Total de chamados) * 100 | Mensal | Acima de 85% (evitar voltar ao cliente por falta de peça) |

### C. Potencial dos Dados para Business Inteligence (BI)
A arquitetura relacional estruturada no DER — integrando entidades como `Cliente`, `Gerador`, `Contrato`, `Manutencao`, `Pagamento` e `Peca` — suporta perfeitamente a extração de relatórios e a construção de painéis gerenciais (*dashboards*) dinâmicos:

* **Painel Operacional de Campo:** Conecta as tabelas `Manutencao`, `Gerador` e `Tecnico` para monitorar chamados abertos em tempo real, o status operacional dos geradores em atendimento e a disponibilidade dos técnicos baseada na tabela `Escala`.
* * **Painel de Confiabilidade e Desempenho (MTTR/MTBF/FFR):** Utiliza o histórico da tabela `Manutencao` e os dados de horímetro da entidade `Gerador` para medir a velocidade de reparo, o índice de solução na primeira visita e a frequência de falhas dos equipamentos.
* **Painel Financeiro e de Contratos:** Agrupa os dados das tabelas `Contrato`, `Pagamento` e `Manutencao` para apresentar a receita recorrente garantida pelos contratos ativos e o faturamento geral da empresa.


## 9. Justificativa Técnica
- Entidades: Separamos Cliente, Gerador, Manutenção, Técnico e Serviço porque cada uma tem ciclo de vida próprio — um cliente existe sem gerador, um gerador passa por várias manutenções, um técnico atende várias manutenções, e um serviço é um catálogo reutilizável. Se juntasse manutenção e gerador ficaria duplicando dados a cada manutenção assim também como serviço é uma entidade separada para evitar repetição de dados.

- Atributos: Cada atributo ficou na entidade que ele realmente descreve. Dados que variam a cada evento (data, tipo, status, valor) foram para Manutenção; dados fixos do equipamento (marca, modelo, potência) ficaram em Gerador. Os dados do técnico que não entraram direto em manutenção pra evitar que aja redundância e também possibilitar consulta de histórico de cada técnico.

Cardinalidade:
- Cliente–Gerador (0,n)-(1,1): um cliente pode ter vários geradores, mas cada gerador tem só um dono.
  
- Gerador-Manutenção (0,n)-(1,1): um gerador pode ter várias manutenções, mas cada manutenção é sobre um único gerador.
  
- Manutenção–Técnico (1,n)-(0,n): toda manutenção precisa de pelo menos um técnico, e um técnico pode atender várias manutenções.
  
- Manutenção–Serviço (1,n)-(0,n): toda manutenção precisa de ao menos um serviço definido no momento do registro; um serviço pode estar cadastrado no catálogo sem nunca ter sido utilizado, ou ter sido aplicado em várias manutenções.
  
---

## 10. Uso de Inteligência Artificial
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
| *Trechos rejeitados ou corrigidos* | Decidimos retirar as partes de “Log de acesso” e “Conformidade com a LGPD” que apareciam no exemplo. Essas seções estavam mais relacionadas ao caso apresentado no modelo, que envolvia dados sensíveis de saúde, e não eram necessárias para o projeto da empresa escolhida. |
| *Justificativa da escolha final* | A estrutura do exemplo foi aproveitada porque atendia ao formato solicitado, mas algumas partes foram retiradas para que o documento ficasse adequado ao contexto da empresa e às informações levantadas. |
| *Reflexão crítica* | 	O exemplo ajudou bastante na organização das informações, mas foi necessário analisar o que realmente se aplicava ao projeto. Dessa forma, utilizamos apenas o modelo como referência e fizemos as adaptações necessárias ao próprio trabalho. |

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
