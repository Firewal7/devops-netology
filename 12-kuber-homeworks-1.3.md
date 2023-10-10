# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.

```
user@vm1:~$ cat deployment.yaml
apiVersion : apps/v1
kind: Deployment
metadata:
  name: netology1
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
        - name: multitool
          image: wbitt/network-multitool
          ports:
            - containerPort: 8080
          env:
            - name: HTTP_PORT
              value: "8080"
```
```
user@vm1:~$ kubectl apply -f deployment.yaml
deployment.apps/netology1 created

user@vm1:~$ microk8s kubectl get deployments
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
netology1   1/1     1            1           11m
```

2. После запуска увеличить количество реплик работающего приложения до 2.

```
Изменил на 2 реплики.
root@vm1:/home/user# microk8s kubectl apply -f deployment.yaml
deployment.apps/netology1 configured
```

3. Продемонстрировать количество подов до и после масштабирования.

До
```
root@vm1:/home/user# microk8s kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
netology1-7d974d59c4-hwg6w   2/2     Running   0          5m
```

После
```
root@vm1:/home/user# microk8s kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
netology1-7d974d59c4-hwg6w   2/2     Running   0          13m
netology1-7d974d59c4-2blx5   2/2     Running   0          63s
```
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

```
root@vm1:/home/user# cat service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  ports:
    - name: web
      port: 80
      targetPort: 80
  selector:
    app: nginx
```
```
root@vm1:/home/user# microk8s kubectl apply -f service.yaml
service/nginx-svc created
```
```
root@vm1:/home/user# microk8s kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP   32m
nginx-svc    ClusterIP   10.152.183.186   <none>        80/TCP    3m34s
```

5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

```
root@vm1:/home/user# microk8s kubectl run multitool --image=wbitt/network-multitool
pod/multitool created

root@vm1:/home/user# microk8s kubectl exec multitool -- curl 10.152.183.186
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   615  100   615    0     0   831k      0 --:--:-- --:--:-- --:--:--  600k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
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

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.

```
cat deployment2.yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app.kubernetes.io/name: MyApp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
spec:
  containers:
  - name: myapp-container
    image: nginx:1.14.2
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup nginx-svc2; do echo waiting for nginx-svc2; sleep 2; done;']
```
```
root@vm1:/home/user# microk8s kubectl apply -f deployment2.yaml
pod/myapp-pod created
```
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.

```
root@vm1:/home/user# microk8s kubectl logs myapp-pod
Defaulted container "myapp-container" out of: myapp-container, init-myservice (init)
Error from server (BadRequest): container "myapp-container" in pod "myapp-pod" is waiting to start: PodInitializing

```

3. Создать и запустить Service. Убедиться, что Init запустился.

```
root@vm1:/home/user# cat service2.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc2
spec:
  ports:
    - name: web
      port: 80
      targetPort: 80
  selector:
    app: myapp
```

```
root@vm1:/home/user# microk8s kubectl apply -f service2.yaml
service/nginx-svc2 created

```
4. Продемонстрировать состояние пода до и после запуска сервиса.

```
До
microk8s kubectl get pods
NAME                          READY   STATUS     RESTARTS   AGE
myapp-pod                     0/1     Init:0/1   0          55s

После
microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
myapp-pod                     1/1     Running   0          3m16s
```
------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------