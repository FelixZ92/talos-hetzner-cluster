output "worker_host" {
  value = {
    name = hcloud_server.worker.name
    private_address = hcloud_server_network.worker.ip
    public_address = hcloud_server.worker.ipv4_address
  }
}
