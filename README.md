# Trabalho de Banco de Dados

Este projeto visa a implementação de um banco de dados em PostgreSQL a partir de uma base SQLite, com a criação de diversas funcionalidades como views, funções, triggers e backup, além de desafios adicionais como monitoramento ativo e criação de um Data Warehouse (DW).

## 🎯 **Objetivos**
  ✅ **Escolher uma das bases em SQlite disponibilizadas nesse trabalho.** Dois grupos não podem escolher a mesma  
  ✅ **Usar o pgloader para carregar os dados do SQlite para o Postgre**  
  ✅**3 Views**  
  ✅ **3 Functions**  
  ⏳ **3 Procedures (Falta uma)**  
  ✅ **3 Triggers**  
  ✅ **PgBarman para configurar backup**  
  ❌ **Configurar o monitoramento ativo da base em Postgre com o TemBoard e o PgBadger**  
  ❌ **Transformar a base em Postgre em um DW (Usar o star schema)**  
  ❌ **Criar ETL do banco em Postgre para o DW**  
  ❌ **Criar dicionários de dados os dois banco criados**  

---

## 📋 **Pré-requisitos**

Antes de começar, certifique-se de ter os seguintes itens instalados:

- Docker: [Instruções de instalação](https://docs.docker.com/get-docker/)
- Docker Compose: [Instruções de instalação](https://docs.docker.com/compose/install/)

## 📦 **Versões de Plugins e Dependências**

- **PostgreSQL**: 14.15
- **Barman**: 3.12.1
- **Temboard**: 8.2.1
- **Pgbadger**: 12.2
- **Python**: 3.9.2

## 🚀 **Como rodar**

1. **Configuração inicial:**
   -  Execute o comando bash init.sh createDirs
   - Adicione o arquivo do banco SQLite com o nome `database.sqlite` dentro da pasta sqlite criada.

2. **Rodando a aplicação:**
   - Acesse o terminal e execute os seguintes comandos:
     ```bash
     docker-compose build
     docker-compose up
     ```
     
3. Após essa sequência de passos, seu banco de dados PostgreSQL estará funcionando e com todos os dados do banco SQLite selecionado.

## 📂 **Pastas do Projeto**
- [Barman](./barman/README.md) – Detalhes sobre a configuração e uso do Barman para backup.
- [PostgreSQL](./postgresql/README.md) – Explicações sobre a configuração do PostgreSQL no projeto.
- [TemBoard](./temboard/README.md) – Como configurar o monitoramento ativo com o TemBoard.
- [PgBadger](./pgbadger/README.md) – Como configurar o PgBadger para análise de logs.
- [PgLoader](./pgloader/README.md) – Detalhes sobre como usar o PgLoader para migrar dados do SQLite para PostgreSQL.
- [Data Warehouse (DW)](./dw/README.md) – Transformação da base PostgreSQL em um Data Warehouse usando Star Schema.

## 🔗 **Links relacionados**

- 📄 [Documentação do projeto](https://docs.google.com/document/d/1MABuknbwydqBFIjl0rFmO8vZBFO2LNYIE70eg8fiy2s/edit?usp=sharing);
- 📦 [Banco de dados - Europe League](https://www.kaggle.com/datasets/jorgeccollanaorosco/data-europa-ligue?resource=download)
