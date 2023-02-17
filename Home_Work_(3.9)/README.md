1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
1. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.  
![Результат](https://github.com/Rain-m-a-n/devops-netology/raw/master/Home_Work_(3.9)/pic/auth.jpg)
1. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
    * Устанавливаем Apache:
      * sudo apt update - обновление базы данных пакетов
      * sudo apt install apache2 - установка пакета Apache
      * sudo ufw app list - выводит список профилей Брандмауэра
      * sudo ufw allow Apache Full - открываем порт 80 и 443
      * sudo ufw status - проверяем корректность выполненных настроек  
        ![Результат](https://github.com/Rain-m-a-n/devops-netology/raw/master/Home_Work_(3.9)/pic/ufw.jpg)
      * sudo systemctl status apache2 - проверяем работу службы,если    всё настроено корректно, получим такой вывод:  
        ![Результат](https://github.com/Rain-m-a-n/devops-netology/raw/master/Home_Work_(3.9)/pic/apache.jpg)
      * Проверим в браузере работу веб-сервера, для этого введём в нём IP адрес сервера:  
        ![Результат](https://github.com/Rain-m-a-n/devops-netology/raw/master/Home_Work_(3.9)/pic/apache2.jpg)
      * настроим виртуальный хост, для этого предварительно создадим папку (test) по пути (/var/www/)- это расположение будет для наполнения сайта.
         * sudo mkdir /var/www/test
      * Назначим владельца папки: 
         * sudo chown -R $USER:$USER /var/www/test
      * Создадим файл приветствия:
         * sudo nano /var/www/test/index.html 
           ```
           <html>
            <head>
             <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
             <title>Пример веб-страницы</title>
            </head>
            <body>
             <h1>Тестовый сайт</h1>
             <p>Первый абзац.</p>
             <p>Второй абзац.</p>
            </body>
           </html>
           ```
      * Включаем модули для SSL: 
         * sudo a2enmod ssl
         * sudo a2enmod rewrite
         * sudo systemctl restart apache2 - перезапуск сервера Apache2
      * Создадим каталог, где будут располагаться сертификаты и перейдём в него: 
        * mkdir /etc/apache2/certificate
        * cd /etc/apache2/certificate
      * Создаём закрытый ключ и сертификат с помощью OpenSSL:
        * openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificate.crt -keyout apache.key
        * отвечаем на вопросы при формировании сертификата. 
        * в **COMMON_NAME** вводим **ip** адрес сервера.
      * Вместо изменения "дефолтного файла" 000-default.conf, создаём новый в том же расположении:
        * sudo nano /etc/apache2/sites-available/test.conf
        * Добавляем след. текст: 
          ```
          <VirtualHost *:80>
              Servername test
              Redirect / https://192.168.0.251/
          </VirtualHost>

          <VirtualHost *:443>
              ServerName test
              ServerAlias www.test
              DocumentRoot /var/www/test
              ErrorLog ${APACHE_LOG_DIR}/error.log
              CustomLog ${APACHE_LOG_DIR}/access.log combined
              SSLEngine on
              SSLCertificateFile /etc/apache2/certificate/apache-certificate.crt
              SSLCertificateKeyFile /etc/apache2/certificate/apache.key
          </VirtualHost>
          ```
        * в первом блоке настраиваем перенаправление с 80 порта на 443
        * во втором блоке прописываем путь к сертификату и ключу + доп настройки.
      * Активируем созданный файл:
        * sudo a2ensite test.conf
      * Отключаем сайт "по-умолчанию", определеный в 000-default.conf: 
        * sudo a2dissite 000-default.conf
      * Проверим конфигурацию на ошибки:
        * sudo apache2ctl configtest 
          * В выводе должно быть:   
            **Syntax OK**
      * Перезапускаем Apache2:
        * systemctl restart apache2
      * В браузере вводим http://IP_server и должны получить такой результат:  
        ![Результат](https://github.com/Rain-m-a-n/devops-netology/raw/master/Home_Work_(3.9)/pic/apache3.jpg)
1. Проверьте на TLS уязвимости произвольный сайт в интернете ( для теста взят сайт auto.ru):
    * Для тестирования использовался ресурс [SSL Labs](https://www.ssllabs.com/ssltest/)
    * Результат тестирования:  
     ![Результат](https://github.com/Rain-m-a-n/devops-netology/raw/master/Home_Work_(3.9)/pic/ssl.jpg)
1. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
    * **Генерируем  RSA ключ:**
      * ssh-keygen -t rsa 
        ```
        bortnik@Server3:~/.ssh$ ssh-keygen -t rsa
        Generating public/private rsa key pair.
        Enter file in which to save the key (/home/bortnik/.ssh/id_rsa):
        Enter passphrase (empty for no passphrase):
        Enter same passphrase again:
        Your identification has been saved in /home/bortnik/.ssh/id_rsa
        Your public key has been saved in /home/bortnik/.ssh/id_rsa.pub
        The key fingerprint is:
        SHA256:RXNytkaqBLCoLIdbSrLxjOIZ4g8m6oc8jqhDwzhCmrc bortnik@Server3
        The key's randomart image is:
        +---[RSA 3072]----+
        |    ...   + =    |
        |   . . . . O .   |
        |  . .   . o o    |
        |.+     . o .     |
        |@+o     S        |
        |X#.              |
        |%*=.             |
        |%+E.             |
        |OB+.             |
        +----[SHA256]-----+
        ```
    * **Копируем ключ на машину, к которой планируем подключаться:**
      * bortnik@Server3:~/.ssh$ ssh-copy-id bortnik@192.168.0.252
        ```
        bortnik@Server3:~/.ssh$ ssh-copy-id bortnik@192.168.0.252
        /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/bortnik/.ssh/id_rsa.pub"
        The authenticity of host '192.168.0.252 (192.168.0.252)' can't be established.
        ECDSA key fingerprint is SHA256:ur64aedNlP6lLuzRFZ6GEZnnwNrI68WIYtARUQe1ius.
        Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
        /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
        /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
        bortnik@192.168.0.252's password:
        Number of key(s) added: 1

        Now try logging into the machine, with:   "ssh 'bortnik@192.168.0.252'"
        and check to make sure that only the key(s) you wanted were added.
        ```
    * Проверяем подключение к серверу по SSH без использования пароля: 
      * ssh bortnik@192.168.0.252
        ```
        bortnik@Server3:~/.ssh$ ssh bortnik@192.168.0.252
        Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-139-generic x86_64)

        Documentation:  https://help.ubuntu.com
        Management:     https://landscape.canonical.com
        Support:        https://ubuntu.com/advantage

        System information as of Fri 17 Feb 2023 04:02:54 PM UTC

        System load:  0.06               Processes:             122
        Usage of /:   13.2% of 30.34GB   Users logged in:       1
        Memory usage: 21%                IPv4 address for eth0: 10.0.2.15
        Swap usage:   0%                 IPv4 address for eth1: 192.168.0.252

        Introducing Expanded Security Maintenance for Applications.
        Receive updates to over 25,000 software packages with your
        Ubuntu Pro subscription. Free for personal use.

           https://ubuntu.com/pro

        This system is built by the Bento project by Chef Software
        More information can be found at https://github.com/chef/bento
        Last login: Fri Feb 17 15:56:35 2023 from 192.168.0.240
        ```
1. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера
    * **Переименовываем приватный ключ:**
      * bortnik@Server3:~/.ssh$ mv id_rsa bort
    * **Создаём конфиг файл и изменяем разрешения на него:**
      *  bortnik@Server3:~/.ssh$ touch config && chmod 600 config
    * **Прописываем конфиг:**
      * bortnik@Server3:~/.ssh$ nano config  
        host server2  
        hostname 192.168.0.252  
        user bortnik  
        IdentityFile ~/.ssh/bort  
    * **Проверяем подключение по имени:**
      * ssh bortnik@server2
        ```
        bortnik@Server3:~/.ssh$ ssh bortnik@server2
        Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-139-generic x86_64)

        * Documentation:  https://help.ubuntu.com
        * Management:     https://landscape.canonical.com
        * Support:        https://ubuntu.com/advantage

        System information as of Fri 17 Feb 2023 07:15:28 PM UTC

        System load:  0.02               Processes:             129
        Usage of /:   13.2% of 30.34GB   Users logged in:       1
        Memory usage: 20%                IPv4 address for eth0: 10.0.2.15
        Swap usage:   0%                 IPv4 address for eth1: 192.168.0.252

        * Introducing Expanded Security Maintenance for Applications.
        Receive updates to over 25,000 software packages with your
        Ubuntu Pro subscription. Free for personal use.

        https://ubuntu.com/pro

        This system is built by the Bento project by Chef Software
        More information can be found at https://github.com/chef/bento
        Last login: Fri Feb 17 19:12:46 2023 from 192.168.0.240
        ```
1. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
    * **Собираем Dump:**
      ```
      bortnik@Server3:~$ sudo tcpdump -c 100 -w 100.pcap -i eth1
      tcpdump: listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes
      100 packets captured
      101 packets received by filter
      0 packets dropped by kernel
      ```
    * **Открываем файл Wireshark:**   
      ![Результат](https://github.com/Rain-m-a-n/devops-netology/raw/master/Home_Work_(3.9)/pic/shark.jpg).
          


