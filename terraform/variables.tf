variable "subscription_id" {
  description = "Subscription id of the account"
  type = string
  default = "c5803b2b-9f6c-4028-b835-cf4828eebaf8"
}

variable "location" {
    description = "location of service"
    type = string
    default = "eastus2"
}

variable "resource_group_name" {
  description = "resource group name"
  type = string
  default = "rg-jenkins-docker-aks"
  
}

variable "os" {
  description = "Operating system"
  type = string
  default = "Linux"
}

variable "aks_name" {
  description = "Name of the AKS cluster"
  type = string
  default = "aks-cluster-docker-jenkins"
}

variable "acr_name" {
    description = "Name of the ACR"
    type = string
    default = "acrjenkinsdocker"
  
}