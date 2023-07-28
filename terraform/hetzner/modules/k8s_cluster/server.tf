# Control Plane(s)
resource "hcloud_server" "cp" {
  count        = var.amount_cp

  name         = "${var.basename}-cp-${count.index + 1}"
  image        = "ubuntu-20.04"
  server_type  = "cx41" # 4vCPUS, 16GB RAM, 160GB SSD, 20TB traffic
  location     = "fsn1"
  ssh_keys     = var.ssh_keys
  labels       = {
    "${var.basename}-cp" = "true"
    environment          = "${var.basename}"
  }
  #placement_group_id = "TBD"
  delete_protection  = true
  rebuild_protection = true

  dynamic "public_net" {
    for_each = var.cpHasPubIP ? [] : [1]
    content {
      ipv4_enabled = false
      ipv6_enabled = false 
    }
  }

  dynamic "public_net" {
    for_each = var.cpHasPubIP ? [1] : []
    content {
      ipv4_enabled = true
      ipv6_enabled = false 
    }
  }

  dynamic "network" {
    for_each = var.cpHasPubIP ? [] : [1]
    content {
      network_id = hcloud_network.int_net.id
      ip         = "${trim(var.cidr_net_int, "0/24")}${var.node_start_ip + count.index}"
    }
  }

  depends_on = [
    hcloud_network_subnet.int_net_subnet_1
  ]
}

# Worker(s)
resource "hcloud_server" "worker" {
  count        = var.amount_worker

  name         = "${var.basename}-worker-${count.index + 1}"
  image        = "ubuntu-20.04"
  server_type  = "cx41" # 4vCPUS, 16GB RAM, 160GB SSD, 20TB traffic
  location     = "fsn1"
   ssh_keys    = var.ssh_keys 
  labels       = {
    "${var.basename}-worker" = "true"
    environment              = "${var.basename}"
  }
  #placement_group_id = "TBD"
  delete_protection  = true
  rebuild_protection = true

  dynamic "public_net" {
    for_each = var.workerHasPubIP ? [] : [1]
    content {
      ipv4_enabled = false
      ipv6_enabled = false 
    }
  }

  dynamic "public_net" {
    for_each = var.workerHasPubIP ? [1] : []
    content {
      ipv4_enabled = true
      ipv6_enabled = false 
    }
  }

  dynamic "network" {
    for_each = var.workerHasPubIP ? [] : [1]
    content {
      network_id = hcloud_network.int_net.id
      ip         = "${trim(var.cidr_net_int, "0/24")}${var.node_start_ip + var.amount_cp + count.index}"
    }
  }

  depends_on = [
    hcloud_network_subnet.int_net_subnet_1
  ]
}
