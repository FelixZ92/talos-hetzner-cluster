output "controlplane_host" {
  value = {
    name = hcloud_server.control_plane.name
    private_address = hcloud_server_network.control_plane.ip
    public_address = hcloud_primary_ip.primary_ip.ip_address
  }
}
