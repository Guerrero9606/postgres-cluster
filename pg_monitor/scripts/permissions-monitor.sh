#!/bin/bash

# Cambiar permisos
chown -R postgres:postgres /var/lib/postgresql/data
chmod 0750 /var/lib/postgresql/data

pg_autoctl create monitor --pgdata /var/lib/postgresql/data --auth trust --ssl-self-signed --pgport 5432 --run

#Inicializar postgres
exec postgres
