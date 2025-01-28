FROM postgres:latest

WORKDIR /app

COPY ./config/postgresql.conf /usr/share/postgresql/postgresql.conf
COPY ./config/postgres.conf /usr/share/postgresql/postgres.conf

ENV PGBADGER_VER=12.2   

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    barman \
    barman-cli \
    rsync \
    cron \
    openssh-server \
    sshpass \
    pgbadger \
    python3-pip \
    python3-venv && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://github.com/darold/pgbadger/archive/refs/tags/v${PGBADGER_VER}.tar.gz | tar zx && \
    ( \
    cd pgbadger-${PGBADGER_VER} && \
    perl Makefile.PL && \
    make install \
    ) && \
    rm -r pgbadger-${PGBADGER_VER}

RUN mkdir -p /etc/temboard /var/lib/temboard && \
    chown -R postgres:postgres /etc/temboard /var/lib/temboard && \
    python3 -m venv /opt/temboard-venv && \
    /opt/temboard-venv/bin/pip install --upgrade pip && \
    /opt/temboard-venv/bin/pip install temboard psycopg2-binary

COPY ./config/temboard-agent.conf /etc/temboard/temboard.conf


RUN mkdir -p /var/lib/postgresql/data/log && \
    chown postgres:postgres /var/lib/postgresql/data/log && \
    chmod 700 /var/lib/postgresql/data/log

RUN mkdir -p /var/lib/barman/pgsql/incoming && \
    mkdir -p /var/lib/postgresql/archive && \
    chown -R postgres:postgres /var/lib/barman /var/lib/postgresql/archive

COPY ./config/custom-entrypoint.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/custom-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint-initdb.d/custom-entrypoint.sh"]

EXPOSE 5432
EXPOSE 8888     