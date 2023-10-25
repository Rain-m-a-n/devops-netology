# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

<details><summary>Инструменты и дополнительные материалы</summary>

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

</details>

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
    ```bash
    > $ kubectl get pods -n kuber-1-5                                                                                                   [±master ●●●]
    NAME                       READY   STATUS    RESTARTS   AGE
    backend-85c557f85b-xs8d7   1/1     Running   0          7m3s
    frontend-77d6cf446-gvmj7   1/1     Running   0          7m3s
    frontend-77d6cf446-hh47q   1/1     Running   0          7m3s
    frontend-77d6cf446-x6kn6   1/1     Running   0          7m3s
    ```
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
    ```bash
    > $ kubectl get svc -n kuber-1-5                                                                                                    [±master ●●●]
    NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
    backend-svc    ClusterIP   10.96.159.134   <none>        8080/TCP   8m58s
    frontend-svc   ClusterIP   10.96.105.67    <none>        80/TCP     8m58s
    ```
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
    ```bash
    > $ kubectl exec -n kuber-1-5 frontend-77d6cf446-hh47q -- curl backend-svc:8080                                                     [±master ●●●]
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed
    0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0WBITT Network MultiTool (with NGINX) - backend-85c557f85b-xs8d7 - 10.244.0.8 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    100   141  100   141    0     0  93750      0 --:--:-- --:--:-- --:--:--  137k
    ```
   ```bash
    > $ kubectl exec -n kuber-1-5 backend-85c557f85b-xs8d7 -- curl frontend-svc                                                         [±master ●●●]
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed
    100   615  100   615    0     0   232k      0 --:--:-- --:--:-- --:--:--  300k
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
    html { color-scheme: light dark; }
    body { width: 35em; margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif; }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>

    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>

    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
    ```
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.  
    [Deploy](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.5)/task1.yml)

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
   ```bash
   > $ sudo microk8s enable ingress                                                                                                     [±master ●●]
   Infer repository core for addon ingress
   Enabling Ingress
   ingressclass.networking.k8s.io/public created
   ingressclass.networking.k8s.io/nginx created
   namespace/ingress created
   serviceaccount/nginx-ingress-microk8s-serviceaccount created
   clusterrole.rbac.authorization.k8s.io/nginx-ingress-microk8s-clusterrole created
   role.rbac.authorization.k8s.io/nginx-ingress-microk8s-role created
   clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
   rolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
   configmap/nginx-load-balancer-microk8s-conf created
   configmap/nginx-ingress-tcp-microk8s-conf created
   configmap/nginx-ingress-udp-microk8s-conf created
   daemonset.apps/nginx-ingress-microk8s-controller created
   Ingress is enabled
   ```
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
   ```bash
   > $ curl net-logy.web                                                                                                                                                                                                                                                                                            [±master ●●]
   <!DOCTYPE html>
   <html>
   <head>
   <title>Welcome to nginx!</title>
   <style>
   html { color-scheme: light dark; }
   body { width: 35em; margin: 0 auto;
   font-family: Tahoma, Verdana, Arial, sans-serif; }
   </style>
   </head>
   <body>
   <h1>Welcome to nginx!</h1>
   <p>If you see this page, the nginx web server is successfully installed and
   working. Further configuration is required.</p>
   
   <p>For online documentation and support please refer to
   <a href="http://nginx.org/">nginx.org</a>.<br/>
   Commercial support is available at
   <a href="http://nginx.com/">nginx.com</a>.</p>
   
   <p><em>Thank you for using nginx.</em></p>
   </body>
   </html>
   ```
   ```bash
   > $ curl net-logy.web/api                                                                                                                                                                                                                                                                                        [±master ●●]
   WBITT Network MultiTool (with NGINX) - backend-85c557f85b-xs8d7 - 10.244.0.8 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```
4. Предоставить манифесты и скриншоты или вывод команды п.2.  
   [Ingress](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.5)/task2.yml)
------
