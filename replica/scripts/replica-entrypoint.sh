#!/bin/bash

# Esperar a que el master esté listo
until pg_isready -h 172.18.0.2 -p 5432 -U postgres; do
  echo "Esperando a que el servidor maestro esté disponible..."
  sleep 2
done

# Eliminar datos existentes en la réplica
#rm -rf /var/lib/postgresql/data/*

#pg_ctl stop -D /var/lib/postgresql/data

# Ejecutar pg_basebackup para copiar datos desde el maestro
#PGPASSWORD=$POSTGRES_REPLICATION_PASSWORD pg_basebackup -h 172.18.0.2 -D /var/lib/postgresql/data -U $POSTGRES_REPLICATION_USER -v -P --wal-method=stream

# Crear archivo recovery.conf en PostgreSQL 15 (sin recovery.conf)
#cat > /var/lib/postgresql/data/postgresql.auto.conf <<EOF
#primary_conninfo = 'host=172.18.0.2 port=5432 user=$POSTGRES_REPLICATION_USER password=$POSTGRES_REPLICATION_PASSWORD sslmode=prefer'
#EOF

# Cambiar permisos
#chown -R postgres:postgres /var/lib/postgresql/data
#touch /var/lib/postgresql/data/standby.signal

# Iniciar PostgreSQL en modo réplica
#exec postgres

postgres -c hba_file=/etc/postgresql/pg_hba.conf -c config_file=/etc/postgresql/postgresql.conf

#pg_ctl stop -D /var/lib/postgresql/data
