# Configure provider
provider "digitalocean" {
  token = var.do_token
}

# Create kubernetes cluster
resource "digitalocean_kubernetes_cluster" "doks_cluster" {
  name    = var.cluster_name
  region  = var.region
  version = "1.14.1-do.2"
  tags    = ["demo"]

  node_pool {
    name       = "worker-pool-1"
    size       = "s-2vcpu-2gb"
    node_count = 3
    tags       = ["np1"]
  }
}

#resource "digitalocean_kubernetes_node_pool" "doks-cluster-np2" {
#  cluster_id = "${digitalocean_kubernetes_cluster.doks_cluster.id}"
#
#  name       = "worker-pool-2"
#  size       = "c-2"
#  node_count = 3
#  tags       = ["np2", "backend"]
#}

output "kube_config" {
  value = digitalocean_kubernetes_cluster.doks_cluster.kube_config[0].raw_config
}

