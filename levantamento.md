# Levantamento e Relato da Entrevista: S. A. de Lima (Limas Energia Geradores)

> Detalhe do item 1.1 do [README](../README.md). O README mostra só o que é problema e como o modelo responde. Este arquivo guarda o relato inteiro, inclusive os assuntos em que não foi relatado problema, e o caminho do levantamento até o banco.

---

## 1. Dados da entrevista

| Item | Informação |
| :--- | :--- |
| Empresa | S. A. de Lima (Limas Energia Geradores) |
| Ramo | Manutenção preventiva e corretiva de geradores de energia (com fins lucrativos) |
| Entrevistado | Sandro Aparecido de Lima, dono da empresa e responsável pela organização |
| Contato | +55 (11) 98373-9556 · sandrolima@limasenergia.com.br |
| Data | 07/11/2026 |
| Local | Sede da empresa: Av. Adriano Bertozzi, 815 - Jardim Helian, São Paulo - SP |
| Formato | Entrevista presencial no ambiente da organização |
| Presentes pelo grupo | Kauan José da Silva (trabalha na empresa e é sobrinho do entrevistado, vínculo declarado no README) |
| Não presentes | Kauê Romaneto Machado, Kaylany Thayna de Oliveira de Paula e Maria Vitória Pereira Alves. Trabalharam a partir do relato e do levantamento do Kauan |
| Comprovação | [Foto da entrevista](../foto%20da%20entrevistas.png) e [foto da empresa](../imagem%20empresa.jpg) |

---

## 2. Contexto

| Indicador | Valor informado |
| :--- | :--- |
| Funcionários | 15 |
| Clientes fixos | 96 |
| Manutenções em geradores | média de 33 por mês (≈ 400 por ano) |
| Regime de atendimento | plantão de 24 horas (emergências a qualquer hora) |
| Controle dos dados | papel: fichas e relatórios físicos (clientes, atendimentos, contratos) |

Hoje a empresa não tem controle digital. Os dados de clientes, atendimentos e contratos ficam em fichas e papéis. Alterações de contrato chegam por e-mail e o faturamento é estimado manualmente.

---

## 3. Relato da entrevista

| # | Assunto | Resposta resumida | Problema |
| :--- | :--- | :--- | :--- |
| 1 | Fichas de clientes e geradores | Já houve perda ou ilegibilidade das fichas em papel | P1 |
| 2 | Histórico e prazo de troca de peças | É preciso buscar nos relatórios, um por um, para achar a última troca | P2 |
| 3 | Contratos | O contrato é relido a cada atendimento para ver se cobre o serviço ou a peça | P3 |
| 4 | Mudanças de contrato | Chegam por e-mail e nem sempre são registradas | P4 |
| 5 | Faturamento e reajustes | As contas são feitas "por cima" e refeitas a cada reajuste | P5 |
| 6 | Orçamentos | Feito quando há problema no gerador e é preciso trocar peça e mão de obra. É elaborado em PDF e enviado por e-mail | Sem problema relatado |
| 7 | Estoque de peças | Não se sabe se a peça está disponível e é preciso ficar procurando. Já foi preciso comprar peça que já tinham | P6 |
| 8 | Boletos e contas a pagar | Os boletos chegam por e-mail ou são pagos todo mês em data marcada | Sem problema relatado |
| 9 | Fornecedores | Os dados ficam em documentos impressos. Nunca houve dificuldade para achar o fornecedor, mas já foi encontrado documento deteriorado | P7 |
| 10 | Plantão e escala dos técnicos | Existe escala de plantão dos técnicos. O plantão de 24 horas é feito por cada técnico quando ocorre um chamado de emergência, quando um gerador para fora do horário comercial. Sem problema com o plantão | Sem problema relatado |
| 11 | Dados pessoais dos clientes (LGPD) | Nunca houve vazamento de dados de clientes. Sem problema com proteção de dados (LGPD) | Sem problema relatado |

> **Atenção:** todas as linhas estão preenchidas. Mantenha somente o que o Sandro realmente disse, sem inventar respostas.

> **Complemento:** os itens 9, 10 e 11 foram detalhados em [data] pelo Kauan, que trabalha na empresa. A entrevista em si foi em 07/11/2026.

---

## 4. Problemas identificados e onde o modelo os resolve

