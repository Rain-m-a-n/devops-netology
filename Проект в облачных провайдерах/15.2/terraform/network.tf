resource "yandex_vpc_network" "netology" {
  name        = var.vpc_name
  description = "VPC Network"
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.default_zone
  network_id     = "${yandex_vpc_network.netology.id}"
  v4_cidr_blocks = var.private_cidr
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = "${yandex_vpc_network.netology.id}"
  v4_cidr_blocks = var.public_cidr
}