#!/bin/bash
if [ -z ${WORKDIR} ]; then
	if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
		WORKDIR=${BASH_REMATCH[1]}
	fi
	if [[ $0 == "bash" ]]; then
		WORKDIR="."
	fi
fi
source ${WORKDIR}/mod.core

#printf "%s\n" "${0} : ${WORKDIR} : ${STATEDIR}"

TOKEN=$(cat ${STATEDIR}/vrni.token.txt)
BODY=$(<${STATEDIR}/result.json)
RESULT=$(curl -k -b "${STATEDIR}/vrni.cookies.txt" -X POST \
	-H 'accept: application/json' \
	-H 'content-type: application/json' \
	-H "x-vrni-csrf-token: $TOKEN" \
	-d "${BODY}" \
"https://field-demo.vrni.cmbu.local/api/config/objects" 2>/dev/null)

printf '%s' "${RESULT}" | jq --tab . >${STATEDIR}/data.json
