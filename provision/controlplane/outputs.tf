output "controlplane_hosts" {
  value = {
    controlplanes = {
      for i, w in hcloud_server.control_plane : w.name => {
        private_address = hcloud_server_network.control_plane[i].ip
        public_address = hcloud_server.control_plane[i].ipv4_address
      }
    }
  }
}

