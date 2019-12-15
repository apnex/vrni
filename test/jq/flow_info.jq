.data | if (. != null) then map({
	"modelKey": .modelKey,
	"name": .name,
	"srcIpEntity": .srcIpEntity.name,
	"dstIPEntity": .dstIPEntity.name,
	"protocol": .protocol,
	"port": .port.display
}) else "" end
