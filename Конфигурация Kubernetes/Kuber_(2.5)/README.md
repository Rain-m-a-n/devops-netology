# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

<details><summary>Дополнительные материалы</summary>

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

</details>

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
    ```bash
    > $ ls -la ./task1/templates                                                                       [±kuber_(2.5) ●●●]
    total 24
    drwxr-xr-x 2 ubuntu ubuntu 4096 Nov 13 23:21 .
    drwxr-xr-x 4 ubuntu ubuntu 4096 Nov 13 23:18 ..
    -rw-r--r-- 1 ubuntu ubuntu 1762 Nov 13 22:14 _helpers.tpl
    -rw-rw-r-- 1 ubuntu ubuntu   63 Nov 13 23:10 namespace.yaml
    -rw-rw-r-- 1 ubuntu ubuntu  327 Nov 13 23:21 nginx.yaml
    -rw-rw-r-- 1 ubuntu ubuntu  224 Nov 13 23:10 service.yaml
    ```
   ```bash
   > $ kube get pods -n kuber-2-5                                                                     [±kuber_(2.5) ●●●]
   NAME                     READY   STATUS    RESTARTS   AGE
   nginx-78d998bcfd-cwbvd   1/1     Running   0          10m
   ```
   ```bash
   > $ kube get svc -n kuber-2-5                                                                      [±kuber_(2.5) ●●●]
   NAME        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
   nginx-svc   ClusterIP   10.152.183.72   <none>        80/TCP    11m
   ```   
3. В переменных чарта измените образ приложения для изменения версии.
   ```bash
   > $ kube get pods -n kuber-2-5                                                                                        [±kuber_(2.5) ●●●]
   NAME                       READY   STATUS    RESTARTS        AGE
   nginx-78d998bcfd-cwbvd     1/1     Running   0               20m
   nginx01-7b6c9b55f4-g76vh   1/1     Running   0               2m26s
   ````   
   ```bash
   > $ kube describe pods -n kuber-2-5 | grep Image                                                                      [±kuber_(2.5) ●●●]
   Image:          nginx:latest
   Image ID:       docker.io/library/nginx@sha256:86e53c4c16a6a276b204b0fd3a8143d86547c967dc8258b3d47c3a21bb68d3c6
   Image:          nginx:stable-bullseye-perl
   Image ID:       docker.io/library/nginx@sha256:3487434b3141ac6300a36fcef44064012e61d767ce7df88d4d2601256c273777
   ```
------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.
   ```bash
   > $ microk8s helm3 list -A                                                                                           [±kuber_(2.5) ●●●]
   NAME   	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART      	APP VERSION
   task1  	app1     	1       	2023-11-13 23:43:19.454304573 +0300 MSK	deployed	task1-0.1.0	1.16.0     
   task1-2	app1     	1       	2023-11-13 23:43:35.885249323 +0300 MSK	deployed	task1-0.2.0	1.16.0     
   task1-3	app2     	1       	2023-11-13 23:43:46.675320748 +0300 MSK	deployed	task1-0.3.0	1.16.0
   ```