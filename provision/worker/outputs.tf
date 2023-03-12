output "worker_hosts" {
  value = {
    worker = {
      for i, w in hcloud_server.worker : w.name => {
        private_address = hcloud_server_network.worker[i].ip
      }
    }
  }
}
