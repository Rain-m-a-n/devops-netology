# Домашнее задание к занятию 2 «Работа с Playbook»

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.  
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.2)/pics/1.png)
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
   ```bash
      vector:
        hosts:
          vector-01:
            ansible_host: 192.168.1.77
   ```
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.  
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.2)/pics/2.png)
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.  
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.2)/pics/5.png)
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.  
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.2)/pics/6.png)
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.  
   ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.2)/pics/8.png)
9.  Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
  [README.md](https://github.com/Rain-m-a-n/devops-netology/blob/master/Система%20управления%20конфигурациями/Home_Work_(8.2)/playbook/playbook.md)
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.
    
