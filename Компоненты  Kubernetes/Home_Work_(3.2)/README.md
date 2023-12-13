# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
    ```bash
    ubuntu@work-vm:~$ kubectl get node
    NAME    STATUS   ROLES           AGE   VERSION
    node1   Ready    control-plane   18m   v1.28.4
    node2   Ready    <none>          18m   v1.28.4
    node3   Ready    <none>          18m   v1.28.4
    node4   Ready    <none>          18m   v1.28.4
    node5   Ready    <none>          18m   v1.28.4
    ```
2. В качестве CRI — containerd.
    ```bash
    ubuntu@node1:~$ systemctl status containerd.service
    ● containerd.service - containerd container runtime
    Loaded: loaded (/etc/systemd/system/containerd.service; enabled; vendor preset: enabled)
    Active: active (running) since Wed 2023-12-13 08:00:16 UTC; 52min ago
    Docs: https://containerd.io
    Main PID: 9313 (containerd)
    Tasks: 89
    Memory: 199.8M
    CPU: 22.994s
    CGroup: /system.slice/containerd.service
    ├─ 9313 /usr/local/bin/containerd
    ├─17676 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 7fc33d31910eba3d089946186933ce9675ee0>
    ├─18482 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 481611b1d8337da55be5319ee49947095c607>
    ├─18502 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id bd3e263b0c51c252bfa7fed103c105d699905>
    ├─19137 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 1e180a7546c5888b96a48974a853ac1246a9d>
    ├─19869 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id cc607de33f8d69138ea431d4678304595e409>
    └─21598 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id cb66743b9b7d6c04f5a5a91eb3
   ```  
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.



## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.
