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

curl -sk -b "./vrni.cookies" -D "./vrni.headers" -X GET \
-H "Origin: https://10.221.81.189" \
-H "Content-Type: application/json" \
-H "x-vrni-csrf-token: ${TOKEN}" \
'https://10.221.81.189/api/model/properties?objectType=515'
