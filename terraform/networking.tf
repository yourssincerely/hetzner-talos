resource "hcloud_network" "net" {
    name     = var.network_name
    ip_range = var.network_cidr
}
resource "hcloud_network_subnet" "cloud_servers" {
    network_id   = hcloud_network.net.id
    type         = "cloud"
    network_zone = var.network_zone
    ip_range     = var.subnet_cloud_cidr

    depends_on = [
        hcloud_network.net
    ]
}
