#!/bin/bash

#curl -k -X POST \
#	--header 'Content-Type: application/json' \
#	--header 'Accept: application/json' \
#	-d '{"username": "admin%40local", "password": "VMware1&#33;SDDC", "domain": { "domain_type": "LOCAL"}}' \
#"https://10.221.81.189/api/ni/auth/token"

RESPONSE=$(curl -s -k -X POST \
	--header 'Content-Type: application/json' \
	--header 'Accept: application/json' \
	-d '{"username": "admin@local", "password": "VMware1!SDDC", "domain": { "domain_type": "LOCAL"}}' \
"https://10.221.81.189/api/ni/auth/token")

TOKEN=$(echo ${RESPONSE} | jq -r '.token')

#	-H 'x-vrni-csrf-token: RW6X9sZkHvNM+rJLFlEpaQ==' \
curl -k -X GET \
	-H 'Accept: application/json' \
	-H "Authorization: NetworkInsight ${TOKEN}" \
"https://10.221.81.189/api/ni/data-sources/vcenters"


