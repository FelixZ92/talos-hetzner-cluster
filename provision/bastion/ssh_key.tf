resource "hcloud_ssh_key" "ssh_key" {
  name       = "bastion-${var.cluster_name}"
  public_key = var.ssh_public_key
}
