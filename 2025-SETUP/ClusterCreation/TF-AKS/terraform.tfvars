
# Note: use of webinar- prefix on some variables to prevent conflicts
public_ip_name       = "webinar-aks_publicip"
virtual_network_name = "webinar-aksVirtualNetwork"
aks_subnet_name      = "webinar-kubesubnet"
app_gateway_name     = "webinar-ApplicationGateway1"

resource_group_name = "webinar-aks"

location = "eastus"

node_count = 1

kubernetes_version = "1.34.1"

vm_size = "Standard_D2_v2"
os_disk_size = 40

kube_config_file = "azure.kubeconfig"

virtual_network_address_prefix = "192.168.0.0/16"

aks_subnet_address_prefix = "192.168.0.0/24"

app_gateway_subnet_address_prefix = "192.168.1.0/24"
app_gateway_sku = "Standard_v2"
app_gateway_tier = "Standard_v2"

aks_service_cidr = "10.0.0.0/16"
aks_dns_service_ip = "10.0.0.10"

vm_username = "ubuntu"

