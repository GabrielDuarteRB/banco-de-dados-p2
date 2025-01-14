FROM dimitri/pgloader:latest

WORKDIR /app

COPY db.load /app/db.load
COPY custom-entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

RUN apt-get update && apt-get install -y \
    wget \
    sudo \
    pgloader \
    sqlite3


ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]