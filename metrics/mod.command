#!/bin/bash
if [[ $(readlink -f $0) =~ ^(.*)/([^/]+)$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
	FILE=${BASH_REMATCH[2]}
	if [[ ${FILE} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
STATEDIR=${WORKDIR}/state
JQDIR=${WORKDIR}/jq
source ${WORKDIR}/drv/mod.core

# build filter
function cmd {
	local COMMAND=${1}
	case "${COMMAND}" in
		watch)
			watch -t -c -n 3 "${WORKDIR}/${FILE} 2>/dev/null"
		;;
		json)
			local PAYLOAD=$(payload)
			setContext "${PAYLOAD}" "${TYPE}"
			echo "${PAYLOAD}" | jq --tab .
		;;
		filter)
			local FILTER=${2}
			local PAYLOAD=$(filter "$(payload)" "${FILTER}")
			setContext "${PAYLOAD}" "${TYPE}"
			buildTable "${PAYLOAD}"
		;;
		*)
			local PAYLOAD=$(payload)
			setContext "${PAYLOAD}" "${TYPE}"
			buildTable "${PAYLOAD}"
		;;
	esac
}

function payload {
	local INPUT=$(eval $(drv "${TYPE}")) # link to drv
	local PAYLOAD=$(echo "${INPUT}" | jq -r "$(run)")
	printf "${PAYLOAD}"
}

function drv {
	local DRIVER=${1}
	printf "${WORKDIR}/drv/drv.${DRIVER}.sh"
}
