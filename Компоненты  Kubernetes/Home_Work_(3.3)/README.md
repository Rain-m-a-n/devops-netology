# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
   [Frontend](https://github.com/Rain-m-a-n/devops-netology/blob/master/Компоненты%20Kubernetes/Home_Work(3.3)/frontend.yaml)  
   [Backend](https://github.com/Rain-m-a-n/devops-netology/blob/master/Компоненты%20Kubernetes/Home_Work(3.3)/backend.yaml)  
   [Cache](https://github.com/Rain-m-a-n/devops-netology/blob/master/Компоненты%20Kubernetes/Home_Work(3.3)/cache.yaml)  
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
    ```bash
    ubuntu@work-vm:~/kuber$ kubectl get pods -n app
    NAME                        READY   STATUS    RESTARTS   AGE
    backend-7bfd89b7c7-pmtbc    1/1     Running   0          17m
    cache-bd6c58d5f-wsnfc       1/1     Running   0          16m
    frontend-578f985797-8l5m7   1/1     Running   0          39m
    ```
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
    ```bash
    ubuntu@work-vm:~/kuber$ kubectl get svc -n app
    NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    backend-svc    ClusterIP   10.233.32.1     <none>        80/TCP    39m
    cache-svc      ClusterIP   10.233.14.200   <none>        80/TCP    39m
    frontend-svc   ClusterIP   10.233.51.82    <none>        80/TCP    44m
    ```
5. Продемонстрировать, что трафик разрешён и запрещён.
    ```bash
    ubuntu@work-vm:~/kuber$ kubectl exec -n app frontend-578f985797-8l5m7 -- curl 10.233.32.1
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed
    100   140  100   140    0     0   177k      0 --:--:-- --:--:-- --:--:--  136k
    WBITT Network MultiTool (with NGINX) - backend-7bfd89b7c7-pmtbc - 10.233.75.4 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
    
   ubuntu@work-vm:~/kuber$ kubectl exec -n app frontend-578f985797-8l5m7 -- curl 10.233.14.200
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    Dload  Upload   Total   Spent    Left  Speed
    0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
    ```