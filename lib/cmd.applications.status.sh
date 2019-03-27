#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core

## input driver
INPUT=$(${WORKDIR}/drv.applications.status.sh)

## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	. | map({
		"entity_id": .entity_id,
		"entity_type": .entity_type,
		"name": .name,
		"created_by": .created_by
	})
CONFIG
PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")

# build filter
FILTER=${1}
FORMAT=${2}
#PAYLOAD=$(filter "${PAYLOAD}" "${FILTER}")

## cache context data record
setContext "$PAYLOAD" "$TYPE"

## output
case "${FORMAT}" in
	json)
		## build payload json
		echo "${PAYLOAD}" | jq --tab .
	;;
	raw)
		## build input json
		echo "${INPUT}" | jq --tab .
	;;
	*)
		## build payload table
		buildTable "${PAYLOAD}"
	;;
esac
