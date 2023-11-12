# Домашнее задание к занятию «Конфигурация приложений»

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

<details><summary>Дополнительные материалы</summary>

1. [Описание](https://kubernetes.io/docs/concepts/configuration/secret/) Secret.
2. [Описание](https://kubernetes.io/docs/concepts/configuration/configmap/) ConfigMap.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.
</details>

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
    ```bash
    > $ kube get configmap -n kuber-2-3                                                                                          [±feature/Kuber_(2.3) ●●]
    NAME               DATA   AGE
    kube-root-ca.crt   1      21m
    multitool-config   1      12m
    ```
3. Продемонстрировать, что pod стартовал и оба конейнера работают.
   ```bash
   > $ kube get pods -n kuber-2-3                                                                                               [±feature/Kuber_(2.3) ●●]
   NAME                               READY   STATUS    RESTARTS   AGE
   nginx-multitool-59c84dd44d-w675m   2/2     Running   0          10m
   ```
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.

   ![pics](https://github.com/Rain-m-a-n/devops-netology/blob/master/Конфигурация%20Kubernetes/Kuber_(2.3)/pics/1.jpg)
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.  
   [ссылка на манифест](https://github.com/Rain-m-a-n/devops-netology/blob/master/Конфигурация%20Kubernetes/Kuber_(2.3)/task1.yml)

------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
   ```bash
   > $ sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout netology.key -out netology.crt                          [±feature/Kuber_(2.3) ●●]
   -----
   You are about to be asked to enter information that will be incorporated
   into your certificate request.
   What you are about to enter is what is called a Distinguished Name or a DN.
   There are quite a few fields but you can leave some blank
   For some fields there will be a default value,
   If you enter '.', the field will be left blank.
   -----
   Country Name (2 letter code) [AU]:RU
   State or Province Name (full name) [Some-State]:Voronezh         
   Locality Name (eg, city) []:Voronezh
   Organization Name (eg, company) [Internet Widgits Pty Ltd]:Home
   Organizational Unit Name (eg, section) []:PC
   Common Name (e.g. server FQDN or YOUR name) []:neto-logy.web
   Email Address []:
   ```
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS.
   ```bash
   > $ kube get ingress -n kuber-2-3                                                                                            [±feature/Kuber_(2.3) ●●]
   NAME         CLASS    HOSTS           ADDRESS     PORTS   AGE
   my-ingress   public   neto-logy.web   127.0.0.1   80      41m
   
   > $ kube get svc -n kuber-2-3                                                                                                [±feature/Kuber_(2.3) ●●]
   NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
   nginx-svc     ClusterIP   10.152.183.39    <none>        8080/TCP   67m
   nginx-1-svc   ClusterIP   10.152.183.153   <none>        80/TCP     50m
   ```
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.  
   [deployment](https://github.com/Rain-m-a-n/devops-netology/blob/master/Конфигурация%20Kubernetes/Kuber_(2.3)/task2.yml)  
   ![pics](https://github.com/Rain-m-a-n/devops-netology/blob/master/Конфигурация%20Kubernetes/Kuber_(2.3)/pics/2.jpg)
------