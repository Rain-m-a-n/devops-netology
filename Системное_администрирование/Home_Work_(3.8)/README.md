1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
    ```bash
    route-views>show ip route xxx.xxx.xxx.xxx
    Routing entry for xxx.xxx.xxx.0/24
    Known via "bgp 6447", distance 20, metric 0
    Tag 6939, type external
    Last update from 64.71.137.241 1d14h ago
    Routing Descriptor Blocks:
    * 64.71.137.241, from 64.71.137.241, 1d14h ago
        Route metric is 0, traffic share count is 1
        AS Hops 2
        Route tag 6939
        MPLS label: none
    ```
    ```bash
    route-views>show bgp xxx.xxx.xxx.xxx
    BGP routing table entry for xxx.xxx.xxx.0/24, version 2676728105
    Paths: (19 available, best #3, table default)
      Not advertised to any peer
      Refresh Epoch 1
      3333 1273 20485 60840
        193.0.0.56 from 193.0.0.56 (193.0.0.56)
          Origin IGP, localpref 100, valid, external
          Community: 1273:12752 1273:30000 20485:10036
          path 7FE16D252210 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      20912 3257 3356 20485 60840
        212.66.96.126 from 212.66.96.126 (212.66.96.126)
          Origin IGP, localpref 100, valid, external
          Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004
          path 7FE14F085080 RPKI State not found
          rx pathid: 0, tx pathid: 0
    
    ************  *************   ******** *
    
      Refresh Epoch 1
      3303 20485 60840
        217.192.89.50 from 217.192.89.50 (138.187.128.158)
          Origin IGP, localpref 100, valid, external
          Community: 3303:1004 3303:1006 3303:1030 3303:3056 20485:10036
          path 7FE1273F1AD8 RPKI State not found
          rx pathid: 0, tx pathid: 0
    ```
1. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
    * ```bash
      root@sysadm-fs:/home/bortnik# ip -br a
      lo               UNKNOWN        127.0.0.1/8 ::1/128
      eth0             UP             10.0.2.15/24 fe80::a00:27ff:fe59:cb31/64
      eth1             UP             192.168.1.250/24 fe80::a00:27ff:fee8:de03/64
      dummy0           UNKNOWN        192.168.1.160/24 fe80::475:fff:fe0d:379d/64
      dummy1           UNKNOWN        192.168.1.170/24 fe80::acf7:e7ff:fe80:a57c/64
      ```
    * ```bash
      root@sysadm-fs:/home/bortnik# ip route add 100.100.1.0/24 dev eth1  
      root@sysadm-fs:/home/bortnik# ip route add 100.200.1.0/24 dev eth0  
      root@sysadm-fs:/home/bortnik# route -n  
      Kernel IP routing table  
      Destination     Gateway         Genmask         Flags Metric Ref    Use Iface  
      0.0.0.0         10.0.2.2        0.0.0.0         UG    100    0        0 eth0  
      10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 eth0  
      10.0.2.2        0.0.0.0         255.255.255.255 UH    100    0        0 eth0  
      100.100.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth1  
      100.200.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth0  
      192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth1  
      192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0   dummy0
      192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0   dummy1 
      ```
1. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
   * **netstat -plnt**
   ```bash
   Active Internet connections (only servers)
   Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/   Program name
   tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      823/systemd-resolve
   tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      952/sshd: /usr/sbin
   tcp6       0      0 :::22                   :::*                    LISTEN      952/sshd: /usr/sbin
   ```
   port ${\color{red}53}$ - DNS  
   port ${\color{red}22}$ - SSH
1. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
   * **netstat -plnu**  
   ```bash
    Active Internet connections (only servers)  
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name  
    udp        0      0 127.0.0.53:53           0.0.0.0:*                           823/systemd-resolve  
    udp        0      0 10.0.2.15:68            0.0.0.0:*                           821/systemd-network  
    udp6       0      0 fe80::a00:27ff:fee8:546 :::*                                821/systemd-network 
   ```
   port ${\color{red}53}$ - DNS  
   port ${\color{red}68}$ -  для клиентов бездисковых рабочих станций, загружающихся с сервера BOOTP; также используется DHCP
1. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.
  ![Результат](https://github.com/Rain-m-a-n/devops-netology/raw/master/Системное_администрирование/Home_Work_(3.8)/pic/network.jpg)

 