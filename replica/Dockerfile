FROM postgres:15

# Instala pg_autoctl y otras dependencias necesarias
RUN apt-get update && \
    apt-get install -y postgresql-auto-failover-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar el script de replicación
COPY ./scripts/replica-entrypoint.sh /docker-entrypoint-initdb.d/replica-entrypoint.sh

# Asignar permisos de ejecución al script
RUN chmod +x /docker-entrypoint-initdb.d/replica-entrypoint.sh

RUN chown -R postgres:postgres /var/lib/postgresql/data
RUN chmod 0700 /var/lib/postgresql/data
# Establecer el usuario no privilegiado
USER postgres
