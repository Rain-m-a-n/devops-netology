# Домашнее задание к занятию 4 «Работа с roles»

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры.
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
   ```yaml
      $ansible-galaxy install -r requirements.yml -p roles 
      Starting galaxy role install process
      - changing role clickhouse from 1.11.0 to 1.11.0
      - extracting clickhouse to /mnt/hgfs/devops/devops-netology/CI, мониторинг и управление конфигурациями/Home_Work_(8.4)/playbook/roles/clickhouse
      - clickhouse (1.11.0) was installed successfully
      - changing role ligthouse-role from v1.0.0 to v1.0.0
      - extracting ligthouse-role to /mnt/hgfs/devops/devops-netology/CI, мониторинг и управление конфигурациями/Home_Work_(8.4)/playbook/roles/ligthouse-role
      - ligthouse-role (v1.0.0) was installed successfully
      - extracting vector-role to /mnt/hgfs/devops/devops-netology/CI, мониторинг и управление конфигурациями/Home_Work_(8.4)/playbook/roles/vector-role
      - vector-role (v1.0.0) was installed successfully
   ```

9.  Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.  
[lighthouse-role](https://github.com/Rain-m-a-n/lighthouse-role)
[vector-role](https://github.com/Rain-m-a-n/vector-role)
[playbook](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI%2C%20%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3%20%D0%B8%20%D1%83%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%BA%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D1%83%D1%80%D0%B0%D1%86%D0%B8%D1%8F%D0%BC%D0%B8/Home_Work_(8.4)/playbook/site.yml/site.yml)
---
