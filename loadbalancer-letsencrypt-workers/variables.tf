# digitalocean token
variable "do_token" {}

# compute variables
variable "do-count" {
  type    = "string"
  default = "1"
}

variable "ssh_keys" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "sfo2"
}

variable "size" {
  type    = "string"
  default = "s-1vcpu-1gb"
}

variable "tag" {
  type    = "string"
  default = "worker"
}

variable "name" {
  type    = "string"
  default = "worker"
}

variable "image" {
  type    = "string"
  default = "ubuntu-18-04-x64"
}

# certificate + loadbalancer
variable "domain" {
  type    = "string"
  default = "example.com"
}

variable "sub_domain" {
  type    = "string"
  default = "sub.example.com"
}

