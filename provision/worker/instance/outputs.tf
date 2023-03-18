output "worker_host" {
  value = {
    name = hcloud_server.worker.name
    private_address = hcloud_server_network.worker.ip
    public_address = hcloud_primary_ip.primary_ip.ip_address
  }
}
