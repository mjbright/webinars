
variable "kube_config_file" {
  default     = "azure.kubeconfig"
}

variable "resource_group_name" {
}

variable public_ip_name {
}

variable "location" {
  type        = string
  description = "Location of the resource group."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "vm_size" {
  type        = string
  description = "VM size"
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual network name"
}

variable "virtual_network_address_prefix" {
  type        = string
  description = "VNET address prefix"
}

variable "aks_subnet_name" {
  type        = string
  description = "Subnet Name."
}

variable "aks_subnet_address_prefix" {
  type        = string
  description = "Subnet address prefix."
}

variable "app_gateway_subnet_address_prefix" {
  type        = string
  description = "Subnet server IP address."
}

variable "app_gateway_name" {
  type        = string
  description = "Name of the Application Gateway"
}

variable "app_gateway_sku" {
  type        = string
  description = "Name of the Application Gateway SKU"
}

variable "app_gateway_tier" {
  type        = string
  description = "Tier of the Application Gateway tier"
}

variable "os_disk_size" {
  type        = number
  description = "Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "aks_service_cidr" {
  type        = string
  description = "CIDR notation IP range from which to assign service cluster IPs"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "DNS server IP address"
}

variable "vm_username" {
  type        = string
  description = "User name for the VM"
}

