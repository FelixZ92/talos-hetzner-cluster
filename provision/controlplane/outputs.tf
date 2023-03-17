output "controlplane_hosts" {
  value = {
    controlplanes = {
      for i, w in module.instance.*.controlplane_host : w.name => {
        private_address = w.private_address
        public_address = w.public_address
      }
    }
  }
}
