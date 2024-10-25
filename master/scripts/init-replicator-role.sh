#!/bin/bash
#
# Esperar a que el master esté listo
until pg_isready -h 172.18.0.4 -p 5432 -U cluster; do
  echo "Esperando a que el servidor monitor esté disponible..."
  sleep 2
done

#Creacion del usuario replicator
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicatorpassword';
EOSQL
