#!/bin/bash

read -r -d '' BBODY <<-CONFIG
{
	"username": "demouser@cmbu.local",
	"password": "demoVMware1!",
	"domain": {
		"domain_type": "LOCAL"
	}
}
CONFIG
read -r -d '' BODY <<-CONFIG
{
	"username": "aobersnel@vmware.com",
	"password": "WanObi323#@#",
	"domain": {
		"domain_type": "LDAP",
		"value": "vmware.com"
	}
}
CONFIG

URL='https://field-demo.vrni.cmbu.local/api/ni/auth/token'

RESPONSE=$(curl -k -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' \
	-d "${BODY}" \
"${URL}" 2>/dev/null)

printf "${RESPONSE}" | jq --tab . 1>&2
printf "${RESPONSE}" | jq -r '.token' > vrni.token.txt
