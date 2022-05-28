#!/bin/sh

# Designate the backup location and file
# e.g. /tmp/backup_file.sql
export BACKUP_FILE=/tmp/tenant1.dump

# Database you want to backup
# e.g. SharedServices or [tenant] for a given tenant if setup with database per tenant on deployment
export PGDATABASE=tenant1

export PGPATH=/opt/sas/viya/home/postgresql11/bin/
export PATH=/opt/sas/viya/home/bin:${PGPATH}:$PATH
source /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)

export PGUSER=dbmsowner
export PGHOST=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_hostname0)
export PGPORT=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_port0)
export PGPASS=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/application/sas/database/postgres/password)

echo "Database Password: ${PGPASS}"

pg_dump -U dbmsowner -Fc -x --clean --if-exists ${PGDATABASE} > ${BACKUP_FILE}

if [ $? != 0 ]
then
  echo "Execution failed: $1"
else
  echo "File has been backed up successfully: ${BACKUP_FILE}"
fi

