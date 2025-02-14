#!/bin/bash
set -e

/usr/local/bin/docker-entrypoint.sh postgres &

cp /usr/share/postgresql/pg_hba.conf /var/lib/postgresql/data/postgres-database/pg_hba.conf
cp /usr/share/postgresql/postgresql.conf /var/lib/postgresql/data/postgres-database/postgresql.conf

function runTemboardAgente {
    psql -U $POSTGRES_USER -d "$db" -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"
    
	if [ ! -f "/var/lib/postgresql/data/temboard_configured" ]
	then
        echo "Necessário configurar o temboard. Leia o Readme para mais informações."
	else
		sudo -u postgres temboard-agent -c /etc/temboard-agent/postgres/temboard-agent.conf
	fi;
}

function runConfigBdBarman {

    if [ ! -f "/var/lib/postgresql/data/barman_configured" ]
    then
        echo "Criando usuario do barman no banco"

        psql -U $POSTGRES_USER -c "CREATE USER barman WITH SUPERUSER REPLICATION PASSWORD 'barman';"

        echo "Configurando banco para barman"

        for db in $(psql -U $POSTGRES_USER -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"); do
            psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_start_backup(text, boolean, boolean) to barman;"
            psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_stop_backup() to barman;"
            psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_stop_backup(boolean, boolean) to barman;"
            psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_switch_wal() to barman;"
            psql -U $POSTGRES_USER -d "$db" -c "GRANT EXECUTE ON FUNCTION pg_create_restore_point(text) to barman;"
            psql -U $POSTGRES_USER -d "$db" -c "GRANT pg_read_all_settings TO barman;"
            psql -U $POSTGRES_USER -d "$db" -c "GRANT pg_read_all_stats TO barman;"
        done

        psql -c "SELECT pg_reload_conf();"

        touch /var/lib/postgresql/data/barman_configured;
    else
        echo "Barman já configurado"
    fi;
	
}

sleep 15 &&

runConfigBdBarman &
runTemboardAgente &

sleep infinity 