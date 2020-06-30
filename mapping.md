## problems
vms where problem
hosts where problem

### VMs on a network
vms group by Network Address

### flows on a network
flows group by Network Address

## shows highest flowing VMs
sum (bytes) of flows group by dest vm order by sum(bytes)

## shows highest flowing subnets (equal?)
sum (bytes) of flows group by subnet order by sum(bytes)

## shows highest flowing subnets (equal?)
sum (bytes) of flows group by subnet order by sum(bytes)

## show highest L3 Subnet pairs
sum(bytes) of flow where Flow Type = 'Routed' group by Source Subnet Network, Destination Subnet Network order by avg(Bytes Rate)

## show highest intra-L2 networks
sum(bytes) of flow where Flow Type = 'Switched' group by Subnet Network order by avg(bytes) in last 3 days

## show highest VM->VM pairs
sum(bytes) of flows where Flow Type = 'Routed' group by source vm, destination vm order by avg(Bytes Rate)
sum(bytes) of flows where Flow Type = 'Switched' group by source vm, destination vm order by avg(Bytes Rate)

## show all VMs answering DNS
list(destination VM) of flow where destination port = 53

##
series(sum(network usage)) of flows where vm group by vm

## Flows where Port number
flows where destination port = 3389 and source country = 'China' group by destination vm 

## show all VMs answering DNS
list(destination VM) of flow where destination port = 53

vm where in (vm where name = 'x')
vm where name in (web-c-601, web-c-901) group by Network Address
vm where name in (list(destination VM) of flow where destination port = 53)

vm where in (vms order by name limit 10) group by Network Address

series(avg(cpu usage)), series(avg(memory usage)), series(sum(network usage)) of vms where application = 'Big CRM'

vm where in (vms order by name limit 100) group by Network Address order by sum(Active Memory) limit 6
vm where (Network Address='10.196.206.0/24')

## VMC/ON PREM
vms group by sddc type

## VMs
vms group by cluster

## By cluster
vms where sddc type = VMC group by cluster
vms where SDDC type = VMC group by resource pool
vms where sddc type = ONPREM group by cluster
vms where sddc type = ONPREM group by resource pool

# reduce traffic within L2
# reduce traffic across L3

# highest pair of subnets
sum(bytes) of flow where Flow Type = 'Routed' group by Source Subnet Network, Destination Subnet Network order by sum(bytes)

# highest pair of VMs across those subnets
sum(bytes) of flows where Flow Type = 'Routed' group by source vm, destination vm order by avg(Bytes Rate)

# per a given subnet - rank by traffic in and out
sum(bytes) of flow where Flow Type = 'Routed' group by Subnet Network order by sum(bytes)

# find vms in highest subnet
vms where network address = 10.196.206.0/24

# flows in subnet
flows where Flow Type = 'Routed' and source vm in (vms where network address = 10.196.206.0/24) group by source vm, destination vm order by sum(bytes)
flows where vm in (vms where network address = 10.196.206.0/24) group by vm
vm where network address = 10.196.206.0/24

## tracking
vms where Application = MigrationWave01 and sddc type = ONPREM
vms where Application = MigrationWave01 and sddc type = VMC

## one network
sum(bytes) of flow where Flow Type = 'Routed' and source ip address = 10.196.206.0/24 group by Source Subnet Network, Destination Subnet Network order by sum(bytes)
