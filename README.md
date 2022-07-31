# terraform-opentelekomcloud-packer

Creates all resources to build an OTC private image and calls packer with the required configuration

## Need

Using packer with OTC comes with some prerequisites.

1. You need an already registered keypair within OTC, the private key of which you have access to locally.
2. You need an EIP already registered within OTC.
3. Your network needs to accept ssh acces, thus you will need a security group that allows inbound access via port 22.

All of these artifacts are only needed for the time span that packer runs. Instead of doing all this work manually, this module manages everything for you.

(alternative idea for later: we could use terratest with calling packer from within the go test code)

I use a JSON file to do all my project configurations. This is the file I refer to in the locals blocks.

```
{
    "tfc_organization" :"selfscrum",
    "tfc_description" : "VPC on OTC",
    "workspace" : "nc_o",
    "env_stage" : "dev",
     ...
    "packer" : {
            "vpc_name" : "vpc-default",
            "sg_group" : "default",
            "source_image_name" : "Standard_Ubuntu_20.04_latest",
            "source_image_ssh_user_name" : "ubuntu",
            "target_image_name" : "packer_image",
            "private_key_file_path" : "/home/desixma/.ssh/",
            "private_key_file_owner" : "desixma",
            "install_script_path" : "../../../assets/nomadconsul_install.sh",
            "wait_before_installing" : 10
    }

}     
```

You might need to adapt paths.
