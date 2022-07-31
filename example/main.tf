# create OTC image from local terraform as an example for the packer module

locals {
  system = jsondecode(file("../assets/system.json"))
}

module "packer" {
  source = "../../terraform-opentelekomcloud-packer"
  identity_endpoint = var.identity_endpoint
  access_key = var.access_key
  secret_key = var.secret_key
  domain_name = var.domain_name
  tenant_name = var.tenant_name
  region = var.region
  availability_zone = var.availability_zone
  username = var.username
  password = var.password

  vpc_name = local.system.packer["vpc_name"]
  sg_group = local.system.packer["sg_group"]
  source_image_name = local.system.packer["source_image_name"]
  source_image_ssh_user_name = local.system.packer["source_image_ssh_user_name"]
  target_image_name = local.system.packer["target_image_name"]
  private_key_file_path = local.system.packer["private_key_file_path"]
  private_key_file_owner = local.system.packer["private_key_file_owner"]
  install_script_path = local.system.packer["install_script_path"]
  wait_before_installing = local.system.packer["wait_before_installing"]
}  

output "target_image_name" {
  value = module.packer.target_image_name
  description = "The name of the private image created at OTC"
}

output "local_private_key" {
  value = module.packer.local_private_key
  description = "The path to the private key file on the local machine"
}
