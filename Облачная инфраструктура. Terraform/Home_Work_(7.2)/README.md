# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Задание 1

1. Изучите проект. В файле variables.tf объявлены переменные для yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
3. Сгенерируйте или используйте свой текущий ssh ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
4. Инициализируйте проект, выполните код. Исправьте возникшую ошибку. Ответьте в чем заключается ее суть?
  * Ошибка:
    ```bash
    .......
    yandex_compute_instance.platform: Creating...

    │ Error: Error while requesting API to create instance: server-request-id = 3a1d2c69-f54c-4f29-8ac0-05634e9a647e server-trace-id = 6724e797f9a5bf95:25c480e11a344c9:6724e797f9a5bf95:1 client-request-id = 57476340-9902-45f3-b5e9-7e3a0e9f5415 client-trace-id = 3ddd2d33-cf3d-46ee-b568-ad2421cd48ca rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v1"; allowed core number: 2, 4
    │ 
    │   with yandex_compute_instance.platform,
    │   on main.tf line 16, in resource "yandex_compute_instance" "platform":
    │   16: resource "yandex_compute_instance" "platform" {
    ```
  * Суть ошибки в том, что на платформе ```standard-v1``` доступно минимум 2 ядра, а в конфиге указан (1)  
  ![standart](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.2)/pics/standart.png) 

5. Ответьте, как в процессе обучения могут пригодиться параметры```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ? Ответ в документации Yandex cloud.
  * **preemptible VM** - прерываемые ВМ, хороши тем, что если при выполнении ДЗ забыть ее выключить, она будет выключена через случайный момент в промежутке 22-24 часа с момента запуска. Так же этот тип ВМ удобен тем, что если в указанной зоне не будет хватать ресурсов для запуска обычной ВМ, прерываемая будет выключена автоматически.
  * **core_fraction** - уровень производительности CPU. От его значения зависит стоимость ВМ и вычислительные возможности. Виртуальные машины с уровнем производительности меньше 100% имеют доступ к вычислительной мощности физических ядер как минимум на протяжении указанного процента от единицы времени. 

В качестве решения приложите:
- скриншот ЛК Yandex Cloud с созданной ВМ,  
![Yandex](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.2)/pics/yc_1.png)
- скриншот успешного подключения к консоли ВМ через ssh,  
![connect](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.2)/pics/connect.png)
- ответы на вопросы.


### Задание 2

1. Изучите файлы проекта.
2. Замените все "хардкод" **значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.  
![plan](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.2)/pics/conf.png)
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf.   
![plan](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.2)/pics/var.png)
3. Проверьте terraform plan (изменений быть не должно).   
![plan](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.2)/pics/plan.png)


### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ(в файле main.tf): **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом **vm_db_** в том же файле('vms_platform.tf').
3. Примените изменения.
![VM_2](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.2)/pics/vm_2.png)


### Задание 4

1. Объявите в файле outputs.tf отдельные output, для каждой из ВМ с ее внешним IP адресом.
    ```bash
    output "external_ip_address_web" {
      value = yandex_compute_instance.platform.network_interface.0.nat_ip_address
    }
    output "external_ip_address_db" {
      value = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
    }
    ```
2. Примените изменения.
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.2)/src]$ terraform output                       *[master]
    external_db = "{netology-develop-platform-db = 158.160.98.77}"
    external_web = "{netology-develop-platform-web = 51.250.76.222}"
    ```

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
    ```bash
    locals {
      vm_web = "${var.tutor}-${var.kurs}-${var.vm_name}-${var.web}"
    }
    
    locals {
      vm_db = "${var.tutor}-${var.kurs}-${var.vm_name}-${var.db}"
    }
    ```
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.
    ```bash
    resource "yandex_compute_instance" "platform" {
    name        = local.vm_web
    ___________
    resource "yandex_compute_instance" "platform_db" {
    name        = local.vm_db
    platform_id = var.vm_db_platform
    ```

3. Примените изменения.
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.2)/src]$ terraform apply                        *[master]
    data.yandex_compute_image.ubuntu: Reading...
    data.yandex_compute_image.ubuntu_db: Reading...
    yandex_vpc_network.develop: Refreshing state... [id=enpeuj5i6941feec0u4h]
    data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd83gfh90hpp3sojs1r3]
    data.yandex_compute_image.ubuntu_db: Read complete after 0s [id=fd83gfh90hpp3sojs1r3]
    yandex_vpc_subnet.develop: Refreshing state... [id=e9b13m8bbkp309l1mjem]
    yandex_compute_instance.platform: Refreshing state... [id=fhmnvnuvt88lillkvgqo]
    yandex_compute_instance.platform_db: Refreshing state... [id=fhmt43fu5nei12sqbm4r]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are
    needed.
    
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    external_db = "{netology-develop-platform-db = 158.160.98.77}"
    external_web = "{netology-develop-platform-web = 51.250.76.222}"
    ```

### Задание 6

1. Вместо использования 3-х переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедените их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources".
  * Добавил сразу переменные со следуещего щага
    ```bash
    locals {
        vm_db_resources     = {core = "2", mem = "2", frac = "20"}
        vm_web_resources    = {core = "2", mem = "1", frac = "5"}
        sport               = "1"
        key                 = "ubuntu:${var.vms_ssh_root_key}"
    }
    ```
2. Так же поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.
  * Исправил ```main.tf```
    ```bash
     metadata = {
        serial-port-enable    = local.sport
        ssh-keys              = local.key    
    }
    ```
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan (изменений быть не должно).
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.2)/src]$ terraform plan                         *[master]
    data.yandex_compute_image.ubuntu_db: Reading...
    data.yandex_compute_image.ubuntu: Reading...
    yandex_vpc_network.develop: Refreshing state... [id=enpjsbvvi82jm6le83fr]
    data.yandex_compute_image.ubuntu_db: Read complete after 0s [id=fd83gfh90hpp3sojs1r3]
    data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd83gfh90hpp3sojs1r3]
    yandex_vpc_subnet.develop: Refreshing state... [id=e9bv5jaceb3u7fvmm5el]
    yandex_compute_instance.platform: Refreshing state... [id=fhm5elag04lcjg6hei41]
    yandex_compute_instance.platform_db: Refreshing state... [id=fhmj4ump5vghrlad4eba]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are
    needed.
    ```

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   
Их выполнение поможет глубже разобраться в материале. Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list?
    ```bash
    > local.test_list[1]
   "staging"
   ```
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
    ```bash
    > length(local.test_list)
    3
    ```
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map ?
    ```bash
    > local.test_map.admin
    "John"
    ```
4. Напишите interpolation выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.2)/src]$ terraform output str                                           *[master]
    "John is admin for production server based on OS ubuntu-20-04 with 10 vcpu, 40 ram and 4 virtual disks"
    ```
В качестве решения предоставьте необходимые команды и их вывод.
