# configuration

variable "TF_floating_ip" {
    type = string
    default = env("TF_floating_ip")
}

variable "TF_network" {
    type = string
    default = env("TF_network")
}

variable "TF_source_image" {
    type = string
    default = env("TF_source_image")
}


variable "TF_ssh_keypair_name" {
    type = string
    default = env("TF_ssh_keypair_name")
}

variable "ENV_target_image_name" {
    type = string
    default = env("ENV_target_image_name")
}

variable "ENV_ssh_username" {
    type = string
    default = env("ENV_ssh_username")
}
variable "ENV_ssh_private_key_file" {
    type = string
    default = env("ENV_ssh_private_key_file")
}

variable "ENV_install_script_path" {
    type = string
    default = env("ENV_install_script_path")
}

variable "ENV_wait_before_installing" {
    type = string
    default = env("ENV_wait_before_installing")
}

# OTC credentials and coordinates

variable "OTC_identity_endpoint" {
    type = string
    default = env("OTC_identity_endpoint")
}

variable "OTC_domain_name" {
    type = string
    default = env("OTC_domain_name")
}

variable "OTC_tenant_name" {
    type = string
    default = env("OTC_tenant_name")
}

variable "OTC_region" {
    type = string
    default = env("OTC_region")
}

variable "OTC_availability_zone" {
    type = string
    default = env("OTC_availability_zone")
}

variable "OTC_username" {
    type = string
    default = env("OTC_username")
}

variable "OTC_password" {
    type = string
    default = env("OTC_password")
}