source /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)

export REGHOST=$(hostname -f)
export REGCERT=/opt/sas/viya/config/etc/SASSecurityCertificateFramework/cacerts/trustedcerts.pem

export REGUSER=azure
export REGPW=secret


export BEARER_TOKEN="eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHBzOi8vbG9jYWxob3N0L1NBU0xvZ29uL3Rva2VuX2tleXMiLCJraWQiOiJsZWdhY3ktdG9rZW4ta2V5IiwidHlwIjoiSldUIn0.eyJqdGkiOiIxZmI5ZTA5MjM3ODQ0NWZkODdhMjMwMjAwNTVjODIyOCIsInN1YiI6InNhcy5hZG1pbiIsImF1dGhvcml0aWVzIjpbImNsaWVudHMucmVhZCIsImNsaWVudHMuc2VjcmV0IiwidWFhLnJlc291cmNlIiwiY2xpZW50cy53cml0ZSIsInVhYS5hZG1pbiIsImNsaWVudHMuYWRtaW4iLCJzY2ltLndyaXRlIiwic2NpbS5yZWFkIl0sInNjb3BlIjpbInVhYS5hZG1pbiJdLCJjbGllbnRfaWQiOiJzYXMuYWRtaW4iLCJjaWQiOiJzYXMuYWRtaW4iLCJhenAiOiJzYXMuYWRtaW4iLCJncmFudF90eXBlIjoiY2xpZW50X2NyZWRlbnRpYWxzIiwicmV2X3NpZyI6ImM3NjM5NmRmIiwiaWF0IjoxNjM2OTkzMjM2LCJleHAiOjE2MzcwMjkyMzYsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3QvU0FTTG9nb24vb2F1dGgvdG9rZW4iLCJ6aWQiOiJ1YWEiLCJhdWQiOlsic2FzLioiLCJ1YWEiLCJzYXMuYWRtaW4iXX0.YnkZel9WbK79qTWy3odz2hUG23D8t4TjSqpvzTwNZP_-kOOaolPOP6Kk-I742ncSWlBWhwd_y16Evx-_xMm8dvE5YcnVXhLIsPPI6_7mz_GbAnyF_EpxqZlokZ7LZ-OUU46_pSUmd4VVowU9Ad2FVKOZsuL-oRezVm7xPubBB1xYBBXFapfRJHkNyWMXn1wg7OvghU_JDS75RLOTeFe_aHfbVyrvpuRScN6vExSH5GW6G_QzhUd4W4ekugT936AAYBKzL2BD2tI-xXvWEkqeEuMGB9-o7Nv85O-AEyEw7FKR1-0eJKzG270HEcQLghsQLQKhF_EUFYyof0pBm6y8RQ"

curl -X POST https://${REGHOST}/SASLogon/oauth/clients \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $BEARER_TOKEN" \
     -d '{ "client_id": "${REGUSER}",
           "client_secret": "${REGPW}",
           "scope": ["openid", "*"],
           "resource_ids": "none",
           "authorities": ["uaa.none"],
           "access_token_validity": 473040000,
           "authorized_grant_types": ["client_credentials"] }'


curl -k https:/${REGHOST}/SASLogon/oauth/token \ 
     -H "Content-Type: application/x-www-form-urlencoded" \ 
     -d "grant_type=client_credentials" \ 
     -u "${REGUER}:${REGPW}"
