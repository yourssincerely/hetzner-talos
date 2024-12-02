resource "hcloud_load_balancer" "lb" {
    name               = var.lb_name
    load_balancer_type = var.lb_type
    location           = var.lb_location
}
resource "hcloud_load_balancer_network" "lb_net" {
    load_balancer_id = hcloud_load_balancer.lb.id
    network_id       = hcloud_network.net.id
    ip               = var.lb_ip
    depends_on = [
        hcloud_network_subnet.cloud_servers
    ]
}
resource "hcloud_load_balancer_target" "cp_nodes" {
    type             = "label_selector"
    load_balancer_id = hcloud_load_balancer.lb.id
    label_selector   = "role=control-plane"
    use_private_ip   = true
    depends_on = [
        hcloud_network_subnet.cloud_servers
    ]
}
resource "hcloud_load_balancer_target" "worker" {
    type             = "label_selector"
    load_balancer_id = hcloud_load_balancer.lb.id
    label_selector   = "role=worker"
    use_private_ip   = true
    depends_on = [
        hcloud_network_subnet.cloud_servers
    ]
}