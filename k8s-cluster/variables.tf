# digitalocean token
variable "do_token" {
  description = "DigitalOcean API token"
}

# Declare variables
variable "cluster_name" {
  description = "Cluster name used within DigitalOcean"
}

variable "region" {
  description = "Selected data center."
  default     = "sfo2"
}

