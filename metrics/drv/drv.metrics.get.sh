#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.vrni.client

# inputs
#ITEM="schema/Flow/metrics"
#ITEM="entities/flows/10000:515:826709463"
ITEM="entities/flows/10000:515:569626449"

# run
run() {
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: vrni [$(cgreen "list")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		vrniGet "${URL}"
	fi
}
run

