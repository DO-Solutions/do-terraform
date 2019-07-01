# providers
provider "digitalocean" {
  token = var.do_token
}

# certificate
resource "digitalocean_certificate" "cert" {
  name    = "${var.sub_domain}.${var.domain}"
  type    = "lets_encrypt"
  domains = ["${var.sub_domain}.${var.domain}"]
}

# loadbalancer
resource "digitalocean_loadbalancer" "public" {
  name                   = "loadbalancer"
  region                 = "sfo2"
  redirect_http_to_https = true

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 80
    target_protocol = "http"

    certificate_id = digitalocean_certificate.cert.id
  }

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path     = "/"
  }

  droplet_tag = "worker"
}

# workers
resource "digitalocean_droplet" "workers" {
  image     = var.image
  name      = "${var.name}-${count.index + 1}"
  region    = var.region
  size      = var.size
  tags      = [var.tag]
  count     = var.do-count
  user_data = file("nginx.sh")
  ssh_keys  = [var.ssh_keys]
}

# dns
resource "digitalocean_record" "sub_domain" {
  domain = var.domain
  type   = "A"
  name   = var.sub_domain
  value  = digitalocean_loadbalancer.public.ip
  ttl    = 300
}

