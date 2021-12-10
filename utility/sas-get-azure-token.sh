export REGHOST=$(hostname -f)
export REGCERT=/opt/sas/viya/config/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.pem
export REGUSER=azure:secret

curl https://${REGHOST}/SASLogon/oauth/token \
	  --cacert ${REGCERT} \
          -H "Content-Type: application/x-www-form-urlencoded" \
          -d "grant_type=client_credentials" \
          -u "${REGUSER}"
