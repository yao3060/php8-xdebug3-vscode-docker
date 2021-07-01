terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.119.1"
    }
  }
}

provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# Find the zones that have the instance type we want and IPv6 support for SLB.
data "alicloud_zones" "default" {
  available_instance_type           = var.worker_instance_type
  available_slb_address_ip_version  = "ipv6"
}

data "alicloud_images" "images_cs" {
  owners      = "system"
  name_regex  = "^centos_7"
  most_recent = true
}
