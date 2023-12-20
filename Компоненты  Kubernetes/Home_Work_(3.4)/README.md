# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

    ### Ответ.
    ```
    Т.к. обновление мажорное, то это подразумевает не возможность работать одновременно разных версий приложений и сервисов.  
    поэтому "стратегия по умолчанию RollingUpdate" не подходит, т.к. ещё и нет достаточного запаса по ресурсам кластера.   
    Для подобной задачи на мой взгляд подойдёт стратегия Recreate. Она "прибьёт" старые поды, а на их месте будут созданы  
    поды с новой версией приложения. 
    ```

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.
   ```bash
   ubuntu@work-vm:~$ kubectl get pods -n kuber-3-4
   NAME                        READY   STATUS    RESTARTS   AGE
   backend-7bfd89b7c7-hd78k    1/1     Running   0          16s
   backend-7bfd89b7c7-knvmq    1/1     Running   0          16s
   backend-7bfd89b7c7-p6wtc    1/1     Running   0          16s
   backend-7bfd89b7c7-rtqck    1/1     Running   0          16s
   backend-7bfd89b7c7-s6bc4    1/1     Running   0          16s
   frontend-8657697bc8-5jv55   1/1     Running   0          16s
   frontend-8657697bc8-6dgjj   1/1     Running   0          16s
   frontend-8657697bc8-pz4tv   1/1     Running   0          16s
   frontend-8657697bc8-s97dl   1/1     Running   0          16s
   frontend-8657697bc8-xrdk5   1/1     Running   0          16s 
   ```
   ```bash
   ubuntu@work-vm:~$ kubectl describe pod frontend-8657697bc8-pz4tv -n kuber-3-4
   Name:             frontend-8657697bc8-pz4tv
   Namespace:        kuber-3-4
   Priority:         0
   Service Account:  default
   Node:             node3/192.168.1.203
   Start Time:       Tue, 19 Dec 2023 20:37:59 +0000
   Labels:           app=frontend
   pod-template-hash=8657697bc8
   Annotations:      cni.projectcalico.org/containerID: 9b52aeb4b0fb63e50a43b86a9a2677a85569522e1e0ae3867840cc19a5aa96a1
   cni.projectcalico.org/podIP: 10.233.71.5/32
   cni.projectcalico.org/podIPs: 10.233.71.5/32
   Status:           Running
   IP:               10.233.71.5
   IPs:
   IP:           10.233.71.5
   Controlled By:  ReplicaSet/frontend-8657697bc8
   Containers:
   nginx:
   Container ID:   containerd://996216ab9df8f5454df0a253d168042f3b3f400a670c5207ac70d2d7d77c120d
   Image:          nginx:1.19 
   ```
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
* Для выполнения задачи в деплой необходимо добавить параметры: 
   ```bash
     strategy:
       type: RollingUpdate
       rollingUpdate:
         maxSurge: 100%
         maxUnavailable: 25%
   ```
* после выполнения получим вторую ревизию деплоя.
   ```bash
   ubuntu@work-vm:~$ kubectl rollout history deployment frontend -n kuber-3-4
   deployment.apps/frontend
   REVISION  CHANGE-CAUSE
   1         <none>
   2         <none>   
   ```
   ```bash
   ubuntu@work-vm:~$ kubectl get deployment frontend -o wide -n kuber-3-4
   NAME       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES       SELECTOR
   frontend   5/5     5            5           22m   nginx        nginx:1.20   app=frontend   
   ```
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
* При попытке обновления приложения на указанную версию, получаем ошибку 
   ```bash
   ubuntu@work-vm:~$ kubectl get pods -n kuber-3-4
   NAME                        READY   STATUS             RESTARTS      AGE
   backend-7bfd89b7c7-hd78k    1/1     Running            1 (10m ago)   23h
   backend-7bfd89b7c7-knvmq    1/1     Running            1 (10m ago)   23h
   backend-7bfd89b7c7-p6wtc    1/1     Running            1 (22h ago)   23h
   backend-7bfd89b7c7-rtqck    1/1     Running            1 (22h ago)   23h
   backend-7bfd89b7c7-s6bc4    1/1     Running            1 (10m ago)   23h
   frontend-86df7d5f98-74r9w   0/1     ImagePullBackOff   0             97s
   frontend-86df7d5f98-b4rvp   0/1     ImagePullBackOff   0             97s
   frontend-86df7d5f98-cfxj7   0/1     ImagePullBackOff   0             97s
   frontend-86df7d5f98-dw8m8   0/1     ImagePullBackOff   0             97s
   frontend-86df7d5f98-zfpln   0/1     ImagePullBackOff   0             97s
   frontend-cc56df9b6-5tsz2    1/1     Running            1 (22h ago)   23h
   frontend-cc56df9b6-fv8vb    1/1     Running            1 (22h ago)   23h
   frontend-cc56df9b6-h6jcp    1/1     Running            1 (10m ago)   23h
   frontend-cc56df9b6-nx6cn    1/1     Running            1 (10m ago)   23h
  ```
   В статусе указано **ImagePullBackOff** - что означает не возможность скачать указанный в деплое образ для контейнера. 
   ```bash
     Failed to pull image "nginx:1.28":
     rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/library/nginx:1.28":
     failed to resolve reference "docker.io/library/nginx:1.28": docker.io/library/nginx:1.28: not found
     ```
  При этом приложение продолжит работать, т.к. поды со старой версией не были уничтожены.  
![pics](https://github.com/Rain-m-a-n/devops-netology/blob/master/Компоненты%20%20Kubernetes/Home_Work_(3.4)/pics/nginx.jpg) 

4. Откатиться после неудачного обновления.
   * Проверим версии деплоймента, чтоб понять на какую последнюю рабочую можно "откатиться"
   ```bash
    ubuntu@work-vm:~$ kubectl rollout history deployment frontend -n kuber-3-4
    deployment.apps/frontend
    REVISION  CHANGE-CAUSE
    1         <none>
    2         <none>
    3         <none>
    ```
   * Пробуем "откатиться" на вторую ревизию 
   ```bash
    ubuntu@work-vm:~$ kubectl rollout undo deployment frontend --to-revision 2 -n kuber-3-4
    deployment.apps/frontend rolled back
    
    ubuntu@work-vm:~$ kubectl get pods -n kuber-3-4
    NAME                       READY   STATUS    RESTARTS      AGE
    backend-7bfd89b7c7-hd78k   1/1     Running   1 (25m ago)   23h
    backend-7bfd89b7c7-knvmq   1/1     Running   1 (25m ago)   23h
    backend-7bfd89b7c7-p6wtc   1/1     Running   1 (23h ago)   23h
    backend-7bfd89b7c7-rtqck   1/1     Running   1 (23h ago)   23h
    backend-7bfd89b7c7-s6bc4   1/1     Running   1 (25m ago)   23h
    frontend-cc56df9b6-5tsz2   1/1     Running   1 (23h ago)   23h
    frontend-cc56df9b6-fv8vb   1/1     Running   1 (23h ago)   23h
    frontend-cc56df9b6-h6jcp   1/1     Running   1 (25m ago)   23h
    frontend-cc56df9b6-nx6cn   1/1     Running   1 (25m ago)   23h
    frontend-cc56df9b6-thkgc   1/1     Running   0             4s
    ```
    * Как видим из вывода команды, новые (бракованные поды) удалены, а 1 пода пересоздана. Что не повлияло на работоспособность приложения в целом. 

