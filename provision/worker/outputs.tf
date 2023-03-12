output "worker_hosts" {
  value = {
    hcloud_server.worker.*.name = {
      private_address = hcloud_server_network.worker.*.ip
    }
  }
}
