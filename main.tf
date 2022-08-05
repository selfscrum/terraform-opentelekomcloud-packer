#
# terraform-opentelekomcloud-packer
#
# Create a compute image in OTC with packer
# 
terraform {
  required_version = ">= 0.12.26"
}

provider "opentelekomcloud" {
  access_key  = var.access_key
  secret_key  = var.secret_key
  domain_name = var.domain_name
  tenant_name = var.tenant_name
  auth_url    = "https://iam.eu-de.otc.t-systems.com/v3"
}

resource "random_integer" "packer_keyfile" {
  min = 10000
  max = 19999

  provisioner "local-exec" {
    when = destroy      
    command = "echo 'You must delete the created private key in file key${self.result} manually!'"
  }

}

# Default VPC

data "opentelekomcloud_vpc_v1" "vpc" {
  name   = var.vpc_name
  shared = true
}

# Default SG
data "opentelekomcloud_networking_secgroup_v2" "secgroup" {
  name = var.sg_group
}

# Standard Image
data "opentelekomcloud_images_image_v2" "packer_source_image" {
  name     = var.source_image_name
}

# Temp EIP
resource "opentelekomcloud_networking_floatingip_v2" "packer_ip" {
}

# Temp Subnet
resource "opentelekomcloud_vpc_subnet_v1" "packer_subnet" {
  name       = format("%s_%d",var.target_image_name, random_integer.packer_keyfile.result)
  cidr       = cidrsubnet(data.opentelekomcloud_vpc_v1.vpc.cidr,8,16)
  vpc_id     = data.opentelekomcloud_vpc_v1.vpc.id
  gateway_ip = cidrhost(cidrsubnet(data.opentelekomcloud_vpc_v1.vpc.cidr,8,16), 1)

  tags = {
    workspace = "PACKER-TEMP"
    scope     = "PUBLIC"
  }
}

# Rule to open ssh port

resource "opentelekomcloud_networking_secgroup_rule_v2" "packer_sg_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = data.opentelekomcloud_networking_secgroup_v2.secgroup.id
}

# keypair for temp packer resource
# be careful where you store your statefile - this contains the private key in clear format!

resource "tls_private_key" "packer_keypair" {
  algorithm   = "ED25519"

  provisioner "local-exec" {
    command = "echo '${self.private_key_openssh}' > '${var.private_key_file_path}key${random_integer.packer_keyfile.result}' && chmod 400 '${var.private_key_file_path}key${random_integer.packer_keyfile.result}' && chown ${var.private_key_file_owner} '${var.private_key_file_path}key${random_integer.packer_keyfile.result}'"
  }
}

resource "opentelekomcloud_compute_keypair_v2" "packer_keypair" {
  name       = format("public_key_%s", random_integer.packer_keyfile.result)
  public_key = tls_private_key.packer_keypair.public_key_openssh
}

# Null Resoure to call packer locally

resource "null_resource" "packer" {

    lifecycle  {
        replace_triggered_by = [
        opentelekomcloud_networking_floatingip_v2.packer_ip.id
        ]
    }

    provisioner "local-exec" {
        environment = {
            # packer environment coming from built resources
            TF_floating_ip = opentelekomcloud_networking_floatingip_v2.packer_ip.id
            TF_network = opentelekomcloud_vpc_subnet_v1.packer_subnet.id
            TF_source_image = data.opentelekomcloud_images_image_v2.packer_source_image.id
            TF_ssh_keypair_name = opentelekomcloud_compute_keypair_v2.packer_keypair.name
            # packer environment coming from terraform variables
            ENV_ssh_private_key_file = format("%skey%s", var.private_key_file_path, random_integer.packer_keyfile.result)
            ENV_target_image_name = format("%s_%d", var.target_image_name, random_integer.packer_keyfile.result)
            ENV_ssh_username = var.source_image_ssh_user_name
            ENV_install_script_path = var.install_script_path
            ENV_wait_before_installing = var.wait_before_installing
            # credentials from secret.tfvars
            OTC_identity_endpoint = var.identity_endpoint
            OTC_domain_name = var.domain_name
            OTC_tenant_name = var.tenant_name
            OTC_region = var.region
            OTC_availability_zone = var.availability_zone
            OTC_username = var.username
            OTC_password = var.password
        }
        working_dir = var.packer_template_directory == "" ? "${path.module}/packer" : var.packer_template_directory
        command = "packer build ."
    }
}


