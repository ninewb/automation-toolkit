

export CUR_USER=$(whoami)
if [ "${CUR_USER}" != 'root' ]
then
  echo 
  echo ERROR: This script must be ran as the root user!
  exit 1
fi

# Need these in the event your LDAP and/or SASL library does not support GSS-SPNEGO

dnf -y install cyrus-sasl cyrus-sasl-gssapi

