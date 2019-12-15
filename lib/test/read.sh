#!/bin/bash

TOKEN=$(cat vrni.token.txt)
#curl -k --trace-ascii /dev/stdout -X GET \
curl -k -X GET \
  -b "vrni.cookies.txt" \
  'https://field-demo.vrni.cmbu.local/api/model/properties?objectType=1' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'cache-control: no-cache' \
  -H 'dnt: 1' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' \
  -H "x-vrni-csrf-token: $TOKEN"
