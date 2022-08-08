#!/bin/bash

# Assumes you have sudo or root access.
# Recommended to restart svi-sand afterwards.

function _f_reinit_od()
{
  cd /opt/sas/viya/home/libexec/elasticsearch-secure/plugins/opendistro_security/tools
  sudo ./securityadmin.sh \
    -ts /opt/sas/viya/config/etc/elasticsearch/default/certs/opendistro/trustedcerts.jks -tspass changeit \
    -ks /opt/sas/viya/config/etc/elasticsearch/default/keys/opendistro/opendistro-key-sgadmin.jks -kspass changeit -cd \
    ../securityconfig -nhnv -icl
}

_f_reinit_od

# Confirmation

# curl --request GET \
#   --cacert /opt/sas/viya/config/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.pem \
#   --key /opt/sas/viya/config/etc/elasticsearch/default/keys/opendistro/opendistrohealthcheck-key.pem \
#   --cert /opt/sas/viya/config/etc/elasticsearch/default/certs/opendistro/opendistrohealthcheck-cert.pem \
#   http://[[hostname]]:9200/_opendistro/_security/api/actiongroups/SANDSEARCH
