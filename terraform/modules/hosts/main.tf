# Generate inventory file for Ansible

resource "local_file" "hosts_cfg" {
  content = templatefile("${var.hosts_tmpl}",
    {
      controller = azurerm_linux_virtual_machine.sas.0.public_ip_address
      sas = join("\n", azurerm_linux_virtual_machine.sas.*.public_ip_address)
      cas = join("\n", azurerm_linux_virtual_machine.cas.*.public_ip_address)
      es = join("\n", azurerm_linux_virtual_machine.es.*.public_ip_address)
    }
  )
  filename = "../../common/stage/inventory/hosts.cfg"
}
