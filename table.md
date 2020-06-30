# vRealize Network Insight - Table of Contents

1. [Trial Process](#overview)
2. [Useful Queries](#queries)
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

### vRNI Pre-requisites
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
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/5.2/com.vmware.vrni.using.doc/GUID-B9F6B6B4-5426-4752-B852-B307E49E86D1.html

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
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/5.2/com.vmware.vrni.using.doc/GUID-4BA21C7A-18FD-4411-BFAC-CADEF0050D76.html

VMware Tools ideally installed on all the virtual machines in the data center.  
This helps in identifying the VM to VM traffic.  

### Installation Steps

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
queries

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
