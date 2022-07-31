# build the system.json file according to your needs

```
{
   "packer" : {
            "vpc_name" : "vpc-default",
            "sg_group" : "default",
            "source_image_name" : "Standard_Ubuntu_20.04_latest",
            "source_image_ssh_user_name" : "ubuntu",
            "target_image_name" : "packer_image",
            "private_key_file_path" : "/home/your-local-user/.ssh/",
            "private_key_file_owner" : "your-local-user",
            "install_script_path" : "../assets/example_install.sh",
            "wait_before_installing" : 10
    }
}
```
