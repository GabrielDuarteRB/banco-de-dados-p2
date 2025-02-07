#!/bin/bash
set -e

echo "Criando usuario do barman no banco"

psql -U $POSTGRES_USER -c "CREATE USER barman WITH REPLICATION PASSWORD 'barman';"

psql -c "SELECT pg_reload_conf();"