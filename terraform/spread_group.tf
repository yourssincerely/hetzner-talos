resource "hcloud_placement_group" "cp_spread_group" {
    name = "cp-spread"
    type = "spread"
    labels = {
      "role" = "control-plane",
    }
}
resource "hcloud_placement_group" "nodepool_1" {
    name = "nodepool_1"
    type = "spread"
    labels = {
      "role" = "worker",
    }
}
resource "hcloud_placement_group" "nodepool_2" {
    name = "nodepool_2"
    type = "spread"
    labels = {
      "role" = "worker",
    }
}
resource "hcloud_placement_group" "nodepool_3" {
    name = "nodepool_3"
    type = "spread"
    labels = {
      "role" = "worker",
    }
}
resource "hcloud_placement_group" "nodepool_4" {
    name = "nodepool_4"
    type = "spread"
    labels = {
      "role" = "worker",
    }
}