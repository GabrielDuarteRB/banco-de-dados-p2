FROM postgres:14

WORKDIR /app

ENV PG_HBA_FILE=/var/lib/postgresql/data/

ENV TEMBOARD_AGENT_VERSION "821"
ENV TEMBOARD_PORT "2345"
ENV PGUSER ${POSTGRES_USER}
ENV PGPASSWORD ${POSTGRES_PASSWORD}
ENV PGDATABASE ${POSTGRES_DB}
ENV PGHOST /var/run/postgresql
ENV TEMBOARD_HOSTNAME "postgres14.host"

#COPY ./config/postgresql.conf /usr/share/postgresql/postgresql.conf.sample
COPY ./config/pg_hba.conf /usr/share/postgresql/pg_hba.conf

RUN apt-get update && apt-get install -y \
    sudo \
    barman-cli \
    gnupg \
    ca-certificates \
    rsync \
    cron \
    openssh-server \
    sshpass \
    python3-pip python3-setuptools python3-dev; \
	whereis python3 && ln -s /usr/bin/python3 /usr/bin/python && \
	python3 -m pip install logutils argparse psycopg2 temboard-agent=="8.2.1" --break-system-packages && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m barman &&  \
    mkdir -p /home/barman/.ssh/ && \
    touch /home/barman/.ssh/authorized_keys && \
    chmod 700 /home/barman/.ssh && \
    chmod 600 /home/barman/.ssh/authorized_keys && \
    chown -R barman:barman /home/barman/.ssh && \
    chown -R barman:barman /home/barman/.ssh/authorized_keys 

#RUN mkdir -p /var/lib/postgresql/data/postgres-database && \
#    touch /var/lib/postgresql/data/postgres-database/postgresql.conf
    

RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

COPY ./config/init/* /docker-entrypoint-initdb.d/

COPY ./config/custom-entrypoint.sh /

RUN chmod +x /custom-entrypoint.sh

EXPOSE 22 
EXPOSE 5432 

ENTRYPOINT ["/custom-entrypoint.sh"]
CMD postgres & sleep infinity