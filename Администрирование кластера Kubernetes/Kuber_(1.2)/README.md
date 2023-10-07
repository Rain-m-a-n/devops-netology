# Домашнее задание к занятию «Базовые объекты K8S»

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.2)/pics/pod.png)
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
* При использовании указанного образа не смог настроить проброс порта, заменил на образ nginx.  
  ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.2)/pics/forward.png)
4. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.2)/pics/pruf1.png)

------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.2)/pics/create.png)
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
  * как и первом задании, не получилось использовать этот образ, заменил на Nginx 
3. Создать Service с именем netology-svc и подключить к netology-web.  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.2)/pics/service.png)
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.2)/pics/svc_forvard.png)  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20кластера%20Kubernetes/Kuber_(1.2)/pics/pruf2.png)


------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get pods`, а также скриншот результата подключения.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.
