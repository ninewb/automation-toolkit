#!/bin/bash

# if/else for Viya versions
# Connect to Database
# Backup Schema
# Backup entire database

source /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)
export PGUSER=dbmsowner
export PGHOST=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_hostname0)
export PGPORT=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_port0)
export PGPASSWORD=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/application/sas/database/postgres/password)

export PGDMPROOT=/tmp
#export PGDATABASE=SharedServices
export PGDATABASE=tenant1
export PGSCHEMA=cddprep

# Viya 3.5

export PGSQLROOT=/opt/sas/viya/home/postgresql11/bin
export PGSQLEXEC=${PGSQLROOT}/psql
export PGDUMPEXEC=${PGSQLROOT}/pg_dump

# Viya 3.4
# export PGSQLEXEC=/opt/sas/viya/home/bin/psql
# export PGDUMPEXEC=

# Connect to DB

#${PGSQLEXEC} -h ${PGHOST} -p ${PGPORT} -U ${PGUSER} ${PGDATABASE}

