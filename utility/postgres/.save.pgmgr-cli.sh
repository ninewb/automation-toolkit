#!/bin/sh

function main__HELP()
{
  echo "
------------------------------------------------------------------------------------------------
SAS INSITIUTE INC. - POSTGRESQL MANAGER COMMAND LINE INTERFACE | v1.0.05272022

  This program was developed by SAS Professional Services and is an alterantive for customer
  PostgreSQL synchronizing across two or more environments. This program comes with limited
  or no support as it was delivered to suppliment a use-case not covered by product.

  This program has two primary uses:
      - Backup an existing database
          - Creates a custom dump file in the designated backup directory
      - Restore from a previous backup
          - Creates a 

Usage:
  pgmgr-cli [options]

Options:
  -b, --database         Database your taking action on (required always)
  -d, --dump             Uses pg_dump to snapshot the database
  -r, --restore          Uses pg_restore on designated database
  -s, --restore-file     Dump file to restore to (required with -r)
  -l, --list-backup      Show the last 10 backups
  -h, --help             This small usage guide

Description:
  This script is used to backup or restore a postgresql database within a Viya 3.5 deployment.

------------------------------------------------------------------------------------------------
"
  exit 0
}

function main__SPEC()
{
  echo "
  For more information, type: "${0##*/}" -h
  "
  exit 0
}

#################################################################################################
## Set Artifact Locations
#################################################################################################

export ROOTLOC=$(pwd)
export DT=$(date +"%Y-%m-%d-%H-%M-%S")

# Log Location
export LOGLOC=${ROOTLOC}/log

# All Postgres Backups
export BACKUPLOC=${ROOTLOC}/backup

# Temporary Backup Location
export BTMPLOC=${ROOTLOC}/btmp

#################################################################################################
## Set Environment
#################################################################################################

export PGROOT=/opt/sas/viya/home/postgresql11
export PATH=${PGROOT}/bin:$PATH
export LD_LIBRARY_PATH=${PGROOT}/lib:$LD_LIBRARY_PATH

#################################################################################################
## MAIN ROOT
#################################################################################################

function main()
{
  local -xgr program="$(readlink -f "${BASH_SOURCE[0]}")"
  local -r OPTIONS=$(getopt -o b:s:drlh -l "database:,restore-file:,dump,restore,list-backup,help" -n "${FUNCNAME[0]}" -- "$@") || return
  eval set -- "$OPTIONS"

  PGDATABASE=
  RESTOREFILE=
  STATE=
  RS=
  while true ; do
    case "$1" in
      -b|--database)          PGDATABASE="$2"; shift 2;;
      -s|--restore-file)      RESTOREFILE="$2"; shift 2;;
      -d|--dump)              STATE=f_dumpdb; shift;;
      -r|--restore)           RS=1;STATE=f_restoredb; shift;;
      -l|--list-backup)       STATE=f_listbu; shift;;
      -h|--help)              main__HELP; shift;;
      --)                     shift; break;;
      *)                      shift; break;;
    esac
  done

  # Verify Flags
  [[ -n ${PGDATABASE} ]] || { echo "  ABORTED: Database must be specified. "; main__SPEC; return 1; }
  [[ -n ${STATE} ]] || { echo "  ABORTED: Must perform a database dump or restore."; return 1; }
  if [ "${RS}" == 1 ]
  then
    [[ -n ${RESTOREFILE} ]] || { echo "  ABORTED: WHen performing a restore, a restore file must be specified."; return 1; }
  fi

${STATE}
}

function f_valroot
{
E_NOTROOT=87
if ! $(sudo -l &> /dev/null); then
  echo "  ABORTED: root privileges are needed to run this script."
  exit $E_NOTROOT
fi
}

function f_list
{
  echo "
  These are a listign of the last 10 backups in ${BACKUPLOC}
  "
  ls -ltr ${BACKUPLOC}
  exit 0
}

function f_consul
{
if [ -d /opt/sas/viya ]
then
  source /opt/sas/viya/config/consul.conf
  export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)
  export PGUSER=dbmsowner
  export PGHOST=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_hostname0)
  export PGPORT=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/postgres/sas.dataserver.pool/common/backend_port0)
  export PGPASSWORD=$(/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/application/sas/database/postgres/password)
else
  echo "  ABORTED: Viya doesn't look to be installed."
fi
}

function f_remschema 
{
  SNAPFILE=ContengencyBackup_${DT}.dump
  pg_dump -U dbmsowner -Fc -x --clean --if-exists ${PGDATABASE} > ${BTMPLOC}/${SNAPFILE}
  echo "  INFO: A contengency backup was performed: ${BTMPLOC}/${SNAPFILE}"
  SNAPFILE=remschema_${DT}.log
  psql -h ${PGHOST} -p ${PGPORT} -U ${PGUSER} ${PGDATABASE} < ${ROOTLOC}/remschema.sql 2> ${LOGLOC}/${SNAPFILE}
  echo "  INFO: Necessary schemas have been dropped from the database."
}

function f_dumpdb 
{
  f_valroot;
  f_consul;

  SNAPFILE=PostgresBackup_${DT}.dump
  pg_dump -U dbmsowner -Fc -x --clean --if-exists ${PGDATABASE} > ${BACKUPLOC}/${SNAPFILE}
}

function f_restoredb 
{
  f_valroot;
  f_consul;

  SNAPFILE=ContengencyBackup_${DT}.dump
  pg_dump -U dbmsowner -Fc -x --clean --if-exists ${PGDATABASE} > ${BTMPLOC}/${SNAPFILE}
  echo "  INFO: A contengency backup was performed: ${BTMPLOC}/${SNAPFILE}"

  SNAPFILE=remschema_${DT}.log
  if [[ -f "${ROOTLOC}/remschema.sql" ]]
  then
    psql -h ${PGHOST} -p ${PGPORT} -U ${PGUSER} ${PGDATABASE} < ${ROOTLOC}/remschema.sql > ${LOGLOC}/${SNAPFILE} 2>&1
    echo "  INFO: Necessary schemas have been dropped from the database."
  else
    echo "  ABORT: The remschema.sql file is missing."
    exit 1
  fi

  RESTORE_PATH=${BACKUPLOC}/${RESTOREFILE} 
  if [[ ! -f "${RESTORE_PATH}" ]]
  then
    echo "  ABORTED: Restore file is invalid."
  fi

  SNAPFILE=PostgresRestore_${DT}.log
  pg_restore -v -Fc -d ${PGDATABASE} ${BACKUPLOC}/${RESTOREFILE} -c --if-exists -U dbmsowner 2> ${LOGLOC}/${SNAPFILE}
}

function f_astart 
{
    ansible all -m shell -a 'sudo systemctl start sas-viya-consul-default'
    ansible all -m shell -a 'sudo systemctl start sas-viya-vault-default'
    ansible all -m shell -a 'sudo systemctl start sas-viya-rabbitmq-server-default'
    ansible all -m shell -a 'sudo systemctl start sas-viya-sasdatasvrc-postgres-node0'
    ansible all -m shell -a 'sudo systemctl start  sas-viya-sasdatasvrc-postgres-pgpool0'
}

main "$@"
