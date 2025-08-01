//************** Basic config variables**************//
variable "resource_group_name" {
  description = "Azure Resource Group name to build into"
  type = string
}

variable "resource_group_id" {
  description = "Azure Resource Group ID to use."
  type = string
  default = ""
}

variable "location" {
  description = "The location/region where resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type = string
}
//************** Virtual machine instance variables **************
variable "admin_username" {
  description = "Administrator username of deployed VM. Due to Azure limitations 'notused' name can be used"
  type        = string
  default     = "notused"
}

variable "admin_password" {
  description = "Administrator password of deployed Virtual Machine. The password must meet the complexity requirements of Azure"
  type = string
}

variable "serial_console_password_hash" {
  description = "Optional parameter, used to enable serial console connection in case of SSH key as authentication type"
  type = string
}

variable "maintenance_mode_password_hash" {
  description = "Maintenance mode password hash, relevant only for R81.20 and higher versions"
  type = string
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."
  default = {}
}

variable "boot_diagnostics" {
  type        = bool
  description = "Enable or Disable boot diagnostics"
  default     = true
}

variable "storage_account_additional_ips" {
  type = list(string)
  description = "IPs/CIDRs that are allowed access to the Storage Account"
  default = []
  validation {
      condition = !contains(var.storage_account_additional_ips, "0.0.0.0") && can([for ip in var.storage_account_additional_ips: regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", ip)])
      error_message = "Invalid IPv4 address."
  }
}
locals {
  serial_console_ips_per_location = {
    "eastasia" : ["20.205.69.28", "20.195.85.180"],
    "southeastasia" : ["20.205.69.28", "20.195.85.180"],
    "australiacentral" : ["20.53.53.224", "20.70.222.112"],
    "australiacentral2" : ["20.53.53.224", "20.70.222.112"],
    "australiaeast" : ["20.53.53.224", "20.70.222.112"],
    "australiasoutheast" : ["20.53.53.224", "20.70.222.112"],
    "brazilsouth" : ["91.234.136.63", "20.206.0.194"],
    "brazilsoutheast" : ["91.234.136.63", "20.206.0.194"],
    "canadacentral" : ["52.228.86.177", "52.242.40.90"],
    "canadaeast" : ["52.228.86.177", "52.242.40.90"],
    "northeurope" : ["52.146.139.220", "20.105.209.72"],
    "westeurope" : ["52.146.139.220", "20.105.209.72"],
    "francecentral" : ["20.111.0.244", "52.136.191.10"],
    "francesouth" : ["20.111.0.244", "52.136.191.10"],
    "germanynorth" : ["51.116.75.88", "20.52.95.48"],
    "germanywestcentral" : ["51.116.75.88", "20.52.95.48"],
    "centralindia" : ["20.192.168.150", "20.192.153.104"],
    "southindia" : ["20.192.168.150", "20.192.153.104"],
    "westindia" : ["20.192.168.150", "20.192.153.104"],
    "japaneast" : ["20.43.70.205", "20.189.228.222"],
    "japanwest" : ["20.43.70.205", "20.189.228.222"],
    "koreacentral" : ["20.200.196.96", "52.147.119.29"],
    "koreasouth" : ["20.200.196.96", "52.147.119.29"],
    "norwaywest" : ["20.100.1.184", "51.13.138.76"],
    "norwayeast" : ["20.100.1.184", "51.13.138.76"],
    "switzerlandnorth" : ["20.208.4.98", "51.107.251.190"],
    "switzerlandwest" : ["20.208.4.98", "51.107.251.190"],
    "uaecentral" : ["20.45.95.66", "20.38.141.5"],
    "uaenorth" : ["20.45.95.66", "20.38.141.5"],
    "uksouth" : ["20.90.132.144", "20.58.68.62"],
    "ukwest" : ["20.90.132.144", "20.58.68.62"],
    "swedencentral" : ["51.12.72.223", "51.12.22.174"],
    "swedensouth" : ["51.12.72.223", "51.12.22.174"],
    "centralus" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "eastus2" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "eastus" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "northcentralus" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "southcentralus" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "westus2" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "westus3" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "westcentralus" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "westus" : ["20.98.146.84", "20.98.194.64", "20.69.5.162", "20.83.222.102"],
    "eastus2euap" : ["20.45.242.18", "20.51.21.252"],
    "centraluseuap" : ["20.45.242.18", "20.51.21.252"]
  }
  serial_console_ips = contains(keys(local.serial_console_ips_per_location),var.location) ? local.serial_console_ips_per_location[var.location] : []
  storage_account_ip_rules = concat(local.serial_console_ips, var.storage_account_additional_ips)
}
variable "vm_instance_identity_type" {
  description = "Managed Service Identity type"
  type = string
  default = "SystemAssigned"
}

variable "template_name"{
  description = "Template name. Should be defined according to deployment type(ha, vmss)"
  type = string
}

variable "template_version"{
  description = "Template name. Should be defined according to deployment type(e.g. ha, vmss)"
  type = string
}

variable "bootstrap_script" {
  description = "An optional script to run on the initial boot"
  type = string
  default = ""
}

variable "os_version"{
  description = "GAIA OS version"
  type = string
}

locals { // locals for 'os_version' allowed values
  os_version_allowed_values = [
    "R81",
    "R8110",
    "R8120",
    "R82"
  ]
  // will fail if [var.installation_type] is invalid:
  validate_os_version_value = index(local.os_version_allowed_values, var.os_version)
}

variable "installation_type"{
  description = "Installation type. Allowed values: cluster, vmss"
  type = string
}

locals { // locals for 'installation_type' allowed values
  installation_type_allowed_values = [
    "cluster",
    "vmss",
    "management",
    "standalone",
    "gateway",
    "mds-primary",
    "mds-secondary",
    "mds-logserver"
  ]
  // will fail if [var.installation_type] is invalid:
  validate_installation_type_value = index(local.installation_type_allowed_values, var.installation_type)
}

variable "number_of_vm_instances"{
  description = "Number of VM instances to deploy"
  type = string
}

variable "allow_upload_download" {
  description = "Allow upload/download to Check Point"
  type = bool
}

variable "is_blink" {
  description = "Define if blink image is used for deployment"
}

variable "vm_size" {
  description = "Specifies size of Virtual Machine"
  type = string
}

locals {// locals for  'vm_size' allowed values
  allowed_vm_sizes = ["Standard_DS2_v2", "Standard_DS3_v2", "Standard_DS4_v2", "Standard_DS5_v2", "Standard_F2s",
    "Standard_F4s", "Standard_F8s", "Standard_F16s", "Standard_D4s_v3", "Standard_D8s_v3",
    "Standard_D16s_v3", "Standard_D32s_v3", "Standard_D64s_v3", "Standard_E4s_v3", "Standard_E8s_v3",
    "Standard_E16s_v3", "Standard_E20s_v3", "Standard_E32s_v3", "Standard_E64s_v3", "Standard_E64is_v3",
    "Standard_F4s_v2", "Standard_F8s_v2", "Standard_F16s_v2", "Standard_F32s_v2", "Standard_F64s_v2",
    "Standard_M8ms", "Standard_M16ms", "Standard_M32ms", "Standard_M64ms", "Standard_M64s",
    "Standard_D2_v2", "Standard_D3_v2", "Standard_D4_v2", "Standard_D5_v2", "Standard_D11_v2",
    "Standard_D12_v2", "Standard_D13_v2", "Standard_D14_v2", "Standard_D15_v2", "Standard_F2",
    "Standard_F4", "Standard_F8", "Standard_F16", "Standard_D4_v3", "Standard_D8_v3", "Standard_D16_v3",
    "Standard_D32_v3", "Standard_D64_v3", "Standard_E4_v3", "Standard_E8_v3", "Standard_E16_v3",
    "Standard_E20_v3", "Standard_E32_v3", "Standard_E64_v3", "Standard_E64i_v3", "Standard_DS11_v2",
    "Standard_DS12_v2", "Standard_DS13_v2", "Standard_DS14_v2", "Standard_DS15_v2", "Standard_D2_v5", "Standard_D4_v5",
    "Standard_D8_v5", "Standard_D16_v5","Standard_D32_v5", "Standard_D2s_v5", "Standard_D4s_v5", "Standard_D8s_v5",
    "Standard_D16s_v5", "Standard_D2d_v5", "Standard_D4d_v5", "Standard_D8d_v5", "Standard_D16d_v5", "Standard_D32d_v5",
    "Standard_D2ds_v5", "Standard_D4ds_v5", "Standard_D8ds_v5", "Standard_D16ds_v5", "Standard_D32ds_v5"
  ]
  // will fail if [var.vm_size] is invalid:
  validate_vm_size_value = index(local.allowed_vm_sizes, var.vm_size)
}
variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Delete datadisk when VM is terminated"
  default     = true
}

variable "publisher" {
  description = "CheckPoint publisher"
  default = "1723173839932"
}

//************** Storage image reference and plan variables ****************//
variable "vm_os_offer" {
  description = "The name of the image offer to be deployed.Choose from: check-point-cg-r81, check-point-cg-r8110, check-point-cg-r8120, check-point-cg-r82"
  type = string
}

locals { // locals for 'vm_os_offer' allowed values
  vm_os_offer_allowed_values = [
    "check-point-cg-r81",
    "check-point-cg-r8110",
    "check-point-cg-r8120",
    "check-point-cg-r82"
  ]
  // will fail if [var.vm_os_offer] is invalid:
  validate_os_offer_value = index(local.vm_os_offer_allowed_values, var.vm_os_offer)
  validate_os_version_match = regex(split("-", var.vm_os_offer)[3], lower(var.os_version))
}

variable "vm_os_sku" {
  /*
    Choose from:
      - "sg-byol"
      - "sg-ngtp" (for R81 and above)
      - "sg-ngtx" (for R81 and above)
      - "mgmt-byol"
      - "mgmt-25"
  */
  description = "The sku of the image to be deployed"
  type = string
}

locals { // locals for 'vm_os_sku' allowed values
  vm_os_sku_allowed_values = [
    "sg-byol",
    "sg-ngtp",
    "sg-ngtx",
    "mgmt-byol",
    "mgmt-25"
  ]
  // will fail if [var.vm_os_sku] is invalid:
  validate_vm_os_sku_value = index(local.vm_os_sku_allowed_values, var.vm_os_sku)
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. "
  type = string
  default = "latest"
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options is Standard_LRS, Premium_LRS"
  type = string
  default     = "Standard_LRS"
}

locals { // locals for 'storage_account_type' allowed values
  storage_account_type_allowed_values = [
    "Standard_LRS",
    "Premium_LRS"
  ]
  // will fail if [var.storage_account_type] is invalid:
  validate_storage_account_type_value = index(local.storage_account_type_allowed_values, var.storage_account_type)
}

variable "storage_account_tier" {
  description = "Defines the Tier to use for this storage account.Valid options are Standard and Premium"
  default = "Standard"
}

locals { // locals for 'storage_account_tier' allowed values
  storage_account_tier_allowed_values = [
   "Standard",
   "Premium"
  ]
  // will fail if [var.storage_account_tier] is invalid:
  validate_storage_account_tier_value = index(local.storage_account_tier_allowed_values, var.storage_account_tier)
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account.Valid options are LRS, GRS, RAGRS and ZRS"
  type = string
  default = "LRS"
}

locals { // locals for 'account_replication_type' allowed values
  account_replication_type_allowed_values = [
   "LRS",
   "GRS",
   "RAGRS",
   "ZRS"
  ]
  // will fail if [var.account_replication_type] is invalid:
  validate_account_replication_type_value = index(local.account_replication_type_allowed_values, var.account_replication_type)
}

variable "disk_size" {
  description = "Storage data disk size size(GB). Select a number between 100 and 3995"
  type = string
}

resource "null_resource" "disk_size_validation" {
  // Will fail if var.disk_size is less than 100 or more than 3995
  count = tonumber(var.disk_size) >= 100 && tonumber(var.disk_size) <= 3995 ? 0 : "variable disk_size must be a number between 100 and 3995"
}

//************** Storage OS disk variables **************//
variable "storage_os_disk_create_option" {
  description = "The method to use when creating the managed disk"
  type = string
  default = "FromImage"
}

variable "storage_os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk"
  default = "ReadWrite"
}

variable "managed_disk_type" {
  description = "Specifies the type of managed disk to create. Possible values are either Standard_LRS, StandardSSD_LRS, Premium_LRS"
  type = string
  default     = "Standard_LRS"
}

locals { // locals for 'managed_disk_type' allowed values
  managed_disk_type_allowed_values = [
   "Standard_LRS",
   "Premium_LRS"
  ]
  // will fail if [var.managed_disk_type] is invalid:
  validate_managed_disk_type_value = index(local.managed_disk_type_allowed_values, var.managed_disk_type)
}

variable "authentication_type" {
  description = "Specifies whether a password authentication or SSH Public Key authentication should be used"
  type = string
}
locals { // locals for 'authentication_type' allowed values
  authentication_type_allowed_values = [
    "Password",
    "SSH Public Key"
  ]
  // will fail if [var.authentication_type] is invalid:
  validate_authentication_type_value = index(local.authentication_type_allowed_values, var.authentication_type)
}


//********************** Role Assignments variables**************************//
variable "role_definition" {
  description = "Role definition. The full list of Azure Built-in role descriptions can be found at https://docs.microsoft.com/bs-latn-ba/azure/role-based-access-control/built-in-roles"
  type = string
  default = "Contributor"
}