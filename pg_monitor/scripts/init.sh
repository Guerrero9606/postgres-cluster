#!/bin/bash
#usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/data

# Espera a que PostgreSQL esté listo
#until pg_isready -U cluster -d pg_auto_failover; do
#  echo "Esperando a que PostgreSQL esté listo..."
#  sleep 2
#done

# Crear el rol cluster y darle permisos de superusuario
#psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
#  CREATE ROLE cluster WITH LOGIN SUPERUSER;
#EOSQL

# Eliminar datos existentes en la réplica
rm -rf /var/lib/postgresql/data/*

# Iniciar el monitor
pg_autoctl create monitor --pgdata /var/lib/postgresql/data --auth trust --ssl-self-signed --pgport 5432 --run

#usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/data
# Ejecutar PostgreSQL
exec postgres
