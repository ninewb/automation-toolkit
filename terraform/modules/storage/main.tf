resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.default.name
    }

    byte_length = 8
}

resource "azurerm_storage_account" "default" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.default.name
    location                    = var.default_location
    account_replication_type    = "LRS"
    account_tier                = "Standard"
}

# Setup for "/opt"
resource "azurerm_managed_disk" "optmount" {
  name                 = "${azurerm_linux_virtual_machine.viya.name}-disk1"
  location             = var.resource_group_location
  resource_group_name  = azurerm_resource_group.default.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

resource "azurerm_virtual_machine_data_disk_attachment" "opt" {
  managed_disk_id    = azurerm_managed_disk.optmount.id
  virtual_machine_id = azurerm_linux_virtual_machine.viya.id
  lun                = "10"
  caching            = "ReadWrite"
}

# Setup for "/var/cache"
resource "azurerm_managed_disk" "varcache" {
  name                 = "${azurerm_linux_virtual_machine.viya.name}-disk2"
  location             = var.resource_group_location
  resource_group_name  = azurerm_resource_group.default.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 80
}

resource "azurerm_virtual_machine_data_disk_attachment" "varcache" {
  managed_disk_id    = azurerm_managed_disk.varcache.id
  virtual_machine_id = azurerm_linux_virtual_machine.viya.id
  lun                = "20"
  caching            = "ReadWrite"
}

# Setup for /cache
resource "azurerm_managed_disk" "optcache" {
  name                 = "${azurerm_linux_virtual_machine.viya.name}-disk3"
  location             = var.resource_group_location
  resource_group_name  = azurerm_resource_group.default.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 300
}

resource "azurerm_virtual_machine_data_disk_attachment" "optcache" {
  managed_disk_id    = azurerm_managed_disk.optcache.id
  virtual_machine_id = azurerm_linux_virtual_machine.viya.id
  lun                = "30"
  caching            = "ReadWrite"
}

# Setup for /mirror
resource "azurerm_managed_disk" "mirror" {
  name                 = "${azurerm_linux_virtual_machine.viya.name}-disk4"
  location             = var.resource_group_location
  resource_group_name  = azurerm_resource_group.default.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 75
}

resource "azurerm_virtual_machine_data_disk_attachment" "mirror" {
  managed_disk_id    = azurerm_managed_disk.mirror.id
  virtual_machine_id = azurerm_linux_virtual_machine.viya.id
  lun                = "40"
  caching            = "ReadWrite"
}

# Setup for /assets
resource "azurerm_managed_disk" "assets" {
  name                 = "${azurerm_linux_virtual_machine.viya.name}-disk5"
  location             = var.resource_group_location
  resource_group_name  = azurerm_resource_group.default.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 20
}

resource "azurerm_virtual_machine_data_disk_attachment" "mirror" {
  managed_disk_id    = azurerm_managed_disk.mirror.id
  virtual_machine_id = azurerm_linux_virtual_machine.viya.id
  lun                = "50"
  caching            = "ReadWrite"
}