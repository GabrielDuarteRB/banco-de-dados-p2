#!/bin/bash
set -e

cp /usr/share/postgresql/postgresql.conf /var/lib/postgresql/data/postgresql.conf
cp /usr/share/postgresql/postgres.conf /etc/barman.d/postgres.conf

chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
chown postgres:postgres /var/lib/postgresql/data/postgres.conf

echo "0 3 * * 1 barman backup postgres" > /etc/cron.d/barman-backup
echo "*/5 * * * * barman backup postgres" > /etc/cron.d/barman-incremental
chmod 0644 /etc/cron.d/barman-backup
chmod 0644 /etc/cron.d/barman-incremental

service cron start

source /opt/temboard-venv/bin/activate


# echo 'aki'
# temboard --home /etc/temboard/ generate-key

# echo 'akii'
# temboard --home /etc/temboard/ register-instance --host localhost --port 5432 --user postgres --password postgres

# echo 'akiii'
# temboard --home /etc/temboard/ serve &

