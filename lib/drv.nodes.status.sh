#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

## input driver
NODES=$(${WORKDIR}/drv.nodes.list.sh)

# re-base to drv.node....?
function getStatus {
	local NODEID=${1}
	ITEM="fabric/nodes"
	CALL="/${NODEID}/status"
	URL=$(buildURL "${ITEM}${CALL}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "status")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
}

function buildNode {
	local KEY=${1}

	read -r -d '' JQSPEC <<-CONFIG # collapse into single line
		.results[] | select(.id=="${KEY}")
	CONFIG
	NODE=$(echo ${NODES} | jq -r "$JQSPEC")

	# build node record
	read -r -d '' NODESPEC <<-CONFIG
		{
			"id": .id,
			"name": .display_name,
			"resource_type": .resource_type,
			"ip_address": .ip_addresses[0]
		}
	CONFIG
	NEWNODE=$(echo "${NODE}" | jq -r "${NODESPEC}")

	## get node status
	RESULT=$(getStatus "$KEY")
	read -r -d '' STATUSSPEC <<-CONFIG
		{
			"status": .host_node_deployment_status,
			"version": .software_version
		}
	CONFIG
	NEWSTAT=$(echo "${RESULT}" | jq -r "${STATUSSPEC}")

	# merge node and status
	MYNODE="$(echo "${NEWNODE}${NEWSTAT}" | jq -s '. | add')"
	printf "%s\n" "${MYNODE}"
}

FINAL="[]"
for KEY in $(echo ${NODES} | jq -r '.results[] | .id'); do
	MYNODE=$(buildNode "${KEY}")
	FINAL="$(echo "${FINAL}[${MYNODE}]" | jq -s '. | add')"
done
printf "${FINAL}" | jq --tab .
