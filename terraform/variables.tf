###################
# GLOBAL CONFIG
###################

variable "project" {
  type = string
  default = "test"
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
  default = "cn-shanghai"
}

###################
# CLUSTER CONFIG
###################

variable "worker_number" {
  type = number
  default = 2
}

variable "max_asg_size" {
  type = number
  default = 5
}

variable "worker_instance_type" {
  type = string
  default = "ecs.g6.large"
}

variable "cluster_addons" {
  description = "Addon components in kubernetes cluster"

  type = list(object({
    name      = string
    config    = string
  }))

  default = [
    {
      "name"     = "flannel",
      "config"   = "",
    },
    {
      "name"     = "csi-plugin",
      "config"   = "",
    },
    {
      "name"     = "csi-provisioner",
      "config"   = "",
    },
    {
      "name"     = "nginx-ingress-controller",
      "config"   = "{\"IngressSlbNetworkType\":\"internet\"}",
    }
  ]
}

###################
# DATABASE CONFIG
###################
variable "rds_instance_type" {
  type = string
  default = "mysql.n1.micro.1"
}

variable "redis_instance_type" {
  type = string
  default = "redis.master.micro.default"
}

variable "magento_db_password" {
  type = string
}
