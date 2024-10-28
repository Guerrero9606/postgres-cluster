FROM postgres:15

# Instalacion de pg_autofailover
RUN apt-get update && \
    apt-get install -y pg-auto-failover-cli postgresql-contrib && \
    apt-get install -y postgresql-15-auto-failover && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar el script para crear el rol replicator
COPY ./scripts/init-replicator-role.sh /docker-entrypoint-initdb.d/init-replicator-role.sh

# Asegurarse de que el script tenga permisos de ejecución
RUN chmod +x /docker-entrypoint-initdb.d/init-replicator-role.sh

RUN mkdir -p /var/lib/postgresql/data/node1 && \
    chown -R postgres:postgres /var/lib/postgresql/data && \
    chmod -R 700 /var/lib/postgresql/data

USER postgres
