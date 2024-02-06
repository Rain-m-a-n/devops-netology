#resource "yandex_mdb_mysql_cluster" "netology" {
#  environment         = "PRESTABLE"
#  name                = "h-w-15-4"
#  network_id          = yandex_vpc_network.netology.id
#  version             = "8.0"
#  folder_id           = var.folder_id
#  deletion_protection = false
#
#  backup_window_start {
#    hours   = 23
#    minutes = 59
#  }
#
#  resources {
#    disk_size          = 20
#    disk_type_id       = "network-hdd"
#    resource_preset_id = "b1.medium"
#  }
#
#  maintenance_window {
#    type = "WEEKLY"
#    day  = "SAT"
#    hour = 2
#  }
#
#  host {
#    zone      = var.zone-a
#    name      = "db01"
#    subnet_id = yandex_vpc_subnet.private-a.id
#  }
#
#  host {
#    zone      = var.zone-b
#    name      = "db02"
#    priority  = 5
#    subnet_id = yandex_vpc_subnet.private-b.id
#  }
#
#  host {
#    zone      = var.zone-c
#    name      = "db03"
#    priority  = 10
#    subnet_id = yandex_vpc_subnet.private-c.id
#  }
#
#}
#resource "yandex_mdb_mysql_database" "database" {
#  cluster_id = yandex_mdb_mysql_cluster.netology.id
#  name       = "netology_db"
#}
#
#resource "yandex_mdb_mysql_user" "user" {
#  cluster_id = yandex_mdb_mysql_cluster.netology.id
#  name       = "user"
#  password   = var.pass_db
#}