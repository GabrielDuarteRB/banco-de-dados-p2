# 🚀 Temboard - Monitoramento do PostgreSQL

Este repositório contém a configuração do **Temboard** para monitoramento e administração do PostgreSQL. 📊

Nesse Readme, vamos detalhar os passos necessários para configurar e utilizar o Temboard em seu ambiente.

## 📋 Requisitos

- ✅ Temboard instalado no servidor de monitoramento.
- ✅ PostgreSQL instalado no servidor do Temboard.
- ✅ Acesso ao servidor PostgreSQL para leitura de informações.
- ✅ Biblioteca do temboard-agent instalado no servidor postgres que sera monitorado.

## 🛠️ Instalação do Temboard

Para começarmos a instalação do Temboard, é necessário configurar os seguintes componentes:

1. **Temboard Server**: O servidor que irá interagir com o PostgreSQL para coletar métricas e informações de desempenho.
2. **Temboard Agent**: O agente que será instalado no servidor PostgreSQL para enviar as informações para o Temboard Server.

### **Temboard Server**

Instale o Temboard Server em um servidor separado. Para isso, vamos configurar o [docker-compose.yml](../docker-compose.yml) do temboard:

```bash
temboard:
    build:
      context: ./temboard
      args:
        TEMBOARD_VERSION: "8.2.1"
    image: temboard:latest
    container_name: temboard
    volumes:
      - ssl:/etc/ssl/certs  
      - pgdata:/var/lib/postgresql/data
      - home:/home/temboard
      - ./temboard/config/temboard.conf:/home/temboard/temboard.conf:rw
      - ./temboard/config/postgresql.conf:/var/lib/postgresql/data/postgresql.conf:rw
    ports:
      - 3010:8888
      - 3110:5431
    depends_on:
      - postgres
    networks:
      postgres-network:
        ipv4_address: 100.100.0.30
```