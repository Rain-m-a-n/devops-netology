# Домашнее задание к занятию 1 «Введение в Ansible»

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.  
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.1)/pics/1.png) 
2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.  
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.1)/pics/2.png)
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
    ```bash
    docker run -dit --name ubuntu pycontribs/ubuntu:latest sleep 6000000
    docker run -dit --name centos7 pycontribs/centos:7 sleep 6000000 
    ```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.  
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.1)/pics/4.png)
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.  
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.1)/pics/6.png)
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
    ```bash
    [~/devops/netology/CI, мониторинг и управление конфигурациями/Home_Work_(8.1)/playbook]$ ansible-vault encrypt ./group_vars/deb/examp.yml                     *[master]
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful
    [~/devops/netology/CI, мониторинг и управление конфигурациями/Home_Work_(8.1)/playbook]$ ansible-vault encrypt ./group_vars/el/examp.yml                      *[master]
    New Vault password: 
    Confirm New Vault password: 
    Encryption successful
    ```
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.1)/pics/7.png)    
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.  
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.1)/pics/8.png)  
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.  
    ```bash
    /playbook$ ansible-doc -t connection -l 
    ```  
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.1)/pics/9.png)  
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.  
    ```bash
    ---
    el:
      hosts:
        centos7:
          ansible_connection: docker
    deb:
      hosts:
        ubuntu:
          ansible_connection: docker
    local:
      hosts:
        localhost:
          ansible_connection: local
    ```      
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.1)/pics/10.png)  
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---
kunaev@dub-ws-235:~/projects/devops-netology/8.ansible/8.1_intro/playbook$ ansible-doc -t connection -l | grep local
community.general.chroot       Interact with local chroot                  
local                          execute on controller 