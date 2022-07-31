variable identity_endpoint {
  type = string
  description = "OTC URL for the API"  
}

variable access_key { 
  type = string
  description = "OTC AK. Don't use together with username/password"  
}

variable secret_key { 
  type = string
  description = "OTC SK. Don't use together with username/password"  
}

variable domain_name { 
  type = string
  description = "OTC Domain"
}

variable tenant_name { 
  type = string
  description = "OTC tenant (i.e. project name)"
}

variable region { 
  type = string
  description = "OTC region"
}

variable availability_zone { 
  type = string
  description = "OTC availability zone"
}

variable username { 
  type = string
  description = "Don't use together with AK/SK"
}

variable password { 
  type = string
  description = "Don't use together with AK/SK"
}

variable "vpc_name" {
    type = string
    default = "vpc-default"
    description = "Existing VPC that will be used for packer instance"
}

variable "sg_group" {
    type = string
    default = "default"
    description = "Security Group that will be extended by a port 22 rule"
}

variable "source_image_name" {
    type = string
    default = "Standard_Ubuntu_20.04_latest"
    description = "Name of the OTC source image"
}

variable "source_image_ssh_user_name" {
    type = string
    default = "ubuntu"
    description = "User name needed for default login at the OTC source image"
}

variable "image_name" {
    type = string
    default = "packer_image"
    description = "Target image name"
}

variable "private_key_file_path" {
    type = string
    default = "/home/desixma/.ssh/"
    description = "Linux user who owns the private key file, ending with '/'"
}

variable "private_key_file_owner" {
    type = string
    description = "Linux user who owns the private key file"
    default = "desixma"
}

variable "install_script_path" {
    type = string
    default = "./empty.sh"
    description = "Local path to the install script."
}

variable "wait_before_installing" {
    type = number
    default = 10
    description = "Waiting time in seconds before the install script starts (avoids service boot issues on some machines)"
}

