#!/bin/bash
set -e

# Rode esse script depois que o container estiver em pe!

psql -U $POSTGRES_USER -d "$db" -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"

/usr/local/share/temboard-agent/purge.sh postgres;
/usr/local/share/temboard-agent/auto_configure.sh http://temboard:8888;
sudo -u postgres temboard-agent -c /etc/temboard-agent/postgres/temboard-agent.conf fetch-key

sudo -u postgres temboard-agent -c /etc/temboard-agent/postgres/temboard-agent.conf

touch /var/lib/postgresql/data/temboard_configured;