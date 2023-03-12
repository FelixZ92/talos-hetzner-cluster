#provider kubernetes {
#  host = yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["clusters"][0]["cluster"]["server"]
#
#  cluster_ca_certificate = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["clusters"][0]["cluster"]["certificate-authority-data"])
#
#  client_certificate = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["users"][0]["user"]["client-certificate-data"])
#  client_key         = base64decode(yamldecode(talos_cluster_kubeconfig.kubeconfig.kube_config)["users"][0]["user"]["client-key-data"])
#}
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
