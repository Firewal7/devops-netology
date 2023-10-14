# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.

[deployment.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-1.4/deployment.yaml) 

```
user@epdpn6ma3pu39gos0stk:~$ kubectl apply -f deployment.yaml
deployment.apps/netology-task-1 created
service/netology-task-1 created

user@epdpn6ma3pu39gos0stk:~$ kubectl get deployments
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
netology-task-1   3/3     3            3           2m59s

user@epdpn6ma3pu39gos0stk:~$ kubectl get svc
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes        ClusterIP   10.152.183.1     <none>        443/TCP             21m
netology-task-1   ClusterIP   10.152.183.250   <none>        9001/TCP,9002/TCP   3m56s
```

3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

```
user@epdpn6ma3pu39gos0stk:~$ kubectl exec -it multitool -- /bin/bash
multitool:/# curl netology-task-1:9001
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
multitool:/# curl netology-task-1:9002
WBITT Network MultiTool (with NGINX) - netology-task-1-6d55d7c5f9-jfqwx - 10.1.219.141 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

[NodePortService.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-1.4/NodePortService.yaml) 

```
user@epdpn6ma3pu39gos0stk:~$ kubectl apply -f NodePortService.yaml                                                                                          service/netology-task-2 created
user@epdpn6ma3pu39gos0stk:~$ kubectl get services
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes        ClusterIP   10.152.183.1     <none>        443/TCP             29m
netology-task-1   ClusterIP   10.152.183.250   <none>        9001/TCP,9002/TCP   11m
netology-task-2   NodePort    10.152.183.51    <none>        9001:30292/TCP      14s
```

![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/12-kuber-homeworks-1.4-1.jpg)

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
