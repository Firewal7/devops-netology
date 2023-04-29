## Домашнее задание к занятию 5. «Elasticsearch»

### Задача 1

В этом задании вы потренируетесь в:

- установке Elasticsearch,
- первоначальном конфигурировании Elasticsearch,
- запуске Elasticsearch в Docker.
  
Используя Docker-образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:

- составьте Dockerfile-манифест для Elasticsearch,
- соберите Docker-образ и сделайте push в ваш docker.io-репозиторий,
- запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины.

Требования к elasticsearch.yml:

- данные path должны сохраняться в /var/lib,
- имя ноды должно быть netology_test.
  
В ответе приведите:

- текст Dockerfile-манифеста,
- ссылку на образ в репозитории dockerhub,
- ответ Elasticsearch на запрос пути / в json-виде.

Подсказки:

- возможно, вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum,
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml,
- при некоторых проблемах вам поможет Docker-директива ulimit,
- Elasticsearch в логах обычно описывает проблему и пути её решения.

Далее мы будем работать с этим экземпляром Elasticsearch.

### Ответ

Создал 
- [Dockerfile](https://github.com/Firewal7/6.5.-Elasticsearch/blob/main/Dockerfile)
- [elasticsearch.yml](https://github.com/Firewal7/6.5.-Elasticsearch/blob/main/elasticsearch.yml)
- [logging.yml](https://github.com/Firewal7/6.5.-Elasticsearch/blob/main/logging.yml)

Собрал Docker образ
```
──(root㉿kali)-[/home/kali/lesson/sql5]
└─# DOCKER_BUILDKIT=0 docker build -t bbb8c2e28d7d/elastic:8.6.2 .

Successfully built a8a910ae5ed7
Successfully tagged bbb8c2e28d7d/elastic:8.6.2
```
Ссылка на образ в репозитории dockerhub

```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# sudo docker push bbb8c2e28d7d/elastic:8.6.2
The push refers to repository [docker.io/bbb8c2e28d7d/elastic]
61927a2c4779: Pushed
843f74087540: Pushed
2b4d6f940fa4: Pushed
6758c1776d18: Pushed
2964648e072e: Pushed
e5d5b907d324: Pushed
c41972607388: Pushed
7fdca66891b8: Pushed
174f56854903: Mounted from library/centos
8.6.2: digest: sha256:2b18cd754a5854502df075f78c6381246b23745b00be31856cb38f9c96                                c06f45 size: 2204
```
```
https://hub.docker.com/layers/bbb8c2e28d7d/elastic/8.6.2/images/sha256-2b18cd754a5854502df075f78c6381246b23745b00be31856cb38f9c96c06f45?context=repo
```
Запустим Образ
```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# docker run -d -p 9200:9200 bbb8c2e28d7d/elastic:8.6.2
afcd6b408c79f27720fc351f0554d6df6b826c4c1bd3a6389818a21774bb23ad
```
ответ Elasticsearch на запрос пути / в json-виде.
```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X GET 'http://localhost:9200/'
{
  "name" : "netology_test",
  "cluster_name" : "netology",
  "cluster_uuid" : "pEd13WyWRYatfW_4cYvVhQ",
  "version" : {
    "number" : "8.6.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "2d58d0f136141f03239816a4e360a8d17b6d8f29",
    "build_date" : "2023-02-13T09:35:20.314882762Z",
    "build_snapshot" : false,
    "lucene_version" : "9.4.2",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```
### Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы,
- изучать состояние кластера,
- обосновывать причину деградации доступности данных.

Ознакомьтесь с документацией и добавьте в Elasticsearch 3 индекса в соответствии с таблицей:



|Имя|Количество реплик|Количество шард|
 |-------|----------|------|
 |ind-1| 0 | 1 |
 |ind-1| 1 | 2 |
 |ind-1| 2 | 4 |
 
```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}                                                                           
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}                                                                           
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}                            
```

Получите список индексов и их статусов, используя API, и приведите в ответе на задание.
```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 JuepGy90SCWQLm0YXfBH5A   1   0          0            0       225b           225b
yellow open   ind-3 TIrNoEHvTVmbM7v-UlYAUw   4   2          0            0       900b           900b
yellow open   ind-2 84179rCxR1u0E8YgUOpaAQ   2   1          0            0       450b           450b
```

Получите состояние кластера Elasticsearch

```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 33.33333333333333
}

```
Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?
```
Cтатус Yellow потому указано число реплик, по факту руплицировать некуда, т.к. нет других серверов. 
```

Удалите все индексы.
```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X DELETE "localhost:9200/ind-1,ind-2,ind-3?pretty"
{
  "acknowledged" : true
}
```

#### Важно

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

### Задача 3

В этом задании вы научитесь:

- создавать бэкапы данных,
- восстанавливать индексы из бэкапов.
Создайте директорию {путь до корневой директории с Elasticsearch в образе}/snapshots.

Используя API, зарегистрируйте эту директорию как snapshot repository c именем netology_backup.

Приведите в ответе запрос API и результат вызова API для создания репозитория.
```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"myrepo" }}'
{
  "acknowledged" : true
}

┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X GET 'http://localhost:9200/_snapshot/netology_backup?pretty'
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "myrepo"
    }
  }
}
```

Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
```
curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}

┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X GET 'http://localhost:9200/test?pretty'
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1678015657730",
        "number_of_replicas" : "0",
        "uuid" : "kwg5tgqdRQCy-x18jYFfWw",
        "version" : {
          "created" : "8060299"
        }
      }
    }
  }
}

```

Создайте snapshot состояния кластера Elasticsearch.
```
curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
```

Приведите в ответе список файлов в директории со snapshot.
```
[elasticsearch@afcd6b408c79 elasticsearch]$ ls -lh /elasticsearch-8.6.2/snapshots/myrepo
total 36K
-rw-r--r-- 1 elasticsearch elasticsearch  846 Mar  5 11:30 index-0
-rw-r--r-- 1 elasticsearch elasticsearch    8 Mar  5 11:30 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch 4.0K Mar  5 11:30 indices
-rw-r--r-- 1 elasticsearch elasticsearch  19K Mar  5 11:30 meta-TFN-W_QyRsK92Eak4Lamog.dat
-rw-r--r-- 1 elasticsearch elasticsearch  356 Mar  5 11:30 snap-TFN-W_QyRsK92Eak4Lamog.dat
```
Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
```

Восстановите состояние кластера Elasticsearch из snapshot, созданного ранее.

Приведите в ответе запрос к API восстановления и итоговый список индексов.
```
┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'
{
  "accepted" : true
}

┌──(root㉿kali)-[/home/kali/lesson/sql5]
└─# curl -X GET http://localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 3tb_oimsQ8aUk_gfKHpakw   1   0          0            0       225b           225b
green  open   test   _aECYtWmQUeTgJAMnN-_wg   1   0          0            0       225b           225b
```
