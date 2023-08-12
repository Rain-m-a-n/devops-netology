## Домашнее задание к занятию 3 «Использование Ansible»

#### Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.  
   * [playbook](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.3)/site.yml)
2. При создании tasks рекомендую использовать модули: get_url, template, yum, apt.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.3)/pics/res.jpg)
4. Подготовьте свой inventory-файл prod.yml.
5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.3)/pics/lint.jpg)
6. Попробуйте запустить playbook на этом окружении с флагом --check.
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.3)/pics/check.jpg)
7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.3)/pics/diff.jpg)
8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.
9.  Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
    [playbook.md](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.3)/playbook/playbook.md)
10. Готовый playbook выложите в свой репозиторий, поставьте тег 08-ansible-03-yandex на фиксирующий коммит, в ответ предоставьте ссылку на него.