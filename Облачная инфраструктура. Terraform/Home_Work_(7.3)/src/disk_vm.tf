resource "yandex_compute_disk" "volumes" {
    count = 3
    name = "disk-${count.index}"
    type = "network-hdd"
    size = 1
    zone = var.default_zone
}

data "yandex_compute_image" "ubuntu_vm" {
    family = var.vm_family
}
resource "yandex_compute_instance" "vmdisks" {
  name        = "vmdisks"
  depends_on = [yandex_compute_instance.web]
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
  
  dynamic secondary_disk {
    for_each = yandex_compute_disk.volumes.*.id 
        content {
            disk_id = secondary_disk.value
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable    = local.sport
    ssh-keys              = local.key    
  }

}

