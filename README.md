### vRNI SDK - Backup and Restore Applications

Step by step instructions for setting up and exporting vRNI Application defintions as per:  
https://code.vmware.com/samples/7128/backup-and-restore-applications---vrealize-network-insight

#### 1. Create new Centos VM
Build a new minimal Centos VM to run the necessary scripts.  
For this, you can use my unattended install procedure here:  
https://github.com/apnex/pxe


#### 2. Install Python and pre-requisite packages
Each command should be completed individually before proceeding to the next.
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
python application_backup.py --help
```

#### 6. Run `application_back.py` with valid parameters
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
