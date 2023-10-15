# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.

[frontend.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-1.5/frontend.yaml)

```
root@vm1:/home/user# microk8s kubectl apply -f frontend.yaml
deployment.apps/frontend created

root@vm1:/home/user# microk8s kubectl get deployment
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
frontend   3/3     3            3           13s
```

2. Создать Deployment приложения _backend_ из образа multitool. 

[backend.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-1.5/backend.yaml)

```
root@vm1:/home/user# microk8s kubectl apply -f backend.yaml
deployment.apps/backend created

root@vm1:/home/user# microk8s kubectl get deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
frontend   3/3     3            3           2m6s
backend    1/1     1            1           8s
```

3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 

[service-backend.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-1.5/service-backend.yaml)

[service-frontend.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-1.5/service-frontend.yaml)

```
root@vm1:/home/user# microk8s kubectl apply -f service-frontend.yaml
service/svc-front created

root@vm1:/home/user# microk8s kubectl apply -f service-backend.yaml
service/svc-back created

root@vm1:/home/user# microk8s kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP   25m
svc-front    ClusterIP   10.152.183.100   <none>        80/TCP    14s
svc-back     ClusterIP   10.152.183.244   <none>        80/TCP    10s
```

4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

```
root@vm1:/home/user#  microk8s kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP   25m
svc-front    ClusterIP   10.152.183.100   <none>        80/TCP    42s
svc-back     ClusterIP   10.152.183.244   <none>        80/TCP    38s

root@vm1:/home/user# microk8s kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
frontend-5d865b9b74-z4g2j   1/1     Running   0          4m57s
frontend-5d865b9b74-l6gcj   1/1     Running   0          4m57s
frontend-5d865b9b74-v97w5   1/1     Running   0          4m57s
backend-866d8d9754-fk56k    1/1     Running   0          2m59s

root@vm1:/home/user# microk8s kubectl exec frontend-5d865b9b74-z4g2j -- curl svc-front
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
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   298k      0 --:--:-- --:--:-- --:--:--  597k

root@vm1:/home/user# microk8s kubectl exec backend-866d8d9754-fk56k -- curl svc-back
WBITT Network MultiTool (with NGINX) - backend-866d8d9754-fk56k - 10.1.225.6 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   139  100   139    0     0  90731      0 --:--:-- --:--:-- --:--:--  135k
```

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.

```
root@vm1:/home/user# microk8s enable ingress
Infer repository core for addon ingress
Enabling Ingress
ingressclass.networking.k8s.io/public created
ingressclass.networking.k8s.io/nginx created
namespace/ingress created
serviceaccount/nginx-ingress-microk8s-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-microk8s-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-microk8s-role created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
configmap/nginx-load-balancer-microk8s-conf created
configmap/nginx-ingress-tcp-microk8s-conf created
configmap/nginx-ingress-udp-microk8s-conf created
daemonset.apps/nginx-ingress-microk8s-controller created
Ingress is enabled
```
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.

[ingress.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-1.5/ingress.yaml)

```
root@vm1:/home/user# microk8s kubectl apply -f ingress.yaml
ingress.networking.k8s.io/ingress created

root@vm1:/home/user# microk8s kubectl describe ingress
Name:             ingress
Labels:           <none>
Namespace:        default
Address:
Ingress Class:    public
Default backend:  <default>
Rules:
  Host        Path  Backends
  ----        ----  --------
  *
              /      svc-front:80 (10.1.225.3:80,10.1.225.4:80,10.1.225.5:80)
              /api   svc-back:80 (10.1.225.6:80)
Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age   From                      Message
  ----    ------  ----  ----                      -------
  Normal  Sync    11s   nginx-ingress-controller  Scheduled for sync

```
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

4. Предоставить манифесты и скриншоты или вывод команды п.2.

![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/12-kuber-homeworks-1.5-1.jpg)

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------