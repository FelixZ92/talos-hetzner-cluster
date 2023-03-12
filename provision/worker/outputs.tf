output "worker_hosts" {
  value = [for i,w in hcloud_server.worker : {
    name = w.name
    private_address = hcloud_server_network.worker[0].ip
  }]
}
