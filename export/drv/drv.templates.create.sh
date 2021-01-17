#!/bin/bash

### login
MYAUTH=$(curl -s -k --location -c "./vrni.cookies" -D "./vrni.headers" -X POST 'https://10.221.81.189/api/auth/login' \
--header 'Accept: application/json, text/javascript, */*; q=0.01' \
--header 'DNT: 1' \
--header 'X-Requested-With: XMLHttpRequest' \
--header 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36' \
--header 'Content-Type: application/json' \
--data-raw '{"username":"admin@local","password":"VMware1!SDDC","tenantName":"10.221.81.189","vIDMURL":"","redirectURL":"","authenticationDomains":{"0":{"domainType":"LOCAL_DOMAIN","domain":"localdomain","redirectUrl":""}},"currentDomain":0,"domain":"localdomain","nDomains":1,"serverTimestamp":false,"loginFieldPlaceHolder":"Username"}')

## Apply CSRF Token
TOKEN=$(echo ${MYAUTH} | jq -r '.csrfToken')
CSRF="x-vrni-csrf-token=${TOKEN}"

read -r -d '' BODY <<-EOF
{
	"id": "",
	"name": "my-new-template",
	"entityType": "515",
	"scope":"GLOBAL",
	"templateProperties": [
		"Bytes Rate",
		"Bytes",
		"Global Destination Security Group",
		"Global Source Security Group",
		"Global Destination L2 Network",
		"Global Source L2 Network",
		"Port",
		"Destination IP Address",
		"Source IP Address",
		"Flow Type"
	]
}
EOF

curl -sk -b "./vrni.cookies" -D "./vrni.headers" -X POST \
	-H "x-vrni-csrf-token: ${TOKEN}" \
	-H 'Content-Type: application/json' \
	--data-raw "${BODY}" \
"https://10.221.81.189/api/auth/csvTemplate"
