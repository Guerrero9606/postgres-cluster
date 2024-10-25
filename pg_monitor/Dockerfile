# Usa la imagen base de PostgreSQL 15
FROM postgres:15

# Instala las dependencias necesarias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    lsb-release \
    gnupg2 && \
    rm -rf /var/lib/apt/lists/*

# Bypass initdb de un clúster "main"
RUN echo 'create_main_cluster = false' > /etc/postgresql-common/createcluster.conf

# Instala PostgreSQL 15 y pg_auto_failover
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    pg-auto-failover-cli \
    postgresql-15-auto-failover && \
    rm -rf /var/lib/apt/lists/*

# Cambiar permisos del directorio de datos
RUN mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql/data && \
    chmod 700 /var/lib/postgresql/data

# Establecer el usuario de PostgreSQL
USER postgres

# Comando por defecto para ejecutar el monitor
#CMD ["pg_autoctl", "monitor"]

