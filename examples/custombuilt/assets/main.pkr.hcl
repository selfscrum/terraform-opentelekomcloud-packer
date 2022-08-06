# main.pkr.hcl
#
# this is the core packer configuration.
# you can use it standalone without the terraform module if you already have a suitable environment in your OTC account.
# In this case, adopt variables in a separate .tfvars file or in the environment to your needs, and run "packer build ."
#

source "openstack" "otc_packer_image" {
    identity_endpoint       = var.OTC_identity_endpoint
    domain_name             = var.OTC_domain_name
    tenant_name             = var.OTC_tenant_name
    region                  = var.OTC_region
    availability_zone       = var.OTC_availability_zone
    password                = var.OTC_password
    username                = var.OTC_username
    flavor                  = "s3.medium.1"
    floating_ip             = var.TF_floating_ip
    networks                = [ var.TF_network ]
    source_image            = var.TF_source_image
    ssh_keypair_name        = var.TF_ssh_keypair_name
    image_name              = var.ENV_target_image_name
    instance_name           = format("%s_instance", var.ENV_target_image_name)
    ssh_private_key_file    = var.ENV_ssh_private_key_file
    ssh_username            = var.ENV_ssh_username
    use_blockstorage_volume = true
  }
  
build {
    sources = ["source.openstack.otc_packer_image"]

    provisioner "shell" {
        inline = ["sleep ${var.ENV_wait_before_installing}"]
        execute_command = "echo '${var.ENV_environment}' > /home/ubuntu/environment.txt"
    }

    post-processor "manifest" {
        output     = format("packer-%s-result.log", var.ENV_target_image_name)
        strip_path = true
    }
}
  