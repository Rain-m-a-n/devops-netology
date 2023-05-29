data "yandex_compute_image" "ubuntu_prod" {
  family = var.vm_family
}

resource "yandex_compute_instance" "prod" {
  depends_on = [yandex_compute_instance.web]
    for_each = {
    for index, vm in var.vm_resource : vm.vm_name => vm
    }
  name        = each.value.vm_name
  platform_id = var.vm_platform
  
  resources {
    cores         = each.value.cpu
    memory        = each.value.mem
    core_fraction = each.value.frac
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


variable "vm_resource" {
    type = list (object({
        vm_name         = string
        cpu             = number
        mem             = number
        hdd             = number
        frac            = number
    }))
    default  = [{
        vm_name         = "prod-1"
        cpu             = 2
        mem             = 1
        hdd             = 1 
        frac            = 5
        },
        {
        vm_name         = "prod-2"
        cpu             = 2
        mem             = 2
        hdd             = 2
        frac            = 20    
        }]
}