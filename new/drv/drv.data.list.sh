#!/bin/bash

printf "%s\n" "DRIVER: ${WORKDIR} : ${STATEDIR} : ${PARENT}" 1>&2

if [[ $(readlink -f $0) =~ ^(.*)/[^/]+$ ]]; then
	printf "%s\n" "MOO"
	source ${BASH_REMATCH[1]}/mod.core
fi

printf "%s\n" "DRIVER: ${WORKDIR} : ${STATEDIR} : ${PARENT}" 1>&2

#printf '%s' $(<${STATEDIR}/data.json) | jq --tab .
