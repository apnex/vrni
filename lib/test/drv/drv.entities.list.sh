#!/bin/bash
if [ -z ${WORKDIR} ]; then
	if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
		WORKDIR=${BASH_REMATCH[1]}
	fi
	if [[ $0 == "bash" ]]; then
		WORKDIR="."
	fi
fi
STATEDIR="${WORKDIR}"
source ${WORKDIR}/mod.core

TOKEN=$(cat ${STATEDIR}/vrni.token.txt)
BODY=$(<./entities.json)
RESULT=$(curl -k -b "${STATEDIR}/vrni.cookies.txt" -X POST \
	-H 'accept: application/json' \
	-H 'content-type: application/json' \
	-H "x-vrni-csrf-token: $TOKEN" \
	-d "${BODY}" \
	"https://field-demo.vrni.cmbu.local/api/metrics/entities" \
2>/dev/null)

#"https://field-demo.vrni.cmbu.local/api/config/objects" \
#[{"modelKey":"10000:515:1018548286","metricNames":["flow.totalBytes.delta.summation.bytes","flow.totalBytesRate.rate.average.bitsPerSecond"],"indicativeValues":true,"startDate":1576099008489,"endDate":1576185408489,"defaultValue":-1}

printf '%s' "${RESULT}" | jq --tab . >./data.json
#printf '%s' "${RESULT}" | jq --tab . >${STATEDIR}/data.json
