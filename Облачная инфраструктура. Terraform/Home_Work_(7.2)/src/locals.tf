locals {
  vm_web = "${var.tutor}-${var.kurs}-${var.vm_name}-${var.web}"
  vm_db  = "${var.tutor}-${var.kurs}-${var.vm_name}-${var.db}"
}

locals {
    vm_db_resources     = {core = "2", mem = "2", frac = "20"}
    vm_web_resources    = {core = "2", mem = "1", frac = "5"}
    sport               = "1"
    key                 = "ubuntu:${var.vms_ssh_root_key}"
}
