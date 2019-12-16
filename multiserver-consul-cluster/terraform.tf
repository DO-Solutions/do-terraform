terraform {
  required_version = ">= 0.12"
}

# Token will be supplied using the DIGITALOCEAN_TOKEN environment variable
provider "digitalocean" {
}
