# Custombuilt Packer

Run this example to create a packer image according to the specifications in `assets/main.pkr.hcl`.
If you change nothing, packer creates a clone of a standard ubuntu image and copies a file with environment data to `/home/ubuntu/environment.txt`.

Pass in the security variables as shown in the `assets/dev-secret.tfvars.md` file in the module itself:

```
terraform init
terraform apply -var-file="../../assets/dev-secret.tfvars"
```