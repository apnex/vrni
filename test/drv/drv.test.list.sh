#!/bin/bash
if [[ $(readlink -f $0) =~ ^(.*)/[^/]+$ ]]; then
	source ${BASH_REMATCH[1]}/mod.core
fi

printf '%s' $(<${STATEDIR}/data.json) | jq --tab .
