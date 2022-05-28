#sshhosts=viya.aws.com
 sshhosts=/workspace/viya/admin/sshhosts

 hosts=`cat ${sshhosts} | tr '\n' ' '`
 for hst in ${hosts}; do ssh ${hst} "
         sudo yum remove -y sas-*
 	sudo yum remove -y httpd
 	sudo yum groups mark remove 'sas-yg*'
         sudo rm -rf /etc/sysconfig/sas
         sudo rm -rf /opt/sas/*
         sudo rm -rf /tmp/*
         sudo yum erase -y mod_ssl
         sudo rm -f /etc/pki/tls/private/localhost.key
         sudo rm -f /etc/pki/tls/certs/localhost.crt
 "; done
