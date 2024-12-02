locals {
    cp_ips = [for i in range(var.cp_start_offset, var.cp_start_offset + var.cp_instance_count) : cidrhost(var.subnet_cloud_cidr, i)]
    np_1_ips = [for i in range(var.np_1_start_offset, var.np_1_start_offset + var.np_1_instance_count) : cidrhost(var.subnet_cloud_cidr, i)]
    np_2_ips = [for i in range(var.np_2_start_offset, var.np_2_start_offset + var.np_2_instance_count) : cidrhost(var.subnet_cloud_cidr, i)]
    np_3_ips = [for i in range(var.np_3_start_offset, var.np_3_start_offset + var.np_3_instance_count) : cidrhost(var.subnet_cloud_cidr, i)]
    np_4_ips = [for i in range(var.np_4_start_offset, var.np_4_start_offset + var.np_4_instance_count) : cidrhost(var.subnet_cloud_cidr, i)]
    worker_ips = concat(local.np_1_ips, local.np_2_ips, local.np_3_ips, local.np_4_ips)
}