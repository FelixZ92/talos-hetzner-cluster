/*
Copyright 2019 The KubeOne Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

provider "hcloud" {}

locals {
  loadbalancer_count = var.disable_kubeapi_loadbalancer ? 0 : 1
}

module "bastion" {
  source       = "./bastion"
  cluster_name = var.cluster_name

  network_id     = hcloud_network_subnet.subnet.network_id
  ssh_public_key = var.ssh_public_key
}

module "controlplane" {
  source = "./controlplane"

  cluster_name = var.cluster_name
  image        = var.image
  network_id   = hcloud_network_subnet.subnet.network_id
}

module "worker" {
  count = 1
  source = "./worker"
  cluster_name = var.cluster_name
  image = var.image
  network_id = hcloud_network_subnet.subnet.network_id
  pool_name = "pool-1"
  datacenter = "nbg1"
}
