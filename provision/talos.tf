provider "talos" {}

resource "talos_machine_secrets" "machine_secrets" {}

resource "talos_machine_configuration_controlplane" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${module.controlplane.kubeapi_endpoint}:6443"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}
