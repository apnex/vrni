#!/bin/bash
if [[ $(readlink -f $0) =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	local TYPE="$(cat ${STATEDIR}/query.json | jq -r '.queryResultSemanticsContext.objectType.objectType')"
	local LCASE=$(echo "${TYPE}" | tr '[:upper:]' '[:lower:]')
	printf '%s' "$(<${JQDIR}/${LCASE}.jq)"
}

## cmd
cmd "${@}"
