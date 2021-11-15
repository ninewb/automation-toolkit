
export REGHOST=sas-aml.azure.sas.com
export REGCERT=/opt/sas/viya/config/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.pem
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)

curl -k -X POST "https://${REGHOST}/SASLogon/oauth/clients/consul?callback=false&serviceId=app" -H "X-Consul-Token: $CONSUL_TOKEN"
