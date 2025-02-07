FROM postgres:14

WORKDIR /app

ENV TEMBOARD_AGENT_VERSION "821"
ENV TEMBOARD_PORT "2345"
ENV PGUSER ${POSTGRES_USER}
ENV PGPASSWORD ${POSTGRES_PASSWORD}
ENV PGDATABASE ${POSTGRES_DB}
ENV PGHOST /var/run/postgresql
ENV TEMBOARD_HOSTNAME "postgres14.host"

COPY ./config/pg_hba.conf /usr/share/postgresql/pg_hba.conf

RUN apt-get update && apt-get install -y \
    barman \
    barman-cli \
    cron \
    python3-pip python3-setuptools python3-dev; \
	whereis python3 && ln -s /usr/bin/python3 /usr/bin/python && \
	python3 -m pip install logutils argparse psycopg2 temboard-agent=="8.2.1" --break-system-packages && \
    rm -rf /var/lib/apt/lists/*

    RUN mkdir -p /home/barman && \
    if ! getent passwd barman > /dev/null; then \
        useradd -d /home/barman -s /bin/bash -u 1010 -g barman barman; \
    else \
        usermod -d /home/barman -s /bin/bash barman; \
    fi && \
    echo "barman:barman" | chpasswd && \
    echo "postgres:postgres" | chpasswd && \
    passwd -d root

RUN chown -R barman:barman /home/barman
    
COPY ./config/init/barman.sh /docker-entrypoint-initdb/init.sh

COPY ./config/custom-entrypoint.sh /

RUN chmod +x /docker-entrypoint-initdb/init.sh && \
    chmod +x /custom-entrypoint.sh && \
    chown -R postgres:postgres /var/lib/postgresql

EXPOSE 5432 

ENTRYPOINT ["/custom-entrypoint.sh"]