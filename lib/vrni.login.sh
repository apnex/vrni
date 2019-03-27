#!/bin/bash

read -r -d '' BODY <<-CONFIG
{
	"username": "demouser@cmbu.local",
	"password": "demoVMware1!",
	"domain": {
		"domain_type": "LOCAL"
	}
}
CONFIG

URL='https://10.196.164.25/api/ni/auth/token'
#printf "${BODY}" | jq --tab .
#printf "${URL}"
#echo

RESPONSE=$(curl -k -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' \
	-d "${BODY}" \
"${URL}" 2>/dev/null)

printf "${RESPONSE}" | jq --tab . 1>&2
printf "${RESPONSE}" | jq -r '.token' > vrni.token.txt
