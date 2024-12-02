terraform {
    cloud {
        organization = "your_org_name"
        workspaces {
            name = "your_workspace"
        }
    }
    required_providers {
        hcloud = {
            source = "hetznercloud/hcloud"
            version = "1.48.0"
        }
        talos = {
            source  = "siderolabs/talos"
            version = "0.7.0-alpha.0"
        }
    }
}
provider "hcloud" {
    token = var.hcloud_token
}