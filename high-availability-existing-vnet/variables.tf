//********************** Basic Configuration Variables **************************//
variable "cluster_name" {
  description = "Cluster name"
  type = string
}

variable "resource_group_name" {
  description = "Azure Resource Group name to build into"
  type = string
}

variable "location" {
  description = "The location/region where resources will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type = string
}

//********************** Virtual Machine Instances Variables **************************//
variable "availability_type" {
  description = "Specifies whether to deploy the solution based on Azure Availability Set or based on Azure Availability Zone."
  type = string
  default = "Availability Zone"
}

locals { // locals for 'availability_type' allowed values
  availability_type_allowed_values = [
    "Availability Zone",
    "Availability Set"
  ]
  // will fail if [var.availability_type] is invalid:
  validate_availability_type_value = index(local.availability_type_allowed_values, var.availability_type)
}

variable "source_image_vhd_uri" {
  type = string
  description = "The URI of the blob containing the development image. Please use noCustomUri if you want to use marketplace images."
  default = "noCustomUri"
}

variable "admin_username" {
  description = "Administrator username of deployed VM. Due to Azure limitations 'notused' name can be used"
  default = "notused"
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

variable "smart_1_cloud_token_a" {
  description = "Smart-1 Cloud Token, for configuring member A"
  type = string
}

variable "smart_1_cloud_token_b" {
  description = "Smart-1 Cloud Token, for configuring member B"
  type = string
}

variable "sic_key" {
  description = "Secure Internal Communication(SIC) key"
  type = string
}
resource "null_resource" "sic_key_invalid" {
  count = length(var.sic_key) >= 12 ? 0 : "SIC key must be at least 12 characters long"
}

variable "template_name" {
  description = "Template name. Should be defined according to deployment type(ha, vmss)"
  type = string
  default = "ha_terraform"
}

variable "template_version" {
  description = "Template version. It is recommended to always use the latest template version"
  type = string
  default = "20230910"
}

variable "installation_type" {
  description = "Installation type"
  type = string
  default = "cluster"
}

variable "number_of_vm_instances" {
  description = "Number of VM instances to deploy "
  type = string
  default = "2"
}

variable "vm_size" {
  description = "Specifies size of Virtual Machine"
  type = string
}

variable "disk_size" {
  description = "Storage data disk size size(GB). Select a number between 100 and 3995"
  type = string
}

variable "os_version" {
  description = "GAIA OS version"
  type = string
}

locals { // locals for 'vm_os_offer' allowed values
  os_version_allowed_values = [
    "R81",
    "R8110",
    "R8120",
    "R82"
  ]
  // will fail if [var.os_version] is invalid:
  validate_os_version_value = index(local.os_version_allowed_values, var.os_version)
}

variable "vm_os_sku" {
  description = "The sku of the image to be deployed."
  type = string
}

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

variable "allow_upload_download" {
  description = "Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point"
  type = bool
}

variable "is_blink" {
  description = "Define if blink image is used for deployment"
  default = true
}

variable "admin_shell" {
  description = "The admin shell to configure on machine or the first time"
  type = string
  default = "/etc/cli.sh"
}

locals {
  admin_shell_allowed_values = [
    "/etc/cli.sh",
    "/bin/bash",
    "/bin/csh",
    "/bin/tcsh"
  ]
  // Will fail if [var.admin_shell] is invalid
  validate_admin_shell_value = index(local.admin_shell_allowed_values, var.admin_shell)
}

//********************** Networking Variables **************************//
variable "vnet_name" {
  description = "Virtual Network name"
  type = string
}

variable "vnet_resource_group" {
  description = "Resource group of existing vnet"
  type = string
}

variable "frontend_subnet_name" {
  description = "Frontend subnet name"
  type = string
}

variable "backend_subnet_name" {
  description = "Backend subnet name"
  type = string
}

variable "frontend_IP_addresses" {
  description = "A list of three whole numbers representing the private ip addresses of the members eth0 NICs and the cluster vip ip addresses. The numbers can be represented as binary integers with no more than the number of digits remaining in the address after the given frontend subnet prefix. The IP addresses are defined by their position in the frontend subnet."
  type = list(number)
}

variable "backend_IP_addresses" {
  description = "A list of three whole numbers representing the private ip addresses of the members eth1 NICs and the backend lb ip addresses. The numbers can be represented as binary integers with no more than the number of digits remaining in the address after the given backend subnet prefix. The IP addresses are defined by their position in the backend subnet."
  type = list(number)
}

variable "vnet_allocation_method" {
  description = "IP address allocation method"
  type = string
  default = "Static"
}

variable "lb_probe_name" {
  description = "Name to be used for lb health probe"
  default = "health_prob_port"
}

variable "lb_probe_port" {
  description = "Port to be used for load balancer health probes and rules"
  default = "8117"
}

variable "lb_probe_protocol" {
  description = "Protocols to be used for load balancer health probes and rules"
  default = "Tcp"
}

variable "lb_probe_unhealthy_threshold" {
  description = "Number of times load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy."
  default = 2
}

variable "lb_probe_interval" {
  description = "Interval in seconds load balancer health probe rule performs a check"
  default = 5
}

variable "bootstrap_script" {
  description = "An optional script to run on the initial boot"
  #example:
  #"touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
}

variable "add_storage_account_ip_rules" {
  type = bool
  default = false
  description = "Add Storage Account IP rules that allow access to the Serial Console only for IPs based on their geographic location"
}

variable "storage_account_additional_ips" {
  type = list(string)
  description = "IPs/CIDRs that are allowed access to the Storage Account"
  default = []
}
//********************** Credentials **************************//
variable "tenant_id" {
  description = "Tenant ID"
  type = string
}

variable "subscription_id" {
  description = "Subscription ID"
  type = string
}

variable "client_id" {
  description = "Application ID(Client ID)"
  type = string
}

variable "client_secret" {
  description = "A secret string that the application uses to prove its identity when requesting a token. Also can be referred to as application password."
  type = string
}

variable "sku" {
  description = "SKU"
  type = string
  default = "Standard"
}

variable "enable_custom_metrics" {
  description = "Indicates whether CloudGuard Metrics will be use for Cluster members monitoring."
  type = bool
  default = true
}

variable "enable_floating_ip" {
  description = "Indicates whether the load balancers will be deployed with floating IP."
  type = bool
  default = false
}

variable "use_public_ip_prefix" {
  description = "Indicates whether the public IP resources will be deployed with public IP prefix."
  type = bool
  default = false
}

variable "create_public_ip_prefix" {
  description = "Indicates whether the public IP prefix will created or an existing will be used."
  type = bool
  default = false
}

variable "existing_public_ip_prefix_id" {
  description = "The existing public IP prefix resource id."
  type = string
  default = ""
}

locals{
  # Validate both s1c tokens are used or both empty
  is_both_tokens_used = length(var.smart_1_cloud_token_a) > 0 == length(var.smart_1_cloud_token_b) > 0
  validation_message_both = "To connect to Smart-1 Cloud, you must provide two tokens (one per member)"
  _ = regex("^$", (local.is_both_tokens_used ? "" : local.validation_message_both))

  is_tokens_used = length(var.smart_1_cloud_token_a) > 0
  # Validate both s1c tokens are unqiue
  token_parts_a = split(" ",var.smart_1_cloud_token_a)
  token_parts_b = split(" ",var.smart_1_cloud_token_b)
  acutal_token_a = local.token_parts_a[length(local.token_parts_a) - 1]
  acutal_token_b = local.token_parts_b[length(local.token_parts_b) - 1]
  is_both_tokens_the_same = local.acutal_token_a == local.acutal_token_b
  validation_message_unique = "Same Smart-1 Cloud token used for both memeber, you must provide unique token for each member"
  __ = local.is_tokens_used ? regex("^$", (local.is_both_tokens_the_same ? local.validation_message_unique : "")) : ""
}

variable "environment" {
  description = "Cloud environment"
  type = string
  default = "china"
}