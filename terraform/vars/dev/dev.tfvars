prefix   = "bofa" # prefix that you assign for the resources to be created
location = "eastus" # e.g. "eastus2"
vm_admin = "sasadmin"
#ssh_public_key = "~/.ssh/azure_rsa.pub" # Name of file with public ssh key for connecting to the VMs
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzO+ELn4Y4lnfSH+mTjG+LXYoOprxqyzyZ/hJJN8xmp8+/Av/qONAcqEE4HhhGoekgkr1gN3J4bZUHl01QhKld55mpXKb+78T8wBzlQqmmvfkP1Ys0XpKr2b0CycjqiK8eeKjkx4eohnmR2qBHRaEE9PZVYHMlh1HuNo40R+gmNvQj6YbkBSXI6AFUsPpYs7lgjPzz5ItnQOZ6a72wh1Iiy159E2FsY9zi6z8Naaka/k37m2sfKd/+JPiR3JVq0tIMo+C4pb/xA+GeHVuVQPN7yRM5hSL3XrFW3rS+MCGxX/totlxbCHj7AXPiy+2xQgfZ2JCAWQ+7tZUyZB3K3dH0AzIk53OM599KK7K65BNwouNuYOiOLs1Fqgcd3VHy3cLTXXEYvHLmeoOLbSPMA9Y4B6dXJdXsm17ldOE1J308jwnztsF/XBD95FtoFHaQ5M1zUFDJ/cDpQAVpSB9q48K3LHHa815v42cU+8xp+TAypZhpghPB9cHRZ5d1tqLZjT0="
create_public_ip = "true" # Determine whether to incorporate a public IP in your vnet

# ****************  SEGMENTED NETWORK  ****************
# These variables should be populated with network resouces to use with
# your deployment, often leveraged for IT control over endpoint access.

segmented_network = "false"
#vnet_resource_group = "azuse-usps-private-sector-fraud-vpn-rg"
#nsg_name = "azuse-usps-private-sector-fraud-subnet-nsg"
#vnet_name = "azuse-usps-private-sector-fraud-vpn-vnet"
#subnet_names = {
#  "segment": "azuse-usps-private-sector-fraud-subnet"
#}

nodes = {
  general = {
    count      = 1
    vm_type    = "Standard_D32s_v4"
    os_size    = 200
    md_size    = 100
  }
  cas-controller = {
    count      = 0
    vm_type    = "Standard_D8s_v4"
    os_size    = 200
    md_size    = 100
  }  
  cas-worker = {
    count      = 0
    vm_type    = "Standard_E4s_v4"
    os_size    = 200
    md_size    = 500
  }
  programming = {
    count      = 0
    vm_type    = "Standard_E16s_v4"
    os_size    = 200
    md_size    = 50
  }
  postgres = {
    count      = 0
    vm_type    = "Standard_D16s_v4"
    os_size    = 200
    md_size    = 50
  }
  es = {
    count      = 0
    vm_type    = "Standard_E4s_v4"
    os_size    = 200
    md_size    = 200
 
  }
}

# Tags can be specified matching your tagging strategy.
tags = {"environment" = "dev"} # for example: { "owner|email" = "<you>@<domain>.<com>", "key1" = "value1", "key2" = "value2" }