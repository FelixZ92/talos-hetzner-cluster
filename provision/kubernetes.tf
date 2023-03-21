provider kubernetes {
  host = yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["clusters"][0]["cluster"]["server"]

  cluster_ca_certificate = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["clusters"][0]["cluster"]["certificate-authority-data"])

  client_certificate = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["users"][0]["user"]["client-certificate-data"])
  client_key         = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["users"][0]["user"]["client-key-data"])
}

provider "helm" {
  kubernetes {
    host = yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["clusters"][0]["cluster"]["server"]

    cluster_ca_certificate = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["clusters"][0]["cluster"]["certificate-authority-data"])

    client_certificate = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["users"][0]["user"]["client-certificate-data"])
    client_key         = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["users"][0]["user"]["client-key-data"])
  }
}

resource "time_sleep" "wait_30_for_api_server" {
  depends_on = [module.controlplane]

  create_duration = "30s"
}

resource "helm_release" "cilium" {
  depends_on = [talos_machine_bootstrap.bootstrap,time_sleep.wait_30_for_api_server]
  chart      = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io/"
  version    = "1.13.1"
  name       = "cilium"
  values     = [
    templatefile("cilium.yaml", {
      private_loadbalancer_ip = hcloud_load_balancer_network.load_balancer.ip
    })
  ]
}

#
#resource "kubernetes_secret" "hcloud_token" {
#  metadata {
#    name = "hcloud"
#  }
#
#  data = {
#    ".dockerconfigjson" = "${file("${path.module}/.docker/config.json")}"
#  }
#
#  type = "kubernetes.io/dockerconfigjson"
#}
