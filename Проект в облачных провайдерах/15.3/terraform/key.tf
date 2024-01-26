resource "yandex_kms_symmetric_key" "bucket" {
  name              = "for-bucket"
  description       = "тестирую KMS"
  default_algorithm = "AES_128"
  folder_id         = var.folder_id
  rotation_period   = "8760h"
  }
