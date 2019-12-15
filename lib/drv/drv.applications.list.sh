#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.vrni.client

CALL=$1
if [[ -n "${VRNIHOST}" ]]; then
	ITEM="groups/applications"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${CALL}" ]]; then
		URL+="/${CALL}"
	else
		URL+="?size=10"
	fi
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		vrniGet "${URL}"
	fi
fi
