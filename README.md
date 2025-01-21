# Trabalho de banco de dados

## 🎯 **Objetivos**
  ✅ **Escolher uma das bases em SQlite disponibilizadas nesse trabalho.** Dois grupos não podem escolher a mesma  
  ✅ **Usar o pgloader para carregar os dados do SQlite para o Postgre**  
  ⏳ **3 Views (Falta 1)**  
  ✅ **3 Functions**  
  ✅ **3 Procedures**  
  ❌ **3 Triggers**  
  ❌ **PgBarman para configurar backup**  
  ❌ **Transformar a base em Postgre em um DW (Usar o star schema)**  
  ❌ **Criar ETL do banco em Postgre para o DW**  
  ❌ **Criar dicionários de dados os dois banco criados**  

---

## 🚀 **Como rodar**

1. **Configuração inicial:**
   - Crie uma pasta `sqlite` no diretório raiz da aplicação.
   - Adicione o arquivo do banco SQLite com o nome `database.sqlite`.

2. **Rodando a aplicação:**
   - Acesse o terminal e execute os seguintes comandos:
     ```bash
     docker-compose build
     docker-compose up
     ```

3. Após essa sequência de passos, seu banco de dados PostgreSQL estará funcionando e com todos os dados do banco SQLite selecionado.

## 🔗 **Links relacionados**

- 📄 [Documentação do projeto](https://docs.google.com/document/d/1MABuknbwydqBFIjl0rFmO8vZBFO2LNYIE70eg8fiy2s/edit?usp=sharing);
- 📦 [Banco de dados - Europe League](https://www.kaggle.com/datasets/jorgeccollanaorosco/data-europa-ligue?resource=download)
