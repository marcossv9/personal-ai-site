# Create ssh key in hcloud
resource "hcloud_ssh_key" "main" {
  name       = "ms-ssh-key"
  public_key = file("~/.ssh/hetzner/hetzner_cloud.pub")
  labels = {
    "env" : "dev"
  }
}

# Ensure a server is attached to a firewall on first boot
# https://registry.terraform.io/providers/hetznercloud/hcloud/1.52.0/docs/resources/firewall_attachment#ensure-a-server-is-attached-to-a-firewall-on-first-boot
resource "hcloud_firewall" "deny_all" {
  name = "deny_all"
}

# Create a new server running debian
resource "hcloud_server" "node1" {
  name                       = "vps1"
  image                      = "ubuntu-24.04"
  ignore_remote_firewall_ids = true
  location                   = "nbg1"
  server_type                = "cx22"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }
  ssh_keys = [
    hcloud_ssh_key.main.name
  ]
  labels = {
    "env" : "dev"
  }
  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    ssh_publickey = var.ssh_publickey
  })

  firewall_ids = [
    hcloud_firewall.deny_all.id
  ]
}

# Configure Firewall
resource "hcloud_firewall" "allow_rules" {
  name = "allow_rules"
  rule {
    description = "PING"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "HTTP"
    direction   = "in"
    protocol    = "tcp"
    port        = "80"
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "HTTPS"
    direction   = "in"
    protocol    = "tcp"
    port        = "443"
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = "2222"
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  rule {
    description = "SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips = [
      "0.0.0.0/0"
    ]
  }

  labels = {
    "env" : "dev"
  }
}

resource "hcloud_firewall_attachment" "deny_all_att" {
  firewall_id = hcloud_firewall.deny_all.id
  server_ids = [
    hcloud_server.node1.id
  ]
}

resource "hcloud_firewall_attachment" "allow_rules_att" {
  firewall_id = hcloud_firewall.allow_rules.id
  server_ids = [
    hcloud_server.node1.id
  ]
}
