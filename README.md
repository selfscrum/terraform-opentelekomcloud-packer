# terraform-opentelekomcloud-packer

Creates all resources to build an OTC private image and calls packer with the required configuration

## Need

Using packer with OTC comes with some prerequisites.

1. You need an already registered keypair within OTC, the private key of which you have access to locally.
2. You need an EIP already registered within OTC.
3. Your network needs to accept ssh acces, thus you will need a security group that allows inbound access via port 22.

## Solution 

![module-architecture](./assets/packer-otc.png)

All of the created artifacts are only needed for the time span that packer runs. Instead of doing all this work manually, this module manages everything for you. We will use the default VPC and borrow the default security group to temporarily attach a port 22 access.

(alternative idea for later: we could use terratest with calling packer from within the go test code)

## Configuration

I use a JSON file to do all my project configurations. IT is located in `assets\system.json`. Adopt to your needs. In this directory you find also the `dev-secret.tfvars` file template which you need to fill with your data. It is gitignored, so you should be safe here.

And of course, you'll need to provide an install script for your target image which will run with sudo. It is referenced in the `system.json`file.

## Run

Start the example from within the `example` directory. 

```
terraform apply -var-file="../assets/dev-secret.tfvars"
```

If successful you should get an image name, and the path to a local private key file. 

You can (and should) destroy the provisioned infrastructure immediately after the build. 

```
terraform destroy -var-file="../assets/dev-secret.tfvars" -auto-approve
```

The image will stay, as well as the local private key. You can delete the key, it was only needed for the build by packer.