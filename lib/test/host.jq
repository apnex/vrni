.data | if (. != null) then map({
	"modelKey": .modelKey,
	"name": .name,
	"powerState": .serverdataParent.runtime.powerState,
	"numCpus": .serverdataParent.numCpus,
	"cpuSockets": .serverdataParent.cpuSockets,
	"memoryMB": .serverdataParent.memoryMB,
	"numVms": .numVms
}) else "" end
