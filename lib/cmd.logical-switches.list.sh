#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then
        WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.command

function run { ## build record
	read -r -d '' SPEC <<-CONFIG
		.results | if (. != null) then map({
	                "id": .id,
	                "name": .display_name,
	                "vni": .vni,
	                "vlan": .vlan,
	                "admin_state": .admin_state
		}) else "" end
	CONFIG
	printf "${SPEC}"
}

## cmd
cmd "${@}"
