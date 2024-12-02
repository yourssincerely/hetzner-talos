resource "talos_machine_secrets" "machine_secrets" {
    talos_version = var.talos_version
}
data "talos_machine_configuration" "controlplane" {
    cluster_name       = var.cluster_name
    machine_type       = "controlplane"
    cluster_endpoint   = "https://${var.lb_ip}:6443"
    machine_secrets    = talos_machine_secrets.machine_secrets.machine_secrets
    talos_version      = var.talos_version
    kubernetes_version = var.kubernetes_version
    config_patches = [
        templatefile("${path.module}/templates/cp_patch.yaml.tmpl", {
            lb_int_ip    = var.lb_ip,
            lb_ext_ip    = hcloud_load_balancer.lb.ipv4,
            subnet       = var.subnet_cloud_cidr,
            cluster_name = var.cluster_name,
            cluster_CIDR = var.cluster_cidr,
            service_CIDR = var.service_cidr
            }
        )
    ]
    depends_on = [
        talos_machine_secrets.machine_secrets,
        hcloud_load_balancer_network.lb_net,
        hcloud_network_subnet.cloud_servers,
        hcloud_load_balancer_network.lb_net
    ]
}
data "talos_machine_configuration" "worker" {
    cluster_name       = var.cluster_name
    machine_type       = "worker"
    cluster_endpoint   = "https://${var.lb_ip}:6443"
    machine_secrets    = talos_machine_secrets.machine_secrets.machine_secrets
    talos_version      = var.talos_version
    kubernetes_version = var.kubernetes_version
    config_patches = [
        templatefile("${path.module}/templates/worker_patch.yaml.tmpl", {
            lb_int_ip    = var.lb_ip,
            lb_ext_ip    = hcloud_load_balancer.lb.ipv4,
            subnet       = var.subnet_cloud_cidr,
            cluster_name = var.cluster_name,
            cluster_CIDR = var.cluster_cidr,
            service_CIDR = var.service_cidr
            }
        )
    ]
    depends_on = [
        talos_machine_secrets.machine_secrets,
        hcloud_load_balancer_network.lb_net,
        hcloud_network_subnet.cloud_servers,
        hcloud_load_balancer_network.lb_net
    ]
}
data "talos_client_configuration" "talosconfig" {
    cluster_name         = var.cluster_name
    client_configuration = talos_machine_secrets.machine_secrets.client_configuration
    endpoints            = [hcloud_load_balancer.lb.ipv4]
    nodes                = concat(local.cp_ips, local.worker_ips)
    depends_on = [
        talos_machine_secrets.machine_secrets,
        hcloud_load_balancer_network.lb_net,
        hcloud_network_subnet.cloud_servers,
        hcloud_load_balancer_network.lb_net
    ]
}
resource "talos_machine_configuration_apply" "controlplane" {
    for_each                    = toset(local.cp_ips)
    client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
    machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
    endpoint                    = hcloud_load_balancer.lb.ipv4
    node                        = each.key
    depends_on = [
        hcloud_server.cp,
        hcloud_load_balancer_target.cp_nodes,
        data.talos_machine_configuration.controlplane,
        hcloud_load_balancer_network.lb_net
    ]
}
resource "talos_machine_bootstrap" "bootstrap" {
    endpoint             = hcloud_load_balancer.lb.ipv4
    node                 = local.cp_ips[0]
    client_configuration = talos_machine_secrets.machine_secrets.client_configuration
    depends_on = [
        talos_machine_configuration_apply.controlplane,
        hcloud_load_balancer_network.lb_net
    ]
}
resource "talos_machine_configuration_apply" "workers" {
    for_each                    = toset(local.worker_ips)
    client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
    machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
    endpoint                    = hcloud_load_balancer.lb.ipv4
    node                        = each.key
    depends_on = [
        hcloud_server.nodepool_1,
        hcloud_server.nodepool_2,
        hcloud_server.nodepool_3,
        hcloud_server.nodepool_4,
        hcloud_load_balancer_target.worker,
        data.talos_machine_configuration.worker,
        hcloud_load_balancer_network.lb_net,
        talos_machine_bootstrap.bootstrap
    ]
}
resource "talos_cluster_kubeconfig" "kubeconfig" {
    endpoint             = hcloud_load_balancer.lb.ipv4
    node                 = local.cp_ips[0]
    client_configuration = talos_machine_secrets.machine_secrets.client_configuration
    depends_on = [
        talos_machine_bootstrap.bootstrap,
        hcloud_load_balancer_network.lb_net
    ]
}