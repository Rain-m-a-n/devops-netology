resource "yandex_compute_instance_group" "lamp" {
  name                = "lamp"
  folder_id           = var.folder_id
  service_account_id  = var.sa
  deletion_protection = false
  instance_template {
    platform_id = var.platform
    resources {
      cores         = 2
      memory        = 2
      core_fraction = 5
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 8
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.netology.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat        = true
    }
    metadata = {
      user-data = file("${path.module}/start-page.yaml")
    }
    scheduling_policy {
      preemptible = true
    }
  }
    scale_policy {
      fixed_scale {
        size = 3
      }
    }
    allocation_policy {
      zones = ["ru-central1-a"]
    }
    deploy_policy {
      max_unavailable = 2
      max_creating    = 1
      max_expansion   = 1
      max_deleting    = 1
    }
    health_check {
      timeout  = "20"
      interval = "10"
      http_options {
        path = "/"
        port = 80
      }
    }
  }





