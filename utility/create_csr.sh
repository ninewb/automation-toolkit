
export srvname=$(hostname -f)
export safename=$(tr '.' '_' <<<${srvname})
export dname=CN=${srvname},OU=US Professional Services, O=SAS Institute Inc., L=Cary, ST=NC, C=US

keytool -genkey -alias server -keyalg RSA -keysize 2048 \
  -keystore ${srvname}.jks \
  -dname "${dname}"

keytool -certreq -alias server -file ${srvname}.csr \
  -keystore ${srvname}.jks 

echo Your certificate signing request is in ${safename}.csr.  Your keystore file is ${safename}.jks.  Thanks for using the DigiCert keytool CSR helper.
