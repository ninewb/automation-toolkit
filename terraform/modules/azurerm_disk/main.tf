resource "azurerm_managed_disk" "disk" {  
  count                = var.node_count == 0 ? 0 : "${length(var.disk_names)}"
  name                 = "${var.name}-${var.disk_names[count.index % length(var.disk_names)]}-${count.index}-disk"
  location             = var.azure_rg_location 
  resource_group_name  = var.azure_rg_name 
  storage_account_type = "Standard_LRS"  
  create_option        = "Empty"  
  disk_size_gb         = "${var.disk_sizes[count.index % length(var.disk_sizes)]}"  
 }

/*
resource "azurerm_virtual_machine_data_disk_attachment" "disk" {  
  count              = "${length(var.disk_names)}"
  managed_disk_id    = "${azurerm_managed_disk.vm[count.index % length(azurerm_managed_disk.vm)].id}"  
  virtual_machine_id = azurerm_linux_virtual_machine.vm[var.node_count].id
  lun                = var.disk_lun 
  caching            = "ReadWrite"  
 }
*/