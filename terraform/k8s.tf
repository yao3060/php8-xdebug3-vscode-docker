resource "alicloud_cs_managed_kubernetes" "k8s" {
  name                      = var.project
  version                   = "1.18.8-aliyun.1"
  worker_vswitch_ids        = alicloud_vswitch.vswitches.*.id
  new_nat_gateway           = false
  password                  = "TODO-CHANGE-TO-key_name"
  worker_instance_types     = [var.worker_instance_type]
  worker_number             = var.worker_number
  worker_disk_category      = "cloud_efficiency"
  worker_data_disk_category = "cloud_ssd"
  worker_data_disk_size     = 40
  security_group_id         = alicloud_security_group.k8s.id
  # resource_group_id         = alicloud_resource_manager_resource_group.project.id
  pod_cidr                  = "172.20.0.0/16"
  service_cidr              = "172.21.0.0/20"

  slb_internet_enabled      = false
  runtime = {
    name    = "docker"
    version = "19.03.5"
  }

  dynamic "addons" {
      for_each = var.cluster_addons
      content {
        name   = lookup(addons.value, "name", var.cluster_addons)
        config = lookup(addons.value, "config", var.cluster_addons)
      }
  }
}

resource "alicloud_security_group" "k8s" {
  name   = "${var.project}-k8s"
  vpc_id = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "k8s_allow_internal" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.k8s.id
  cidr_ip           = "10.0.0.0/8"
}

resource "alicloud_security_group_rule" "k8s_allow_internal_vpc" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.k8s.id
  cidr_ip           = "172.31.0.0/16"
}

resource "alicloud_security_group_rule" "k8s_allow_outgoing" {
  type              = "egress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.k8s.id
  cidr_ip           = "0.0.0.0/0"
}

###############
## Autoscaling
###############
resource "alicloud_cs_kubernetes_node_pool" "autoscale" {
  name                         = "${var.project}-autoscale"
  cluster_id                   = alicloud_cs_managed_kubernetes.k8s.id
  vswitch_ids                  = alicloud_vswitch.vswitches.*.id
  instance_types               = [var.worker_instance_type]
  system_disk_category         = "cloud_efficiency"
  system_disk_size             = 40
  password                     = "TODO-CHANGE-TO-key_name"
  install_cloud_monitor        = true

  # automatic scaling node pool configuration.
  scaling_config {
    min_size      = 0
    max_size      = 10
  }

}

resource "alicloud_ram_policy" "autoscale" {
  policy_name = "CSAutoscaling-k8s"
  policy_document = <<EOF
  {
    "Version": "1",
    "Statement": [
      {
        "Action": [
          "ess:DescribeScalingGroups",
          "ess:DescribeScalingInstances",
          "ess:DescribeScalingActivities",
          "ess:DescribeScalingConfigurations",
          "ess:DescribeScalingRules",
          "ess:DescribeScheduledTasks",
          "ess:DescribeLifecycleHooks",
          "ess:DescribeNotificationConfigurations",
          "ess:DescribeNotificationTypes",
          "ess:DescribeRegions",
          "ess:CreateScalingRule",
          "ess:ModifyScalingGroup",
          "ess:RemoveInstances",
          "ess:ExecuteScalingRule",
          "ess:ModifyScalingRule",
          "ess:DeleteScalingRule",
          "ecs:DescribeInstanceTypes",
          "ess:DetachInstances",
          "vpc:DescribeVSwitches"
        ],
        "Resource": [
          "*"
        ],
        "Effect": "Allow"
      }
    ]
  }
  EOF
  description = "Allow autoscaling of k8s nodes"
  force       = true
}

resource "alicloud_ram_role_policy_attachment" "autoscale" {
  policy_name = alicloud_ram_policy.autoscale.name
  policy_type = alicloud_ram_policy.autoscale.type
  role_name   = alicloud_cs_managed_kubernetes.k8s.worker_ram_role_name
}
