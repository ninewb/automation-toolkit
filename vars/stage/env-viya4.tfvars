# !NOTE! - These are only a subset of CONFIG-VARS.md provided as examples.
# Customize this file to add any variables from 'CONFIG-VARS.md' whose default values
# you want to change.

# ****************  REQUIRED VARIABLES  ****************
# These required variables' values MUST be provided by the User
prefix   = "viya4" # this is a prefix that you assign for the resources to be created
location = "eastus" # e.g., "eastus2"
ssh_public_key = "<path-to-public-key-on-host-running-iac>" # Name of file with public ssh key for connecting to the VMs
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzO+ELn4Y4lnfSH+mTjG+LXYoOprxqyzyZ/hJJN8xmp8+/Av/qONAcqEE4HhhGoekgkr1gN3J4bZUHl01QhKld55mpXKb+78T8wBzlQqmmvfkP1Ys0XpKr2b0CycjqiK8eeKjkx4eohnmR2qBHRaEE9PZVYHMlh1HuNo40R+gmNvQj6YbkBSXI6AFUsPpYs7lgjPzz5ItnQOZ6a72wh1Iiy159E2FsY9zi6z8Naaka/k37m2sfKd/+JPiR3JVq0tIMo+C4pb/xA+GeHVuVQPN7yRM5hSL3XrFW3rS+MCGxX/totlxbCHj7AXPiy+2xQgfZ2JCAWQ+7tZUyZB3K3dH0AzIk53OM599KK7K65BNwouNuYOiOLs1Fqgcd3VHy3cLTXXEYvHLmeoOLbSPMA9Y4B6dXJdXsm17ldOE1J308jwnztsF/XBD95FtoFHaQ5M1zUFDJ/cDpQAVpSB9q48K3LHHa815v42cU+8xp+TAypZhpghPB9cHRZ5d1tqLZjT0="

# ****************  REQUIRED VARIABLES  ****************

# !NOTE! - Without specifying your CIDR block access rules, ingress traffic
#          to your cluster will be blocked by default.

# **************  RECOMMENDED  VARIABLES  ***************
default_public_access_cidrs = [] # e.g., ["123.45.6.89/32"]
default_public_access_cidrs = ["10.3.0.0/16"]

# **************  RECOMMENDED  VARIABLES  ***************

# Tags can be specified matching your tagging strategy.
tags = {} # for example: { "owner|email" = "<you>@<domain>.<com>", "key1" = "value1", "key2" = "value2" }
