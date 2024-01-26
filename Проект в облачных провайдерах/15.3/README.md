# Домашнее задание к занятию «Безопасность в облачных провайдерах»  

Используя конфигурации, выполненные в рамках предыдущих домашних заданий, нужно добавить возможность шифрования бакета.

---
## Задание 1. Yandex Cloud   

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

 - создать ключ в KMS;
    ```bash
   resource "yandex_kms_symmetric_key" "bucket" {
    name              = "for-bucket"
    description       = "тестирую KMS"
    default_algorithm = "AES_128"
    folder_id = var.folder_id
    rotation_period   = "8760h"
    }
   ```
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.  
    ![pic](https://github.com/Rain-m-a-n/devops-netology/blob/master/Проект%20в%20облачных%20провайдерах/15.3/pic/secure.png)
2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:

 - создать сертификат;
    ```bash
    > $ yc certificate-manager certificate list                                                                                            [±15.3 ●●●]
    +----------------------+----------+--------------------------------------------+-----------+---------+------------+
    |          ID          |   NAME   |                  DOMAINS                   | NOT AFTER |  TYPE   |   STATUS   |
    +----------------------+----------+--------------------------------------------+-----------+---------+------------+
    | fpqb9mi0ql9idmrnlb9g | netology | netology-bortnikov.website.yandexcloud.net |           | MANAGED | VALIDATING |
    +----------------------+----------+--------------------------------------------+-----------+---------+------------+
    ```
 - создать статическую страницу в Object Storage и применить сертификат HTTPS;
 - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).  
   ![pic](https://github.com/Rain-m-a-n/devops-netology/blob/master/Проект%20в%20облачных%20провайдерах/15.3/pic/web.png)

Полезные документы:

- [Настройка HTTPS статичного сайта](https://cloud.yandex.ru/docs/storage/operations/hosting/certificate).
- [Object Storage bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket).
- [KMS key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key).
Resource Terraform:

- [IAM Role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role).
- [AWS KMS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key).
- [S3 encrypt with KMS key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object#encrypting-with-kms-key).
