# talos-hetzner-image

[packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli) 
config file to create a snapshot on hetzner cloud for [Talos Linux](https://www.talos.dev/)

```shell
# First you need set API Token
export HCLOUD_TOKEN=${TOKEN}

# Upload image
packer init .
packer build .
# Save the image ID
export IMAGE_ID=<image-id-in-packer-output>
```
