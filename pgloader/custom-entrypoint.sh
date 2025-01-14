#!/bin/bash

echo "Aguardando mais 10 segundos para garantir que o PostgreSQL foi iniciado completamente"
sleep 10

echo "Iniciando migração com pgloader..."
pgloader /app/db.load

exec "$@"
