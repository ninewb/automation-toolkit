resource "azurerm_network_security_group" "catalyst" {
  name                = "${var.mod_resource_group_name}-nsg"
  location            = "${var.mod_resource_group_location}"
  resource_group_name = azurerm_resource_group.catalyst.name

  dynamic "security_rule" {
    for_each = [for x in var.sas_rules : {
      name                       = x.name
      priority                   = x.priority
      direction                  = x.direction
      access                     = x.access
      protocol                   = x.protocol
      source_port_ranges         = split(",", replace(x.source_port_ranges, "*", "0-65535"))
      destination_port_ranges    = split(",", replace(x.destination_port_ranges, "*", "0-65535"))
      source_address_prefix      = x.source_address_prefix
      destination_address_prefix = x.destination_address_prefix
      description                = x.description
    }]
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_ranges         = security_rule.value.source_port_ranges
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      description                = security_rule.value.description
    }
  }
}