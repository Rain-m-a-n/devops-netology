resource "yandex_vpc_network" "netology" {
  name        = var.vpc_name
  description = "VPC Network"
}

resource "yandex_vpc_subnet" "private-a" {
  name           = "private-a"
  zone           = var.zone-a
  network_id     = "${yandex_vpc_network.netology.id}"
  v4_cidr_blocks = var.private_cidr_a
}

resource "yandex_vpc_subnet" "private-b" {
  name           = "private-b"
  zone           = var.zone-b
  network_id     = "${yandex_vpc_network.netology.id}"
  v4_cidr_blocks = var.private_cidr_b
}

resource "yandex_vpc_subnet" "private-c" {
  name           = "private-c"
  zone           = var.zone-c
  network_id     = "${yandex_vpc_network.netology.id}"
  v4_cidr_blocks = var.private_cidr_c
}

resource "yandex_vpc_subnet" "public-a" {
  name           = "public"
  zone           = var.zone-a
  network_id     = "${yandex_vpc_network.netology.id}"
  v4_cidr_blocks = var.public_cidr_a
}

resource "yandex_vpc_subnet" "public-b" {
  name           = "public-b"
  zone           = var.zone-b
  network_id     = "${yandex_vpc_network.netology.id}"
  v4_cidr_blocks = var.public_cidr_b
}

resource "yandex_vpc_subnet" "public-c" {
  name           = "public-c"
  zone           = var.zone-c
  network_id     = "${yandex_vpc_network.netology.id}"
  v4_cidr_blocks = var.public_cidr_c
}

resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = "sec-group"
  network_id = yandex_vpc_network.netology.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "ANY"
    description    = "local network"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = "-1"
  }
}