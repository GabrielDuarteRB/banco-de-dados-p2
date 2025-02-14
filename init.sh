#!/bin/bash
set -e

CONTAINER_POSTGRES="postgres"

createDirs() {
    mkdir -m 777 -p ./sqlite ./barman/backup ./postgres-database ./pgbadger/pg_log
}

createNormalizedBd() {
    SQL_FILE="./app/normalizacao/match.sql"

    if [ ! -f "$SQL_FILE" ]; then
        echo "Arquivo SQL não encontrado: $SQL_FILE"
        exit 1
    fi

    docker cp "$SQL_FILE" "$CONTAINER_POSTGRES:/tmp/match.sql"

    docker exec -it "$CONTAINER_POSTGRES" bash -c "psql -U postgres -d bd-p2 -f /tmp/match.sql"

    docker exec -it "$CONTAINER_POSTGRES" bash -c "rm /tmp/match.sql"

    echo "Normalização concluída!"
}

executeFunctionsTriggerView() {
    SQL_DIR="./app/entregas"
    SQL_FILES=("procedure.sql" "funcoes.sql" "trigger.sql" "views.sql")

    docker cp "$SQL_DIR" "$CONTAINER_POSTGRES:/tmp/"

    for FILE in "${SQL_FILES[@]}"; do
        docker exec -it "$CONTAINER_POSTGRES" psql -U postgres -d bd-p2 -f "/tmp/entregas/$FILE"
    done

    docker exec -it "$CONTAINER_POSTGRES" sh -c "rm -rf /tmp/entregas"

    echo "Funções, Procedures, Triggers e Views executadas!"
}

configTemboardOnPostgres() {

    CONFIG_SCRIPT="./app/config/temboard-config.sh"

    if [ ! -f "$CONFIG_SCRIPT" ]; then
        echo "Arquivo de configuração não encontrado: $CONFIG_SCRIPT"
        exit 1
    fi

    docker cp "$CONFIG_SCRIPT" "$CONTAINER_POSTGRES:/tmp/temboard-config.sh"

    docker exec -it "$CONTAINER_POSTGRES" bash -c "chmod +x /tmp/temboard-config.sh && /tmp/temboard-config.sh"

    docker exec -it "$CONTAINER_POSTGRES" bash -c "rm /tmp/temboard-config.sh"

    echo "Normalização concluída!"

    exec "$@"
}

$1