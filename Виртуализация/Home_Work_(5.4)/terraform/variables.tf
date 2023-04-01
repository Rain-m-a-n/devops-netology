# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1grgef7o02pmmkgrrvd"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gmie6p07gs449h84gj"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "ubuntu-22-04-lts-v20230330" {
  default = "fd8q1v63f44qhr62knmm"
}