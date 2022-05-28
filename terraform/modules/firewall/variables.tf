variable "sas_rules" {
  type    = list(map(string))
  default = [
    {
      name                       = "SAS_VPN"
      priority                   = "110"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_ranges         = "*"
      destination_port_ranges    = "*"
      source_address_prefix      = "149.173.0.0/16"
      destination_address_prefix = "*"
      description                = "Allow traffic over the SAS VPN"
    },
    {
      name                       = "SAS_Open_01"
      priority                   = "120"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_ranges         = "*"
      destination_port_ranges    = "*"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
      description                = "Allow traffic for SAS Open network"
    },
    {
      name                       = "SAS_Open_02"
      priority                   = "130"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_ranges         = "*"
      destination_port_ranges    = "*"
      source_address_prefix      = "172.16.0.0/12"
      destination_address_prefix = "*"
      description                = "Allow traffic for SAS Open network"
    }
  ]
}