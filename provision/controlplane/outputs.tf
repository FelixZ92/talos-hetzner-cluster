output "kubeapi_endpoint" {
  value = local.kubeapi_endpoint
}

output "controlplane_hosts" {
  value = {
    "controlplanes" = [for i,w in hcloud_server.control_plane : {
      name = w.name
      private_address = hcloud_server_network.control_plane[i].ip
    }]
  }
}
