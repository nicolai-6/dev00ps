resource "hcloud_load_balancer" "cls_cp" {
  name               = "${var.basename}-vip-cp"
  load_balancer_type = "lb11"
  location           = "fsn1"

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_target" "cls_cp_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.cls_cp.id
  label_selector   = "${var.basename}-cp = true"
  use_private_ip   = true

  depends_on = [
    hcloud_network_subnet.int_net_subnet_1,
    hcloud_network.int_net
  ]
}

resource "hcloud_load_balancer_network" "cls_cp_network" {
  load_balancer_id        = hcloud_load_balancer.cls_cp.id
  network_id              = hcloud_network.int_net.id
  ip                      = "${trim(var.cidr_net_int, "0/24")}200"
  enable_public_interface = false

  depends_on = [
    hcloud_network_subnet.int_net_subnet_1,
    hcloud_network.int_net
  ]
}

resource "hcloud_load_balancer_service" "cls_cp_service" {
    load_balancer_id = hcloud_load_balancer.cls_cp.id
    protocol         = "tcp"
    listen_port      = 6443
    destination_port = 6443

    health_check {
      interval = 30
      protocol = "tcp"
      port     = 6443
      timeout  = 3
      retries  = 2
    }
}

# VIP for worker(s) traefik
## traefik
resource "hcloud_load_balancer" "cls_worker_traefik" {
  name               = "${var.basename}-vip-worker-traefik"
  load_balancer_type = "lb11"
  location           = "fsn1"

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_target" "cls_worker_target_traefik" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.cls_worker_traefik.id
  label_selector   = "${var.basename}-worker = true"
  use_private_ip   = true

  depends_on = [
    hcloud_network_subnet.int_net_subnet_1,
    hcloud_network.int_net
  ]
}

resource "hcloud_load_balancer_network" "cls_worker_network_traefik" {
  load_balancer_id        = hcloud_load_balancer.cls_worker_traefik.id
  network_id              = hcloud_network.int_net.id
  ip                      = "${trim(var.cidr_net_int, "0/24")}201"
  enable_public_interface = true

  depends_on = [
    hcloud_network_subnet.int_net_subnet_1
  ]
}

resource "hcloud_load_balancer_service" "cls_worker_service_traefik_https" {
    load_balancer_id = hcloud_load_balancer.cls_worker_traefik.id
    protocol         = "tcp"
    listen_port      = 443
    destination_port = 443

    health_check {
      interval = 30
      protocol = "tcp"
      port     = 443
      timeout  = 3
      retries  = 2
    }
}
