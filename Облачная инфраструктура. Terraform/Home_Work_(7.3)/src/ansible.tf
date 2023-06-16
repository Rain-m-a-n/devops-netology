resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {vm_count = yandex_compute_instance.web
     vm_for = yandex_compute_instance.prod }) 
  
  filename = "${abspath(path.module)}/hosts"
  
}
