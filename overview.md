# data sources
Supported Data Sources:
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/4.1/com.vmware.vrni.install.doc/GUID-4BA21C7A-18FD-4411-BFAC-CADEF0050D76.html

Add new Data Source:
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/4.1/com.vmware.vrni.using.doc/GUID-AB342101-8A47-4F24-9EC3-4273E1E4EAFB.html

# path topology
More info on NSX Path topology:
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/4.1/com.vmware.vrni.using.doc/GUID-D6B1149A-2C09-4A8A-9C74-1B0AD9C52BEE.html

# export CSV
CSV Export Options
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/4.1/com.vmware.vrni.using.doc/GUID-30906FE7-A099-4655-B622-2E4993F4A301.html
Exporting CSV records are highly configurable with respect to the individual fields needed.
Any tabular search result can be exported from vRNI.
The main consideration here is what "key" to use per-record - as it is based on an "Entity".
An Entity in this context is a VM, Folder, Cluster, Switch, Host, Network, Application etc..

An example search might be:
vm where application = 'CCTV'

Or something more complicated and specific.
Export field templates can be customised and saved for future use.

# API
vRNI API Guide:
https://vdc-download.vmware.com/vmwb-repository/dcr-public/79f08a61-269a-41b4-b490-0d33084cd229/bc9e0b9f-0ed4-4ec5-beb1-bfd9621a78a1/vRealize-Network-Insight-API-Guide.pdf

Though not strictly required - data extraction from vRNI can be automated through the REST API by simply returning raw JSON formatted data.
Some examples in the API guide above.

