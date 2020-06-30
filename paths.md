## pin boards
Demo: VM to VM Path Topology
Awesome Paths
NSX-T Demo

## Specific paths


## security
firewall rules where Service Any = true
firewall rules where Service Any = true and action = ALLOW and destination ip = '0.0.0.0'

### VMs in an Application
vms group by Application

### VMs on a network
vm group by network address
vm group by subnet

### Flows by a Subnet
sum(bytes) of flows group by subnet order by sum(bytes)

### Flows by Destination VM
sum(bytes) of flows group by Destination VM order by sum(bytes)

### Flows by L3 Subnet Pairs
sum(bytes) of flow where Flow Type = 'Routed' group by Source Subnet Network, Destination Subnet Network order by avg(Bytes Rate)

### Flows by L2 Subnets
sum(bytes) of flow where Flow Type = 'Switched' group by Network Address order by avg(Bytes Rate)

### Show highest VM->VM pairs
sum(bytes) of flows where Flow Type = 'Routed' group by source vm, destination vm order by avg(Bytes Rate)
sum(bytes) of flows where Flow Type = 'Switched' group by source vm, destination vm order by avg(Bytes Rate)

### Show all VMs answering DNS
list(destination VM) of flow where destination port = 53
