# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

<details><summary>Инструменты и дополнительные материалы</summary>

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

</details>

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.  
    [ссылка на манифест](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.3)/task1.yml)  
   ![pics](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.3)/1.png)
2. После запуска увеличить количество реплик работающего приложения до 2.  
   ![pics](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.3)/2.png)
3. Продемонстрировать количество подов до и после масштабирования.  
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.  
   ![pics](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.3)/3.png)
6. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.  
   ![pics](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.3)/4.png)

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.  
   [ссылка на манифест](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.3)/task2.yml)
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.  
   ![pics](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.3)/5.png)
------
