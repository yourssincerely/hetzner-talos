variable "hcloud_token" {
    description = "The token for accessing the Hetzner Cloud API"
    type        = string
    sensitive   = true
}
# versions
variable "talos_version" {
    description = "Version of talos to be installed"
    type        = string
}
variable "kubernetes_version" {
    description = "Version of kubernetes to be installed"
    type        = string
}
variable "cluster_name" {
    description = "Name of the talos cluster"
    type        = string
}
# networking
variable "network_name" {
    description = "Name of the main network"
    type        = string
}
variable "network_zone" {
    description = "Zone of the main network"
    type        = string
}
variable "network_cidr" {
    description = "CIDR range of the main network"
    type        = string
}
variable "subnet_cloud_cidr" {
    description = "CIDR range of subnate that will allocate cloud servers and load balancers"
    type        = string
}
variable "cluster_cidr" {
    description = "CIDR range where pods will be allocated"
    type        = string
}
variable "service_cidr" {
    description = "CIDR range where services will be allocated"
    type        = string
}
# os
variable "snapshot_id" {
    description = "ID of the snapshot to be used as base OS in the nodes"
    type        = string
}
variable "ssh_keys" {
    description = "ID of the SSH keys used to log into the server"
    type        = list(string)
}
# load balancer
variable "lb_name" {
    description = "The name of the load balancer"
    type = string
}
variable "lb_type" {
    description = "The type of the load balancer"
    type = string
}
variable "lb_ip" {
    description = "IP address that will be assigned to the load balancer. Must be within the subnet_cloud_CIDR range"
    type        = string
}
variable "lb_location" {
    description = "Location where the Load Balancer will be deployed"
    type        = string
}
# control plane
variable "cp_instance_count" {
    description = "Number of control plane nodes. Must be odd"
    type        = number
}
variable "cp_instance_type" {
    description = "Instance type of the control plane nodes"
    type        = string
}
variable "cp_start_offset" {
    description = "Starting point within the `subnet_cloud_cidr` CIDR block from which to begin generating IP addresses of the control plane nodes"
    type        = number
}
variable "cp_locations" {
    description = "Location where the servers will be deployed. Run `hcloud location list` to get a list of all available locations"
    type        = list(string)
}
# nodepools
# nodepool 1
variable "np_1_instance_count" {
    description = "Number of nodes to be deployed in the nodepool 1"
    type        = number
}
variable "np_1_instance_type" {
    description = "Instance type of the nodes in the nodepool 1"
    type        = string
}
variable "np_1_start_offset" {
    description = "Starting point within the `subnet_cloud_cidr` CIDR block from which to begin generating IP addresses of the nodes of the nodepool 1"
    type        = number
}
variable "np_1_locations" {
    description = "Locations where the nodes in the nodepool 1 will be deployed"
    type        = list(string)
}
# nodepool 2
variable "np_2_instance_count" {
    description = "Number of nodes to be deployed in the nodepool 2"
    type        = number
}
variable "np_2_instance_type" {
    description = "Instance type of the nodes in the nodepool 2"
    type        = string
}
variable "np_2_start_offset" {
    description = "Starting point within the `subnet_cloud_cidr` CIDR block from which to begin generating IP addresses of the nodes of the nodepool 2"
    type        = number
}
variable "np_2_locations" {
    description = "Locations where the nodes in the nodepool 2 will be deployed"
    type        = list(string)
}
# nodepool 3
variable "np_3_instance_count" {
    description = "Number of nodes to be deployed in the nodepool 3"
    type        = number
}
variable "np_3_instance_type" {
    description = "Instance type of the nodes in the nodepool 3"
    type        = string
}
variable "np_3_start_offset" {
    description = "Starting point within the `subnet_cloud_cidr` CIDR block from which to begin generating IP addresses of the nodes of the nodepool 3"
    type        = number
}
variable "np_3_locations" {
    description = "Locations where the nodes in the nodepool 3 will be deployed"
    type        = list(string)
}
# nodepool 4
variable "np_4_instance_count" {
    description = "Number of nodes to be deployed in the nodepool 4"
    type        = number
}
variable "np_4_instance_type" {
    description = "Instance type of the nodes in the nodepool 4"
    type        = string
}
variable "np_4_start_offset" {
    description = "Starting point within the `subnet_cloud_cidr` CIDR block from which to begin generating IP addresses of the nodes of the nodepool 4"
    type        = number
}
variable "np_4_locations" {
    description = "Locations where the nodes in the nodepool 4 will be deployed"
    type        = list(string)
}