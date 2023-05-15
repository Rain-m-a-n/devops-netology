## Задача 1

**Используя Docker-образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:**

* составьте Dockerfile-манифест для Elasticsearch,
* соберите Docker-образ и сделайте push в ваш docker.io-репозиторий,
* запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины.

**Требования к elasticsearch.yml:**

* данные path должны сохраняться в /var/lib,
* имя ноды должно быть netology_test.
  
**В ответе приведите:**

* текст Dockerfile-манифеста,
  * т.к. при настройке файла качать через VPN было каждый раз долго, скачал архив и в манифесте поэтому локальный путь:
    ```bash
    FROM centos:7
    COPY ./elasticsearch-8.7.1-linux-x86_64.tar.gz /opt
    COPY ./elasticsearch-8.7.1-linux-x86_64.tar.gz.sha512 /opt
    RUN yum update && yum upgrade -y  
    RUN yum install -y perl-Digest-SHA
    RUN cd /opt && groupadd elasticsearch && useradd -g elasticsearch -p elasticsearch elasticsearch
    WORKDIR /opt/
    RUN shasum -a 512 -c elasticsearch-8.7.1-linux-x86_64.tar.gz.sha512
    RUN tar -xzfv /opt/elasticsearch-8.7.1-linux-x86_64.tar.gz
    RUN mkdir /var/lib/data && chmod -R 777 /var/lib/data
    RUN chown -R elasticsearch:elasticsearch /opt/elasticsearch-8.7.1/ && yum clean all
    USER elasticsearch
    WORKDIR /opt/elasticsearch-8.7.1/
    COPY elasticsearch.yml config/
    EXPOSE 9200 9300 
    ENTRYPOINT ["bin/elasticsearch"]
    ```
