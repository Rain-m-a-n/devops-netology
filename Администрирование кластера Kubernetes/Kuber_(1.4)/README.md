# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

------

<details><summary>Инструменты и дополнительные материалы</summary>

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.
</details>

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
    ```bash
    > $ kubectl -n kuber-1-4 get pods -o wide                                                                                           [±master ●●●]
    NAME                       READY   STATUS    RESTARTS   AGE     IP            NODE                     NOMINATED NODE   READINESS GATES
    kuber-4-55b64f6865-2qhrj   2/2     Running   0          4m11s   10.244.0.36   netology-control-plane   <none>           <none>
    kuber-4-55b64f6865-6gj7g   2/2     Running   0          4m10s   10.244.0.37   netology-control-plane   <none>           <none>
    kuber-4-55b64f6865-vjndt   2/2     Running   0          4m13s   10.244.0.35   netology-control-plane   <none>           <none>
    ```
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
    ```bash
    > $ kubectl get svc -n kuber-1-4 -o wide                                                                                            [±master ●●●]
    NAME        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE   SELECTOR
    task1-svc   ClusterIP   10.96.107.45   <none>        9001/TCP,9002/TCP   15m   app=kuber-4
    ```
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
    ```bash
   > $ kubectl -n kuber-1-4 get pods                                                                                                   [±master ●●●]
    NAME                       READY   STATUS    RESTARTS   AGE
    kuber-4-55b64f6865-2qhrj   2/2     Running   0          6m1s
    kuber-4-55b64f6865-6gj7g   2/2     Running   0          6m
    kuber-4-55b64f6865-vjndt   2/2     Running   0          6m3s
    multitool                  1/1     Running   0          12m
    ```
    ```bash
    > $ kubectl exec -n kuber-1-4 multitool -- curl 10.96.107.45:9002                                                                   [±master ●●●]
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed
    100   142  100   142    0     0   105k      0 --:--:-- --:--:-- --:--:--  138k
    WBITT Network MultiTool (with NGINX) - kuber-4-55b64f6865-vjndt - 10.244.0.35 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
    ```
    ```bash
    > $ kubectl exec -n kuber-1-4 multitool -- curl 10.96.107.45:9001                                                                   [±master ●●●]
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed
    100   615  100   615    0     0   283k      0 --:--:-- --:--:-- --:--:--  300k
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    ```
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
    ```bash
    > $ kubectl exec -n kuber-1-4 multitool -- curl task1-svc.kuber-1-4.svc.cluster.local:9001                                          [±master ●●●]
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed
    0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    .............
    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
    100   615  100   615    0     0   212k      0 --:--:-- --:--:-- --:--:--  300k
    ```
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.  
   [ссылка на манифест](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.4)/task1.yml)
------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.  
   ![ссылка на манифест](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.4)/pics/1.png)
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.  
   [ссылка на манифест](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.4)/task2.yml)
------

