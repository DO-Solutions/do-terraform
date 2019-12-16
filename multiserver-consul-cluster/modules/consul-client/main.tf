# Create Droplet tags
resource "digitalocean_tag" "consul_tag" {
  name = var.tag
}

# Create Consul cluster servers
resource "digitalocean_droplet" "consul_droplet" {
  count              = var.droplet_count
  name               = "${var.server_name}-${format("%02d", count.index + 1)}"
  image              = var.image
  region             = var.region
  size               = var.size
  monitoring         = true
  private_networking = true
  ssh_keys           = var.keys
  tags               = ["${digitalocean_tag.consul_tag.id}"]
  user_data          = file("${path.module}/config/cloud-config.yaml")

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.private_key_path)
    timeout     = "2m"
  }

  # Push templated bash script over to the Droplets for consul installation
  provisioner "file" {
    content = templatefile("${path.module}/scripts/consul_install.sh", {
      consul_version   = var.consul["version"],
      consul_configdir = var.consul["config_path"],
      consul_datadir   = var.consul["data_path"],
      consul_binpath   = var.consul["bin_path"],
      consul_user      = var.consul["user"],
      droplet_count    = var.droplet_count
    })
    destination = "/tmp/consul_install.sh"
  }
  # Execute the consul install script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/consul_install.sh",
      "nohup /tmp/consul_install.sh client &",
      "sleep 5s;",
    ]
    on_failure = continue
  }
  # Create standard server config file
  provisioner "file" {
    content = templatefile("${path.module}/templates/client-config.json", {
      region            = var.region,
      data_path         = var.consul["data_path"],
      node_name         = self.name,
      bind_address      = self.ipv4_address_private,
      consul_gossip_key = var.consul_gossip_key,
      consul_ips        = var.consul_ips
    })
    destination = "/etc/consul/client/config.json"
  }
  # Create systemd unit file for consul service
  provisioner "file" {
    content = templatefile("${path.module}/templates/consul-client.service", {
      consul_configdir     = var.consul["config_path"],
      consul_user          = var.consul["user"],
      consul_group         = var.consul["group"],
      consul_binpath       = var.consul["bin_path"],
      consul_runpath       = var.consul["run_path"],
      restart_sec          = var.consul["systemd_restart_sec"],
      systemd_limit_nofile = var.consul["systemd_limit_nofile"]
    })
    destination = "/etc/systemd/system/consul-client.service"
  }
}

