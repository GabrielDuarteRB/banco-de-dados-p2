# 🛡️ Barman - Backup para PostgreSQL

Este repositório contém a configuração do **Barman** para realizar backups incrementais e ponto-a-ponto do PostgreSQL. 🗄️

Nesse Readme, iremos aprender o que cada detalhe da configuração faz.

## 📋 Requisitos

- ✅ PostgreSQL instalado no servidor.
- ✅ Barman instalado no servidor de backup.
- ✅ Configuração de streaming

## 🛠️ Instalação do Barman

Para iniciarmos a instalação do barman, precisamos analisar o arquivo do Dockerfile

Dentro do arquivo, fazendo a instalação das seguintes bibliotecas:

- barman;
- barman-cli;
- cron;

As duas primeiras serão utilizadas para comandos do barman, enquanto a última utilizaremos caso queiramos configurar um backup completo durante algum momento.

## ⚙️ Configuração do PostgreSQL

No servidor PostgreSQL, edite o arquivo *[postgresql.conf](../app/config/postgresql.conf)* e habilite o WAL com os comandos a seguir 🔄:

| Configuração | Descrição |
|-------------|-----------|
| `listen_addresses = '*'` | Permite que o PostgreSQL aceite conexões de qualquer IP. |
| `wal_level = replica` | Define o nível de gravação de logs para permitir replicação. |
| `shared_preload_libraries = 'pg_stat_statements'` | Carrega a extensão para análise de estatísticas de consultas. |
| `log_connections = on` | Registra todas as conexões ao banco de dados. |
| `log_statement = all` | Registra todas as consultas SQL executadas. |
| `log_line_prefix = '%m [%p]: [%l-1] app=%a,db=%d,client=%h,user=%u'` | Define um formato detalhado para os logs. |
| `cluster_name = 'postgres'` | Nomeia o cluster do PostgreSQL. |
| `archive_mode = on` | Habilita o arquivamento de logs WAL. |
| `max_wal_senders = 10` | Define o número máximo de processos que enviam logs WAL para réplicas. |
| `max_replication_slots = 10` | Define o número máximo de slots de replicação para retenção de WALs. |

### 👤 Criação de usuários

Crie o usuário `barman` no PostgreSQL e conceda as permissões:

Dentro da nossa arquitetura possuimos um arquivo [init](../app/config/init/barman.sh) que, sempre que o nosso servidor PostresSQL subir, executará essas configurações.

```bash
psql -U $POSTGRES_USER -c "CREATE USER barman WITH REPLICATION PASSWORD 'barman';"
```

### Configurando Banco de dados

Ao iniciar o projeto, precisamos nos certificar que algumas configurações e extensão estão funcionando.

Para isso, vamos configurar dentro do [custom-entrypoint](../app/config/postgresql.conf) esses parametros.

Dentro desse arquivo, temos uma função **runBarman** na qual possui todos os parametros necessários para que rode corretamente.

```bash
    for db in $(psql -U $POSTGRES_USER -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"); do
        psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_start_backup(text, boolean, boolean) to barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_stop_backup() to barman;"
	psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_stop_backup(boolean, boolean) to barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_switch_wal() to barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_create_restore_point(text) to barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT pg_read_all_settings TO barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT pg_read_all_stats TO barman;"
    done
```

#### Explicação dos comandos

Comando                                                                 | Descrição
------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------
SELECT datname FROM pg_database WHERE datistemplate = false;             | Recupera o nome de todos os bancos de dados não template do PostgreSQL, ignorando os bancos de dados padrão.
GRANT EXECUTE ON FUNCTION pg_start_backup(text, boolean, boolean) TO barman; | Concede ao usuário `barman` permissão para executar a função `pg_start_backup`, que inicia o processo de backup no PostgreSQL.
GRANT EXECUTE ON FUNCTION pg_stop_backup() TO barman;                    | Concede ao usuário `barman` permissão para executar a função `pg_stop_backup`, que encerra o processo de backup.
GRANT EXECUTE ON FUNCTION pg_stop_backup(boolean, boolean) TO barman;    | Concede ao usuário `barman` permissão para executar a função `pg_stop_backup` com parâmetros específicos.
GRANT EXECUTE ON FUNCTION pg_switch_wal() TO barman;                     | Concede ao usuário `barman` permissão para executar a função `pg_switch_wal`, que força o PostgreSQL a mudar o arquivo WAL (Write Ahead Log).
GRANT EXECUTE ON FUNCTION pg_create_restore_point(text) TO barman;        | Concede ao usuário `barman` permissão para executar a função `pg_create_restore_point`, que cria um ponto de restauração no PostgreSQL.
GRANT pg_read_all_settings TO barman;                                     | Concede ao usuário `barman` permissão para ler todas as configurações do PostgreSQL.
GRANT pg_read_all_stats TO barman;                                        | Concede ao usuário `barman` permissão para ler todas as estatísticas de desempenho do PostgreSQL.

