variable "vpc_name" {
  type        = string
  default     = "netology"
  description = "VPC network for 15.1"
}

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "default_zone" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "folder_id" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "ssh_adm_key" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "platform" {
  type = string
  default = "standard-v1"
}
variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "sa" {
  type       = string
}

variable "root_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_key_path" {
  type    = string
  default = "./ssh_key"
}

variable "ssh_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbD88iq8wabgdWNTAyoWJWvPX14o0uZRpweXxPd/oxCCUYD17QQlq75/Kicmhh/uOzUS2AIFZ+SiwVThJKHAuhjTdqU4Jz/KEAvJDFltCGAMWo9pn+moxQC3iD60EfPaL2903oxa4k/f69ZGZeyK2hpv9qlXdTLSQEEBgLe9h4rIV0yyS+uZQ2nwdF+mBd5+TxQ9A+ZBcGaTfhX3qteNaaqiTs/mLpS1OvrMWLLMsoeOvqLoUiZGKaNa276EEDs/9P1IrBmAvDsfwNIAlcXa7kbcC/NXvuUpG0lnq5eZyyYAW/o3YSreCoc0sZM9qGzW9yIqjoce7KGxyluJ0JqmV3gmsP+a2TVyEW65P3sW3UzfIFRWZYj0x1Li2QJbl1MIsfXfj+/jfl3gP5Q6Y+DT5eKzNe0Lf33m0Kq6fFB2LaWz4GEXjJDNYkme/7EKtRecsVkTkw2efzxxmR9Mf71eCiDwX7EfB0qBDFIxCE+ScPyKG2P6EvCnjwDu4gRdMZWC8= bortnikov@MacBook.local"
}