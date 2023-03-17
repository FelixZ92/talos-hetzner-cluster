output "controlplane_host" {
  value = {
    name = hcloud_server.control_plane.name
    private_address = hcloud_server_network.control_plane.ip
    public_address = hcloud_server.control_plane.ipv4_address
  }
}
