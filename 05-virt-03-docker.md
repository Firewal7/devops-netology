## Домашнее задание к занятию "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

```
┌──(root㉿kali)-[/home/kali/nginx]
└─# docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED              STATUS              PORTS
bc69f84983de   bbb8c2e28d7d/sofin:v2   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8081->80/tcp, xwell

┌──(root㉿kali)-[/home/kali/nginx]
└─# curl http://localhost:8081/
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>

```
Ответ: https://hub.docker.com/r/bbb8c2e28d7d/sofin 

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
```
Желательно на Физический сервер, т.к. приложение монолитное, сложно разбить на микросервисы.
Необходим прямой доступ к ресурсам. 
```
- Nodejs веб-приложение;
```
Подойдет Docker, так как это веб-платформа с подключаемыми внешними библиотеками, снижает трудозатраты на деплой приложения и организацию.
```
- Мобильное приложение c версиями для Android и iOS;
```
Необходим GUI, подойдет виртуализация.
```
- Шина данных на базе Apache Kafka;
```
Я считаю что лучше подойдёт VM., если полнота данных критична.
```
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды - elasticsearch, два logstash и две ноды kibana;
```
Elasticsearvh лучше на VM, отказоустойчивость решается на уровне кластера, kibana и logstash можно вынести в Docker.
```
- Мониторинг-стек на базе Prometheus и Grafana;
```
Подойдет Docker, легко масштабировать, данные не хранятся.
```
MongoDB, как основное хранилище данных для java-приложения;
```
Зависит от нагрузки на DB. Если нагрузка большая, то физический сервер, если нет – VM.
```
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
```
Подойдет VM для DB и фалового хранилища, Docker для сервисов
```
  
## Задача 3

- Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
``` 
┌──(root㉿kali)-[/home/kali]
└─#  docker run -it -d --name centos -v $(pwd)/data:/data centos:latest
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
5774c2f8e3895fc45d30f5f1622752e65145adc715bfd22becdab93d115a1612
```
- Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
```
┌──(root㉿kali)-[/home/kali]
└─# docker run -it -d --name debian -v $(pwd)/data:/data debian:latest
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
1e4aec178e08: Pull complete
Digest: sha256:43ef0c6c3585d5b406caa7a0f232ff5a19c1402aeb415f68bcd1cf9d10180af8
Status: Downloaded newer image for debian:latest
77521fddbdc99a5bdbc03a87e97df3d12980bba69de3527f604ef20beb62baf5
```
- Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
```
─(root㉿kali)-[/home/kali]
└─# docker exec -it centos bash
[root@5774c2f8e389 /]# exit
exit
```
- Добавьте еще один файл в папку /data на хостовой машине;
```
┌──(root㉿kali)-[/home/kali]
└─# echo "New file-2" >> data/file.txt

```
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
```
┌──(root㉿kali)-[/home/kali]
└─# docker exec -it debian bash
root@77521fddbdc9:/# ls data/
centos.txt  file.txt
```
  
