#!/bin/sh

export VIP=$(ip addr show eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}')
export S_SERVERNAME=$(hostname -s)
export L_SERVERNAME=${S_SERVERNAME}.${UC_DOMAIN}
export LDAPHOST=ldap.${UC_DOMAIN}

# For multi-tenancy, currently i am focused on one tenant, can build a list and concatenate to build the hosts in the future.
export CUSTOM_NAMES=tenant1.${L_SERVERNAME}

echo "${VIP} ${L_SERVERNAME} ${S_SERVERNAME} ${CUSTOM_NAMES} ${LDAPHOST}" | sudo tee -a /etc/hosts 1>&2
sudo hostnamectl set-hostname ${L_SERVERNAME}
