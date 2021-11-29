
export host=psfc.unx.sas.com
export cacert=/opt/sas/viya/config/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.pem
export key=/opt/sas/viya/config/etc/elasticsearch/default/keys/searchguard/sgadminkey.pem
export cert=/opt/sas/viya/config/etc/elasticsearch/default/certs/searchguard/sgadmincert.pem

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
