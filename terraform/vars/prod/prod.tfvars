prefix   = "catalyst" # prefix that you assign for the resources to be created
location = "eastus" # e.g. "eastus2"
vm_admin = "sasadmin"
ssh_public_key = "~/.ssh/azure_rsa.pub" # Name of file with public ssh key for connecting to the VMs
create_public_ip = "false" # Determine whether to incorporate a public IP in your vnet

# ****************  SEGMENTED NETWORK  ****************
# These variables should be populated with network resouces to use with
# your deployment, often leveraged for IT control over endpoint access.

segmented_network = "true"
vnet_resource_group = "azuse-usps-private-sector-fraud-vpn-rg"
#nsg_name = "azuse-usps-private-sector-fraud-subnet-nsg"
vnet_name = "azuse-usps-private-sector-fraud-vpn-vnet"
subnet_names = {
  "segment": "azuse-usps-private-sector-fraud-subnet"
}

nodes = {
  sas = {
    count      = 3
    vm_type    = "Standard_DS1_v2"
    os_size    = 200
    md_size    = 300
    disk_names = ["yumcache", "optsas", "sascache", "saswork", "sasdata", "assets"]
    disk_sizes = [50, 200, 300, 100, 50, 25]
    disk_lun   = [10, 20, 30, 40, 50, 60]
  }
  cas = {
    count      = 1
    vm_type    = "Standard_DS1_v2"
    os_size    = 200
    md_size    = 300
    disk_names = ["yumcache", "optsas", "sascache"]
    disk_sizes = [50, 200, 300]
    disk_lun   = [10, 20, 30]
  }
  es = {
    count      = 1
    vm_type    = "Standard_DS1_v2"
    os_size    = 200
    md_size    = 300
    disk_names = ["yumcache", "optsas"]
    disk_sizes = [50, 200]
    disk_lun   = [10, 20]
  }
}

# Tags can be specified matching your tagging strategy.
tags = {} # for example: { "owner|email" = "<you>@<domain>.<com>", "key1" = "value1", "key2" = "value2" }