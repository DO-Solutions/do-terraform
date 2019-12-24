#############################
### Begin input variables ###
#############################
variable "server_name" {
  description = "Name to use for resources within DigitalOcean."
}

variable "size" {
  description = "Droplet size to deploy."
}

variable "image" {
  description = "Distribution to use for deployment."
}

variable "region" {
  description = "Selected data center."
}

variable "keys" {
  description = "SSH key to be installed on the Droplet."
}

variable "private_key_path" {
  description = "Path to your private SSH key to be used when executing remote scripts."
}

variable "consul_gossip_key" {
  description = "Key used to encrypt gossip communications between consul cluster members."
  type        = string
}

variable "droplet_count" {
  description = "Number of Consul servers to provision."
  type        = number
  default     = 3
}

variable "consul" {
  description = "consul installation location paramters"
  type        = map
  default = {
    # key = "value"
    version               = "1.6.1"
    bin_path              = "/usr/local/bin"
    config_path           = "/etc/consul"
    data_path             = "/var/consul"
    log_path              = "/var/log/consul"
    log_file              = "consul.log"
    run_path              = "/var/consul"
    user                  = "consul"
    group                 = "bin"
    systemd_restart_sec   = 10
    systemd_limit_nofile  = 65536
    binary                = "/usr/local/bin/consul" # TODO: may want to remove binary arg 
    domain                = "consul"
    iface                 = "eth0"
    ui_enable             = true
    raft_protocol         = 3
    retry_join_skip_hosts = false
    retry_interval        = "30s"
    retry_interval_wan    = "30s"
    retry_max             = 0
    retry_max_wan         = 0
  }
}

variable "tag" {
  description = "Tag to apply to Droplets."
  type        = string
  default     = "consul:server"
}

##############################
### Begin output variables ###
##############################
output "consul_join_ip" {
  description = "Module output to be used for consul client configuration."
  value       = jsonencode(digitalocean_droplet.consul_droplet.*.ipv4_address_private)
}

output "num_servers" {
  value = length(digitalocean_droplet.consul_droplet.*.id)
}

output "server_ids" {
  value = digitalocean_droplet.consul_droplet.*.id
}

output "server_tag" {
  value = digitalocean_droplet.consul_droplet.0.tags
}
