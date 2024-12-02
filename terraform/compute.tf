resource "hcloud_server" "cp" {
    count              = var.cp_instance_count
    name               = "cp-${var.cp_locations[count.index]}"
    image              = var.snapshot_id
    server_type        = var.cp_instance_type
    location           = "${var.cp_locations[count.index]}"
    ssh_keys           = var.ssh_keys
    placement_group_id = hcloud_placement_group.cp_spread_group.id
    labels             = {
        "role"          = "control-plane"
        "zone"          = "${var.cp_locations[count.index]}"
        "instance-type" = var.cp_instance_type
    }
    network {
        network_id = hcloud_network.net.id
        ip         = local.cp_ips[count.index]
    }
    depends_on = [
        hcloud_placement_group.cp_spread_group,
        hcloud_network_subnet.cloud_servers
    ]
}
resource "hcloud_server" "nodepool_1" {
    count              = var.np_1_instance_count
    name               = "nodepool1-${count.index + 1}-${var.np_1_locations[count.index]}"
    image              = var.snapshot_id
    server_type        = var.np_1_instance_type
    location           = "${var.np_1_locations[count.index]}"
    ssh_keys           = var.ssh_keys
    placement_group_id = hcloud_placement_group.nodepool_1.id
    labels             = {
        "role"          = "worker"
        "location"      = "${var.np_1_locations[count.index]}"
        "instance-type" = var.np_1_instance_type
    }
    network {
        network_id = hcloud_network.net.id
        ip         = local.np_1_ips[count.index]
    }
    depends_on = [
        hcloud_placement_group.nodepool_1,
        hcloud_network_subnet.cloud_servers
    ]
}
resource "hcloud_server" "nodepool_2" {
    count              = var.np_2_instance_count
    name               = "nodepool2-${count.index + 1}-${var.np_2_locations[count.index]}"
    image              = var.snapshot_id
    server_type        = var.np_2_instance_type
    location           = "${var.np_2_locations[count.index]}"
    ssh_keys           = var.ssh_keys
    placement_group_id = hcloud_placement_group.nodepool_2.id
    labels             = {
        "role"          = "worker"
        "location"      = "${var.np_2_locations[count.index]}"
        "instance-type" = var.np_2_instance_type
    }
    network {
        network_id = hcloud_network.net.id
        ip         = local.np_2_ips[count.index]
    }
    depends_on = [
        hcloud_placement_group.nodepool_2,
        hcloud_network_subnet.cloud_servers
    ]
}
resource "hcloud_server" "nodepool_3" {
    count              = var.np_3_instance_count
    name               = "nodepool3-${count.index + 1}-${var.np_3_locations[count.index]}"
    image              = var.snapshot_id
    server_type        = var.np_3_instance_type
    location           = "${var.np_3_locations[count.index]}"
    ssh_keys           = var.ssh_keys
    placement_group_id = hcloud_placement_group.nodepool_3.id
    labels             = {
        "role"          = "worker"
        "location"      = "${var.np_3_locations[count.index]}"
        "instance-type" = var.np_3_instance_type
    }
    network {
        network_id = hcloud_network.net.id
        ip         = local.np_3_ips[count.index]
    }
    depends_on = [
        hcloud_placement_group.nodepool_3,
        hcloud_network_subnet.cloud_servers
    ]
}
resource "hcloud_server" "nodepool_4" {
    count              = var.np_4_instance_count
    name               = "nodepool4-${count.index + 1}-${var.np_4_locations[count.index]}"
    image              = var.snapshot_id
    server_type        = var.np_4_instance_type
    location           = "${var.np_4_locations[count.index]}"
    ssh_keys           = var.ssh_keys
    placement_group_id = hcloud_placement_group.nodepool_4.id
    labels             = {
        "role"          = "worker"
        "location"      = "${var.np_4_locations[count.index]}"
        "instance-type" = var.np_4_instance_type
    }
    network {
        network_id = hcloud_network.net.id
        ip         = local.np_4_ips[count.index]
    }
    depends_on = [
        hcloud_placement_group.nodepool_4,
        hcloud_network_subnet.cloud_servers
    ]
}