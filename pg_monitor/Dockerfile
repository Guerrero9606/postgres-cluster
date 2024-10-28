# Usa la imagen base de PostgreSQL 15
FROM postgres:15

# Instalacion de pg_autofailover
RUN apt-get update && \
    apt-get install -y pg-auto-failover-cli postgresql-contrib && \
    apt-get install -y postgresql-15-auto-failover && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copiar el script para crear el rol replicator
COPY ./scripts/init.sh /usr/local/bin/init.sh

# Asegurarse de que el script tenga permisos de ejecución
RUN chmod +x /usr/local/bin/init.sh

RUN chown -R postgres:postgres /var/lib/postgresql/data
RUN chmod 777 /var/lib/postgresql/data

# Bypass initdb de un clúster "main"
RUN echo 'create_main_cluster = false' > /etc/postgresql-common/createcluster.conf

# Ejecuta PostgreSQL y el script en segundo plano
# CMD ["sh", "-c", "/usr/local/bin/init-monitor.sh"]

USER postgres

# Ejecuta initdb para inicializar el directorio de datos
#RUN /usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/data
