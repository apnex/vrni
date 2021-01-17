#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
STATEDIR="."

# inputs
#https://10.221.81.189/api/auth/csvTemplate?scope=GLOBAL&entityType=515
ITEM="/auth/csvTemplate?scope=GLOBAL&entityType=515"

ENDPOINTS=$(<./endpoints.json)
SPEC=$(echo "${ENDPOINTS}" | jq -r '.endpoints[] | select(.type=="vrni")')
VRNIHOST=$(echo "${SPEC}" | jq -r '.hostname')
VRNIUSER=$(echo "${SPEC}" | jq -r '.username')
VRNIPASS=$(echo "${SPEC}" | jq -r '.password')
VRNIONLINE=$(echo "${SPEC}" | jq -r '.online')
VRNISESSION="${STATEDIR}/vrni.token"
VRNIBASE="https://${VRNIHOST}/api"

function getCode {
	local STRING=${1}
	if [[ $STRING =~ ^(.*)([0-9]{3})$ ]]; then
		local BODY=${BASH_REMATCH[1]}
		local CODE=${BASH_REMATCH[2]}
	fi
	printf "%s\n" "${CODE}"
}

function getBody {
	local STRING=${1}
	if [[ $STRING =~ ^(.*)([0-9]{3})$ ]]; then
		local BODY=${BASH_REMATCH[1]}
		local CODE=${BASH_REMATCH[2]}
	fi
	printf "%s\n" "${BODY}"
}

function vrniLogin {
	local URL="https://${VRNIHOST}/api/ni/auth/token"
	read -r -d '' VRNIBODY <<-CONFIG
	{
		"username": "${VRNIUSER}",
		"password": "${VRNIPASS}",
		"domain": {
			"domain_type": "LOCAL"
		}
	}
	CONFIG

	local RESPONSE=$(curl -k -c "${STATEDIR}/vrni.cookies" -D "${STATEDIR}/vrni.headers" -w "%{http_code}" -X POST \
		-H 'Content-Type: application/json' \
		-H 'Accept: application/json' \
		-d "${VRNIBODY}" \
	"${URL}" 2>/dev/null)

	#echo ${RESPONSE}
	local CODE=$(getCode "${RESPONSE}")
	local BODY=$(getBody "${RESPONSE}")
	local TOKEN=$(echo ${BODY} | jq -r '.token')
	printf "%s\n" "${TOKEN}"
}

function vrniSession {
	local SESSION=${VRNISESSION}
	local ONLINE=${VRNIONLINE}
	if [[ "$ONLINE" == "true" ]]; then
		local RUNFIND="$(find ${SESSION} -mmin -10 2>/dev/null)"
		if [[ -z ${RUNFIND} ]]; then
			printf "No valid session found, authenticating... " 1>&2
			local LOGIN=$(vrniLogin)
			if [[ -n ${LOGIN} ]]; then
				echo "${LOGIN}" >"${SESSION}"
			fi
		else
			printf "Using existing valid session... " 1>&2
		fi
	fi
	printf "%s\n" "$(cat "${SESSION}" 2>/dev/null)"
}

#vrniLogin
vrniSession
