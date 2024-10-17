#!/bin/bash

# Esperar a que el master esté listo
until pg_isready -h master -p 5432 -U replicator; do
  echo "Esperando a que el servidor maestro esté disponible..."
  sleep 2
done

# Eliminar datos existentes en la réplica
rm -rf /var/lib/postgresql/data/*

# Ejecutar pg_basebackup para copiar datos desde el maestro
PGPASSWORD=$POSTGRES_REPLICATION_PASSWORD pg_basebackup -h master -D /var/lib/postgresql/data -U $POSTGRES_REPLICATION_USER -v -P --wal-method=stream

# Crear archivo recovery.conf en PostgreSQL 15 (sin recovery.conf)
cat > /var/lib/postgresql/data/postgresql.auto.conf <<EOF
primary_conninfo = 'host=master port=5432 user=$POSTGRES_REPLICATION_USER password=$POSTGRES_REPLICATION_PASSWORD'
EOF

# Cambiar permisos
chown -R postgres:postgres /var/lib/postgresql/data

# Iniciar PostgreSQL en modo réplica
exec postgres
