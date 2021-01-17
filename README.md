# vRealize Network Insight - Traffic Analysis

1. [Trial Process](#overview)
	1. [Prerequisites](#prerequisites)
	2. [Installation](#installation)
2. [Useful Queries](#queries)
	1. [Security](#query-security)
	2. [VM by Application](#query-vm-application)
	3. [VM by Network](#query-vm-network)
	4. [Traffic Analysis - L2 Network](#query-traffic-network)
	5. [Traffic Analysis - Routing and Aggregation](#query-traffic-routing)
	6. [Traffic Analysis - Ports and Services](#query-traffic-services)
	7. [VMs, Routed via Specific L3 Device](#query-vms-routed-specific)
	8. [VMs, Hairpinning and L3 Subnet Dependencies](#query-vms-hairpinning)
	9. [Flows, Aggegration Prefix - Traffic Stats](#query-flows-aggregation)
	10. [Flows, VM-VM, Routed, on Same Host](#query-flows-routed-samehost)
	11. [Flows, VM-VM, Routed, via any L3 Router](#query-flows-routed-any)
	12. [Flows, VM-VM, Routed, via specific L3 Router](#query-flows-routed-specific)
3. [Import/Export Applications](#applications)

## vRNI Trial Process <a name="introduction"></a>

The first step is to register for the VRNI trial and download the appliance files.  
You can then copy the OVAs onto a vSphere Datastore in your management environment ready to go, as this will greatly simplify the process.  

Also - please read the pre-requisites below as they relate to product versions, vCenter permissions, and the Distributed Switch.  

To get access to the 60-day vRNI Trial you can go here:
https://www.vmware.com/go/vna-field

To download the appliances (and get the license key), you can sign in using your my.vmware.com credentials.
If you do not have a my.vmware.com account - select "create an account" to register first.

You will then get access to download the latest vRNI OVAs:
- VMware-vRealize-Network-Insight-X.X.X.XXXXXXXXXX-platform.ova
- VMware-vRealize-Network-Insight-X.X.X.XXXXXXXXXX-proxy.ova

Main documentation page:  
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/index.html

### vRNI Prerequisites <a name="prerequisites"></a>
For the vRNI trial, there are 2x OVA images (mentioned above) to be imported into a vSphere environment.  
These will be configured to begin collecting vCenter inventory and VDS flow information from the virtual environment.  

Please take a look at the pre-requisites below.

To set up these VMs - you will require:
1. 2x static IP addresses to be allocated from a MGMT environment (1 IP per VM)
2. VMs to be imported into a MGMT environment (OVAs to be copied over to vCenter datastore first, but not yet deployed)
3. These IP addresses require connectivity/access (L2 or L3) to the MGMT network of vCenter and ESX host mgmt VMK ports
4. Environment must be using the Distributed Virtual Switch
5. vCenter Server credentials with privileges:
- Distributed Switch: Modify
- dvPort group: Modify

More details on permissions here:  
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/6.1/com.vmware.vrni.using.doc/GUID-B9F6B6B4-5426-4752-B852-B307E49E86D1.html

6. Once installed - the vRNI Platform will modify and enable IPFIX flows on the VDS
- This will be a change (although non-impacting) - please ensure any change control items are covered  
- Verify current ESX VDS IPFIX configuration before proceeding

From here we can:
- Create some high level VM 'Application' grouping constructs
- Typically gather data for 3-5 days (or more) and generate reports for app dependencies, routed, switched etc..
- Plan logical constructs for a transition to NSX

Here are the vRNI VM requirements (refer to Install documentation below):

vRealize Network Insight Platform OVA:  
- 8 cores - Reservation 4096 Mhz
- 32 GB RAM - Reservation - 16GB
- 750 GB - HDD, Thin provisioned

vRealize Network Insight Proxy OVA:  
- 4 cores - Reservation 2048 Mhz
- 10 GB RAM - Reservation - 5GB
- 150 GB - HDD, Thin provisioned

VMware vCenter Server (version 5.5+ and 6.0+):
- To configure and use IPFIX

VMware ESXi:
- 5.5 Update 2 (Build 2068190) and above
- 6.0 Update 1b (Build 3380124) and above

Full list of supported data sources:  
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/6.1/com.vmware.vrni.using.doc/GUID-4BA21C7A-18FD-4411-BFAC-CADEF0050D76.html

VMware Tools ideally installed on all the virtual machines in the data center.  
This helps in identifying the VM to VM traffic.  

### Installation Steps <a name="installation"></a>

I would usually block out a morning or afternoon (around 2 hours) to complete this.  
If you have already copied the VMs to vCenter this can be < 1 hour.

vRealize Network Insight Install Documentation:  
https://www.vmware.com/support/pubs/vrealize-network-insight-pubs.html

This covers the install process - fairly straight forward.  
High-level steps:
1. Import Platform VM OVA and power up
2. Connect HTTPS to Platform VM and run through wizard
3. Enter License Key - this is for the 60-day trial
4. Generate shared key from Platform VM
5. Import Proxy VM and enter shared key
6. Finalise Proxy install via setup CLI
7. Login to Platform VM UI (HTTPS) and configure vCenter / VDS datasources (IPFIX)

## Useful Queries <a name="queries"></a>

vRNI can provide a dizzying array of outputs and data analysis.  
The usefulness of these outputs is only as good as the questions asked of the system, as constructed via **queries**  
Here is a collection of query information that I have personally found useful.  

**Basic Search Queries**

https://docs.vmware.com/en/VMware-vRealize-Network-Insight/6.1/com.vmware.vrni.using.doc/GUID-176F5A09-2325-41EA-A315-58738CB4F117.html

**Advanced Search Queries**

https://docs.vmware.com/en/VMware-vRealize-Network-Insight/6.1/com.vmware.vrni.using.doc/GUID-6D40445C-8BBD-4BCE-88D5-BD4A9D733EFF.html

#### Security Rules <a name="query-security"></a>
```
firewall rules where Service Any = true
firewall rules where Service Any = true and action = ALLOW and destination ip = '0.0.0.0'
firewall rules from VM 'App01-ACI' to VM 'DB02-ACI'
```

#### VMs in an Application <a name="query-vm-application"></a>
```
vms group by Application
```

#### VMs on a Network <a name="query-vm-network"></a>
```
vm group by network address
vm group by subnet
```

#### Traffic Analysis - L2 Network <a name="query-traffic-network"></a>

```
vms group by Default Gateway Router
vms group by Network Address, Default Gateway
L2 Network group by Default Gateway
L2 Network group by Default Gateway, Network Address
L2 Network where VM Count = 0
L2 Network where VM Count = 0 group by Network Address
L2 Network where VM Count > 0 group by Network Address, VM Count

Router Interface group by Device
Router Interface where device = 'w1c04-vrni-tmm-7050sx-1'
```

#### Traffic Analysis - Routing and Aggregation <a name="query-traffic-routing"></a>
- Flows by Subnet

```
flows group by subnet order by sum(bytes)
```

- Flows by Destination VM

```
flows group by Destination VM order by sum(bytes)
```

- Show highest VM->VM pairs by Byte Rate (Routed)

```
sum(bytes) of flows where Flow Type = 'Routed' group by Source VM, Destination VM order by avg(Bytes Rate)
```

- Show highest VM->VM pairs by Byte Rate (Switched)

```
sum(bytes) of flows where Flow Type = 'Switched' group by Source VM, Destination VM order by avg(Bytes Rate)
```

- Show highest Subnet->Subnet pairs by Byte Rate (Routed)

```
sum(bytes) of flows where Flow Type = 'Routed' group by Source Subnet, Destination Subnet order by avg(Bytes Rate)
```

- Show highest Subnet->Subnet pairs by Byte Rate (Switched)

```
sum(bytes) of flows where Flow Type = 'Switched' group by Source Subnet, Destination Subnet order by avg(Bytes Rate)
```

#### Traffic Analysis - Ports and Services <a name="query-traffic-services"></a>
- List VMs accepting UDP 53 (DNS) connections

```
list(Destination VM) of flows where Destination Port = 53
```

- List flows by port-range

```
flows where (port >= 100 AND port <= 200)
```

- Show RDP connections to VMs (List)

```
flows where Destination Port == 3389
```

- Show RDP connections to VMs from specific `Source Country`

```
flows where Destination Port == 3389 and Source Country == 'China'
```

- Show RDP connections to VMs (List VM pairs)

```
flows where Destination Port == 3389 group by Destination VM, Source VM
```

- Show RDP connections to VMs (List IP-VM pairs)

```
flows where Destination Port == 3389 group by Destination VM, Source IP Address
```

- Show RDP connections to VMs (List Source Country)

```
flows where Destination Port == 3389 group by Destination VM, Source Country
```

#### VMs, Routed via Specific L3 Device <a name="query-vms-routed-specific"></a>
- Show me all VMs that use L3 Router `w1c04-vrni-tmm-7050sx-1`

```
vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1'))
```

- Show me all VMs that use L3 Router `w1c04-vrni-tmm-7050sx-1` - group by VLAN

```
vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1')) group by VLAN
```

- Show me all VMs that use L3 Router `w1c04-vrni-tmm-7050sx-1` - group by VLAN, SUBNET

```
vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1')) group by VLAN, Network Address
```

- Show me all VMs that use any L3 Router - group by Router Interface, Network Address

```
vm group by Default Gateway Router Interface, Network Address
```

#### VM Flow Hairpinning and L3 Subnet Dependencies <a name="query-vms-hairpinning"></a>
- Show me traffic between VMs grouped by L3 router device

```
vms group by Default Gateway Router, Default Gateway order by sum(Total Network Traffic)
```

- Show me VM->VM pairs of flows hairpinning via any L3 Router

```
sum(Bytes) of flows where (Flow Type = 'Routed' and Flow Type = 'Same Host') group by Source VM, Destination VM order by avg(Byte Rate)
```

- Show me aggregated Bytes and Byte rate of hairpinning traffic

```
sum(bytes), avg(Bytes Rate) of flows where (Flow Type = 'Routed' and Flow Type = 'Same Host')
```

- Show me physical Hosts from where I am hairpinning traffic

```
flows where (Flow Type = 'Routed' and Flow Type = 'Same Host') group by Host order by sum(Bytes)
```

- Show me VM->VM hairpinning from a specific host

```
flows where host = 'esx003-ovh-ns103551.vrni.cmbu.org' and (Flow Type = 'Routed' and Flow Type = 'Same Host') group by Source VM, Destination VM order by sum(bytes)
```

#### Flows: Aggegration Prefix - Traffic Stats <a name="query-flows-aggregation"></a>
A useful query prefix for constructing aggregation traffic stats for `Flows`  
Replace **`<flow.query>`** with actual query filter syntax.  

```
sum(Bytes), sum(Bytes Rate), sum(Retransmitted Packet Ratio), max(Average Tcp RTT) of flows where <flow.query>
```

#### Flows: Routed, Same Host <a name="query-flows-routed-samehost"></a>
- Show me aggregated Bytes and Byte Rate of hairpinning traffic via L3 Router (includes VM->Physical flows)

```
sum(Bytes), sum(Bytes Rate) of flows where (Flow Type = 'Routed' and Flow Type = 'Same Host')
```

- Show me hosts from where I am hairpinning traffic (includes VM->Physical flows) - group by `Host`

```
sum(Bytes), sum(Bytes Rate) of flows where (Flow Type = 'Routed' and Flow Type = 'Same Host') group by Host order by sum(Bytes)
```

- Show me VM->VM pairs hairpinning traffic via any L3 Router in same Host

```
sum(Bytes), sum(Bytes Rate) of flows where (Flow Type = 'Routed' and Flow Type = 'Same Host') group by Source VM, Destination VM order by sum(Bytes)
```

- Show me VM->VM hairpinning via any L3 Router from specific host `esx003-ovh-ns103551.vrni.cmbu.org`

```
sum(Bytes), sum(Bytes Rate) of flows where host = 'esx003-ovh-ns103551.vrni.cmbu.org' and (Flow Type = 'Routed' and Flow Type = 'Same Host') group by Source VM, Destination VM order by sum(bytes)
```

#### Flows: Routed, VM->VM, via any L3 Router <a name="query-flows-routed-any"></a>

- Show aggregate traffic stats of all VM->VM flows via any L3 Router

```
sum(Bytes) of flows where (Flow Type = 'Routed' and Flow Type = 'VM-VM')
```

- Show aggregate traffic stats of all `Same Host` VM->VM flows via any L3 Router

```
sum(bytes) of flows where (Flow Type = 'Routed' and Flow Type = 'VM-VM' and Flow Type = 'Same Host')
```

- Show aggregate traffic stats of all `Diff Host` VM->VM flows via any L3 Router

```
sum(bytes) of flows where (Flow Type = 'Routed' and Flow Type = 'VM-VM' and Flow Type = 'Diff Host')
```

- Show aggregate traffic stats of `Same Host` VM->VM flows that are hairpinning via any L3 Router

```
sum(Bytes), sum(Bytes Rate), sum(Retransmitted Packet Ratio), max(Average Tcp RTT) of flows where (Flow Type = 'Routed' and Flow Type = 'VM-VM' and Flow Type = 'Same Host')
```

- Show me VM->VM pairs and traffic stats of `Same Host` VM->VM flows that are hairpinning via any L3 Router

```
sum(Bytes), sum(Bytes Rate), sum(Retransmitted Packet Ratio), max(Average Tcp RTT) of flows where (Flow Type = 'Routed' and Flow Type = 'VM-VM') group by Source VM, Destination VM order by sum(Bytes)
```

#### Flows: Routed, VM->VM via specific L3 Router <a name="query-flows-routed-specific"></a>
- Show me all flows via L3 Router `w1c04-vrni-tmm-7050sx-1` 

```
flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1')))
```

- Show me aggregate packet stats of all flows via L3 Router `w1c04-vrni-tmm-7050sx-1`

```
sum(Bytes), sum(Bytes Rate), sum(Retransmitted Packet Ratio), max(Average Tcp RTT) of flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1')))
```

- Show me all flows (East-West + North-South) via L3 Router `w1c04-vrni-tmm-7050sx-1`

```
sum(bytes) of flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1'))) AND (Flow Type = 'Routed')
```

- Show me all North-South (VM->Internet) flows via L3 Router `w1c04-vrni-tmm-7050sx-1`

```
sum(bytes) of flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1'))) AND (Flow Type = 'Routed' and Flow Type = 'Internet')
```

- Show me all East-West (VM->VM and VM->Physical) flows via L3 Router `w1c04-vrni-tmm-7050sx-1`

```
sum(bytes) of flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1'))) AND (Flow Type = 'Routed' and Flow Type = 'East-West')
```

- Show me all VM->VM flows via L3 Router `w1c04-vrni-tmm-7050sx-1`

```
sum(bytes) of flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1'))) AND (Flow Type = 'Routed' and Flow Type = 'VM-VM')
```

- Show me all VM->Physical flows via L3 Router `w1c04-vrni-tmm-7050sx-1`

```
sum(bytes) of flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1'))) AND (Flow Type = 'Routed' and Flow Type = 'VM-Physical')
```

- Show me VM->VM pairs and traffic stats of all flows via L3 Router `w1c04-vrni-tmm-7050sx-1` 

```
sum(Bytes), sum(Bytes Rate), sum(Retransmitted Packet Ratio), max(Average Tcp RTT) of flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1'))) group by Source VM, Destination VM order by sum(Bytes)
```

- Show me SUBNET->SUBNET pairs and traffic stats of all flows via L3 Router `w1c04-vrni-tmm-7050sx-1` 

```
sum(Bytes), sum(Bytes Rate), sum(Retransmitted Packet Ratio), max(Average Tcp RTT) of flows where vm in (vms where Default Gateway Router Interface in (Router Interface where (device = 'w1c04-vrni-tmm-7050sx-1'))) group by Source Subnet, Destination Subnet order by sum(Bytes)
```

## Import/Export Applications <a name="applications"></a>
Step by step instructions for setting up and exporting vRNI Application definitions as per:  
https://code.vmware.com/samples/7128/backup-and-restore-applications---vrealize-network-insight

This workflow leverages the vRNI Python SDK.  

#### 1. Create new Centos VM
Build a new minimal Centos VM to run the necessary scripts.  
For this, you can use my unattended install procedure here:  
https://github.com/apnex/pxe

#### 2. Install Python and pre-requisite packages
Each command should be completed individually before proceeding to the next.  
Commands assume you are logged in as root.  
```sh
yum update
yum install epel-release
yum install python python-pip git
pip install --upgrade pip
pip install python-dateutil urllib3 requests pyyaml
```

#### 3. Clone the `network-insight-sdk-python` repository
```sh
git clone https://github.com/vmware/network-insight-sdk-python
```

#### 4. Install the Python Swagger client
```sh
cd network-insight-sdk-python/swagger_client-py2.7.egg
python setup.py install
```

#### 5. Test and run an example
```sh
cd ../examples
python application_backups.py --help
```

#### 6. EXPORT: Run `application_backups.py` with valid parameters
Example with **LOCAL** auth:
```sh
python application_backups.py \
--deployment_type 'onprem' \
--platform_ip '<vrni.fqdn.or.ip>' \
--domain_type 'LOCAL' \
--username '<username>' \
--password '<password>' \
--application_backup_yaml 'applications.yaml' \
--application_backup_action 'save'
```

Example with **LDAP** auth:
```sh
python application_backups.py \
--deployment_type 'onprem' \
--platform_ip '<vrni.fqdn.or.ip>' \
--domain_type 'LDAP' \
--domain_value '<domain>' \
--username '<username@domain>' \
--password '<password>' \
--application_backup_yaml 'applications.yaml' \
--application_backup_action 'save'
```

#### 7. IMPORT: Run `application_backups.py` with valid parameters
Example with **LOCAL** auth:
```sh
python application_backups.py \
--deployment_type 'onprem' \
--platform_ip '<vrni.fqdn.or.ip>' \
--domain_type 'LOCAL' \
--username '<username>' \
--password '<password>' \
--application_backup_yaml 'applications.yaml' \
--application_backup_action 'restore'
```

Example with **LDAP** auth:
```sh
python application_backups.py \
--deployment_type 'onprem' \
--platform_ip '<vrni.fqdn.or.ip>' \
--domain_type 'LDAP' \
--domain_value '<domain>' \
--username '<username@domain>' \
--password '<password>' \
--application_backup_yaml 'applications.yaml' \
--application_backup_action 'restore'
```

#### Throttling Calls - HTTP 429 Errors
Depending on vRNI platform utilisation and deployed size, you may see a `429 Too Many Requests` error.  
This is the platfrom appliance rejecting API calls that exceed its current ability to process.  

Solve this by modifying the `application_backups.py` file to sleep longer (for 1 second) between API calls.  

```diff
-    36	                time.sleep(0.025)
+    36	                time.sleep(1)
-    58	                time.sleep(0.025)
+    58	                time.sleep(1)
```
