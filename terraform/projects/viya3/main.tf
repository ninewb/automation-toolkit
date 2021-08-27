provider "azurerm" {

#  subscription_id = var.subscription_id
#  client_id       = var.client_id
#  client_secret   = var.client_secret
#  tenant_id       = var.tenant_id
#  partner_id      = var.partner_id
#  use_msi         = var.use_msi

  features {}
}

terraform {
  backend "azurerm" {}
}

#terraform {
#  backend "azurerm" {
#    resource_group_name  = "catalyst-devops-rg"
#    storage_account_name = "catalystdevopsacc"
#    container_name       = "catacontainer"
#    key                  = "dev.terraform.tfstate"
#  }
#}


data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

locals {
  subnets = { for k, v in var.subnets : k => v if ! ( k == "netapp" && var.storage_type == "standard")}
}

module "resource_group" {
  source   = "../../modules/azurerm_resource_group"

  prefix   = var.prefix
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "nsg" {
  source              = "../../modules/azurerm_network_security_group"

  prefix              = var.prefix
  name                = var.nsg_name
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = module.resource_group.tags

  depends_on          = [module.resource_group]
}

module "vnet" {
  source              = "../../modules/azurerm_vnet"

  name                = var.vnet_name
  prefix              = var.prefix
  resource_group_name = var.segmented_network == "false" ? module.resource_group.name : var.vnet_resource_group
  location            = var.location
  subnets             = local.subnets
  existing_subnets    = var.subnet_names
  address_space       = [var.vnet_address_space]
  tags                = module.resource_group.tags

  depends_on          = [module.resource_group]
}

module "nodes" {
  for_each          = var.nodes

  source            = "../../modules/azurerm_vm"
  
  name              = each.key
  node_count        = each.value.count
  azure_rg_name     = module.resource_group.name
  azure_rg_location = var.location
  vnet_subnet_id    = module.vnet.subnets["misc"].id
  vm_type           = each.value.vm_type
  os_size           = each.value.os_size
  md_size           = each.value.md_size
  azure_nsg_id      = module.nsg.id
  tags              = module.resource_group.tags
  vm_admin          = var.vm_admin
  vm_zone           = var.vm_zone
  ssh_public_key    = var.ssh_public_key
  create_public_ip  = var.create_public_ip

  depends_on        = [module.vnet]
}

