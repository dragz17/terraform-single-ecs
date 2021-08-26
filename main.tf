resource "alicloud_vpc" "vpc" {
  vpc_name       = "tf-vpc"
  cidr_block = "192.168.0.0/16"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "192.168.0.0/24"
  zone_id           = "ap-southeast-5a"
}

resource "alicloud_security_group" "default" {
  name        = "tf_test_foo"
  description = "foo"
  vpc_id      = alicloud_vpc.vpc.id
}

data "alicloud_instance_types" "c2g4" {
  cpu_core_count = 2
  memory_size    = 4
}

data "alicloud_images" "default" {
  name_regex  = "^ubuntu"
  most_recent = true
  owners      = "system"
}

# Create a web server
resource "alicloud_instance" "web" {
  image_id              = "${data.alicloud_images.default.images.0.id}"
  internet_charge_type  = "PayByBandwidth"
  instance_type        = "${data.alicloud_instance_types.c2g4.instance_types.0.id}"
  system_disk_category = "cloud_efficiency"
  security_groups      = ["${alicloud_security_group.default.id}"]
  instance_name        = "web"
  vswitch_id           = alicloud_vswitch.vswitch.id
}
