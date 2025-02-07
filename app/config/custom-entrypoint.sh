#!/bin/bash
set -e

touch /var/lib/postgresql/data/postgres-database
cp /usr/share/postgresql/pg_hba.conf /var/lib/postgresql/data/postgres-database/pg_hba.conf

function waitForPostgres {
    until pg_isready -h localhost -p 5432 -U postgres; do
        echo "Aguardando PostgreSQL iniciar..."
        sleep 5
    done
    echo "PostgreSQL está pronto!"
}

function runTemboardAgente {
	if [ ! -f "/var/lib/postgresql/data/configured" ]
	then
		/usr/local/share/temboard-agent/purge.sh data/postgres-database;
		/usr/local/share/temboard-agent/auto_configure.sh http://temboard:3010;
		sudo -u postgres temboard-agent -c /etc/temboard-agent/data/postgres-database/temboard-agent.conf fetch-key --force;
	else
		echo "Temboard Agente Configured"
	fi;
    sudo -u postgres temboard-agent -c /etc/temboard-agent/data/postgres-database/temboard-agent.conf;
}

function runBarman {
	echo "Rodando Barman"

    for db in $(psql -U $POSTGRES_USER -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"); do
        psql -U $POSTGRES_USER -d "$db" -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_start_backup(text, boolean, boolean) to barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_stop_backup() to barman;"
		psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_stop_backup(boolean, boolean) to barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_switch_wal() to barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_create_restore_point(text) to barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT pg_read_all_settings TO barman;"
        psql -U $POSTGRES_USER -d "$db" -c "GRANT pg_read_all_stats TO barman;"
    done
}

/usr/local/bin/docker-entrypoint.sh postgres &

waitForPostgres
sleep 15

runBarman &
#runTemboardAgente &

sleep infinity 