#!/bin/bash

TOKEN=$(cat ./drv/vrni.token.txt)

RESULT=$(curl -k -b "./drv/vrni.cookies.txt" -X GET \
	-H 'accept: application/json' \
	-H "x-vrni-csrf-token: $TOKEN" \
	'https://field-demo.vrni.cmbu.local/api/model/objectTypes?=' \
2>/dev/null)

printf "${RESULT}" | jq --tab .
