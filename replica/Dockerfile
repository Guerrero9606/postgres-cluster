FROM postgres:15

# Instalacion de pg_autofailover
RUN apt-get update && \
    apt-get install -y pg-auto-failover-cli postgresql-contrib && \
    apt-get install -y postgresql-15-auto-failover && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar el script de replicación
COPY ./scripts/replica-entrypoint.sh /docker-entrypoint-initdb.d/replica-entrypoint.sh

# Asignar permisos de ejecución al script
RUN chmod +x /docker-entrypoint-initdb.d/replica-entrypoint.sh

RUN mkdir -p /var/lib/postgresql/data/node2 && \
    chown -R postgres:postgres /var/lib/postgresql/data && \
    chmod -R 700 /var/lib/postgresql/data

# Establecer el usuario no privilegiado
USER postgres
