FROM debian:latest

ENV PGBADGER_VER=12.2  

RUN apt update && apt install -y \
    curl \
    pgbadger \
    nginx \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://github.com/darold/pgbadger/archive/refs/tags/v${PGBADGER_VER}.tar.gz | tar zx && \
    ( \
    cd pgbadger-${PGBADGER_VER} && \
    perl Makefile.PL && \
    make install \
    ) && \
    rm -r pgbadger-${PGBADGER_VER}

RUN mkdir -p /var/log/nginx /var/www/html

COPY ./config/nginx.conf /etc/nginx/nginx.conf

COPY ./config/custom-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

EXPOSE 80

CMD ["/custom-entrypoint.sh"]