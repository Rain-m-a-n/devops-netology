# Домашнее задание к занятию "Управляющие конструкции в коде Terraform"

------

### Инструменты/ дополнительные материалы, которые пригодятся для выполнения задания

1. [Консоль управления Yandex Cloud](https://console.cloud.yandex.ru/folders/<cloud_id>/vpc/security-groups).
2. [Группы безопасности](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
3. [Datasource compute disk](https://terraform-eap.website.yandexcloud.net/docs/providers/yandex/d/datasource_compute_disk.html).


### Задание 1

1. Изучите проект.
2. Заполните файл personal.auto.tfvars
3. Инициализируйте проект, выполните код (он выполнится даже если доступа к preview нет).

Примечание: Если у вас не активирован preview доступ к функционалу "Группы безопасности" в Yandex Cloud - запросите доступ у поддержки облачного провайдера. Обычно его выдают в течении 24-х часов.

Приложите скриншот входящих правил "Группы безопасности" в ЛК Yandex Cloud  или скриншот отказа в предоставлении доступа к preview версии.

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нем создание двух **одинаковых** виртуальных машин с минимальными параметрами, используя мета-аргумент **count loop**.
    ```bash
    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.3)/src]$ terraform apply                                 *[master]
    data.yandex_compute_image.ubuntu: Reading...
    data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8qssu7gclkmoi9flt4]
    ................
    yandex_compute_instance.web[0]: Creation complete after 36s [id=fhmaa2fco0apjh6k8nmh]
    yandex_compute_instance.web[1]: Creation complete after 36s [id=fhmkp4p3p5cu4paqhdqa]

    Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
    ```  
    ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.3)/pics/2.1.png) 


2. Создайте файл for_each-vm.tf. Опишите в нем создание 2 **разных** по cpu/ram/disk виртуальных машин, используя мета-аргумент **for_each loop**. Используйте переменную типа list(object({ vm_name=string, cpu=number, ram=number, disk=number  })). При желании внесите в переменную все возможные параметры.
3. ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.
4. Используйте функцию file в local переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ №2.
5. Инициализируйте проект, выполните код.
    ```bash
    yandex_compute_instance.prod["prod-1"]: Creation complete after 34s [id=fhmbealhhv8u76lk2cl9]
    yandex_compute_instance.prod["prod-2"]: Still creating... [40s elapsed]
    yandex_compute_instance.prod["prod-2"]: Still creating... [50s elapsed]
    yandex_compute_instance.prod["prod-2"]: Still creating... [1m0s elapsed]
    yandex_compute_instance.prod["prod-2"]: Creation complete after 1m3s [id=fhm95scj3o75miok0hmb]
    Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

    [~/devops/netology/Облачная инфраструктура. Terraform/Home_Work_(7.3)/src]$ ssh ubuntu@84.201.128.54                                                                                              *[master]
    The authenticity of host '84.201.128.54 (84.201.128.54)' can't be established.
    ED25519 key fingerprint is SHA256:Wi6ahM2LBWv8j4cZzBF7Nfzt+WV6vPfsxLGGM31rf90.
    This key is not known by any other names
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    Warning: Permanently added '84.201.128.54' (ED25519) to the list of known hosts.
    Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-148-generic x86_64)
    
     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage
    
    The programs included with the Ubuntu system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.
    
    Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
    applicable law.
    
    To run a command as administrator (user "root"), use "sudo <command>".
    See "man sudo_root" for details.
    
    ubuntu@fhmul9fl0cnodlnr9bb9:~$ 
    ```

------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска, размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.3)/pics/disks.png) 
2. Создайте в том же файле одну **любую** ВМ. Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.
3. Назначьте ВМ созданную в 1-м задании группу безопасности.
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.3)/pics/secur.png) 
------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demonstration2).
Передайте в него в качестве переменных имена и внешние ip-адреса ВМ из задания 2.1 и 2.2.
2. Выполните код. Приложите скриншот получившегося файла. 

![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Облачная%20инфраструктура.%20Terraform/Home_Work_(7.3)/pics/4.png) 

Для общего зачета создайте в вашем GitHub репозитории новую ветку terraform-03. Закомитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 5*(необязательное)
1. Напишите output, который отобразит все 5 созданных ВМ в виде списка словарей:
``` 
[
 {
  "name" = 'имя ВМ1'
  "id"   = 'идентификатор ВМ1'
  "fqdn" = 'Внутренний FQDN ВМ1'
 },
 {
  "name" = 'имя ВМ2'
  "id"   = 'идентификатор ВМ2'
  "fqdn" = 'Внутренний FQDN ВМ2'
 },
 ....
]
```
Приложите скриншот вывода команды ```terrafrom output```

------

### Задание 6*(необязательное)

1. Используя null_resource и local-exec примените ansible-playbook к ВМ из ansible inventory файла.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demonstration2).
3. Дополните файл шаблон hosts.tftpl. 
Формат готового файла:
```netology-develop-platform-web-0   ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>"```

Для проверки работы уберите у ВМ внешние адреса. Этот вариант используется при работе через bastion сервер.
Для зачета предоставьте код вместе с основной частью задания.