* ссылку на образ в репозитории dockerhub,  
  [Ссылка](https://hub.docker.com/layers/bsv27/elastic/v4/images/sha256-20466c2fbd7a5fa950b0bdeb64893c2e7350ef2067d2b9568f03473f5cb26517?context=repo)
* ответ Elasticsearch на запрос пути / в json-виде.
  ```json
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl --insecure -u elastic https://localhost:9200
  Enter host password for user 'elastic':
  {
    "name" : "netology_test",
    "cluster_name" : "elasticsearch",
    "cluster_uuid" : "CIpUMy8ZTOWYEjp_XLKuog",
    "version" : {
      "number" : "8.7.1",
      "build_flavor" : "default",
      "build_type" : "tar",
      "build_hash" : "f229ed3f893a515d590d0f39b05f68913e2d9b53",
      "build_date" : "2023-04-27T04:33:42.127815583Z",
      "build_snapshot" : false,
      "lucene_version" : "9.5.0",
      "minimum_wire_compatibility_version" : "7.17.0",
      "minimum_index_compatibility_version" : "7.0.0"
    },
    "tagline" : "You Know, for Search"
  }
  ```
**Подсказки:**

* возможно, вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum,
* при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml,
* при некоторых проблемах вам поможет Docker-директива ulimit,
* Elasticsearch в логах обычно описывает проблему и пути её решения.
Далее мы будем работать с этим экземпляром Elasticsearch.

## Задача 2

**В этом задании вы научитесь:**

* создавать и удалять индексы,
* изучать состояние кластера,
* обосновывать причину деградации доступности данных.
* Ознакомьтесь с документацией и добавьте в Elasticsearch 3 индекса в соответствии с таблицей:

  | Имя	| Количество реплик | 	Количество шард | 
  | ----- | ------| -----| 
  |ind-1	| 0| 	1|
  |ind-2	| 1	| 2|
  |ind-3	| 2	| 4
  ```bash
  curl -X PUT --insecure -u elastic "https://localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'{"settings": {"index": {number_of_shards": 1, "number_of_replicas": 0}}}'
  curl -X PUT --insecure -u elastic "https://localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'{"settings": {"index": {number_of_shards": 2, "number_of_replicas": 1}}}'
  curl -X PUT --insecure -u elastic "https://localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'{"settings": {"index": {number_of_shards": 4, "number_of_replicas": 2}}}'
  ```
* Получите список индексов и их статусов, используя API, и приведите в ответе на задание.
  ```bash
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cat/indices?v=true"
  health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
  green  open   ind-1 cGm_ed0mRWiCNu91t0B0dw   1   0          0            0       225b           225b
  yellow open   ind-3 Yd4P-zn6QKu23M_DdB0Oyg   4   2          0            0       900b           900b
  yellow open   ind-2 SEoHqDT0SHGlzMbuJISGpw   2   1          0            0       450b           450b

  ```
* Получите состояние кластера Elasticsearch, используя API.
  ```bash
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cluster/health?pretty"
  {
    "cluster_name" : "elasticsearch",
    "status" : "yellow",
    "timed_out" : false,
    "number_of_nodes" : 1,
    "number_of_data_nodes" : 1,
    "active_primary_shards" : 8,
    "active_shards" : 8,
    "relocating_shards" : 0,
    "initializing_shards" : 0,
    "unassigned_shards" : 10,
    "delayed_unassigned_shards" : 0,
    "number_of_pending_tasks" : 0,
    "number_of_in_flight_fetch" : 0,
    "task_max_waiting_in_queue_millis" : 0,
    "active_shards_percent_as_number" : 44.44444444444444
  }
  ```
* Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?
  * Индексы и кластер находятся в yellow, так как при создании индексов мы указали количество реплик больше 1. В кластере у нас 1 нода, поэтому реплицировать индексы некуда.

* Удалите все индексы.
  ```bash
  curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-1?pretty"
  curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-2?pretty"
  curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-3?pretty"
  ```

Важно

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

**В этом задании вы научитесь:** 

* создавать бэкапы данных,
* восстанавливать индексы из бэкапов.
* Создайте директорию {путь до корневой директории с Elasticsearch в образе}/snapshots.
  ```bash
  mkdir /opt/elasticsearch-8.7.1/snapshots
  ```
* Используя API, зарегистрируйте эту директорию как snapshot repository c именем netology_backup.
  * В конфигурационный файл ```elasticsearch.yml``` нужно добавить параметр: ```path.repo: ["/opt/elasticsearch-8.7.1/snapshots"]```

* Приведите в ответе запрос API и результат вызова API для создания репозитория.
  ```bash
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d '{ "type": "fs", "settings": { "location": "/opt/elasticsearch-8.7.1/snapshots", "compress": true} }'
  {
    "acknowledged" : true
  }
  ```
* Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
  ```bash 
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X PUT --insecure -u elastic "https://localhost:9200/test?pretty" -H 'Content-Type: application/json' -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}'
  Enter host password for user 'elastic':
  {
    "acknowledged" : true,
    "shards_acknowledged" : true,
    "index" : "test"
  }
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cat/indices?v=true"
  health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
  green  open   test  F7pBADPqRLi8ceT8vdFKGA   1   0          0            0       225b           225b
  ```
* Создайте snapshot состояния кластера Elasticsearch.
  ```bash
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/_snapshot/netology_backup/%3Cmy_snapshot_%7Bnow%2Fd%7D%3E?pretty"
  {
    "accepted" : true
  }
  ```
* Приведите в ответе список файлов в директории со snapshot.
  ```bash
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ ls -la /opt/elasticsearch-8.7.1/snapshots/
  total 48
  drwxrwxr-x 3 elasticsearch elasticsearch  4096 May 15 20:29 .
  drwxr-xr-x 1 elasticsearch elasticsearch  4096 May 15 20:02 ..
  -rw-r--r-- 1 elasticsearch elasticsearch   850 May 15 20:29 index-0
  -rw-r--r-- 1 elasticsearch elasticsearch     8 May 15 20:29 index.latest
  drwxr-xr-x 4 elasticsearch elasticsearch  4096 May 15 20:29 indices
  -rw-r--r-- 1 elasticsearch elasticsearch 18900 May 15 20:29 meta-aVP-WILFREyimWwmXTDv5w.dat
  -rw-r--r-- 1 elasticsearch elasticsearch   355 May 15 20:29 snap-aVP-WILFREyimWwmXTDv5w.dat
  ```
* Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
  ```bash
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/test?pretty"
  {
    "acknowledged" : true
  }
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X PUT --insecure -u elastic "https://localhost:9200/test2?pretty" -H 'Content-Type: application/json' -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}'
  Enter host password for user 'elastic':
  { 
    "acknowledged" : true,
    "shards_acknowledged" : true,
    "index" : "test2"
  }
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cat/indices?v=true"
  health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
  green  open   test2 ujmSk-cmSianmg9eXnEZUQ   1   0          0            0       225b           225b
  ```
* Восстановите состояние кластера Elasticsearch из snapshot, созданного ранее.
  * Необходимо получить список snapshot(ов):
  ```bash
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_snapshot/netology_backup/*?verbose=false&pretty"
  {
    "snapshots" : [
      {
        "snapshot" : "my_snapshot_2023.05.15",
        "uuid" : "aVP-WILFREyimWwmXTDv5w",
        "repository" : "netology_backup",
        "indices" : [
          ".security-7",
          "test"
        ],
        "data_streams" : [ ],
        "state" : "SUCCESS"
      }
    ],
    "total" : 1,
    "remaining" : 0
  }
  ```
* Приведите в ответе запрос к API восстановления и итоговый список индексов.
  ```bash
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X POST --insecure -u elastic:elastic "https://localhost:9200/_snapshot/netology_backup/my_snapshot_2023.05.15/_restore?pretty" -H 'Content-Type: application/json' -d '{"indices": "*", "include_global_state": true}'
  {
    "accepted" : true
  }
  [elasticsearch@31021941874d elasticsearch-8.7.1]$ curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cat/indices?v=true"
  health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
  green  open   test2 ujmSk-cmSianmg9eXnEZUQ   1   0          0            0       225b           225b
  green  open   test  VyaDCAluT7K2i_qgqZoEYg   1   0          0            0       225b           225b
  ```

Подсказки:

возможно, вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить Elasticsearch.


