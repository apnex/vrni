#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run {
	read -r -d '' SPEC <<-CONFIG
		. | if (. != null) then map({
			"modelKey": .modelKey,
			"name": .name
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
