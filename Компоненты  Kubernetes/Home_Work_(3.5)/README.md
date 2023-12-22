# Домашнее задание к занятию Troubleshooting

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
    * Во время использования деплоя получили ошибку
    ```bash
    ubuntu@work-vm:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
    Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
    Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
    Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
    ```
3. Исправить проблему, описать, что сделано.
    * Проблема в отсутствии Неймспейсов указанных в деплое. Для решения проблемы перед применением деплоя нужно их создать, либо добавить создание в сам деплой.
    
    ```bash
    ubuntu@work-vm:~$ kubectl create ns data
    namespace/data created
    ubuntu@work-vm:~$ kubectl create ns web
    namespace/web created
    ```
   * После выполнения этих команд повторно запускаем деплой. 
    ```bash
    ubuntu@work-vm:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
    deployment.apps/web-consumer created
    deployment.apps/auth-db created
    service/auth-db created
    ```
4. Продемонстрировать, что проблема решена.
    ```bash
    ubuntu@work-vm:~$ kubectl get pods -n data
    NAME                       READY   STATUS    RESTARTS   AGE
    auth-db-7b5cdbdc77-r4hlh   1/1     Running   0          3m30s
    
    ubuntu@work-vm:~$ kubectl get pods -n web
    NAME                            READY   STATUS    RESTARTS   AGE
    web-consumer-5f87765478-nxdbf   1/1     Running   0          3m35s
    web-consumer-5f87765478-qdc97   1/1     Running   0          3m35s

    ubuntu@work-vm:~$ kubectl get svc -n data
    NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
    auth-db   ClusterIP   10.233.39.178   <none>        80/TCP    4m4s
    ```



