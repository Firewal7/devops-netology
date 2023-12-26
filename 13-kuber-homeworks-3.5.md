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

root@vm1:~# kubectl get deployments -A -o wide
NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS                IMAGES                                      SELECTOR
kube-system   coredns                   1/1     1            1           2m15s   coredns                   coredns/coredns:1.10.1                      k8s-app=kube-dns
kube-system   calico-kube-controllers   1/1     1            1           2m14s   calico-kube-controllers   docker.io/calico/kube-controllers:v3.25.1   k8s-app=calico-kube-controllers
web           web-consumer              2/2     2            2           14s     busybox                   radial/busyboxplus:curl                     app=web-consumer
data          auth-db                   1/1     1            1           14s     nginx                     nginx:1.19.1                                app=auth-db

Выводим IP адреса pod-ов

root@vm1:~# kubectl get pods -n data -o wide
NAME                       READY   STATUS    RESTARTS   AGE    IP           NODE   NOMINATED NODE   READINESS GATES
auth-db-7b5cdbdc77-n6rc9   1/1     Running   0          2m5s   10.1.225.4   vm1    <none>           <none>

root@vm1:~# kubectl get pods -n web -o wide
NAME                            READY   STATUS    RESTARTS   AGE     IP           NODE   NOMINATED NODE   READINESS GATES
web-consumer-5f87765478-ppqh6   1/1     Running   0          3m22s   10.1.225.3   vm1    <none>           <none>
web-consumer-5f87765478-t8fll   1/1     Running   0          3m22s   10.1.225.5   vm1    <none>           <none>

Заходим в первый под web-consumer-5f87765478-ppqh6 с адресом 10.1.225.3, и пробуем оттуда сначала пинговать auth-db по адресу 10.1.225.4. Как видим приложение доступно:

root@vm1:~# kubectl exec -it pod/web-consumer-5f87765478-ppqh6 -n web -c busybox -- bin/sh
bin/sh: shopt: not found

[ root@web-consumer-5f87765478-ppqh6:/ ]$ ping 10.1.225.4
PING 10.1.225.4 (10.1.225.4): 56 data bytes
64 bytes from 10.1.225.4: seq=0 ttl=63 time=0.134 ms
64 bytes from 10.1.225.4: seq=1 ttl=63 time=0.067 ms
^C
--- 10.1.225.4 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.067/0.089/0.134 ms

[ root@web-consumer-5f87765478-ppqh6:/ ]$ curl 10.1.225.4
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

Заходим во второй pod:

root@vm1:~# kubectl exec -it pod/web-consumer-5f87765478-t8fll -n web -c busybox -- bin/sh
bin/sh: shopt: not found

[ root@web-consumer-5f87765478-t8fll:/ ]$ ping 10.1.225.4
PING 10.1.225.4 (10.1.225.4): 56 data bytes
64 bytes from 10.1.225.4: seq=0 ttl=63 time=0.085 ms
64 bytes from 10.1.225.4: seq=1 ttl=63 time=0.073 ms
^C
--- 10.1.225.4 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.073/0.079/0.085 ms

[ root@web-consumer-5f87765478-t8fll:/ ]$ curl 10.1.225.4
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