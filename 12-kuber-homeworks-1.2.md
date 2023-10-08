# Домашнее задание к занятию «Базовые объекты K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

```
root@vm2:~# cat hello-world.yaml 
apiVersion : v1
kind: Pod
metadata:
  name: pod
spec:
  containers:
    - name : pod
      image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
      ports:
        - containerPort: 8080
root@vm2:~# kubectl apply -f hello-world.yaml
pod/pod created
```

```
root@vm2:~# microk8s kubectl get pods
NAME          READY   STATUS    RESTARTS   AGE
hello-world   1/1     Running   0          52s
```

```
root@vm2:~# kubectl port-forward pod/pod 8888:8080
Forwarding from 127.0.0.1:8888 -> 8080
Forwarding from [::1]:8888 -> 8080
Handling connection for 8888
```

<details>
<summary>curl --insecure localhost:8001</summary>
root@vm2:/home/user# curl --insecure localhost:8888


Hostname: pod

Pod Information:
        -no pod information available-

Server values:
        server_version=nginx: 1.12.2 - lua: 10010

Request Information:
        client_address=127.0.0.1
        method=GET
        real path=/
        query=
        request_version=1.1
        request_scheme=http
        request_uri=http://localhost:8080/

Request Headers:
        accept=*/*  
        host=localhost:8888  
        user-agent=curl/7.81.0  

Request Body:
        -no body in request-
</details>

------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

```
root@vm2:~# cat netology-web.yaml 
apiVersion : v1
kind: Pod
metadata:
  name: netology-web
  labels:
    app: netology
spec:
  containers:
    - name : netology-web
      image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
      ports:
        - containerPort: 8080
```
```
root@vm2:~# cat netology-svc.yaml 
apiVersion: v1
kind: Service
metadata:
  name: netology-svc
spec:
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: netology
```
```
root@vm2:~# kubectl apply -f netology-web.yaml
pod/netology-web created
root@vm2:~# kubectl apply -f netology-svc.yaml
service/netology-svc created
root@vm2:~# microk8s kubectl get pods
NAME           READY   STATUS    RESTARTS   AGE
hello-world    1/1     Running   0          29m
netology-web   1/1     Running   0          2m49s

root@vm2:~# kubectl get pods -o wide
NAME           READY   STATUS    RESTARTS   AGE   IP             NODE   NOMINATED NODE   READINESS GATES
hello-world    1/1     Running   0          28m   10.1.185.198   vm2    <none>           <none>
netology-web   1/1     Running   0          91s   10.1.185.201   vm2    <none>           <none>

root@vm2:~# kubectl get service -o wide
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE    SELECTOR
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP   6h7m   <none>
netology-svc   ClusterIP   10.152.183.143   <none>        80/TCP    93s    app=netology
```

```
root@vm2:~kubectl port-forward service/netology-svc 8889:80
Forwarding from 127.0.0.1:8889 -> 8080
Forwarding from [::1]:8889 -> 8080
Handling connection for 8889
```
<details>
<summary>curl --insecure localhost:8001</summary>
root@vm2:/home/user# curl --insecure localhost:8889


Hostname: netology-web

Pod Information:
        -no pod information available-

Server values:
        server_version=nginx: 1.12.2 - lua: 10010

Request Information:
        client_address=127.0.0.1
        method=GET
        real path=/
        query=
        request_version=1.1
        request_scheme=http
        request_uri=http://localhost:8080/

Request Headers:
        accept=*/*  
        host=localhost:8889  
        user-agent=curl/7.81.0  

Request Body:
        -no body in request-
</details>
------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get pods`, а также скриншот результата подключения.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------

### Критерии оценки
Зачёт — выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку — задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.