| ID | Problema (crise operacional) | Evidência | Onde o modelo o resolve |
| :--- | :--- | :--- | :--- |
| P1 | Fichas em papel sujeitas a perda ou ilegibilidade | Entrevista (item 1) e fotos [ficha](../ficha-cliente.jpg) e [arquivo](../arquivo-fichas.jpg) | `Cliente`, `Gerador`, `Manutencao` (RF01, RF02, RF03, RF08, RN01–RN03) |
| P2 | Histórico e última troca de peças só são achados folheando relatórios | Entrevista (item 2) e foto dos [relatórios](../relatorios-pecas.jpg) | `Cronograma_Preventivo`, `Peca`, `Manutencao`, `atualiza` (RF02, RF04, RF05, RN08, RN09) |
| P3 | Contrato relido a cada atendimento para checar cobertura | Entrevista (item 3) e foto do [contrato](../contrato-papel.jpg) | `Contrato`, `Gerador.id_contrato`, `Manutencao.id_contrato` (RF06, RN12–RN15) |
| P4 | Alterações de contrato por e-mail, sem registro garantido | Entrevista (item 4) | `Aditivo_contrato` (RF19, RN27) |
| P5 | Faturamento estimado e reajustes refeitos à mão | Entrevista (item 5) | `Contrato`, `Aditivo_contrato`, `Pagamento` (RF14, RF19, RN20, RN21) |
| P6 | Não se sabe se a peça existe em estoque, é preciso ficar procurando e já houve compra de peça que já se tinha | Entrevista (item 7) | `Peca` (atributo `estoque`), `Compra`, relacionamento `contem` entre `Compra` e `Peca` (RF15, RF16, RN23) |
| P7 | Dados de fornecedores em documentos impressos, sujeitos a deterioração | Entrevista (item 9) | `Fornecedor`, `Compra` (relacionamento `fornece`) e `Peca` (RF16) |

---

### 4.1 Regras adotadas no modelo (decisões do grupo)

Estas regras estão no README e no modelo, mas não vieram como fala do Sandro. São decisões do grupo para organizar o banco, e não devem ser lidas como relato da entrevista.

- **Plantão e escala:** a tabela `Escala` registra período, turno e dia de folga de cada técnico, e a escala serve de base para o plantão de 24 horas, em que o técnico atende os chamados de emergência fora do horário comercial (Processo 9).
- **Emergência:** o orçamento também precisa ser aprovado antes da execução, mas o pagamento pode vir depois (Processos 5 e 13).
- **Preventiva em contrato:** as preventivas previstas no contrato são pagas pela mensalidade e não passam por orçamento; o que fica fora do previsto é cobrado à parte (Processos 3 e 5).

---

## 5. Evidências

- Foto da entrevista, com o integrante e o responsável no local: [foto da entrevistas.png](../foto%20da%20entrevistas.png)
- Foto da empresa (fachada, com o nome e o número 815 visíveis): [imagem empresa.jpg](../imagem%20empresa.jpg)
- Ficha de cliente ou gerador em papel, com dados pessoais cobertos (P1): [ficha-cliente.jpg](../ficha-cliente.jpg)
- Arquivo ou armário onde as fichas ficam guardadas (P1): [arquivo-fichas.jpg](../arquivo-fichas.jpg)
- Relatórios de manutenção empilhados, mostrando a busca pela última troca de peça (P2): [relatorios-pecas.jpg](../relatorios-pecas.jpg)
- Contrato em papel, na página de cobertura, com dados pessoais cobertos (P3): [contrato-papel.jpg](../contrato-papel.jpg)
- Perfil no Google Maps: https://maps.app.goo.gl/XExBHSXrFvbUNv8Y6?g_st=aw
- Site: https://limasenergia.com.br/

---

## 6. Pendências do grupo

- [ ] Conferir se existem regras de negócio (RN) ligadas a compras e fornecedores para acrescentar em P6 e P7, além da RN23.
- [ ] Preencher "Achados da observação presencial" e "Nova visita (Entrega 2)" no README.
- [ ] Confirmar com o Sandro se existe algum problema sobre especificações do equipamento (por exemplo, capacidade de óleo). Se existir, incluir o atributo no DER, no modelo lógico, no dicionário e no script SQL antes de listá-lo como problema.
- [ ] Tirar e salvar na raiz do repositório as fotos citadas na seção 5 (`ficha-cliente.jpg`, `arquivo-fichas.jpg`, `relatorios-pecas.jpg`, `contrato-papel.jpg`), com dados pessoais cobertos. Enquanto não existirem, os links da seção 4 e da seção 5 ficam quebrados.
- [ ] Renomear a foto da entrevista (`127480.png`) para `foto da entrevistas.png`.
