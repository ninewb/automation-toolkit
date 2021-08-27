## Managed Disks

variable "disk_names" { type = list(string) }
variable "disk_sizes" { type = list(number) }
variable "disk_lun" { type = list(number) }

variable "azure_rg_name" {
  type = string
}

variable "azure_rg_location" {
  type = string
}

variable name {
  type = string
}

variable "node_count" {
  description = "Number of nodes to create"
  default     = 1
}

variable "virtual_machine_id" { type = map(list(string)) }