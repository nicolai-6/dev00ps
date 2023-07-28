# internal network
resource "hcloud_network" "int_net" {
  name         = "${var.basename}-int-net"
  ip_range     = var.cidr_net_int
}

resource "hcloud_network_subnet" "int_net_subnet_1" {
  network_id   = hcloud_network.int_net.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.cidr_net_int
}
