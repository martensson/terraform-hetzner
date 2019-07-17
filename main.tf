# vars
variable "hostname" {}
variable "domain" {}
variable "cfemail" {}
variable "cftoken" {}
variable "htoken" {}
variable "sshkeys" {type = list(string)}

# Providers
provider "cloudflare" {
  email = "${var.cfemail}"
  token = "${var.cftoken}"
}

provider "hcloud" {
  token = "${var.htoken}"
}

# resources
resource "hcloud_server" "server" {
  name = "${var.hostname}.${var.domain}"
  image = "ubuntu-18.04"
  server_type = "cx21"
  ssh_keys = var.sshkeys
  location = "nbg1"
  backups = "false"
}

resource "cloudflare_record" "dns_a" {
  domain = "${var.domain}"
  name   = "${var.hostname}"
  value  = "${hcloud_server.server.ipv4_address}"
  type   = "A"
  ttl    = 3600
}

resource "cloudflare_record" "dns_aaaa" {
  domain = "${var.domain}"
  name   = "${var.hostname}"
  value  = "${hcloud_server.server.ipv6_address}"
  type   = "AAAA"
  ttl    = 3600
}

output "ipv4" {
  value = hcloud_server.server.ipv4_address
}

output "ipv6" {
  value = hcloud_server.server.ipv6_address
}

output "status" {
  value = hcloud_server.server.status
}

output "datacenter" {
  value = hcloud_server.server.datacenter
}

output "id" {
  value = hcloud_server.server.id
}
