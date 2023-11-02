# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

-----

<details><summary>Дополнительные материалы</summary>

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).
</details>

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
    ```bash
    > $ kube get pv                                                                                                   [±feature/Kube_(2.2) ●●]
    NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS   REASON   AGE
    local   1Gi        RWX            Retain           Bound    kuber-2-2/task1                           13m

    > $ kube get pvc -n kuber-2-2                                                                                     [±feature/Kube_(2.2) ●●]
    NAME    STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    task1   Bound    local    1Gi        RWX                           13m
    ```
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории.
    ```bash
    > $ kube exec -n kuber-2-2 home-work-5879b79597-qm5w7 -c busybox -- tail -5 /output/welcome.txt                   [±feature/Kube_(2.2) ●●]
    hello
    hello
    hello
    hello
    hello

    > $ kube exec -n kuber-2-2 home-work-5879b79597-qm5w7 -c multitool -- tail -5 /input/welcome.txt                  [±feature/Kube_(2.2) ●●]
    hello
    hello
    hello
    hello
    hello
    ```
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
   ```bash
   > $ kube delete deployment -n kuber-2-2 home-work                                                                 [±feature/Kube_(2.2) ●●]
   deployment.apps "home-work" deleted

   > $ kube delete pvc task1 -n kuber-2-2                                                                            [±feature/Kube_(2.2) ●●]
   persistentvolumeclaim "task1" deleted
   
   > $ kube get pv                                                                                                   [±feature/Kube_(2.2) ●●]
   NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM             STORAGECLASS   REASON   AGE
   local   1Gi        RWX            Retain           Released   kuber-2-2/task1                           19m
   ```
    
   * **Пояснение:**   
     На лекции при демонстрации материала, во время удаления PVC терминал "завис", до тех пор, пока не был удалён POD использующий PVC. 
     У меня при выполнении ДЗ, во время удаления деплоймента удалился и под, поэтому зависания не произошло. А PV перешёл в статус "Освобождён" 
----
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.  
    * Не нашёл как подключиться на ноду Microk8s, поэтому чуть исправил деплоймент (убрал контейнер Busybox) и запустил его повторно.
    * Как видно из вывода ниже, при повторном создании PV и подключении PVC(по тому же пути, что и в предыдущем задании), данные в нём сохраняются без изменений.
     
    ```bash
     > $ kube get pods -n kuber-2-2                                                                       [±feature/Kube_(2.2) ●●]
    NAME                         READY   STATUS    RESTARTS   AGE
    home-work-57f5ff7f56-rzggm   1/1     Running   0          32s

    > $ kube exec -n kuber-2-2 home-work-57f5ff7f56-rzggm -- tail -5 /input/welcome.txt                  [±feature/Kube_(2.2) ●●]
    hello
    hello
    hello
    hello
    hello
    ```
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.  
   [deploynment](https://github.com/Rain-m-a-n/devops-netology/blob/master/Конфигурация%20Kubernetes/Kuber_(2.2)/task1.yml)  
   [check](https://github.com/Rain-m-a-n/devops-netology/blob/master/Конфигурация%20Kubernetes/Kuber_(2.2)/task1_1.yml)

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.


