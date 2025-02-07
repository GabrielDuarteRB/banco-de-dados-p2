#!bin/bash

configure(){
    mkdir -m 777 -p $(pwd)/drivers && \
    wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar -P $(pwd)/drivers && \
    wget https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/23.2.0.0/ojdbc8-23.2.0.0.jar -P $(pwd)/drivers && \
    wget https://jdbc.postgresql.org/download/postgresql-42.6.0.jar -P $(pwd)/drivers && \
    wget https://repo1.maven.org/maven2/org/apache/nifi/nifi-kite-nar/1.15.3/nifi-kite-nar-1.15.3.nar -P $(pwd)/drivers && \
    wget https://truststore.pki.rds.amazonaws.com/sa-east-1/sa-east-1-bundle.pem -P $(pwd)/drivers && \
    wget https://jdbcsql.sourceforge.net/sqljdbc4.jar -P $(pwd)/drivers && \
    chmod 777 $(pwd)/drivers/*;
}

build(){
    docker compose --compatibility --project-name "nifi" build --no-cache -m 1g
}

up(){
    docker compose --compatibility --project-name "nifi" up -d
}

stop(){
    docker compose --compatibility --project-name "nifi" stop
}

restart(){
    docker-compose --compatibility --project-name "nifi" down && \
    docker-compose --compatibility --project-name "nifi" up -d
}

drop(){
    docker compose --compatibility --project-name "nifi" down
}

drop_hard(){
    docker-compose --compatibility --project-name "nifi" down --remove-orphans --volumes --rmi 'all' && \
    docker builder prune -f && \
    docker image rm $(docker images --format "{{.ID}} {{.Repository}}:{{.Tag}}" | grep -v "$(docker ps --format {{.Image}})" | awk '{ print $1}') 2>/dev/null;
    rm -rf $(pwd)/drivers;
}

# Acessar com http://localhost:8081/nifi
# OU
# Acessar com https://localhost:8443/nifi usuario: admin senha: ILvhISLIkaTlBACLUfhesmtTg


$1