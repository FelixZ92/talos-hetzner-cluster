output "kubeapi_endpoint" {
  value = local.kubeapi_endpoint
}

output "controlplane_hosts" {
  value = {
    hostnames            = hcloud_server.control_plane.*.name
    private_address      = hcloud_server_network.control_plane.*.ip
  }
}
