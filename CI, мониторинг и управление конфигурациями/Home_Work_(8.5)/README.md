# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"` и драйвера `pip3 install molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
    * Ubuntu:latest  
        ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.5)/pics/ubuntu.png)
    * Centos:8  
        ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.5)/pics/centos8.png)
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
    [Vector-role tag.v1.0.2](https://github.com/Rain-m-a-n/vector-role/tree/v1.0.2)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
    ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.5)/pics/tox1.png)
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
    ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.5)/pics/light.png)
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
    ```bash
     commands =
         {posargs:molecule test -s centos7tox --destroy always}
    ``` 
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.  
    ![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/CI,%20мониторинг%20и%20управление%20конфигурациями/Home_Work_(8.5)/pics/tox_final.png)
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
    [Vector-role tag.v1.0.3](https://github.com/Rain-m-a-n/vector-role/tree/v1.0.3)