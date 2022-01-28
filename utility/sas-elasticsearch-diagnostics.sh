#!/bin/sh

# For Visual Investigator 10.8

. ../profile/.profile

export LOGOUT=SAS_ElasticSearch_Diagnostics_${LOGDATE}.out

export ca_cert=/opt/sas/viya/config/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.pem
export cert_file=/opt/sas/viya/config/etc/elasticsearch/default/certs/opendistro/opendistrohealthcheck-cert.pem
export key_file=/opt/sas/viya/config/etc/elasticsearch/default/keys/opendistro/opendistrohealthcheck-key.pem

###########################################################################################
# /_cluster/health
# Provides an overview of the health of the Elasticsearch cluster and information
# about the architecture like the number of data nodes
###########################################################################################

echo -e "------ Processing /_cluster/health ------\n\n" > ${LOGDIR}/${LOGOUT}
curl --cacert ${ca_cert} --key ${key_file} --cert ${cert_file} \
     https://localhost:9200/_cluster/health | jq '.' >> ${LOGDIR}/${LOGOUT}
echo -e "\n\n" >> ${LOGDIR}/${LOGOUT}

###########################################################################################
# /_cat/indices?s=index&v
# Provides a list of the indices and their size (which is useful for determining 
# whether the number of primary shards is appropriate for the size of the index)
###########################################################################################

echo -e "------ Processing /_cat/indices?s=index&v ------\n\n" >> ${LOGDIR}/${LOGOUT}
curl --cacert ${ca_cert} --key ${key_file} --cert ${cert_file} \
     https://localhost:9200/_cat/indices?s=index&v >> ${LOGDIR}/${LOGOUT}
echo -e "\n\n" >> ${LOGDIR}/${LOGOUT}

###########################################################################################
# /_cat/shards?s=index&v 
# Provides a more detailed view on the shard distribution for indices
###########################################################################################

echo -e "------ Processing /_cat/shards?s=index&v ------\n\n" >> ${LOGDIR}/${LOGOUT}
curl --cacert ${ca_cert} --key ${key_file} --cert ${cert_file} \
     https://localhost:9200/_cat/shards?s=index&v >> ${LOGDIR}/${LOGOUT}
echo -e "\n\n" >> ${LOGDIR}/${LOGOUT}

###########################################################################################
# /_cat/nodes?v 
# For a summary of key node details
###########################################################################################

echo -e "------ Processing /_cat/nodes?v ------\n\n" >> ${LOGDIR}/${LOGOUT}
curl --cacert ${ca_cert} --key ${key_file} --cert ${cert_file} \
     https://localhost:9200/_cat/nodes?v >> ${LOGDIR}/${LOGOUT}
echo -e "\n\n" >> ${LOGDIR}/${LOGOUT}

###########################################################################################
#/_nodes/stats 
# Provides more detailed resource usage statistics for each of the nodes 
# e.g. heap and thread pool usage
###########################################################################################

echo -e "------ Processing /_nodes/stats ------\n\n" >> ${LOGDIR}/${LOGOUT}
curl --cacert ${ca_cert} --key ${key_file} --cert ${cert_file} \
     https://localhost:9200/_nodes/stats >> ${LOGDIR}/${LOGOUT}
echo -e "\n\n" >> ${LOGDIR}/${LOGOUT}

###########################################################################################
# /_nodes/stats/jvm,thread_pool?human
# To focus on specific areas
###########################################################################################

echo -e "------ Processing /_nodes/stats/jvm,thread_pool?human ------\n\n" >> ${LOGDIR}/${LOGOUT}
curl --cacert ${ca_cert} --key ${key_file} --cert ${cert_file} \
     https://localhost:9200/_nodes/stats/jvm,thread_pool?human | jq '.' >> ${LOGDIR}/${LOGOUT}
echo -e "\n\n" >> ${LOGDIR}/${LOGOUT}


