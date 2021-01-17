#!/bin/bash

urlencode() {
	# urlencode <string>
	old_lc_collate=$LC_COLLATE
	LC_COLLATE=C
	local length="${#1}"
	for (( i = 0; i < length; i++ )); do
		local c="${1:i:1}"
		case $c in
			[a-zA-Z0-9.~_-]) printf "$c" ;;
			*) printf '%%%02X' "'$c" ;;
		esac
	done
	LC_COLLATE=$old_lc_collate
}

urldecode() {
	# urldecode <string>
	local url_encoded="${1//+/ }"
	printf '%b' "${url_encoded//%/\\x}"
}

SEARCH=${1}
STATEDIR="./state"
TOKEN=$(<${STATEDIR}/vrni.token.txt)
QUERY=$(urlencode "${SEARCH}")
#searchString=hosts+where+VM+Count+%3E+10
RESULT=$(curl -k -b "${STATEDIR}/vrni.cookies.txt" -X GET \
	-H 'accept: application/json' \
	-H "x-vrni-csrf-token: $TOKEN" \
	"https://field-demo.vrni.cmbu.local/api/search/query?searchString=${QUERY}&includeObjects=false&includeFacets=true&includeMetrics=true&includeModelKeyOnly=false&startIndex=0&maxItemCount=10" \
2>/dev/null)

read -r -d '' SPEC <<-CONFIG
	.resultList | if (. != null) then {
		"requests": map(
			.searchContext | {
			"modelKey": .modelKey
		})
	} else "" end
CONFIG

printf '%s' "${RESULT}" | jq --tab "${SPEC}" >${STATEDIR}/result.json
printf '%s' "${RESULT}" | jq --tab . >${STATEDIR}/query.json

./drv/drv.objects.list.sh

#'https://field-demo.vrni.cmbu.local/api/search/query?searchString=host&includeObjects=false&includeFacets=true&includeMetrics=false&includeEvents=false&includeModelKeyOnly=false&startIndex=0&maxItemCount=10'
#'https://field-demo.vrni.cmbu.local/api/search/query?searchString=host&includeObjects=true&includeModelKeyOnly=false'

#printf '%s' "${RESULT}" | jq --tab .
