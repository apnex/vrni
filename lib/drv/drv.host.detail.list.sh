#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.vrni.client

function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"entity_type": "Host"
	}
	CONFIG
	printf "${BODY}"
}

CALL=$1
if [[ -n "${VRNIHOST}" ]]; then
	ITEM="search"
	BODY=$(makeBody)
	URL=$(buildURL "${ITEM}")
	if [[ -n "${CALL}" ]]; then
		URL+="/${CALL}"
	else
		URL+="?size=10"
	fi
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		vrniPost "${URL}" "${BODY}"
	fi
fi
