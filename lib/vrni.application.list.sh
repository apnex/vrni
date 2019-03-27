#!/bin/bash

TOKEN=$(cat vrni.token.txt)
URL='https://10.196.164.25/api/ni/groups/applications?size=10'

RESPONSE=$(curl -k -X GET --header 'Accept: application/json' \
	--header "Authorization: NetworkInsight ${TOKEN}" \
"${URL}" 2>/dev/null)

printf "${RESPONSE}" | jq --tab .

APPID=$(printf "${RESPONSE}" | jq -r '.results[0].entity_id')

#printf "${APPID}"
