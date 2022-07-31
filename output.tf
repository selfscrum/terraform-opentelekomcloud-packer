output "target_image_name" {
    value = format("%s_%d", var.target_image_name, random_integer.packer_keyfile.result)
    description = "The name of the private image created at OTC"
}

output "local_private_key" {
    value = format("%skey%s", var.private_key_file_path, random_integer.packer_keyfile.result)
    description = "The path to the private key file on the local machine"
}