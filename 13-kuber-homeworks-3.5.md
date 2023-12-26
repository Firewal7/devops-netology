# Домашнее задание к занятию Troubleshooting

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

```
Запустил:

root@vm2:~# kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found

Нет namespaces.

Создаём его:

root@vm2:~# microk8s kubectl create namespace web
namespace/web created

root@vm2:~# microk8s kubectl create namespace data
namespace/data created

root@vm2:~# kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created

root@vm2:~# kubectl get pod -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-5f87765478-gwlkh   1/1     Running   0          22m
web-consumer-5f87765478-gpbzd   1/1     Running   0          22m

root@vm2:~# kubectl get pod -n data
NAME                       READY   STATUS    RESTARTS   AGE
auth-db-7b5cdbdc77-tq5rl   1/1     Running   0          22m

root@vm2:~# kubectl get all -n data
NAME                           READY   STATUS    RESTARTS   AGE
pod/auth-db-7b5cdbdc77-tq5rl   1/1     Running   0          23m

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/auth-db   ClusterIP   10.152.183.38   <none>        80/TCP    23m

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/auth-db   1/1     1            1           23m

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/auth-db-7b5cdbdc77   1         1         1       23m

Смотрим логи:

root@vm2:~# kubectl logs pod/web-consumer-5f87765478-gpbzd -n web
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'

Хост не знает dns имени auth-db.

Надо записать в dns запись auth-db.

Пропишу в каждом контейнере в файле hosts.

root@vm2:~# kubectl exec -it pod/web-consumer-5f87765478-gpbzd -n web -c busybox -- bin/sh
bin/sh: shopt: not found

[ root@web-consumer-5f87765478-gpbzd:/ ]$ echo 10.152.183.38 auth-db >> /etc/hosts

[ root@web-consumer-5f87765478-gpbzd:/ ]$ cat /etc/hosts
# Kubernetes-managed hosts file.
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
fe00::0 ip6-mcastprefix
fe00::1 ip6-allnodes
fe00::2 ip6-allrouters
10.1.185.196    web-consumer-5f87765478-gpbzd
10.152.183.38 auth-db

Проверим:

[ root@web-consumer-5f87765478-gpbzd:/ ]$ curl auth-db
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

Делаем тоже самое со 2м pod:

root@vm2:~# kubectl exec -it pod/web-consumer-5f87765478-gpbzd -n web -c busybox -- bin/sh
bin/sh: shopt: not found

[ root@web-consumer-5f87765478-gpbzd:/ ]$ echo 10.152.183.38 auth-db >> /etc/hosts

[ root@web-consumer-5f87765478-gpbzd:/ ]$ curl auth-db
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
```

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.