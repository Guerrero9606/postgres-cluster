FROM postgres:15

# Instala pg_autoctl y otras dependencias necesarias
RUN apt-get update && \
    apt-get install -y postgresql-auto-failover-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar el script para crear el rol replicator
COPY ./scripts/init-replicator-role.sh /docker-entrypoint-initdb.d/init-replicator-role.sh

# Asegurarse de que el script tenga permisos de ejecución
RUN chmod +x /docker-entrypoint-initdb.d/init-replicator-role.sh

RUN chown -R postgres:postgres /var/lib/postgresql/data
RUN chmod 0700 /var/lib/postgresql/data
