1. Работа c HTTP через telnet.
    * Подключитесь утилитой telnet к сайту stackoverflow.com
        * *telnet stackoverflow.com 80*
    * Отправьте HTTP запрос
        * *GET /questions HTTP/1.0*  
          *HOST: stackoverflow.com*
    * Результат запроса:
      ``` 
        HTTP/1.1 403 Forbidden
        Connection: close
      ```
      * Значение :  
      **HTTP 403 Forbidden** — стандартный код ответа HTTP, означающий, что доступ к запрошенному ресурсу запрещен. Сервер понял запрос, но не выполнит его. Наиболее вероятными причинами ограничения может послужить попытка доступа к системным ресурсам веб-сервера (например, файлам .htaccess или .htpasswd) или к файлам, доступ к которым был закрыт с помощью конфигурационных файлов, требование аутентификации не средствами HTTP, например, для доступа к системе управления содержимым или разделу для зарегистрированных пользователей либо сервер не удовлетворён IP-адресом клиента, например, при блокировках. Появился в HTTP/1.0.
1. Повторите задание 1 в браузере, используя консоль разработчика
     * Укажите в ответе полученный HTTP код: <span style="color:red">**200**</span>
       ![Результат](https://gitlab.com/rainman1/devops-netology/raw/master/Home_Work_(3.6)/pics/header.jpg)

    * Проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?<font color='red'> **stackoverflow.com** - 306 ms</font>
       ![Результат](https://gitlab.com/rainman1/devops-netology/raw/master/Home_Work_(3.6)/pics/process.jpg)
1. Какой IP адрес у вас в интернете?
    * bortnik@sysadm-fs:~$ curl icanhazip.com  
      84.21.XXX.XXX
1.     
       