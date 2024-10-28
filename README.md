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
├── config
│   ├── master
│   │   ├── pg_hba.conf
│   │   └── postgresql.conf
│   ├── monitor
│   │   ├── pg_hba.conf
│   │   └── postgresql.conf
│   └── replica
│       ├── pg_hba.conf
│       └── postgresql.conf
├── docker-compose.yml
├── master
│   ├── Dockerfile
│   └── scripts
│       └── init-replicator-role.sh
├── pg_monitor
│   ├── Dockerfile
│   └── scripts
│       └── init.sh
├── prometheus
│   └── prometheus.yml
├── README.md
└── replica
    ├── Dockerfile
    └── scripts
        └── replica-entrypoint.sh
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

## Persistencia de Datos

Los datos se almacenan de manera persistente en volúmenes Docker, lo que garantiza que no se perderán si los contenedores se detienen o se reinician.

La persistencia en Prometheus y Grafana aun no esta configurada.

## Notas Finales

Asegúrate de que el archivo `pg_hba.conf` del maestro permite conexiones de replicación desde la dirección IP de la réplica. También revisa que los puertos estén configurados correctamente para evitar problemas de conexión.

