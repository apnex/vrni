#!/bin/bash

./drv.complete.sh "hos" | jq '.data.partialQueryCompletions.completionsByType.ENTITY_TYPE[] | .completion'
