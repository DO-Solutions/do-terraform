#############################
### Begin input variables ###
#############################
variable "region" {
  description = "Selected data center."
  type        = string
}

variable "keys" {
  description = "SSH key to be installed on the Droplet."
  type        = list(string)
}

variable "private_key_path" {
  description = "Path to your private SSH key to be used when executing remote scripts."
  type        = string
}

variable "consul_gossip_key" {
  description = "Key used to encrypt gossip communications between consul cluster members."
  type        = string
}

##############################
### Begin output variables ###
##############################
#output "consul_join_ip" {
#  value       = module.consul_server.consul_join_ip
#  description = "Module output to be used for consul client configuration."
#}

#output "num_servers" {
#  value = module.consul_server.num_servers
#}

#output "server_ids" {
#  value = module.consul_server.server_ids
#}
