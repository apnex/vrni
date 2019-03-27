#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.vrni.client

## input driver
NODES=$(${WORKDIR}/drv.applications.list.sh)

# re-base to drv.node....?
function getStatus {
	local NODEID=${1}
	./drv.applications.list.sh "${NODEID}"
}

function buildNode {
	local KEY=${1}

	read -r -d '' JQSPEC <<-CONFIG # collapse into single line
		.results[] | select(.entity_id=="${KEY}")
	CONFIG
	NODE=$(echo ${NODES} | jq -r "$JQSPEC")

	# build node record
	read -r -d '' NODESPEC <<-CONFIG
		{
			"entity_id": .entity_id,
			"entity_type": .entity_type
		}
	CONFIG
	NEWNODE=$(echo "${NODE}" | jq -r "${NODESPEC}")

	## get node status
	RESULT=$(getStatus "$KEY")
	read -r -d '' STATUSSPEC <<-CONFIG
		{
			"name": .name,
			"created_by": .created_by
		}
	CONFIG
	NEWSTAT=$(echo "${RESULT}" | jq -r "${STATUSSPEC}")

	# merge node and status
	MYNODE="$(echo "${NEWNODE}${NEWSTAT}" | jq -s '. | add')"
	printf "%s\n" "${MYNODE}"
}

FINAL="[]"
for KEY in $(echo ${NODES} | jq -r '.results[] | .entity_id'); do
	MYNODE=$(buildNode "${KEY}")
	FINAL="$(echo "${FINAL}[${MYNODE}]" | jq -s '. | add')"
done
printf "${FINAL}" | jq --tab .
