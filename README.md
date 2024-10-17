# PostgreSQL Cluster con Docker

Este proyecto configura un clúster de PostgreSQL con replicación utilizando Docker y Docker Compose. A continuación se documentan los pasos necesarios para ejecutar el clúster, así como la estructura del proyecto y las versiones de las herramientas utilizadas.

## Requisitos

Antes de ejecutar el proyecto, asegúrate de tener instaladas las siguientes herramientas:

- **Docker**: 24.0.5
- **Docker Compose**: v2.20.3
- **Git**: 2.43.0
- **PostgreSQL**: 15

## Estructura del Proyecto

```plaintext
project-directory/
│
├── docker-compose.yml
├── master/
│   ├── Dockerfile
│   └── scripts/
│       └── init-replicator-role.sh
│
├── replica/
│   ├── Dockerfile
│   └── scripts/
│       └── replica-entrypoint.sh
│
├── config/
│   ├── master/
│   │   ├── postgresql.conf
│   │   └── pg_hba.conf
│   └── replica/
│       ├── postgresql.conf
│       └── pg_hba.conf
```

## Creación de la Red

Antes de ejecutar `docker-compose`, se debe crear la red en Docker para el clúster. Ejecuta el siguiente comando:

```bash
docker network create --subnet=172.18.0.0/16 pg_network
```

## Ejecución del Proyecto

Para inicializar el clúster, utiliza uno de los siguientes comandos:

```bash
docker-compose up --build
```

o

```bash
docker-compose up -d
```

## Archivos de Configuración

Se copian varios archivos de configuración necesarios para el funcionamiento de PostgreSQL. Los scripts de inicialización son los siguientes:

### Master: `init-replicator-role.sh`

```bash
#!/bin/bash
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicatorpassword';
EOSQL
```

Este script se ejecuta al iniciar el contenedor maestro y crea un rol `replicator` con permisos de replicación.

### Replica: `replica-entrypoint.sh`

```bash
#!/bin/bash

# Esperar a que el master esté listo
until pg_isready -h master -p 5432 -U replicator; do
  echo "Esperando a que el servidor maestro esté disponible..."
  sleep 2
done

# Eliminar datos existentes en la réplica
rm -rf /var/lib/postgresql/data/*

# Ejecutar pg_basebackup para copiar datos desde el maestro
PGPASSWORD=$POSTGRES_REPLICATION_PASSWORD pg_basebackup -h 172.18.0.2 -D /var/lib/postgresql/data -U $POSTGRES_REPLICATION_USER -v -P --wal-method=stream

# Crear archivo recovery.conf en PostgreSQL 15 (sin recovery.conf)
cat > /var/lib/postgresql/data/postgresql.auto.conf <<EOF
primary_conninfo = 'host=172.18.0.2 port=5432 user=$POSTGRES_REPLICATION_USER password=$POSTGRES_REPLICATION_PASSWORD sslmode=prefer'
EOF

# Cambiar permisos
chown -R postgres:postgres /var/lib/postgresql/data
touch /var/lib/postgresql/data/standby.signal

# Iniciar PostgreSQL en modo réplica
exec postgres
```

Este script espera a que el servidor maestro esté disponible, elimina datos existentes en la réplica, y utiliza `pg_basebackup` para copiar datos del maestro. Luego crea el archivo de configuración necesario y arranca el servidor en modo réplica.

## Persistencia de Datos

Los datos se almacenan de manera persistente en volúmenes Docker, lo que garantiza que no se perderán si los contenedores se detienen o se reinician.

## Notas Finales

Asegúrate de que el archivo `pg_hba.conf` del maestro permite conexiones de replicación desde la dirección IP de la réplica. También revisa que los puertos estén configurados correctamente para evitar problemas de conexión.

