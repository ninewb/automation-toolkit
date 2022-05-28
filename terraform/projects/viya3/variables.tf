# RESOURCE GROUP

variable "prefix" {
  description = "A prefix used in the name for all cloud resources created by this script. The prefix string must start with lowercase letter and contain only lowercase alphanumeric characters and hyphen or dash(-), but can not start or end with '-'."
  type        = string

  validation {
    condition     = can(regex("^[a-z][-0-9a-z]*[0-9a-z]$", var.prefix)) && length(var.prefix) > 2 && length(var.prefix) < 21
    error_message = "ERROR: Value of 'prefix'\n * must start with lowercase letter and at most be 20 characters in length\n * can only contain lowercase letters, numbers, and hyphen or dash(-), but can't start or end with '-'."
  }
}

variable "resource_group_name" {
  type    = string
  default = null
  description = "Name of pre-exising resource group. Leave blank to have one created"
}

variable "location" {
  description = "The Azure Region to provision all resources in this script"
  default     = "East US"
}

# NETWORK SECURITY GROUP

variable "nsg_name" {
  type    = string
  default = null
  description = "Name of pre-exising NSG. Leave blank to have one created"
}

# VNET

variable "vnet_name" {
  type    = string
  default = null
  description = "Name of pre-exising vnet. Leave blank to have one created"
}

variable "segmented_network" {
  type    = string
  default = false
  description = "Set to true some of your network resources are managed in a different resource group"
}

variable "vnet_resource_group" {
  type    = string
  default = null
  description = "Name of pre-exising resource group. Leave blank to have one created"
}

variable "vnet_address_space" {
  type        = string
  default     = "192.168.0.0/16"
  description = "Address space for created vnet"
}

variable "subnet_names" {
  type        = map(string)
  default     = {}
  description = "Map subnet usage roles to existing subnet names"
  # Example:
  # subnet_names = {
  #   'aks': 'my_aks_subnet', 
  #   'misc': 'my_misc_subnet', 
  #   'netapp': 'my_netapp_subnet'
  # }
}

variable "subnets" {
  type = map(object({
    prefixes                                       = list(string)
    service_endpoints                              = list(string)
    enforce_private_link_endpoint_network_policies = bool
    enforce_private_link_service_network_policies  = bool
    service_delegations                            = map(object({
      name    = string
      actions = list(string)
    }))
  }))
  default = {
    aks = {
      "prefixes": ["192.168.0.0/23"],
      "service_endpoints": ["Microsoft.Sql"],
      "enforce_private_link_endpoint_network_policies": false,
      "enforce_private_link_service_network_policies": false,
      "service_delegations": {},
    }
    misc = {
      "prefixes": ["192.168.2.0/24"],
      "service_endpoints": ["Microsoft.Sql"],
      "enforce_private_link_endpoint_network_policies": false,
      "enforce_private_link_service_network_policies": false,
      "service_delegations": {},
    }
    netapp = {
      "prefixes": ["192.168.3.0/24"],
      "service_endpoints": [],
      "enforce_private_link_endpoint_network_policies": false,
      "enforce_private_link_service_network_policies": false,
      "service_delegations": {
        netapp = {
          "name"    : "Microsoft.Netapp/volumes"
          "actions" : ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    }
  }
}

# NODES

variable "nodes" {
    type = map(object({
        count = number
        os_size = number
        md_size = number
        vm_type = string
    }))
}

variable "create_public_ip" {
  default = true
}

variable "vm_admin" {
  description = "OS Admin User for VM"
  default     = "azureuser"
}

variable "vm_zone" {
  description = "The Zone in which this Virtual Machine should be created. Changing this forces a new resource to be created"
  default     = null
}

variable "vm_machine_type" {
  default = "Standard_B2s"
  description = "SKU which should be used for this Virtual Machine"
}

variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "storage_type" {
  type    = string
  default = "standard"

  validation {
    condition     = contains(["standard", "ha"], lower(var.storage_type))
    error_message = "ERROR: Supported value for `storage_type` are - standard, ha."
  }
}

variable "tags" {
  description = "Map of common tags to be placed on the Resources"
  type        = map
  default     = {}
}
