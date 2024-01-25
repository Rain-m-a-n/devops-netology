# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
    ```bash
    > $ yc storage bucket list                                                                        [±15.2 ●●●]
    +----------------+----------------------+----------+-----------------------+---------------------+
    |      NAME      |      FOLDER ID       | MAX SIZE | DEFAULT STORAGE CLASS |     CREATED AT      |
    +----------------+----------------------+----------+-----------------------+---------------------+
    | static-picture | b1gmie6p07gs449h84gj |        0 | STANDARD              | 2024-01-25 13:38:57 |
    +----------------+----------------------+----------+-----------------------+---------------------+
    ```
 - Положить в бакет файл с картинкой.
    ```bash
    > $ yc storage bucket stats static-picture                                                        [±15.2 ●●●]
    name: static-picture
    used_size: "163637"
    storage_class_used_sizes:
   - storage_class: STANDARD
     class_size: "163637"
     storage_class_counters:
   - storage_class: STANDARD
     counters:
     simple_object_size: "163637"
     simple_object_count: "1"
     default_storage_class: STANDARD
     anonymous_access_flags:
     read: true
     list: false
     config_read: false
     created_at: "2024-01-25T13:38:57.119126Z"
     updated_at: "2024-01-25T13:45:15.438138Z"
      ```
 - Сделать файл доступным из интернета.
    ![cartoon](https://github.com/Rain-m-a-n/devops-netology/blob/master/Проект%20в%20облачных%20провайдерах/15.2/pic/cartoon.png)
   
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:
- Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`. 
   ```bash
    > $ yc compute instance-group list                                                                [±15.2 ●●●]
    +----------------------+------+--------+------+
    |          ID          | NAME | STATUS | SIZE |
    ----------------------+------+--------+------+
     cl1pa03feciv2ht7fc7o | lamp | ACTIVE |    3 |
    +----------------------+------+--------+------+

    > $ yc compute instance-group list-instances --id cl1pa03feciv2ht7fc7o                            [±15.2 ●●●]
    +----------------------+---------------------------+---------------+---------------+------------------------+----------------+
    |     INSTANCE ID      |           NAME            |  EXTERNAL IP  |  INTERNAL IP  |         STATUS         | STATUS MESSAGE |
    +----------------------+---------------------------+---------------+---------------+------------------------+----------------+
    | fhmrket77sb14jhh1dbq | cl1pa03feciv2ht7fc7o-ibos | 51.250.13.38  | 192.168.10.28 | RUNNING_ACTUAL [2h32m] |                |
    | fhmksimmihs7boafmqmr | cl1pa03feciv2ht7fc7o-obac | 51.250.77.228 | 192.168.10.18 | RUNNING_ACTUAL [2h31m] |                |
    | fhm556ojkn0s1kgpklsv | cl1pa03feciv2ht7fc7o-adec | 158.160.98.63 | 192.168.10.9  | RUNNING_ACTUAL [23m]   |                |
    +----------------------+---------------------------+---------------+---------------+------------------------+----------------+
   
   > $ yc compute instance-group get --id cl1pa03feciv2ht7fc7o                                                                            [±15.2 ●●●]
    id: cl1pa03feciv2ht7fc7o
    folder_id: ******************
    created_at: "2024-01-25T15:08:27.383Z"
    name: lamp
    instance_template:
    platform_id: standard-v1
    resources_spec:
    memory: "2147483648"
    cores: "2"
    core_fraction: "5"
    boot_disk_spec:
    ode: READ_WRITE
    disk_spec:
    type_id: network-hdd
    size: "8589934592"
    image_id: fd827b91d99psvq5fjit
   
     ----------
    scale_policy:
    fixed_scale:
    size: "3"
    deploy_policy:
    max_unavailable: "2"
    max_deleting: "1"
    max_creating: "1"
    max_expansion: "1"
    strategy: PROACTIVE
    ```
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
    ```bash
    > $ yc lb nlb list                                                                                                                     [±15.2 ●●●]
    +----------------------+-------------+-------------+----------+----------------+------------------------+--------+
    |          ID          |    NAME     |  REGION ID  |   TYPE   | LISTENER COUNT | ATTACHED TARGET GROUPS | STATUS |
    +----------------------+-------------+-------------+----------+----------------+------------------------+--------+
    | enpddjvu7ktfrog27vr5 | netology-lb | ru-central1 | EXTERNAL |              1 | enpu03tr02evfhh6k6uq   | ACTIVE |
    +----------------------+-------------+-------------+----------+----------------+------------------------+--------+
    
    > $ yc lb tg list                                                                                                                      [±15.2 ●●●]
    +----------------------+------------+---------------------+-------------+--------------+
    |          ID          |    NAME    |       CREATED       |  REGION ID  | TARGET COUNT |
    +----------------------+------------+---------------------+-------------+--------------+
    | enpu03tr02evfhh6k6uq | lamp-group | 2024-01-25 15:58:04 | ru-central1 |            3 |
    +----------------------+------------+---------------------+-------------+--------------+
    ```
 - Проверить работоспособность, удалив одну или несколько ВМ.
    ```bash
    > $ yc compute instance list                                                                                                           [±15.2 ●●●]
    +----------------------+---------------------------+---------------+---------+---------------+---------------+
    |          ID          |           NAME            |    ZONE ID    | STATUS  |  EXTERNAL IP  |  INTERNAL IP  |
    +----------------------+---------------------------+---------------+---------+---------------+---------------+
    | fhm556ojkn0s1kgpklsv | cl1pa03feciv2ht7fc7o-adec | ru-central1-a | RUNNING | 158.160.98.63 | 192.168.10.9  |
    | fhmksimmihs7boafmqmr | cl1pa03feciv2ht7fc7o-obac | ru-central1-a | RUNNING | 51.250.77.228 | 192.168.10.18 |
    | fhmrket77sb14jhh1dbq | cl1pa03feciv2ht7fc7o-ibos | ru-central1-a | RUNNING | 51.250.13.38  | 192.168.10.28 |
    +----------------------+---------------------------+---------------+---------+---------------+---------------+

    > $ yc compute instance delete fhmksimmihs7boafmqmr                                                                                      [±15.2 ●●●]
    done (55s)
   
    > $ yc compute instance list                                                                                                           [±15.2 ●●●]
    +----------------------+---------------------------+---------------+---------+---------------+---------------+
    |          ID          |           NAME            |    ZONE ID    | STATUS  |  EXTERNAL IP  |  INTERNAL IP  |
    +----------------------+---------------------------+---------------+---------+---------------+---------------+
    | fhm556ojkn0s1kgpklsv | cl1pa03feciv2ht7fc7o-adec | ru-central1-a | RUNNING | 158.160.98.63 | 192.168.10.9  |
    | fhmrket77sb14jhh1dbq | cl1pa03feciv2ht7fc7o-ibos | ru-central1-a | RUNNING | 51.250.13.38  | 192.168.10.28 |
    +----------------------+---------------------------+---------------+---------+---------------+---------------+

    > $ curl 158.160.129.188                                                                                                               [±15.2 ●●●]
    <html>
    <body>

       <h1>Hi, this is picture in Object Storage </h1>

       <img src="https://storage.yandexcloud.net/static-picture/3hero.jpg" /img>

    </body>
    </html>

    ```
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---
Resource Terraform:

- [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template).
- [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group).
- [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration).

