provider "azurerm"{
    features{}
}
data "azurerm_user_assigned_identity" "AKSIDENTITY" {
  name = "myownidentity"
  resource_group_name = "learning"
}
data "azurerm_subnet" "subnet" {
  name = "aks-subnet"
  resource_group_name = "learning"
  virtual_network_name = "vnet2"
}
resource "azurerm_kubernetes_cluster" "aks" {
  name = "aks-test"
  resource_group_name = "learning"
  dns_prefix = "aks-test"
  location = "east us"
  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_DS2_v2"
    enable_auto_scaling = true
    max_count = 3
    min_count = 1
    vnet_subnet_id = data.azurerm_subnet.subnet.id
  }
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    dns_service_ip = "178.0.0.10"
    service_cidr = "178.0.0.0/16"
    docker_bridge_cidr = "172.17.0.1/16"
  }
  identity {
    type = "UserAssigned"
    user_assigned_identity_id = data.azurerm_user_assigned_identity.AKSIDENTITY.id
  }
  role_based_access_control {
    enabled = true
  }
}