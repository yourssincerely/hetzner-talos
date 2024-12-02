resource "hcloud_load_balancer_service" "kubernetes_API" {
    load_balancer_id = hcloud_load_balancer.lb.id
    protocol         = "tcp"
    listen_port      = 6443
    destination_port = 6443
    health_check {
        protocol = "tcp"
        port     = 6443
        interval = 10
        timeout  = 5
    }
}
resource "hcloud_load_balancer_service" "talos_API" {
    load_balancer_id = hcloud_load_balancer.lb.id
    protocol         = "tcp"
    listen_port      = 50000
    destination_port = 50000
    health_check {
        protocol = "tcp"
        port     = 50000
        interval = 10
        timeout  = 5
    }
}