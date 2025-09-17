
# Locals block for hardcoded names
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.test.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.test.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.test.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.test.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.test.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.test.name}-rqrt"
  app_gateway_subnet_name        = "appgwsubnet"
}

resource azurerm_resource_group rg {
  name     = var.resource_group_name
  location = var.location
}

resource random_pet azurerm_kubernetes_cluster_name {
  prefix = "cluster"
}

resource random_pet azurerm_kubernetes_cluster_dns_prefix {
  prefix = "dns"
}

resource azurerm_kubernetes_cluster k8s {
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  name                = random_pet.azurerm_kubernetes_cluster_name.id
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = var.vm_size
    node_count = var.node_count
    os_disk_size_gb = var.os_disk_size
    vnet_subnet_id  = data.azurerm_subnet.kubesubnet.id
  }

  linux_profile {
    admin_username = var.vm_username

    ssh_key {
      #key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  network_profile {
    # TODO: investigate
    network_plugin     = "azure"
    #network_plugin    = "kubenet"
    load_balancer_sku = "standard"
    dns_service_ip     = var.aks_dns_service_ip
    service_cidr       = var.aks_service_cidr
  }
  
  # TODO:
  # Added to enable IngressController functionality:
  #ingress_application_gateway { }
  #http_application_routing_enabled = true
}

resource local_file azure_kubeconfig {
    filename = var.kube_config_file
    content  = azurerm_kubernetes_cluster.k8s.kube_config_raw
}

resource azurerm_virtual_network test {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix]

  subnet {
    name             = var.aks_subnet_name
    address_prefixes = [ var.aks_subnet_address_prefix ]
  }

  subnet {
    name             = "appgwsubnet"
    address_prefixes = [ var.app_gateway_subnet_address_prefix ]
  }
}

data azurerm_subnet kubesubnet {
  name                 = var.aks_subnet_name
  virtual_network_name = azurerm_virtual_network.test.name
  resource_group_name  = azurerm_resource_group.rg.name
}

data azurerm_subnet appgwsubnet {
  name                 = "appgwsubnet"
  virtual_network_name = azurerm_virtual_network.test.name
  resource_group_name  = azurerm_resource_group.rg.name
}

# Public Ip 
resource azurerm_public_ip test {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource azurerm_application_gateway network {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = var.app_gateway_sku
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = data.azurerm_subnet.appgwsubnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.test.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }
}

