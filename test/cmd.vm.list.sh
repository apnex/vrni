#!/bin/bash
if [[ $(readlink -f $0) =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	printf '%s' "$(<${JQDIR}/vm.jq)"
}

## cmd
cmd "${@}"
