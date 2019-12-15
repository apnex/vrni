#!/bin/bash
if [[ $(readlink -f $0) =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
printf "%s\n" "${WORKDIR}"
source ${WORKDIR}/mod.command

function run {
	printf '%s' "$(<${JQDIR}/host.jq)"
}

## cmd
cmd "${@}"
