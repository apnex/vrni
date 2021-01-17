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
#echo "${CSRF}"

#curl -k -b "./vrni.cookies" -D "./vrni.headers" -X POST \
#-H "Origin: https://10.221.81.189" \
#-H "Content-Type: application/x-www-form-urlencoded" \
#--data-urlencode 'csvFields=name,port.display,port.ianaName,flow.totalBytes.delta.summation.bytes,protocol,srcVm,srcCluster,srcHost,srcIP.ipAddress,dstVm,dstCluster,dstHost,dstIP.ipAddress' \
#--data-urlencode 'dateTimeZone=+11:00' \
#--data-urlencode 'maxItemCount=356' \
#--data-urlencode 'searchString=flows' \
#--data-urlencode 'sourceString=USER' \
#--data-urlencode 'timeRangeString= at Now ' \
#--data-urlencode 'timestamp=1603843857221' \
#--data-urlencode "${CSRF}" \
#'https://10.221.81.189/api/search/csv'

curl -k -b "./vrni.cookies" -D "./vrni.headers" -X GET \
-H "Origin: https://10.221.81.189" \
-H "Content-Type: application/json" \
-H "x-vrni-csrf-token: ${TOKEN}" \
'https://10.221.81.189/api/auth/csvTemplate?scope=GLOBAL&entityType=515'
