# Sistema Financeiro

Aplicação desktop desenvolvida em Delphi para gerenciamento financeiro de contas a pagar e receber, com cadastro unificado de clientes e fornecedores.

---

# Tecnologias Utilizadas

- Delphi 12 Athens Community Edition
- SQLite
- FireDAC
- Arquitetura MVC
- Integração com ViaCEP

---

# Requisitos

- Windows 10 ou superior
- Delphi 12 Community Edition
- Arquivo `sqlite3.dll` na pasta do executável

---

# Estrutura do Projeto

```text
SistemaFinanceiro/
│
├── FrmPrincipal.pas              # Tela principal e menu de navegação
├── FrmPessoa.pas                 # Cadastro de pessoas
├── FrmContaPagar.pas             # Contas a pagar
├── FrmContaReceber.pas           # Contas a receber
├── DataModule.pas                # Conexão com banco e criação das tabelas
│
├── ModelPessoa.pas               # Model da entidade Pessoa
├── ModelContaPagar.pas           # Model da entidade Conta a Pagar
├── ModelContaReceber.pas         # Model da entidade Conta a Receber
│
├── ControllerPessoa.pas          # Regras de negócio de Pessoa
├── ControllerContaPagar.pas      # Regras de negócio de Conta a Pagar
├── ControllerContaReceber.pas    # Regras de negócio de Conta a Receber
│
├── Constantes.pas                # Mensagens e constantes SQL
├── banco.sql                     # Script de referência do banco
└── sqlite3.dll                   # Driver SQLite
```

---

# Funcionalidades

## Cadastro de Pessoas

- Cadastro unificado de:
  - Clientes
  - Fornecedores
  - Ambos
- Validação de CPF
- Validação de CNPJ
- Validação de e-mail
- Consulta automática de endereço via CEP utilizando ViaCEP
- Filtros por:
  - Nome
  - Tipo
  - CPF/CNPJ
  - Cidade
  - Estado

---

## Contas a Pagar

- Cadastro de contas com:
  - Fornecedor
  - Data de emissão
  - Valor total
- Controle de parcelas:
  - Data de vencimento
  - Valor da parcela
- Registro de pagamento:
  - Data do pagamento
  - Valor pago
- Validação das datas das parcelas
- Validação da soma das parcelas
- Botão Finalizar para bloqueio de alterações
- Filtros por:
  - Período de emissão
  - Faixa de valor
  - Fornecedor
  - Situação

---

## Contas a Receber

- Cadastro de contas com:
  - Cliente
  - Data de emissão
  - Valor total
- Controle de parcelas:
  - Data de vencimento
  - Valor da parcela
- Registro de recebimento:
  - Data do recebimento
  - Valor recebido
- Validação das datas das parcelas
- Validação da soma das parcelas
- Botão Finalizar para bloqueio de alterações
- Filtros por:
  - Período de emissão
  - Faixa de valor
  - Cliente
  - Situação

---

# Arquitetura

O projeto segue o padrão MVC adaptado para aplicações VCL em Delphi.

## Model

Responsável pelas entidades e regras de estrutura dos dados.

## Controller

Responsável pelas regras de negócio, validações e acesso ao banco de dados.

## View

Responsável pelas telas VCL e interação com o usuário.

---

# Banco de Dados

O banco de dados utilizado é o SQLite, escolhido por ser leve, local e não exigir instalação de servidor.

A estrutura foi modelada seguindo a Terceira Forma Normal (3FN), evitando redundância de dados e melhorando a integridade das informações.

A tabela `CIDADE` foi separada para evitar repetição de cidade e estado nos cadastros.
