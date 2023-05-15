# Домашнее задание к занятию «Введение в Terraform»

### Чеклист готовности к домашнему заданию

1. **Скачайте и установите актуальную версию **terraform** (не менее 1.3.7). Приложите скриншот вывода команды ```terraform --version```.**
   ```bash
   [~/devops/netology/Облачная инфраструктура. Terraform]$ terraform --version                                 *[master]
   Terraform v1.4.6
   on darwin_arm64
   ```
2. **Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.**
   ```bash
   [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.1)]$ ls -l                               *[master]
   total 16
   -rw-r--r--@ 1 bortikovsv  staff  5231 12 май 15:09 README.md
   drwxr-xr-x@ 5 bortikovsv  staff   160 10 май 03:39 src
   ```
3. **Убедитесь, что в вашей ОС установлен docker.**
   ```bash
   [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.1)]$ docker --version                    *[master]
   Docker version 23.0.2, build 569dd73db1
   ```
------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Установка и настройка Terraform  [ссылка](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#from-yc-mirror)
2. Зеркало документации Terraform  [ссылка](https://registry.tfpla.net/browse/providers) 
3. Установка docker [ссылка](https://docs.docker.com/engine/install/ubuntu/) 
------

### Задание 1

1. *Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте.*
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.1)/src]$ terraform validate              *[master]
    ╷
    │ Error: Missing name for resource
    │ 
    │   on main.tf line 24, in resource "docker_image":
    │   24: resource "docker_image" {
    │ 
    │ All resource blocks must have 2 labels (type, name).
    ╵
    ╷
    │ Error: Invalid resource name
    │ 
    │   on main.tf line 29, in resource "docker_container" "1nginx":
    │   29: resource "docker_container" "1nginx" {
    │ 
    │ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
    ```
2. *Изучите файл **.gitignore**. В каком terraform файле допустимо сохранить личную, секретную информацию?*
   ```bash
   # own secret vars store.
   personal.auto.tfvars
   ``` 
3. *Выполните код проекта. Найдите  в State-файле секретное содержимое созданного ресурса **random_password**. Пришлите его в качестве ответа.*
   ``` "result": "3T1LtZWAvpP5pM7y"```
4. *Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла **main.tf**.*  
*Выполните команду ```terraform validate```. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.*
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.1)/src]$ terraform validate              *[master]
    ╷
    │ Error: Missing name for resource
    │ 
    │   on main.tf line 24, in resource "docker_image":
    │   24: resource "docker_image" {
    │ 
    │ All resource blocks must have 2 labels (type, name).
    ```
     * блок ресурса должен иметь 2 значения тип и имя, в примере указано одно значение из-за чего возникает ошибка
    ```bash
    ╷
    │ Error: Invalid resource name
    │ 
    │   on main.tf line 29, in resource "docker_container" "1nginx":
    │   29: resource "docker_container" "1nginx" {
    │ 
    │ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
    ```
     * имя не может начинаться с цифры, но межет начинаться с (_) или буквы.
     * исправленный код:
     ```terraform 
     resource "docker_image" "nginx" {
       name         = "nginx:latest"
       keep_locally = true
     }
     
     resource "docker_container" "nginx" {
       image = docker_image.nginx.image_id
       name  = "example_${random_password.random_string.result}"
     ```

5. *Выполните код. В качестве ответа приложите вывод команды ```docker ps```*
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.1)/src]$ docker ps                       *[master]
    CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                  NAMES
    308335a4724c   6405d9b26faf       "/docker-entrypoint.…"   23 minutes ago   Up 23 minutes   0.0.0.0:8000->80/tcp   example_3T1LtZWAvpP5pM7y
    ```
6. *Замените имя docker-контейнера в блоке кода на ```hello_world```, выполните команду ```terraform apply -auto-approve```.*
    * заменил имя контейнера в коде: 
      ```bash
      resource "docker_container" "nginx" {
      image = docker_image.nginx.image_id
      name = "hello_world"
      ```

    * выполнил команду: ```terraform apply -auto-approve```
      ```bash
      [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.1)/src]$ docker ps                             *[master]
      CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                  NAMES
      c1565982cb52   6405d9b26faf       "/docker-entrypoint.…"   4 seconds ago   Up 4 seconds   0.0.0.0:8000->80/tcp   hello_world
      ```
  
* *Объясните своими словами, в чем может быть опасность применения ключа  ```-auto-approve``` ?* 
    * Опасность применения этого ключа в след:   
    внесенные изменения будут применены, без отображения на экране. Т.е. не будет выведен список всех грядущих изменений и запроса на применение, в котором нужно ответить yes. Что может привести к серьезным последствиям.

8. *Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**.* 
  * Docker контейнер удален. 
  * Вывод файла **terraform.tfstate**: 
    ```bash
    {
    "version": 4,
    "terraform_version": "1.4.6",
    "serial": 17,
    "lineage": "63be83d3-5118-1fb4-9562-ef3fd91f8556",
    "outputs": {},
    "resources": [],
    "check_results": null
    }
    ```
9. *Объясните, почему при этом не был удален docker образ **nginx:latest** ?(Ответ найдите в коде проекта или документации)*
    * образ не был удален из-за этой части кода:
      ```bash
      keep_locally = true
      ```

------

## Дополнительные задания (со звездочкой*)

### Задание 2*

1. Изучите в документации provider [**Virtualbox**](https://registry.tfpla.net/providers/shekeriev/virtualbox/latest/docs/overview/index) от 
shekeriev.
  * данный образ не подходит под архитектуру MAC Book, поэтому доп задание сделал на другом ПК.
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.1)/src1]$ terraform init                          *[master]
    
    Initializing the backend...
    
    Initializing provider plugins...
    - Finding shekeriev/virtualbox versions matching "0.0.4"...
    ╷
    │ Error: Incompatible provider version
    │ 
    │ Provider registry.terraform.io/shekeriev/virtualbox v0.0.4 does not have a package available for your current platform,
    │ darwin_arm64.
    │ 
    │ Provider releases are separate from Terraform CLI releases, so not all providers are available for all platforms. Other
    │ versions of this provider may have different platforms supported.
    ```
2. Создайте с его помощью любую виртуальную машину.

В качестве ответа приложите plan для создаваемого ресурса.
* По совету экспертов, сменил образ.
В качестве ответа приложите plan для создаваемого ресурса.
    ```bash
    stas@stas-home:/media/stas/SSD3/devops/Netology/Github/devops-netology/Облачная 
    инфраструктура. Terraform/Home_Work_(7.1)/src1$ terraform plan

    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # virtualbox_vm.vm1 will be created
    + resource "virtualbox_vm" "vm1" {
        + cpus   = 1
        + id     = (known after apply)
        + image  = "https://github.com/tommy-muehle/puppet-vagrant-boxes/releases/download/1.1.0/centos-7.0-x86_64.box"
        + memory = "512 mib"
        + name   = "centos-7.0"
        + status = "running"
  
        + network_adapter {
            + device                 = "IntelPro1000MTDesktop"
            + host_interface         = "vboxnet0"
            + ipv4_address           = (known after apply)
            + ipv4_address_available = (known after apply)
            + mac_address            = (known after apply)
            + status                 = (known after apply)
            + type                   = "hostonly"
          }
      }

     Plan: 1 to add, 0 to change, 0 to destroy.

     Changes to Outputs:
       + IPAddress = (known after apply)
  
     ───────────────────────────────────────────────────────────────────────────────

     Note: You didn't use the -out option to save this plan, so Terraform can't
     guarantee to take exactly these actions if you run "terraform apply" now.
     ```
------

------
