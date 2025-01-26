#!/bin/bash
set -e

cp /usr/share/postgresql/postgresql.conf.sample /var/lib/postgresql/data/postgresql.conf
cp /usr/share/postgresql/postgres.conf /etc/barman.d/postgres.conf

echo "0 3 * * 1 barman backup postgres" > /etc/cron.d/barman-backup
chmod 0644 /etc/cron.d/barman-backup

echo "*/5 * * * * barman backup postgres" > /etc/cron.d/barman-incremental
chmod 0644 /etc/cron.d/barman-incremental

service cron start

exec /usr/local/bin/docker-entrypoint.sh postgres

tail -f /dev/null
