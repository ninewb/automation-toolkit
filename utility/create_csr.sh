
export srvname=psfc_unx_sas_com
export dname=CN=psfc.unx.sas.com,OU=US Professional Services, O=SAS Institute Inc., L=Cary, ST=NC, C=US

keytool -genkey -alias server -keyalg RSA -keysize 2048 \
  -keystore ${srvname}.jks \
  -dname "${dname}"

keytool -certreq -alias server -file ${srvname}.csr \
  -keystore ${srvname}.jks 

echo Your certificate signing request is in psfc_unx_sas_com.csr.  Your keystore file is psfc_unx_sas_com.jks.  Thanks for using the DigiCert keytool CSR helper.
