# Talos Cluster on Hetzner Cloud with Terraform

This repository provides the necessary Terraform configuration and Packer templates to deploy a **minimal Talos cluster** on Hetzner Cloud.

The aim is to deploy a **highly configurable and minimal infrastructure** that can serve as a base for further customization and scaling. This configuration is **NOT production-ready**. It doesn't deploy a CNI, kube-proxy or metrics server. It's a starting point for users who need a minimal setup and want to build upon it.

## :white_check_mark: Requirements

* A [hetzner cloud](https://www.hetzner.com/cloud/) account
* [Packer](https://www.packer.io/)
* [Terraform](https://www.terraform.io/)

While these are optional, they are needed to interact with the cluster:
* [talosctl](https://www.talos.dev/v1.8/learn-more/talosctl/)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/)

## :warning: Disclaimer
> **Building the image and/or deploying the cluster will incur charges! :moneybag:**

## :minidisc: Build the Talos image
Additional information on how to build the Talos OS image can be found in the [official guide](https://www.talos.dev/v1.8/talos-guides/install/cloud-platforms/hetzner/) for more detailed instructions.

Navigate to the `packer` folder within the repo and update the required variables in `.pkrvars.hcl`:

* `talos_version`: Specify the desired Talos OS version.
* `arch`: Choose the architecture for the nodes (e.g., arm64).
* `server_type`: Select the type of server you want to provision (e.g., cax11).
* `server_location`: Set the server location (e.g., nbg1).

Once the variables are updated:

```
export HCLOUD_TOKEN=${TOKEN}
packer init .
packer build -var-file=.pkrvars.hcl .
```
You can set the `HCLOUD_TOKEN` variable in the method you prefer.<br>
After doing this, you can find the snapshot in the console interface.

## :rocket: Deploy the cluster

Navigate to the `terraform` fdirectory in the repository and modify the necessary variables in the `.tfvars` file. Descriptions are provided below. <br>
The `cloud` block within the `providers.tf` file is used for configuring Terraform Cloud as the backend for storing the state. If you prefer to use a different backend (e.g., AWS S3, Azure Blob Storage, etc.), feel free to update the configuration to suit your needs.

Please note that the `hcloud_token` variable must be defined somewhere. You can choose your preferred method for this, whether it's by defining it directly in the `.tfvars` file, as a variable in Terraform Cloud, or through an external secrets management tool.

Once you've made these changes, proceed with the following steps:

```
terraform init
terraform validate
terraform apply -var-file .tfvars
```
It'll take a few minutes to deploy all the resources. Once the plan has completed, we can save the talos and kubernetes configuration files:

```
terraform output -raw talosconfig > /path/to/talos/config
terraform output -raw kubeconfig > /path/to/kube/config
```

> :bulb: Please note that the kubeconfig must be updated, as we've used the internal IP address of the load balancer in the terraform plan.

```
nano /path/to/kube/config
```
And replace the line `https://lb_int_ipv4:6443` with `https://lb_ext_ipv4:6443`. <br>
I strongly suggest running `terraform destroy -var-file .tfvars -target=hcloud_load_balancer_target.worker --auto-approve` once the plan execution is complete as well.

> :bulb: We need the worker nodes to be reachable through the endpoint in order to apply the Talos configuration. After the configuration is applied, direct access to the worker nodes is no longer required.

### :exclamation: Additional notes

* This plan currently supports up to 10 nodes per nodepool. This is due to [hetzner's limit of 10 servers per placement group](https://docs.hetzner.com/cloud/placement-groups/overview).
* Additional configuration can be done by editing the `templates/cp_patch.yaml.tpl` and `templates/worker_patch.yaml.tmpl`. For instance, removing `cluster.network.cni` will deploy the cluster with the default CNI, flannel. Removing `cluster.proxy` will deploy the cluster with kube-proxy enabled.
* The location variables have been manually defined. While this is a bit hacky, automatically generating them would introduce unnecessary complexity. These variables are configured so that servers with the same index across different node pools are placed in different locations. For example, server 1 in nodepool 1 will be deployed in a different location than server 1 in nodepool 3.

### :wrench: Variable description
##### **talos_version**
`string`. For example, `"v1.8.3"`.
##### **kubernetes_version**
`string`. For example, `"1.31.3"`.
##### **cluster_name**
`string`. For example, `"my-cluster"`. Please note that the cluster name will be used as the DNS name of the cluster in `cluster.network.dnsDomain: "${cluster_name}.local"`.
##### **network_name**
`string`. The name of the Hetzner network. For example, `"my-net"`.
##### **network_zone**
`string`. The zone where the network will be deployed. For example, `"eu-central"`.
##### **network_cidr**
`string`. Defines the overall network CIDR range for the infrastructure. This range will encompass all subnets. For example, `"10.0.0.0/16"`.
##### **subnet_cloud_cidr**
`string`. Specifies the CIDR range for the subnet where the load balancer and cloud servers will be deployed. For example, `"10.0.1.0/24"`. This range will serve as the basis for dynamically assigning IP addresses to the node pools and control plane nodes.
##### **cluster_cidr**
`string`. The CIDR range for the cluster’s internal pod network. This range defines the IP addresses assigned to pods within the cluster. Must be within the Hetzner Cloud Network Range, but must not overlap with any created subnets. By default, Kubernetes assigns a `/24` (254 addresses) per Node. For example, `"10.0.16.0/20"`.
##### **service_cidr**
`string`. The CIDR range for the cluster’s internal services. This range is used for allocating virtual IP addresses to Kubernetes services. It can be within the Hetzner Cloud Network Range, as long as it does not overlap with any other Subnets. For example, `"10.0.8.0/21"`.

> :warning: Please design your network with care. The example values have been taken from [Hetzner's hccm github page](https://github.com/hetznercloud/hcloud-cloud-controller-manager/blob/main/docs/deploy_with_networks.md)

##### **snapshot_id**
`string`. The ID of the Talos OS snapshot created with Packer. You can get it from the [hetzner cloud console](https://console.hetzner.cloud/projects/3085823/servers/snapshots) or using the `hcloud` command `hcloud image list | grep "snapshot"`. For example, `"000000000"`.
##### **ssh_keys**
`list(string)`. The ssh keys that will be used to ssh into the server. This is a bit pointless, since Talos OS is designed to be immutable and minimal, and it does not include an SSH server for security and simplicity. However, I hate getting emails with the credentials everytime I deploy a server, so I have these set up. For example, `["00000000"]`.
##### **lb_name**
`string`. The name of the Load Balancer. For example: `"my-lb"`.
##### **lb_type**
`string`. The type of the Load Balancer. For example: `"lb11"`.
##### **lb_ip**
`string`. Internal IPv4 address of the Load Balancer. Must be a valid IP within the `subnet_cloud_cidr` range. For example, `"10.0.1.254"`.
#####  **lb_location**
`string`. Location where the Load Balancer will be deployed. For example, `"nbg1"`.
##### **cp_instance_count**
`number`. Number of control plane nodes to be deployed. For example, `3`. Must be odd.
##### **cp_instance_type**
`string`. Instance type of the control plane nodes. For example, `"cax11"`
#####  **cp_start_offset**
`number`. Specifies the starting index for assigning IP addresses to control plane nodes. This value is used as an offset within the defined CIDR range to ensure unique IP allocation. For example, it helps calculate control plane node IPs by incrementing from this starting point using a loop or function like `cidrhost`. IP addresses will be allocated in the `subnet_cloud_cidr` range. <br>
Setting `1` as `cp_start_offset` and `3` as `cp_instance_count` will result in the following list of IP addresses for the control plane nodes: `["10.0.1.1", "10.0.1.2", "10.0.1.3"]`.
For nodepools, setting `10` as `np_1_start_offset` will allocate IP addresses starting at `10.0.1.10` for that specific nodepool. You could set the first nodepool offset to `10`, the second nodepool offset to `20` and so on. This would allocate IPs from `10.0.1.10` to `10.0.1.19` to the first nodepool. IPs from `10.0.1.20` to `10.0.1.29` to the second one, etc. Please keep in mind the 10 node limit per nodepool.
##### **cp_locations**
`list(string)`. Locations have been set manually. While this is a bit hacky, automatically generating them would introduce unnecessary complexity. These variables are configured so that servers with the same index across different node pools are placed in different locations. For example, server 1 in nodepool 1 will be deployed in a different location than server 1 in nodepool 3.
