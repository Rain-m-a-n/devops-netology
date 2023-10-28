# Домашнее задание к занятию «Хранение в K8s. Часть 1»

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

<details><summary>Дополнительные материалы</summary>

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).
</details>

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
    ```bash
    > $ kubectl get pods -n kuber-2-1                                                                        [±feature/kuber-2-1 ●●●]
    NAME                        READY   STATUS    RESTARTS   AGE
    home-work-bf6598d54-8bxg6   2/2     Running   0          5m53s
    ```
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
    ```bash
    > $ kubectl exec -n kuber-2-1 home-work-bf6598d54-8bxg6 -c multitool -- tail -5 /input/welcome.txt       [±feature/kuber-2-1 ●●●]
    hello
    hello
    hello
    hello
    hello
   ```
    
6. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.  
   [Manifest](https://github.com/Rain-m-a-n/devops-netology/blob/master/Конфигурация%20Kubernetes/Kuber_(2.1)/task1.yml)
------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
    ```bash
    > $ kubectl get pods -n kuber-2-1                                                                        [±feature/kuber-2-1 ●●●]
    NAME                        READY   STATUS    RESTARTS   AGE
    home-work-bf6598d54-8bxg6   2/2     Running   0          35m
    multi-tool-hwk92            1/1     Running   0          97s
    ```
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
    * т.к. в этой папке на Ноде пусто, смонтировал на папку выше `/var/log`
    ```bash
    > $ kubectl exec -n kuber-2-1 multi-tool-hwk92  -- ls -l /node/logs                                      [±feature/kuber-2-1 ●●●]
    total 32
    -rw-r--r--    1 root     root          2955 Oct 27 16:15 alternatives.log
    drwxr-xr-x    2 root     root          4096 Oct 10 20:49 apt
    drwxr-xr-x    2 root     root         12288 Oct 27 19:10 containers
    -rw-r--r--    1 root     root           532 Oct 10 20:49 dpkg.log
    drwxr-xr-x   16 root     root          4096 Oct 27 19:10 pods
    drwxr-xr-x    2 root     root          4096 Oct 27 19:06 syslog
    ```    
3. Продемонстрировать возможность чтения файла изнутри пода.
    ```bash
    > $ kubectl exec -n kuber-2-1 multi-tool-hwk92  -- cat /node/logs/dpkg.log                               [±feature/kuber-2-1 ●●●]
    2023-10-10 20:49:36 startup archives unpack
    2023-10-10 20:49:36 install nano:arm64 <none> 5.4-2+deb11u2
    2023-10-10 20:49:36 status half-installed nano:arm64 5.4-2+deb11u2
    2023-10-10 20:49:36 status unpacked nano:arm64 5.4-2+deb11u2
    2023-10-10 20:49:36 startup packages configure
    2023-10-10 20:49:36 configure nano:arm64 5.4-2+deb11u2 <none>
    2023-10-10 20:49:36 status unpacked nano:arm64 5.4-2+deb11u2
    2023-10-10 20:49:36 status half-configured nano:arm64 5.4-2+deb11u2
    2023-10-10 20:49:36 status installed nano:arm64 5.4-2+deb11u2
    ```
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.  
   [Manifest](https://github.com/Rain-m-a-n/devops-netology/blob/master/Конфигурация%20Kubernetes/Kuber_(2.1)/task2.yml)
