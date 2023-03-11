output "kubeapi_endpoint" {
  value = var.loadbalancer_count == 0 ? hcloud_server_network.control_plane.0.ip : hcloud_load_balancer.load_balancer.0.network_ip
}
