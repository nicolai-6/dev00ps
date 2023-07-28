# worker disks / volumes
resource "hcloud_volume" "worker_disk" {
  count             = var.amount_worker

  name              = "${var.basename}-worker-${count.index + 1}-disk"
  location          = "fsn1"
  size              = 300
  delete_protection = true
}

resource "hcloud_volume_attachment" "worker_disk_ref" {
  count             = var.amount_worker

  volume_id = hcloud_volume.worker_disk[count.index].id
  server_id = hcloud_server.worker[count.index].id
  automount = true
}

# workers ceph object storage 
resource "hcloud_volume" "worker_disk_ceph" {
  count             = var.amount_worker

  name              = "${var.basename}-worker-${count.index + 1}-ceph-disk"
  location          = "fsn1"
  size              = 45
  delete_protection = true
}

resource "hcloud_volume_attachment" "worker_disk_ceph_ref" {
  count             = var.amount_worker

  volume_id = hcloud_volume.worker_disk_ceph[count.index].id
  server_id = hcloud_server.worker[count.index].id
  automount = true
}
