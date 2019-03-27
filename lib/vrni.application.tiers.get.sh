#!/bin/bash

APPID="${1}"
TOKEN=$(cat vrni.token.txt)
URL="https://10.196.164.25/api/ni/groups/applications/${APPID}/tiers"

RESPONSE=$(curl -k -X GET --header 'Accept: application/json' \
	--header "Authorization: NetworkInsight ${TOKEN}" \
"${URL}" 2>/dev/null)

printf "${RESPONSE}" | jq --tab .
