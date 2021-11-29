
export host=$(hostname -f)
export vbase=/opt/sas/viya/config
export cacert=${vbase}/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.pem

# Lower than VI 10.8

if [ -d /etc/elasticsearch/default/keys/searchguard ]; then
  export key=${vbase}/etc/elasticsearch/default/keys/searchguard/sgadminkey.pem
  export cert=${vbase}/etc/elasticsearch/default/certs/searchguard/sgadmincert.pem
fi

# VI 10.8+

if [ -d ${vbase}/etc/elasticsearch/default/certs/opendistro ]; then
  export cert=${vbase}/etc/elasticsearch/default/certs/opendistro/opendistrohealthcheck-cert.pem
  export key=${vbase}/etc/elasticsearch/default/keys/opendistro/opendistrohealthcheck-key.pem
fi

sudo curl \
  --cacert ${cacert} \
  --key ${key} \
  --cert ${cert} \
  https://${host}:9200/

sudo curl \
  --cacert ${cacert} \
  --key ${key} \
  --cert ${cert} \
  https://${host}:9200/_cat/plugins
