#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.vrni.client

CALL=$1
if [[ -n "${VRNIHOST}" && "${CALL}" ]]; then
	ITEM="groups/applications"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${CALL}" ]]; then
		URL+="/${CALL}/tiers"
	fi
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: vrni [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		vrniGet "${URL}"
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "applications.tiers.list") $(ccyan "<application.id>")\n" 1>&2
fi

