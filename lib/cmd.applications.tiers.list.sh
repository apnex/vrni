#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core

## input driver
INPUT=$(${WORKDIR}/drv.applications.tiers.list.sh "${@}")

#					"membership_type": "SearchMembershipCriteria",
#					"search_membership_criteria": {
#						"entity_type": "BaseVirtualMachine",
#						"filter": "name = 'App01'"
#					}
## build record structure
read -r -d '' INPUTSPEC <<-CONFIG
	.results | map({
		"entity_id": .entity_id,
		"name": .name,
		"entity_type": .entity_type,
		"membership_type": .group_membership_criteria[0].membership_type,
		"membership_entity_type": .group_membership_criteria[0].search_membership_criteria.entity_type,
		"membership_entity_filter": .group_membership_criteria[0].search_membership_criteria.filter
	})
CONFIG
PAYLOAD=$(echo "$INPUT" | jq -r "$INPUTSPEC")

# build filter
#FILTER=${1}
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
