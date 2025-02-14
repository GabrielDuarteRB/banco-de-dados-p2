#!/bin/bash

if [ ! -f "/home/pgloader/configured" ] 
then
    echo "Configurando pgloader..."
    echo "Aguardando mais 10 segundos para garantir que o PostgreSQL foi iniciado completamente"
    sleep 10

    echo "Iniciando migração com pgloader..."
    pgloader /app/db.load
    mkdir -p /home/pgloader
    touch /home/pgloader/configured
fi

exec "$@"
