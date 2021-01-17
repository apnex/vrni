#1 Create a Migration Wave
#2 Look at CPU/Mem footprint
#3 Look at VM dependency with other VMS outside the APP
#4 Look at Networks vms where application = MigrationWave01 group by Network Address
#5 Look at Storage
1 - Avoid Network tromboning
2 - Identify all VMs using North-South traffic and traversing DET’s firewall
3 - Group VMs together if there are dependency (i.e. Web server, apps and database server)
-- Look at Dependency
4 - Identify VMs with high network bandwidth usage
5 - Identify VMs with high network bandwidth traffic between our 2 DCs (2T <-> EB)
6 - Group our selected VMs into vLan groups, we have stretch vLans and non-stretch vLans.

# Storage queries
vms where application = 'Migration-wave-01' group by vcenter
vms where application = 'Migration-wave-01' group by Network Address

## check port group
vm group by dvpg

### check subnet pairs
flow where application = 'Migration-wave-01' and Flow Type = 'Routed' group by Source Subnet Network, Destination Subnet Network order by sum(bytes)

### 10.10.134.0/24
vms in dvpg that are not in app

###
Flows where (External IPs - PHYSICAL) outside migration wave are talking to migration wave // flow type?
Flows where VMs outside migration wave are talking to migration wave // flow type?

### VM
Subnet by subnet

### If I migrate these whole subnets, what VMs are affected?
