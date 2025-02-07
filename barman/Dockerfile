FROM postgres:14

RUN apt-get update && apt-get install -y \
    barman \
    barman-cli  \
    cron && \
    rm -rf /var/lib/apt/lists/*

COPY ./config/custom-entrypoint.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/custom-entrypoint.sh

RUN chown barman:barman /etc/barman.conf

ENTRYPOINT ["/docker-entrypoint-initdb.d/custom-entrypoint.sh"]