FROM postgres:14-bullseye

ARG TEMBOARD_VERSION

ENV PGPORT "5431"
ENV POSTGRES_PASSWORD "temboard"
ENV POSTGRES_USER "postgres"
ENV POSTGRES_DB "temboard"
ENV PGDATA "/var/lib/postgresql/data/pgdata"
ENV POSTGRES_NAME "temboard"

ENV PGUSER=postgres
ENV PGHOST=postgres
ENV LOGDIR=/home/temboard/log/temboard
ENV LOGFILE=/home/temboard/log/temboard/temboard-auto-configure.log
ENV ETCDIR=/home/temboard/etc
ENV VARDIR=/home/temboard/bin
ENV SYSUSER=root
ENV TEMBOARD_PORT=8888
ENV TEMBOARD_PASSWORD=temboard
ENV TEMBOARD_DATABASE=temboard
ENV TEMBOARD_LOGGING_LEVEL=INFO
ENV TEMBOARD_VERSION ${TEMBOARD_VERSION}

COPY ./config/postgresql.conf /etc/postgresql/postgresql.conf

WORKDIR /home/temboard
   
RUN apt-get update -y && \
    apt-get install -y sudo python3-pip locales; \
	whereis python3 && ln -s /usr/bin/python3 /usr/bin/python && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8;

ENV LANG en_US.utf8
ENV TZ America/Bahia

COPY ./config/db-config.sh /docker-entrypoint-initdb.d/

COPY ./config/custom-entrypoint.sh /home/temboard/

RUN chmod +x /home/temboard/custom-entrypoint.sh

RUN mkdir -p /home/temboard/log/temboard; \
	mkdir -p /home/temboard/etc; \
	mkdir -p /home/temboard/bin; \
	echo '' > /home/temboard/log/temboard/temboard-auto-configure.log; \
	pip install temboard==${TEMBOARD_VERSION} psycopg2-binary && temboard --version;

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
ENTRYPOINT ["/home/temboard/custom-entrypoint.sh"]