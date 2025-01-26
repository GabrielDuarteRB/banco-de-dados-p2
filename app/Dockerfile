FROM postgres:latest

WORKDIR /app

COPY ./config/postgresql.conf /usr/share/postgresql/postgresql.conf
COPY ./config/postgres.conf /usr/share/postgresql/postgres.conf

RUN apt-get update && apt-get install -y \
    barman \
    barman-cli \
    rsync \
    cron \
    openssh-server \
    sshpass  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/barman/pgsql/incoming && \
    mkdir -p /var/lib/postgresql/archive && \
    chown -R postgres:postgres /var/lib/barman /var/lib/postgresql/archive

COPY ./config/custom-entrypoint.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/custom-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/custom-entrypoint.sh"]

EXPOSE 5432