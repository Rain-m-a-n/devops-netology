output "external_web" {
  value = "${yandex_compute_instance.platform.name} = ${yandex_compute_instance.platform.network_interface.0.nat_ip_address}}"
}

output "external_db" {
  value = "${yandex_compute_instance.platform_db.name} = ${yandex_compute_instance.platform_db.network_interface[0].nat_ip_address}}"
}

output "str" {
  value = "${local.test_map.admin} is admin for ${local.test_list[2]} server based on OS ${local.servers.production.image} with ${local.servers.production.cpu} vcpu, ${local.servers.production.ram} ram and ${length(local.servers.production.disks)} virtual disks"
  
}

