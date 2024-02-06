resource "yandex_iam_service_account" "kube" {
  folder_id = var.folder_id
  name      = "kuber-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  # Сервисному аккаунту назначается роль "editor".
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.kube.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.kube.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.kube.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-publicAdmin" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.kube.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  # Сервисному аккаунту назначается роль "container-registry.images.puller".
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.kube.id}"
}

resource "yandex_kubernetes_cluster" "kuber" {
  network_id              = yandex_vpc_network.netology.id
  service_account_id      = yandex_iam_service_account.kube.id
  node_service_account_id = yandex_iam_service_account.kube.id
  release_channel         = "STABLE"
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-publicAdmin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }

  labels = {
    cluster  = "netology"
    location = "yandex"
  }
  master {
    version   = "1.28"
    public_ip = true

    maintenance_policy {
      auto_upgrade = false

      maintenance_window {
        duration   = "3h"
        start_time = "02:00"
        day        = "saturday"
      }
    }

    master_logging {
      enabled = false
      folder_id = var.folder_id
      kube_apiserver_enabled = false
      cluster_autoscaler_enabled = false
      events_enabled = false
      audit_enabled = false
    }

    regional {
      region = "ru-central1"

      location {
        zone      = var.zone-a
        subnet_id = "${yandex_vpc_subnet.public-a.id}"
      }

      location {
        zone      = var.zone-b
        subnet_id = "${yandex_vpc_subnet.public-b.id}"
      }

      location {
        zone      = var.zone-c
        subnet_id = "${yandex_vpc_subnet.public-c.id}"
      }
    }
  security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
  }
}

resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ Yandex Key Management Service для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}

resource "yandex_kubernetes_node_group" "k8s" {
  cluster_id  = "${yandex_kubernetes_cluster.kuber.id}"
  name        = "k8s-cluster"
  version     = "1.28"

  instance_template {
    platform_id = "standard-v2"
    network_acceleration_type = "standard"
    network_interface {
      nat         = true
      subnet_ids  = ["${yandex_vpc_subnet.public-a.id}"]
    }
    resources {
      core_fraction = 50
      cores         = 2
      memory        = 4
    }
    boot_disk {
      size = 64
      type = "network-hdd"
    }
    container_runtime {
      type = "containerd"
    }
    scheduling_policy {
      preemptible =  true
    }
  }
  scale_policy {
    auto_scale {
      initial = 3
      max     = 6
      min     = 3
    }
  }
  allocation_policy {
    location {
      zone = var.zone-a
    }
  }
  maintenance_policy {
    auto_repair  = true
    auto_upgrade = false
  }
}