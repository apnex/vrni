.data | if (. != null) then map({
	"modelKey": .modelKey,
	"name": .name,
	"totalCpu": .totalCpu,
	"totalMemory": .totalMemory,
	"numCpuCores": .numCpuCores,
	"numHosts": .numHosts,
	"numDatastores": .numDatastores
}) else "" end
