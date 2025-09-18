
# Derived from
- ?? Microsoft AKS - https://learn.microsoft.com/fr-fr/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli ??

# Pre-requisites

To stand up a AKS cluster using Terraform, you will need:
- optional: the az client
- the terraform client
- the kubectl client

# Standing up cluster

az login

This will create the ~/.azure folder with your credentials - the Azure Terraform Provider will use those credentials

Then
    terraform init
    terraform apply # May take a long time, typically 5 minutes

# Obtaining the kubeconfig file

The file ```azure.kubeconfig``` will have been created.

### Using the --kubeconfig option

Check that you can access your cluster using kubectl as follows:
```kubectl --kubeconfig ./azure.kubeconfig get nodes```

### Exporting the KUBECONFIG variable

or

```
export KUBECONFIG=$PWD/azure.kubeconfig
kubectl get nodes
```

Now you can use ```kubectl``` commands without any special arguments

### Setting/replacing ~/.kube/config

You may wish to install this in the standard location - be careful not to overwrite an existing file !

The standard location is ~/.kube/config - you may need to first create the ~/.kube folder

# Investigating cluster resources

## Investigating cluster resources - using az

If you are interested to see the Azure resources which were created, you can view the Azure cluster resources using ```az resource list -o table```

You should see output something like below:

```
az resource list -o table
Name                                  ResourceGroup                              Location    Type                                              Status
------------------------------------  -----------------------------------------  ----------  ------------------------------------------------  --------
NetworkWatcher_eastus                 NetworkWatcherRG                           eastus      Microsoft.Network/networkWatchers
NetworkWatcher_westus                 NetworkWatcherRG                           westus      Microsoft.Network/networkWatchers
sshsensiblemule                       webinar-aks                                eastus      Microsoft.Compute/sshPublicKeys
webinar-aks_publicip                  webinar-aks                                eastus      Microsoft.Network/publicIPAddresses
webinar-aksVirtualNetwork             webinar-aks                                eastus      Microsoft.Network/virtualNetworks
webinar-ApplicationGateway1           webinar-aks                                eastus      Microsoft.Network/applicationGateways
cluster-awaited-elf                   webinar-aks                                eastus      Microsoft.ContainerService/managedClusters
c9faae18-bd3b-408f-a5e8-2f2f85926a06  MC_webinar-aks_cluster-awaited-elf_eastus  eastus      Microsoft.Network/publicIPAddresses
kubernetes                            MC_webinar-aks_cluster-awaited-elf_eastus  eastus      Microsoft.Network/loadBalancers
cluster-awaited-elf-agentpool         MC_webinar-aks_cluster-awaited-elf_eastus  eastus      Microsoft.ManagedIdentity/userAssignedIdentities
aks-agentpool-17553829-nsg            MC_webinar-aks_cluster-awaited-elf_eastus  eastus      Microsoft.Network/networkSecurityGroups
aks-agentpool-33679207-vmss           MC_webinar-aks_cluster-awaited-elf_eastus  eastus      Microsoft.Compute/virtualMachineScaleSets
```

Note the resource types above, in particular:
- cluster itself: ```cluster-awaited-elf          webinar-aks                        eastus  Microsoft.ContainerService/managedClusters```
- pool of Nodes:  ```aks-agentpool-33679207-vmss  MC_webinar-aks_cluster-awaited-elf_eastus  eastus      Microsoft.Compute/virtualMachineScaleSets```

## Investigating cluster resources - using terraform

You can view the cluster resources from Terraform's point of view using:

```terraform state list```

You can view a json dump of individiual resources using ```terraform state show <<resource>>```, e.g.

```terraform state show azurerm_kubernetes_cluster.k8s```

# Tearing down cluster

terraform destroy # May take 5 minutes or more


