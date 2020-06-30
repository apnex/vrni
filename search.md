## Useful Queries

vRNI can provide a dizzying array of outputs and data analysis.  
The usefulness of these outputs is only as good as the questions asked of the system, as constructed via **queries**  
Here is a collection of query information that I have personally found useful.  

### Query Overview

#### Basic Search Queries
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/5.2/com.vmware.vrni.using.doc/GUID-176F5A09-2325-41EA-A315-58738CB4F117.html

#### Advanced Search Queries
https://docs.vmware.com/en/VMware-vRealize-Network-Insight/5.2/com.vmware.vrni.using.doc/GUID-6D40445C-8BBD-4BCE-88D5-BD4A9D733EFF.html

### Query Examples

#### Security Rules
```
firewall rules where Service Any = true
firewall rules where Service Any = true and action = ALLOW and destination ip = '0.0.0.0'
```

### VMs in an Application
```
vms group by Application
```

### VMs on a network
```
vm group by network address
vm group by subnet
```

#### Routing and Grouping/Aggregation
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

#### Ports and Services
list(destination VM) of flow where destination port = 53

- List flows by port-range

```
flows where (port >= 100 AND port <= 200)
```

- Show RDP connections to VMs (List)

```
flows where Destination Port == 3389
```

- Show RDP connections to VMs (List VM pairs)

```
flows where Destination Port == 3389 group by Destination VM, Source VM
```

- Show RDP connections to VMs (List Source Country)

```
flows where Destination Port == 3389 group by Source Country = 'China'
```

#### Applications

Migration Grouping and Traffic Hairpinning

Migration Grouping and Traffic Hairpinning{
  outline: 2px dotted blue;
}

In his beard lived three <span style="color:red">cardinals</span>.

#### A blue heading
{: .blue}

Roses are \textcolor{red}{red}, violets are \textcolor{blue}{blue}.

- ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) `#f03c15`
- ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) `#c5f015`
- ![#FFFFFF](https://via.placeholder.com/15/1589F0/000000?text=+) `#1589F0`

```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```

<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
<p>okay</p>


<style>.test{
	color:blue;
}</style>
## **foo** {#test}


