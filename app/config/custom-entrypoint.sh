#!/bin/bash
set -e

#cp /usr/share/postgresql/postgresql.conf.sample /var/lib/postgresql/data/postgres-database/postgresql.conf
cp /usr/share/postgresql/pg_hba.conf /var/lib/postgresql/data
cp /home/barman/.ssh/id_rsa.pub /home/barman/.ssh/authorized_keys

service ssh start

function waitForPostgres {
    until pg_isready -h localhost -p 5432 -U postgres; do
        echo "Aguardando PostgreSQL iniciar..."
        sleep 5
    done
    echo "PostgreSQL está pronto!"
}

function runTemboardAgente {
	sleep 15
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


/usr/local/bin/docker-entrypoint.sh postgres &

waitForPostgres

runTemboardAgente &

sleep infinity 