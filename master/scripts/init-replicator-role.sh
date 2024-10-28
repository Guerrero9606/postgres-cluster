#!/bin/bash
# Esperar a que el master esté listo
until pg_isready -h 172.18.0.4 -p 5432 -U postgres; do
  echo "Esperando a que el monitor este disponible..."
  sleep 2
done

#rm -rf /var/lib/postgresql/data/*

#pg_ctl stop -D /var/lib/postgresql/data

#Creacion del usuario replicator
#psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
#  CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicatorpassword';
#EOSQL

postgres -c hba_file=/etc/postgresql/pg_hba.conf -c config_file=/etc/postgresql/postgresql.conf

#pg_ctl stop -D /var/lib/postgresql/data
