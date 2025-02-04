FROM postgres:14


RUN apt-get update && apt-get install -y \
    openssh-server \
    barman \
    barman-cli  \
    cron \
    rsync \
    ca-certificates \
    sudo \
    gnupg   && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


RUN id -u barman &>/dev/null || useradd -m barman && \
    mkdir -p /home/barman/.ssh && \
    touch /home/barman/.ssh/id_rsa && \
    touch /home/barman/.ssh/authorized_keys && \
    chmod 700 /home/barman/.ssh && \
    chmod 600 /home/barman/.ssh/authorized_keys && \
    chown -R barman:barman /home/barman/.ssh && \
    chown -R barman:barman /home/barman/.ssh/id_rsa && \
    chown -R barman:barman /home/barman/.ssh/authorized_keys

RUN mkdir -p /var/lib/barman/postgres/incoming && \
    chmod 777 /var/lib/barman/postgres/incoming

COPY ./config/postgres.conf /etc/barman.d/postgres.conf

RUN chown barman:barman /etc/barman.d/postgres.conf

RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config && \ 
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

RUN echo "0 2 * * * /usr/bin/barman backup postgres" > /etc/cron.d/barman-backup && \
    chmod 0644 /etc/cron.d/barman-backup && \
    crontab /etc/cron.d/barman-backup

COPY ./config/custom-entrypoint.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/custom-entrypoint.sh

RUN mkdir -p /var/lib/barman/postgres && \
    chown -R barman:barman /var/lib/barman && \
    chmod -R 750 /var/lib/barman

EXPOSE 22 

ENTRYPOINT ["sh", "-c", "service ssh start && /docker-entrypoint-initdb.d/custom-entrypoint.sh"]