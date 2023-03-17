output "worker_hosts" {
  value = {
    worker = {
      for i, w in module.instance.*.worker_host : w.name => {
        private_address = w.private_address
        public_address = w.public_address
      }
    }
  }
}
