# Домашнее задание к занятию «Кластеры. Ресурсы под управлением облачных провайдеров»

### Цели задания 

1. Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
2. Размещение в private подсетях кластера БД, а в public — кластера Kubernetes.

---
## Задание 1. Yandex Cloud

1. Настроить с помощью Terraform кластер баз данных MySQL.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость. 
 - Разместить ноды кластера MySQL в разных подсетях.
    ```bash
    > $ yc managed-mysql hosts list --cluster-id c9qh5aeullrvv7jkvo1a                                                                      [±15.3 ●●●]
    +-------------------------------------------+----------------------+---------+--------+---------------+-----------+--------------------+----------+-----------------+
    |                   NAME                    |      CLUSTER ID      |  ROLE   | HEALTH |    ZONE ID    | PUBLIC IP | REPLICATION SOURCE | PRIORITY | BACKUP PRIORITY |
    +-------------------------------------------+----------------------+---------+--------+---------------+-----------+--------------------+----------+-----------------+
    | rc1a-bb10qm5u7rjc9h05.mdb.yandexcloud.net | c9qh5aeullrvv7jkvo1a | REPLICA | ALIVE  | ru-central1-a | false     |                    |        0 |               0 |
    | rc1b-hjmytzet6w2yev4j.mdb.yandexcloud.net | c9qh5aeullrvv7jkvo1a | REPLICA | ALIVE  | ru-central1-b | false     |                    |        5 |               0 |
    | rc1c-deyjdsdafzb4ymlo.mdb.yandexcloud.net | c9qh5aeullrvv7jkvo1a | MASTER  | ALIVE  | ru-central1-c | false     |                    |       10 |               0 |
    +-------------------------------------------+----------------------+---------+--------+---------------+-----------+--------------------+----------+-----------------+
    ```
 - Необходимо предусмотреть репликацию с произвольным временем технического обслуживания.
 - Использовать окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.  
   ![pic](https://github.com/Rain-m-a-n/devops-netology/blob/master/Проект%20в%20облачных%20провайдерах/15.4/pics/preset.png)
 - Задать время начала резервного копирования — 23:59.
    ```bash
     backup_window_start {
       hours   = 23
       minutes = 59
     } 
   ```
 - Включить защиту кластера от непреднамеренного удаления.
    ```bash
    resource "yandex_mdb_mysql_cluster" "netology" {
    environment         = "PRESTABLE"
    name                = "h-w-15-4"
    network_id          = yandex_vpc_network.netology.id
    version             = "8.0"
    folder_id           = var.folder_id
    deletion_protection = true 
   ```
 - Создать БД с именем `netology_db`, логином и паролем.
    ```bash
    > $ yc managed-mysql database list --cluster-id c9qh5aeullrvv7jkvo1a                                                                                                                          [±15.3 ●●●]
    +-------------+----------------------+
    |    NAME     |      CLUSTER ID      |
    +-------------+----------------------+
    | netology_db | c9qh5aeullrvv7jkvo1a |
    +-------------+----------------------+ 
   ```    
   ![pic](https://github.com/Rain-m-a-n/devops-netology/blob/master/Проект%20в%20облачных%20провайдерах/15.4/pics/user.png)

2. Настроить с помощью Terraform кластер Kubernetes.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.
 - Создать отдельный сервис-аккаунт с необходимыми правами. 
 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.
 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.  
   ![kms](https://github.com/Rain-m-a-n/devops-netology/blob/master/Проект%20в%20облачных%20провайдерах/15.4/pics/kms.png)
 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.
   ```bash
   > $ yc managed-kubernetes node-group list                                                   [±15.4 ●●●]
   +----------------------+----------------------+-------------+----------------------+---------------------+---------+------+
   |          ID          |      CLUSTER ID      |    NAME     |  INSTANCE GROUP ID   |     CREATED AT      | STATUS  | SIZE |
   +----------------------+----------------------+-------------+----------------------+---------------------+---------+------+
   | cat41tusp95qn6drlfch | cat84s4o0gv6lkb49qe0 | k8s-cluster | cl1ct0nkbid4kma5vpoj | 2024-02-06 17:00:37 | RUNNING | auto |
   +----------------------+----------------------+-------------+----------------------+---------------------+---------+------+
   ```
   ```bash
   > $ yc managed-kubernetes node-group get --id cat41tusp95qn6drlfch                          [±15.4 ●●●]                                                                                                  [±15.3 ●●●]
   id: cat41tusp95qn6drlfch
   cluster_id: cat84s4o0gv6lkb49qe0
   created_at: "2024-02-06T17:00:37Z"
   name: k8s-cluster
   status: RUNNING
   node_template:
   platform_id: standard-v2
   resources_spec:
   memory: "4294967296"
   cores: "2"
   core_fraction: "50"
   scheduling_policy:
   preemptible: true
   ...........
   scale_policy:
   auto_scale:
   min_size: "3"
   max_size: "6"
   initial_size: "3"
   deploy_policy:
   max_expansion: "3"
   instance_group_id: cl1ct0nkbid4kma5vpoj
   node_version: "1.28"
   version_info:
   current_version: "1.28"
   ```   

 - Подключиться к кластеру с помощью `kubectl`.
     *  Для подключения к кластеру в консоли облака берём строку для подключения и выполняем на локальном ПК, где установлен `kubectl`.
   ```bash
   yc managed-kubernetes cluster get-credentials --id cat84s4o0gv6lkb49qe0 --external
   ````
   ```bash
   > $ kubectl get pods -A                                                                     [±15.4 ●●●]
   NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
   kube-system   coredns-768758b987-jtrvf               1/1     Running   0          96s
   kube-system   coredns-768758b987-wsc2w               1/1     Running   0          5m4s
   kube-system   ip-masq-agent-4jwdn                    1/1     Running   0          2m13s
   kube-system   ip-masq-agent-6rth2                    1/1     Running   0          2m11s
   kube-system   ip-masq-agent-9flw8                    1/1     Running   0          2m7s
   kube-system   kube-dns-autoscaler-74d99dd8dc-97k5x   1/1     Running   0          5m
   kube-system   kube-proxy-g98fr                       1/1     Running   0          2m13s
   kube-system   kube-proxy-k79fx                       1/1     Running   0          2m11s
   kube-system   kube-proxy-qbvc9                       1/1     Running   0          2m7s
   kube-system   metrics-server-6b5df79959-q5c46        2/2     Running   0          88s
   kube-system   npd-v0.8.0-86rkz                       1/1     Running   0          2m7s
   kube-system   npd-v0.8.0-bvdx9                       1/1     Running   0          2m13s
   kube-system   npd-v0.8.0-gjsbl                       1/1     Running   0          2m11s
   kube-system   yc-disk-csi-node-v2-bl6st              6/6     Running   0          2m7s
   kube-system   yc-disk-csi-node-v2-h582t              6/6     Running   0          2m13s
   kube-system   yc-disk-csi-node-v2-hdpk4              6/6     Running   0          2m11s

   ```
 - *Запустить микросервис phpmyadmin и подключиться к ранее созданной БД.
 - *Создать сервис-типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД.

Полезные документы:

- [MySQL cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster).
- [Создание кластера Kubernetes](https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create)
- [K8S Cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster).
- [K8S node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group).
