## Playbook

Playbook устанавливает clichouse и vector на две виртуальные машины Centos7 docker, собранные с помощью docker-compose файла, запускает службу `clichouse-server` и `vector`, а также создает базу `logs` в `clichouse`. 

### Variables
В каталоге group_vars задаются необходимые версии дистрибутивов.

|clickhouse_version|версия clickhous| 
|-|--------|
|vector_version|версия vector|

    
 ### Install Clickhouse
 Скачиваются rpm пакеты, устанавливается Clickhouse, создается база logs. 
 
### Install vector
Скачиваются пакеты, устанавливается vector. Запуск службы.

### Tags
|clickhouse|производит полную конфигурацию сервера clickhouse-01| 
|-|--------|
|vector|производит полную конфигурацию сервера vector-01|
    
   
Для работы playbook необходимо:
 - собрать и запустить из `docker-compose.yml` файла две виртуальные машины.
```shell
docker-compose up
Проверить, что docker-контейнеры запущены
docker ps
```
 - запустить `ansible-playbook`:
```shell
ansible-playbook -i inventory/prod.yml site.yml
```
