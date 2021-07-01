#####################
## MYSQL DATABASE
#####################
resource "alicloud_db_instance" "instance" {
  engine               = "MySQL"
  engine_version       = "8.0"
  instance_storage     = "30"
  instance_type        = var.rds_instance_type
  instance_charge_type = "Postpaid"
  instance_name        = var.project
  zone_id              = data.alicloud_zones.default.zones.0.id
#  zone_id_slave_a      = data.alicloud_zones.default.zones.1.id
  vswitch_id           = alicloud_vswitch.vswitches.0.id
#  vswitch_id           = join(",", alicloud_vswitch.vswitches.*.id) # If is HA version concatenate the IDs with colon.
  monitoring_period    = "60"
  security_ips         = [ "127.0.0.1" ]
  security_group_ids   = [alicloud_security_group.k8s.id]
#   resource_group_id    = alicloud_resource_manager_resource_group.project.id
}

resource "alicloud_db_database" "magento" {
  instance_id   = alicloud_db_instance.instance.id
  name          = "magento"
  character_set = "utf8"
}

resource "alicloud_db_account" "magento" {
  instance_id = alicloud_db_instance.instance.id
  name        = "magento"
  password    = var.magento_db_password
}

resource "alicloud_db_account_privilege" "magento" {
  instance_id  = alicloud_db_instance.instance.id
  account_name = alicloud_db_account.magento.name
  privilege    = "ReadWrite"
  db_names     = [alicloud_db_database.magento.name]
}

#####################
## REDIS DATABASE
#####################
resource "alicloud_kvstore_instance" "instance" {
  db_instance_name  = var.project
  vswitch_id        = alicloud_vswitch.vswitches.0.id
  instance_type     = "Redis"
  engine_version    = "4.0"
  zone_id           = data.alicloud_zones.default.zones.0.id
  instance_class    = var.redis_instance_type
  security_ips      = [ "127.0.0.1" ]
  security_group_id = alicloud_security_group.k8s.id
#   resource_group_id = alicloud_resource_manager_resource_group.project.id
}
