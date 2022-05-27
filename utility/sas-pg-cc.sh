#!/bin/bash

source /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)
export PGUSER=dbmsowner
export PGHOST=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_hostname0)
export PGPORT=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_port0)
export PGPASSWORD=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/application/sas/database/postgres/password)

export PGDMPROOT=/tmp
export PGDATABASE=SharedServices

# Viya 3.5

export PGSQLROOT=/opt/sas/viya/home/postgresql11/bin
export PGSQLEXEC=${PGSQLROOT}/psql
export PGDUMPEXEC=${PGSQLROOT}/pg_dump

# Connect to DB

${PGSQLEXEC} -h ${PGHOST} -p ${PGPORT} -U ${PGUSER} ${PGDATABASE} -c \
"SELECT con.*
       FROM pg_catalog.pg_constraint con
            INNER JOIN pg_catalog.pg_class rel
                       ON rel.oid = con.conrelid
            INNER JOIN pg_catalog.pg_namespace nsp
                       ON nsp.oid = connamespace
       WHERE nsp.nspname = 'maps'
             AND rel.relname = 'databasechangeloglock';"
