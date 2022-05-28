# https://docs.microsoft.com/en-us/azure/virtual-network/public-ip-addresses
resource "azurerm_public_ip" "vm_ip" {
  count               = var.create_public_ip ? var.node_count : 0
  name                = "${var.name}-${count.index}-public_ip"
  location            = var.azure_rg_location
  resource_group_name = var.azure_rg_name
  allocation_method   = "Static"
  sku                 = var.vm_zone == null ? "Basic" : "Standard"
  # DEPRECIATED - availability_zone is expected.
  #zones               = var.vm_zone == null ? [] : [var.vm_zone]
  tags                = var.tags
}

resource "azurerm_network_interface" "vm_nic" {
  count                         = var.node_count
  name                          = "${var.name}-${count.index}-nic"
  location                      = var.azure_rg_location
  resource_group_name           = var.azure_rg_name
  enable_accelerated_networking = length(regexall("/-nfs/", var.name)) > 0 ? true : var.enable_accelerated_networking

  ip_configuration {
    name                          = "${var.name}-${count.index}-ip_config"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.vm_ip[count.index].id : null
  }
  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "vm_nic_sg" {
  count                     = var.node_count
  network_interface_id      = azurerm_network_interface.vm_nic[count.index].id
  network_security_group_id = var.azure_nsg_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                        = var.node_count
  name                         = "${var.name}-${count.index}-vm"
  location                     = var.azure_rg_location
  proximity_placement_group_id = var.proximity_placement_group_id == "" ? null : var.proximity_placement_group_id
  resource_group_name          = var.azure_rg_name
  size                         = var.vm_type
  admin_username               = var.vm_admin
  zone                         = var.vm_zone

  network_interface_ids = [
    azurerm_network_interface.vm_nic[count.index].id,
  ]

  admin_ssh_key {
    username   = var.vm_admin
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_size
  }

  source_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  additional_capabilities {
    ultra_ssd_enabled = var.data_disk_storage_account_type == "UltraSSD_LRS" ? true : false
  }

  tags = var.tags
}