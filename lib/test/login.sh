#!/bin/bash

STATEDIR="./drv"
TOKEN=$(curl -k -X POST \
  -c "${STATEDIR}/vrni.cookies.txt" \
  https://field-demo.vrni.cmbu.local/api/auth/login \
  -H 'accept: application/json' \
  -H 'content-type: application/json' \
  -d '{"username":"demouser@cmbu.local","password":"demoVMware1!","tenantName":"field-demo.vrni.cmbu.local","vIDMURL":"","redirectURL":"","authenticationDomains":{"0":{"domainType":"LDAP","domain":"vmware.com","redirectUrl":""},"1":{"domainType":"LOCAL_DOMAIN","domain":"localdomain","redirectUrl":""}},"currentDomain":1,"domain":"localdomain","nDomains":2,"serverTimestamp":false,"loginFieldPlaceHolder":"Username"}' \
2>/dev/null | jq -r '.csrfToken')

printf '%s' "${TOKEN}" >${STATEDIR}/vrni.token.txt
printf '%s\n' "${TOKEN}" 1>&2

#{"username":"demouser@cmbu.local","password":"demoVMware1!","tenantName":"field-demo.vrni.cmbu.local","vIDMURL":"","redirectURL":"","authenticationDomains":{"0":{"domainType":"LDAP","domain":"vmware.com","redirectUrl":""},"1":{"domainType":"LOCAL_DOMAIN","domain":"localdomain","redirectUrl":""}},"currentDomain":1,"domain":"localdomain","nDomains":2,"serverTimestamp":false,"loginFieldPlaceHolder":"Username"}
