resource "hcloud_server" "bastion" {
  name        = "${var.cluster_name}-bastion"
  server_type = var.bastion_type
  image       = var.bastion_image
  location    = var.datacenter
  user_data   = templatefile("${path.module}/files/bastion_userdata.tmpl.yaml", {
    ssh_username : var.ssh_username,
    ssh_key : var.ssh_public_key
  })
  ssh_keys = [
    hcloud_ssh_key.ssh_key.id,
  ]

  labels = {
    "cluster" = var.cluster_name
    "role"                 = "bastion"
  }
}

resource "hcloud_server_network" "bastion" {
  server_id = hcloud_server.bastion.id
  subnet_id = var.network_id
}
