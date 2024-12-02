resource "hcloud_firewall" "talos_cp" {
    name = "talos-cp"
    labels = {
        "role"  = "control-plane"
        "scope" = "talos"
    }
    rule {
        description = "Talos apid"
        direction   = "in"
        protocol    = "tcp"
        port        = "50000"
        source_ips  = [var.subnet_cloud_cidr]
    }
    rule {
        description = "Talos trustd"
        direction   = "in"
        protocol    = "tcp"
        port        = "50001"
        source_ips  = [var.subnet_cloud_cidr]
    }
}
resource "hcloud_firewall" "talos_worker" {
    name = "talos-worker"
    labels = {
        "role"  = "worker"
        "scope" = "talos"
    }
    rule {
        description = "Talos apid"
        direction   = "in"
        protocol    = "tcp"
        port        = "50000"
        source_ips  = [var.subnet_cloud_cidr]
    }
}
resource "hcloud_firewall" "kubernetes_cp" {
    name = "kubernetes-cp"
    labels = {
        "role"  = "control-plane"
        "scope" = "kubernetes"
    }
    rule {
        description = "Kubernetes API server"
        direction   = "in"
        protocol    = "tcp"
        port        = "6443"
        source_ips  = [var.subnet_cloud_cidr]
    }
    rule {
        description = "etcd server client API"
        direction   = "in"
        protocol    = "tcp"
        port        = "2379-2380"
        source_ips  = [var.subnet_cloud_cidr]
    }
    rule {
        description = "Kubelet API"
        direction   = "in"
        protocol    = "tcp"
        port        = "10250"
        source_ips  = [var.subnet_cloud_cidr]
    }
    rule {
        description = "kube-scheduler"
        direction   = "in"
        protocol    = "tcp"
        port        = "10259"
        source_ips  = [var.subnet_cloud_cidr]
    }
    rule {
        description = "kube-controller-manager"
        direction   = "in"
        protocol    = "tcp"
        port        = "10257"
        source_ips  = [var.subnet_cloud_cidr]
    }
}
resource "hcloud_firewall" "kubernetes_worker" {
    name = "kubernetes-worker"
    labels = {
        "role"  = "worker"
        "scope" = "kubernetes"
    }
    rule {
        description = "Kubelet API"
        direction   = "in"
        protocol    = "tcp"
        port        = "10250"
        source_ips  = [var.subnet_cloud_cidr]
    }
    rule {
        description = "Default range for NodePort Services"
        direction   = "in"
        protocol    = "tcp"
        port        = "30000-32767"
        source_ips  = [var.subnet_cloud_cidr]
    }
}