.data | if (. != null) then map({
	"modelKey": .modelKey,
	"name": .name,
	"powerState": .serverdataParent.runtime.powerState,
	"numCpus": .serverdataParent.numCpus,
	"osFullName": .serverdataParent.osFullName,
	"memoryMB": .serverdataParent.memoryMB
}) else "" end
