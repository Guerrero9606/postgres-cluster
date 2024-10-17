FROM postgres:15

# Copiar el script de replicación
COPY ./scripts/replica-entrypoint.sh /docker-entrypoint-initdb.d/replica-entrypoint.sh

# Asignar permisos de ejecución al script
RUN chmod +x /docker-entrypoint-initdb.d/replica-entrypoint.sh

RUN chown -R postgres:postgres /var/lib/postgresql/data
RUN chmod 0700 /var/lib/postgresql/data
# Establecer el usuario no privilegiado
USER postgres
