module "k8s_cls" {
    source            = "../modules/k8s_cluster"

    cidr_net_int      = var.cidr_net_int
    basename          = var.basename
    amount_cp         = var.amount_cp
    amount_worker     = var.amount_worker
    ssh_keys          = var.ssh_keys
}
