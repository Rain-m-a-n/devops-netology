1. Работа c HTTP через telnet.
    * Подключитесь утилитой telnet к сайту stackoverflow.com
        * *telnet stackoverflow.com 80*
    * Отправьте HTTP запрос
        * *GET /questions HTTP/1.0*  
          *HOST: stackoverflow.com*
    * Результат запроса:
      ```bash
        HTTP/1.1 403 Forbidden
        Connection: close
      ```
      * Значение :  
      **HTTP 403 Forbidden** — стандартный код ответа HTTP, означающий, что доступ к запрошенному ресурсу запрещен. Сервер понял запрос, но не выполнит его. Наиболее вероятными причинами ограничения может послужить попытка доступа к системным ресурсам веб-сервера (например, файлам .htaccess или .htpasswd) или к файлам, доступ к которым был закрыт с помощью конфигурационных файлов, требование аутентификации не средствами HTTP, например, для доступа к системе управления содержимым или разделу для зарегистрированных пользователей либо сервер не удовлетворён IP-адресом клиента, например, при блокировках. Появился в HTTP/1.0.
1. Повторите задание 1 в браузере, используя консоль разработчика
     * Укажите в ответе полученный HTTP код: <span style="color:red">**200**</span>
       ![Результат](https://gitlab.com/rainman1/devops-netology/raw/master/Home_Work_(3.6)/pics/header.jpg)

    * Проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?${\color{green} stackoverflow.com}$ ${\color{red}-306ms}$
       ![Результат](https://gitlab.com/rainman1/devops-netology/raw/master/Home_Work_(3.6)/pics/process.jpg)
1. Какой IP адрес у вас в интернете?
    * bortnik@sysadm-fs:~$ curl icanhazip.com  
      84.21.XXX.XXX
1. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS?
    * Провайдер:  
     bortnik@sysadm-fs:~$ whois 84.21.XXX.XXX  
     inetnum:        84.21.xxx.xxx - 84.21.xxx.xxx  
     netname:        **RU-TELECOMSERVICEVRN-20181004**  
    * Автономная система:  **AS60840** 
      ```bash
      bortnik@sysadm-fs:~$ whois 84.21.xxx.xxx | grep origin
      origin:         AS60840
      ``` 
1. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS?
    ```bash
    bortnik@sysadm-fs:~$ traceroute -AI 8.8.8.8  
    traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets  
    1  _gateway (10.0.2.2) [*]  0.144 ms  0.121 ms  0.118 ms
    2  mygpon (192.168.1.254) [*]  0.903 ms  1.220 ms  3.368 ms
    3  10.0.0.1 (10.0.0.1) [*]  7.407 ms  7.348 ms  7.429 ms
    4  172.28.131.1 (172.28.131.1) [*]  7.741 ms  7.853 ms  7.889 ms
    5  172.28.132.1 (172.28.132.1) [*]  65.778 ms  65.888 ms  65.973 ms
    6  msk-ix-gw3.google.com (195.208.208.250) [AS5480]  20.990 ms  14.255 ms  14.372 ms
    7  108.170.250.34 (108.170.250.34) [AS15169]  15.503 ms  11.866 ms  11.856 ms
    8  142.250.238.138 (142.250.238.138) [AS15169]  30.466 ms  30.584 ms  30.703 ms
    9  142.250.233.0 (142.250.233.0) [AS15169]  28.317 ms  29.381 ms  29.618 ms
    10  216.239.46.139 (216.239.46.139) [AS15169]  35.563 ms  36.495 ms  36.744 ms
    11  * * *
    19  * * *
    20  dns.google (8.8.8.8) [AS15169/AS263411]  27.252 ms  27.366 ms  27.486 ms
    ```      
    * Пакет идёт через:   
      **[AS5480]**  
      **[AS15169]**  
      **[AS15169/AS263411]**  
1. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
   ```bash
   bortnik@sysadm-fs:~$ mtr -r 8.8.8.8
   Start: 2023-01-24T20:57:27+0000
   HOST: sysadm-fs                   Loss%   Snt   Last   Avg  Best  Wrst StDev
    1.|-- _gateway                   0.0%    10    0.2   0.2   0.1   0.4   0.1
    2.|-- mygpon                     0.0%    10    0.9   1.0   0.7   1.1   0.2
    3.|-- 10.0.0.1                   0.0%    10    1.7   2.0   1.3   2.6   0.5
    4.|-- 172.28.131.1               0.0%    10    1.6   2.0   1.5   2.7   0.5
    5.|-- 172.28.132.1               0.0%    10    2.0   2.4   1.7   3.4   0.5
    6.|-- msk-ix-gw3.google.com      0.0%    10   14.3  14.3  13.7  15.2   0.5
    7.|-- 108.170.250.34             0.0%    10   11.8  11.7  11.2  13.0   0.5
    8.|-- 142.251.238.82             0.0%    10   30.0  29.8  29.0  30.4   0.4
    9.|-- 142.251.238.66             0.0%    10   26.1  26.8  26.1  29.9   1.1
   10.|-- 216.239.49.115             0.0%    10   29.7  30.5  29.7  31.3   0.5
   11.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   12.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   13.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   14.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   15.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   16.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   17.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   18.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   19.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   20.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   21.|-- ???                       100.0    10    0.0   0.0   0.0   0.0   0.0
   22.|-- dns.google                 0.0%    10   28.7  29.0  28.3  29.6   0.4
   ```
     * Наибольшая задержка на 10 hope:
       ```bash
       HOST: sysadm-fs                   Loss%   Snt   Last   Avg  Best  Wrst StDev
       10.|-- 216.239.49.115             0.0%    10   29.7  30.5  29.7  31.3   0.5
1. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи?
    * Запрос NS-записи: **dig NS dns.google**
      ```bash
      bortnik@sysadm-fs:~$ dig NS dns.google  
      ; <<>> DiG 9.16.1-Ubuntu <<>> NS dns.google
      ;; global options: +cmd
      ;; Got answer:
      ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37060
      ;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1
    
      ;; OPT PSEUDOSECTION:
      ; EDNS: version: 0, flags:; udp: 65494
      ;; QUESTION SECTION:
      ;dns.google.                    IN      NS

      ;; ANSWER SECTION:
      dns.google.             6857    IN      NS      ns1.zdns.google.
      dns.google.             6857    IN      NS      ns4.zdns.google.
      dns.google.             6857    IN      NS      ns2.zdns.google.
      dns.google.             6857    IN      NS      ns3.zdns.google.
      ```
    * Запрос А записи: **dig dns.google**
      ```bash
      bortnik@sysadm-fs:~$ dig dns.google

      ; <<>> DiG 9.16.1-Ubuntu <<>> dns.google
      ;; global options: +cmd
      ;; Got answer:
      ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50689
      ;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

      ;; OPT PSEUDOSECTION:
      ; EDNS: version: 0, flags:; udp: 65494
      ;; QUESTION SECTION:
      ;dns.google.                    IN      A

      ;; ANSWER SECTION:
      dns.google.             219     IN      A       8.8.8.8
      dns.google.             219     IN      A       8.8.4.4

      ;; Query time: 0 msec
      ;; SERVER: 127.0.0.53#53(127.0.0.53)
      ;; WHEN: Tue Jan 24 21:17:04 UTC 2023
      ;; MSG SIZE  rcvd: 71
      ```
1. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? 
      * Команда: **dig -x 8.8.4.4**
        ```bash
        ; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
        ;; global options: +cmd
        ;; Got answer:
        ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 1508
        ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

        ;; OPT PSEUDOSECTION:
        ; EDNS: version: 0, flags:; udp: 65494
        ;; QUESTION SECTION:
        ;4.4.8.8.in-addr.arpa.          IN      PTR

        ;; ANSWER SECTION:
        4.4.8.8.in-addr.arpa.   6939    IN      PTR     dns.google.

        ;; Query time: 0 msec
        ;; SERVER: 127.0.0.53#53(127.0.0.53)
        ;; WHEN: Tue Jan 24 21:27:32 UTC 2023
        ;; MSG SIZE  rcvd: 73
        ```
     * Команда:  **dig -x 8.8.8.8 +short**  
       ```bortnik@sysadm-fs:~$ dig -x 8.8.8.8 +short```  
       ```dns.google.```


