#!/bin/sh

# Define your desired password.
export ORCLPW=
export RSPPATH=/path/to/response

# Check to make sure we are "oracle".

export CUR_USER=$(whoami)
if [ "${CUR_USER}" != 'oracle' ]
then
  echo
  echo ERROR: This script must be ran as the oracle user!
  echo ""
  echo E.g. sudo su - oracle
  exit 1
fi

# Instantiate environment.

echo "export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1
export PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export ORACLE_SID=orcl" >> ~/.bash_profile

source ~/.bash_profile

# Create Database

dbca -silent -createDatabase -responseFile ${RSPPATH}/db_create.rsp

lsnrctl start
