#!/bin/bash
if [[ $(readlink -f $0) =~ ^(.*)/[^/]+$ ]]; then
	source ${BASH_REMATCH[1]}/mod.core
fi

TOKEN=$(<${STATEDIR}/vrni.token.txt)
BODY=$(<${STATEDIR}/result.json)
#BODY=$(<./test.json)
RESULT=$(curl -k -b "${STATEDIR}/vrni.cookies.txt" -X POST \
	-H 'accept: application/json' \
	-H 'content-type: application/json' \
	-H "x-vrni-csrf-token: $TOKEN" \
	-d "${BODY}" \
"https://field-demo.vrni.cmbu.local/api/config/objects" 2>/dev/null)

printf '%s' "${RESULT}" | jq --tab . >${STATEDIR}/data.json
