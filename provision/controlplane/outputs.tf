output "kubeapi_endpoint" {
  value = local.kubeapi_endpoint
}

output "test" {
  value = {
    controlplanes = {
      for i, w in hcloud_server.control_plane : w.name => {
        private_address = hcloud_server_network.control_plane[i].ip
      }
    }
  }
}

