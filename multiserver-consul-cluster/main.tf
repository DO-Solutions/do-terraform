locals {
  consul_tags = flatten([module.consul_client.client_tag, module.consul_server.server_tag])
}

module "consul_server" {
  source            = "./modules/consul-server"
  server_name       = "consul-server"
  droplet_count     = 3
  size              = "s-2vcpu-2gb"
  image             = "ubuntu-18-04-x64"
  region            = var.region
  keys              = var.keys
  private_key_path  = var.private_key_path
  consul_gossip_key = var.consul_gossip_key
}

module "consul_client" {
  source            = "./modules/consul-client"
  server_name       = "consul-client"
  droplet_count     = 2
  size              = "s-1vcpu-1gb"
  image             = "ubuntu-18-04-x64"
  region            = var.region
  keys              = var.keys
  private_key_path  = var.private_key_path
  consul_gossip_key = var.consul_gossip_key
  consul_ips        = module.consul_server.consul_join_ip
}

module "consul_fw" {
  source            = "git::https://github.com/DO-Solutions/tf-do-firewall.git?ref=v0.2.0"
  name              = "consul-fw"
  tags              = local.consul_tags
  inbound_tag_rules = var.inbound_tag_rules
}

