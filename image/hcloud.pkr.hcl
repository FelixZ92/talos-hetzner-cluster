# hcloud.pkr.hcl

packer {
  required_plugins {
    hcloud = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hcloud"
    }
  }
}

variable "talos_version" {
  type    = string
  default = "v1.3.5"
}

locals {
  image = "https://github.com/siderolabs/talos/releases/download/${var.talos_version}/hcloud-amd64.raw.xz"
}

source "hcloud" "talos" {
  rescue        = "linux64"
  image         = "debian-11"
  location      = "hel1"
  server_type   = "cx11"
  ssh_username  = "root"
  snapshot_name = "talos system disk ${var.talos_version}"
  snapshot_labels = {
    type    = "infra",
    os      = "talos",
    version = "${var.talos_version}",
  }
}

build {

  hcp_packer_registry {
    bucket_name = "talos-linux"
    description = <<EOT
Talos Linux snapshot on hcloud. See https://www.talos.dev/v1.3/talos-guides/install/cloud-platforms/hetzner/
    EOT
    bucket_labels = {
      "owner"         = "fzx"
      "os"            = "Talos",
      "talos-version" = "${var.talos_version}",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }

  sources = ["source.hcloud.talos"]

  provisioner "shell" {
    inline = [
      "apt-get install -y wget",
      "wget -O /tmp/talos.raw.xz ${local.image}",
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
    ]
  }
}
