resource "alicloud_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"
  vpc_name   = var.project
}

resource "alicloud_vswitch" "vswitches" {
  count             = 2
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = element(["172.31.32.0/20", "172.31.16.0/20"], count.index)
  zone_id           = data.alicloud_zones.default.zones[count.index % length(data.alicloud_zones.default.zones)]["id"]
  vswitch_name      = "${var.project}-${count.index}"
}

resource "alicloud_nat_gateway" "nat" {
  vpc_id = alicloud_vpc.vpc.id
  name   = var.project
}

resource "alicloud_eip" "nat" {
  name                 = "${var.project}-nat"
  bandwidth            = 1
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip_association" "nat" {
  allocation_id = alicloud_eip.nat.id
  instance_id   = alicloud_nat_gateway.nat.id
}

resource "alicloud_snat_entry" "nat" {
  count             = length(alicloud_vswitch.vswitches)
  depends_on        = [alicloud_eip_association.nat]
  snat_table_id     = alicloud_nat_gateway.nat.snat_table_ids
  source_vswitch_id = alicloud_vswitch.vswitches[count.index].id
  snat_ip           = alicloud_eip.nat.ip_address
}
