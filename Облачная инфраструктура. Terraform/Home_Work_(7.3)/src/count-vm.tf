
data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}

resource "yandex_compute_instance" "web" {
  count = 2
  name        = "netology-develop-${count.index}"
  platform_id = var.vm_platform
  resources {
    cores         = local.cpu
    memory        = local.mem
    core_fraction = local.frac
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys              = local.key    
    serial-port-enable    = local.sport
  }

}
