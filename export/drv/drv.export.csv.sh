#!/bin/bash

### credentials
#USERNAME='admin@local'
#PASSWORD='VMware1!SDDC'
#ENDPOINT='10.221.81.189'

USERNAME='aobersnel@vmware.com'
PASSWORD='WanObi212@!@'
ENDPOINT='field-demo.vrni.cmbu.org'

### AD body
read -r -d '' LDAP <<-EOF
{
	"username": "${USERNAME}",
	"password": "${PASSWORD}",
	"tenantName": "${ENDPOINT}",
	"vIDMURL":"",
	"redirectURL":"",
	"authenticationDomains":{
		"0":{
			"domainType": "LDAP",
			"domain": "vmware.com",
			"redirectUrl": ""
		},
		"1":{
			"domainType": "LOCAL_DOMAIN",
			"domain": "localdomain",
			"redirectUrl": ""
		}
	},
	"currentDomain": 0,
	"domain": "vmware.com",
	"nDomains": 2,
	"serverTimestamp": false,
	"loginFieldPlaceHolder": "Username"
}
EOF

### LOCAL body
read -r -d '' LOCAL <<-EOF
{
	"username": "${USERNAME}",
	"password": "${PASSWORD}",
	"tenantName": "${ENDPOINT}",
	"vIDMURL":"",
	"redirectURL":"",
	"authenticationDomains": {
		"0": {
			"domainType": "LOCAL_DOMAIN",
			"domain": "localdomain",
			"redirectUrl": ""
		}
	},
	"currentDomain": 0,
	"domain": "localdomain",
	"nDomains": 1,
	"serverTimestamp": false,
	"loginFieldPlaceHolder": "Username"
}
EOF
echo ${LOCAL} | jq --tab .

### Create AUTH Token
URL="https://${ENDPOINT}/api/auth/login"
MYAUTH=$(curl -s -k --location -c "./vrni.cookies" -D "./vrni.headers" -X POST \
	-H 'Content-Type: application/json' \
	--data-raw "${LDAP}" \
"${URL}")
TOKEN=$(echo ${MYAUTH} | jq -r '.csrfToken')

### Call CSV export method
URL="https://${ENDPOINT}/api/search/csv"
curl -k -b "./vrni.cookies" -D "./vrni.headers" -X POST \
	-H "Origin: https://${ENDPOINT}" \
	-H "Content-Type: application/x-www-form-urlencoded" \
	--data-urlencode "x-vrni-csrf-token=${TOKEN}" \
	--data-urlencode 'csvFields=name,port.display,port.ianaName,flow.totalBytes.delta.summation.bytes,protocol,srcVm,srcCluster,srcHost,srcIP.ipAddress,dstVm,dstCluster,dstHost,dstIP.ipAddress' \
	--data-urlencode 'maxItemCount=999999' \
	--data-urlencode 'searchString=flows' \
	--data-urlencode 'sourceString=USER' \
	--data-urlencode 'timeRangeString= at Now ' \
"${URL}"
