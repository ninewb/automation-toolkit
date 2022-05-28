#!/bin/sh

# Designate the backup location and file
# e.g. /tmp/backup_file.sql
export BACKUP_FILE=/tmp/file.sql

# Database you want to backup
# e.g. SharedServices or [tenant] for a given tenant if setup with database per tenant on deployment
export PGDATABASE=dev

export PATH=/opt/sas/viya/home/bin:$PATH
source /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)

export PGUSER=dbmsowner
export PGHOST=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_hostname0)
export PGPORT=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_port0)
export PGPASS=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/application/sas/database/postgres/password)

pg_dump -U dbmsowner -Ft -x ${PGDATABASE} > ${BACKUP_FILE}