> **Aviso:** Caso a versão do PostgreSQL esteja 15 ou superior, haverá novas nomenclaturas para as funções, conforme a [documentação](https://docs.pgbarman.org/release/3.12.1/user_guide/pre_requisites.html#postgres-users).


### Habilitando requisições externas para o servidor

Dentro do PostgresSQL possui um arquivo (pg_hba.conf) no qual configura quem pode se conectar de forma externa ao servidor.

Nesse arquivo, iremos habilitar que o barman se conecte no nosso servidor postgres utilizando o ipv4 que criamos para eles dentro do [docker-compose.yml](../docker-compose.yml)

``` bash
# Permitir conexões locais sem senha para o usuário postgres
local   all             postgres                                trust

# Permitir conexões locais para qualquer usuário, mas exigindo senha
local   all             all                                     md5

# Permitir conexões remotas apenas com senha criptografada (mude para 'trust' se necessário)
host    all             all             0.0.0.0/0               md5

# Permitir replicação para o Barman
host    replication     barman          100.100.0.20/32         scram-sha-256
```

## 🏗️ Configuração do Barman

O Barman é uma ferramenta de backup e recuperação de dados para o PostgreSQL. No nosso ambiente, a configuração do Barman e do PostgreSQL é realizada através de arquivos localizados em `/etc/barman.conf` e `/etc/barman.d/postgres.conf`.

### Estrutura de Arquivos

Dentro da pasta `barman.d`, podemos ter um ou mais arquivos de configuração para diferentes servidores PostgreSQL. Para o nosso ambiente, a configuração do Barman está mapeada a partir de volumes Docker. As configurações de cada PostgreSQL estão em uma pasta específica, facilitando o gerenciamento e a implementação.

### Exemplo de Configuração do PostgreSQL

A seguir, apresentamos o nosso exemplo de configuração do Barman para um servidor PostgreSQL:

```ini
[postgres]
description = "Servidor PostgreSQL"

conninfo = user=barman dbname=bd-p2 host=postgres password=barman port=5432
backup_method = postgres
path_prefix = "/usr/bin"

streaming_archiver = on
streaming_conninfo = host=postgres user=barman dbname=bd-p2 password=barman port=5432
streaming_backup_name = postgresql_streaming_backup
streaming_archiver_name = postgresql_receive_wal
streaming_archiver_batch_size = 50

create_slot = auto
slot_name = barman
```

### Explicação dos Comandos

| **Comando**                            | **Descrição**                                                                                                  |
|----------------------------------------|----------------------------------------------------------------------------------------------------------------|
| `description`                          | Descrição do servidor PostgreSQL. Define um nome ou descrição para o servidor.                                 |
| `conninfo`                             | Informações de conexão com o banco de dados PostgreSQL. Inclui usuário, banco de dados, host, senha e porta.   |
| `backup_method`                        | Define o método de backup a ser utilizado. No caso, `postgres`, que indica que o backup será feito diretamente com o PostgreSQL. |
| `path_prefix`                          | Prefixo do caminho do executável do PostgreSQL. Aqui é especificado o diretório onde o binário do PostgreSQL está localizado (`/usr/bin`). |
| `streaming_archiver`                   | Habilita ou desabilita o arquivador de streaming. Se `on`, o Barman usará o streaming para arquivar WALs.     |
| `streaming_conninfo`                   | Informações de conexão para o arquivador de streaming. Contém as credenciais e o endereço do servidor de streaming. |
| `streaming_backup_name`                | Nome do backup de streaming que será realizado. Aqui é nomeado como `postgresql_streaming_backup`.            |
| `streaming_archiver_name`              | Nome do processo de arquivamento de streaming. Neste caso, o nome dado é `postgresql_receive_wal`.             |
| `streaming_archiver_batch_size`        | Define o tamanho do lote de arquivos WAL a serem processados de uma vez. Aqui está configurado para 50.       |
| `create_slot`                          | Define como o slot de replicação será gerado. Se `auto`, o Barman cria o slot automaticamente.                |
| `slot_name`                            | Nome do slot de replicação. Aqui é especificado como `barman`.                                                |


## 🔍 Teste da Configuração

Verifique se o Barman consegue acessar o PostgreSQL:

Os dois primeiros passos devem ter sido executados durante a inicialização pelo [custom-entrypoint.sh](./config/custom-entrypoint.sh). Caso isso não tenha ocorrido corretamente, execute os seguintes comandos manualmente:

1. **Ative o cron do Barman**  
```bash
barman cron
```

2. **Force a criação do WAL**  
```bash
barman switch-wal --force --archive all
```
> Esse comando força a rotação e arquivamento do WAL, garantindo que as transações mais recentes sejam incluídas no backup.

3. **Teste a conexão com o PostgreSQL**  
```bash
barman check postgres
```
Se não houver erro, a saída será semelhante a esta:

![image](https://github.com/user-attachments/assets/423d5aed-3853-4430-b26c-a8887335f78f)

> ⚠️ **Atenção**: Se houver falhas anteriores no backup, a saída pode incluir a mensagem "FAILED". Isso não significa um erro atual, apenas indica que em algum momento anterior houve uma falha.

---

## 💾 Executando o Backup  

Para iniciar um backup manualmente, execute:  
```bash
barman backup postgres
```

---

## 🔄 Restaurando um Backup  

Para recuperar o backup mais recente, utilize:  
```bash
barman recover postgres LATEST /var/lib/postgresql/recovery/
```

---

## 📊 Monitoramento  

Para verificar o status dos backups disponíveis:  
```bash
barman list-backup postgres
```

---

## 📝 Logs  

Se precisar depurar algum erro, consulte os logs com:  
```bash
sudo journalctl -u barman
```


