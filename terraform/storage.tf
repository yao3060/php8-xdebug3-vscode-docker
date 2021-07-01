#####################
## CONTAINER STORAGE
#####################
# resource "alicloud_cr_namespace" "registry" {
#   name               = var.project
#   auto_create        = true
#   default_visibility = "PRIVATE"
# }

#####################
## NAS STORAGE
#####################
resource "alicloud_nas_file_system" "data" {
  protocol_type = "NFS"
  storage_type  = "Performance"
  description   = var.project
}

resource "alicloud_nas_access_group" "data" {
  access_group_name        = var.project
  access_group_type        = "Vpc"
}

resource "alicloud_nas_mount_target" "data" {
  count             = length(alicloud_vswitch.vswitches)
  file_system_id    = alicloud_nas_file_system.data.id
  access_group_name = alicloud_nas_access_group.data.access_group_name
  vswitch_id        = alicloud_vswitch.vswitches[count.index].id
}
