#!/bin/bash

TOKEN=$(cat vrni.token.txt)
curl -k -X GET \
  -b "vrni.cookies.txt" \
  'https://field-demo.vrni.cmbu.local/api/model/objectTypes?=' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H "x-vrni-csrf-token: $TOKEN"
