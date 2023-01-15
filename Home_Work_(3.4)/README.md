1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:
    * Создал UNIT в папке /etc/systemd/system/**monitoring.service**
    ```
    [Unit]
    Description=Node Exporter
    After=network.target

    [Service]
    Type=simple
    ExecStart=/usr/local/bin/node_exporter
    EnvironmentFile=-/usr/lib/systemd/system
    KillMode=mixed

    [Install]
    WantedBy=default.target
    ```
    скачал **node_exporter** *wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz*  
    распаковал архив и перенёс в **/usr/local/bin:**  
    перечитал **daemon:** sudo systemctl daemon-reload

    - поместите его в автозагрузку:  
    *sudo systemctl enable monitoring.service*  
    ```
    bortnik@MyFirstVM:~$ sudo systemctl status monitoring.service
    monitoring.service - Node Exporter
    Loaded: loaded (/etc/systemd/system/monitoring.service; enabled; vendor preset: enabled)
    Active: active (running) since Wed 2023-01-11 23:02:52 MSK; 1min 48s ago
    Main PID: 1866 (node_exporter)
    Tasks: 5 (limit: 4525)
    Memory: 3.1M
    CGroup: /system.slice/monitoring.service
            └─1866 /usr/local/bin/node_exporter
    ```
1. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
     * **Для CPU:**  
     node_cpu_seconds_total  
     node_pressure_cpu_waiting_seconds_total  
     node_schedstat_waiting_seconds_total  
     node_load1  
     node_load15
     * **Для памяти:**  
     node_pressure_memory_stalled_seconds_total  
     node_pressure_memory_waiting_seconds_total  
     node_memory_MemFree_bytes  
     node_memory_MemAvailable_bytes
     * **Для дисков:**  
     node_filesystem_avail_bytes  
     node_disk_write_time_seconds_total  
     node_disk_read_time_seconds_total
     * **Для network:**  
     node_network_carrier_down_changes_total  
     node_network_carrier_up_changes_total  
     node_network_receive_bytes_total  
     node_network_transmit_bytes_total  
     node_network_up  
1. Установите в свою виртуальную машину Netdata. Добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер. После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
    * Сделал проброс, с локального ПК зашёл по адресу: localhoost:19999
    * **Netdata** - собирает метрики по большому количеству показателей: CPUs, Memory, Disk, Networking stack, IPv4/IPv6 Networking, Network Interface, Systemd Services, Aplications, User Groups, Users, Netdata Monitoring/
1. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
    * Можно это понять по выводу команды: **dmesg | grep -i dmi**
      ```
      bortnik@MyFirstVM:~$ dmesg | grep -i dmi
      [    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
      [    0.239274] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
      ```
      В выводе видно, что система запущена на VirtualBox. 
    * На физическом устройстве будет вывод производителя: 
      ```
      stas ~ $ dmesg | grep -i dmi
      [    0.000000] DMI: Hewlett-Packard HP ProBook 430 G2/2246, BIOS M73 Ver. 01.15 07/24/2015
      ```
1. Как настроен sysctl fs.nr_open на системе по-умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?    
    * Этот параметр задаёт количество открытых дескрипторов в системе. Т.е. любой процесс в системе не сможет открыть более 1048576 файлов. 
      ```
      bortnik@MyFirstVM:~$ sysctl fs.nr_open
      fs.nr_open = 1048576
      ```
    * Значение "по-умолчанию" можно изменить, для этого редактируем файл:   
    **sudo vi /etc/sysctl.conf** и добавляем строку *fs.nr_open = 1025*. Теперь при выполнении той же команды увидим вывод:
      ``` 
       bortnik@MyFirstVM:~$ sysctl fs.nr_open
       fs.nr_open = 1025
      ```
1. Запустите любой долгоживущий процесс в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.
    * Запустим процесс в отдельном namespace: **sudo unshare --fork --pid --mount-proc sleep 1h**
    * Подключиться к другой сессии и найти PID процесса
      ```
      bortnik@MyFirstVM:~$ ps aux | grep sleep
      root        1638  0.0  0.1   9260  4624 pts/0    S+   21:12   0:00 sudo unshare --fork --pid --mount-proc sleep 1h
      root        1639  0.0  0.0   5480   580 pts/0    S+   21:12   0:00 unshare --fork --pid --mount-proc sleep 1h
      root        1640  0.0  0.0   5476   580 pts/0    S+   21:12   0:00 sleep 1h
      bortnik     1695  0.0  0.0   6432   724 pts/1    S+   21:13   0:00 grep --color=auto sleep
      ```
    * Целевой процесс для получения пространств имен из: **sudo nsenter -t 1640 --pid --mount**
    * Проверить PID 
      ```
      root@MyFirstVM:/# ps aux
      USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
      root           1  0.0  0.0   5476   580 pts/0    S+   21:12   0:00 sleep 1h
      root           2  0.0  0.1   7356  4216 pts/1    S    21:14   0:00 -bash
      root          14  0.0  0.0   8888  3280 pts/1    R+   21:14   0:00 ps aux
      ```
1. Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04. 
    * Это Fork бомба, процесс который постоянно дублирует себя, пока не займёт все ресурсы системы. 
    * Механизм (Cgroup) помог автоматической стабилизации  
    **[ 2821.215457] cgroup: fork rejected by pids controller in /user.slice/user-1001.slice/session-1.scope**  
       Механизм предоставляет следующие возможности:  
       * ограничение ресурсов  
       * приоритизацию  
       * изоляцию. 
    * Как изменить число процессов, которое можно создать в сессии?
        ```
        bortnik@MyFirstVM:~$ ulimit -Hu
        15222
        ```
        Изменить командой: ulimit -u <число> 
        ```
        bortnik@MyFirstVM:~$ ulimit -u 1500
        bortnik@MyFirstVM:~$ ulimit -Hu
        1500
        bortnik@MyFirstVM:~$
        ```

    
