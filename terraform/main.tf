provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
    name                = var.acr_name
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    sku                 = "Basic"
    admin_enabled       = true
    
}

resource "azurerm_kubernetes_cluster" "aks" {
    name                = var.aks_name
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    dns_prefix          = "aks-cluster-docker-jenkins"

    default_node_pool {
        name                = "agentpool"
        node_count          = 1
        vm_size             = "Standard_B2ms"
    }

    identity {
        type = "SystemAssigned"
    }

    linux_profile {
        admin_username = "azureuser"

        ssh_key {
            key_data = file("~/.ssh/aks_ssh_key.pub")
        }
    }
}

resource "azurerm_role_assignment" "acr_pull" {
    scope                = azurerm_container_registry.acr.id
    role_definition_name = "AcrPull"
    principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  }

