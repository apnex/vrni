#!/bin/bash

curl -k -X POST \
  -c "vrni.cookies.txt" \
  https://field-demo.vrni.cmbu.local/api/auth/login \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'dnt: 1' \
  -H 'origin: https://field-demo.vrni.cmbu.local' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' \
  -H 'x-vrni-csrf-token: RW6X9sZkHvNM+rJLFlEpaQ==' \
  -d '{"username":"demouser@cmbu.local","password":"demoVMware1!","tenantName":"field-demo.vrni.cmbu.local","vIDMURL":"","redirectURL":"","authenticationDomains":{"0":{"domainType":"LDAP","domain":"vmware.com","redirectUrl":""},"1":{"domainType":"LOCAL_DOMAIN","domain":"localdomain","redirectUrl":""}},"currentDomain":1,"domain":"localdomain","nDomains":2,"serverTimestamp":false,"loginFieldPlaceHolder":"Username"}'

#{"username":"demouser@cmbu.local","password":"demoVMware1!","tenantName":"field-demo.vrni.cmbu.local","vIDMURL":"","redirectURL":"","authenticationDomains":{"0":{"domainType":"LDAP","domain":"vmware.com","redirectUrl":""},"1":{"domainType":"LOCAL_DOMAIN","domain":"localdomain","redirectUrl":""}},"currentDomain":1,"domain":"localdomain","nDomains":2,"serverTimestamp":false,"loginFieldPlaceHolder":"Username"}
