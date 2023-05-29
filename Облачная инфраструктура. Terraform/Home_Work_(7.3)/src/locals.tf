locals {
    cpu     = "2"
    mem     = "1"
    frac    = "5"
}

locals {
    key     = "ubuntu:${var.vms_ssh_root_key}"
    sport   = "1"
}

