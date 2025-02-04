FROM apache/nifi:2.0.0-M3 AS nifi

USER root

WORKDIR /opt/nifi/nifi-current

RUN apt-get update -y && apt-get install -y wget

RUN mkdir -p /opt/nifi/nifi-current/jdbc

RUN echo "java.arg.8=-Duser.timezone=America/Bahia" >> /opt/nifi/nifi-current/conf/bootstrap.conf

CMD /opt/nifi/nifi-current/bin/nifi.sh run
