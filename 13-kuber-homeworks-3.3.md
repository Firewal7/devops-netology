# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

## Решение

### Создаем namespace

```
microk8s kubectl create namespace app
namespace/app created
```

### Создаем deployment и сервисы к ним.

Конфиг: [frontend.yaml](frontend.yaml)

Конфиг: [backend.yaml](backend.yaml)

Конфиг: [cache.yaml](cache.yaml)

Конфиг: [svc-frontend.yaml](svc-frontend.yaml)

Конфиг: [svc-backend.yaml](svc-backend.yaml)

Конфиг: [svc-cache.yaml](svc-cache.yaml)
```
root@vm:/home/user# microk8s kubectl apply -f frontend.yaml
deployment.apps/frontend created

root@vm:/home/user# microk8s kubectl apply -f backend.yaml
deployment.apps/backend created

root@vm:/home/user# microk8s kubectl apply -f svc-frontend.yaml
service/frontend created

root@vm:/home/user# microk8s kubectl apply -f svc-backend.yaml
service/backend created

root@vm:/home/user# microk8s kubectl apply -f cache.yaml
deployment.apps/cache created

root@vm:/home/user# microk8s kubectl apply -f svc-cache.yaml
service/cache created

root@vm:/home/user# microk8s kubectl get -n app deployments
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
cache      1/1     1            1           2m37s
frontend   1/1     1            1           3m38s
backend    1/1     1            1           3m8s

root@vm:/home/user# microk8s kubectl config set-context --current --namespace=app
Context "microk8s" modified.

root@vm:/home/user# microk8s kubectl get pod -o wide
NAME                        READY   STATUS    RESTARTS   AGE     IP            NODE   NOMINATED NODE   READINESS GATES
frontend-7c96b4cbfb-7lmt7   1/1     Running   0          4m39s   10.1.141.67   vm     <none>           <none>
backend-6478c64696-94lx7    1/1     Running   0          4m28s   10.1.141.68   vm     <none>           <none>
cache-575bd6d866-87w9z      1/1     Running   0          2m6s    10.1.141.69   vm     <none>           <none>
```

Создаем сетевые политики.

Конфиг: [np-zapret.yaml](np-zapret.yaml)

Конфиг: [np-frontend.yaml](np-frontend.yaml)

Конфиг: [np-backend.yaml](np-backend.yaml)

Конфиг: [np-cache.yaml](np-cache.yaml)

```

### Делаем полный запрет

root@vm:/home/user# microk8s kubectl apply -f np-zapret.yaml
networkpolicy.networking.k8s.io/default-deny-ingress created

### Проверка запрета

root@vm:/home/user# microk8s kubectl get pod -o wide
NAME                        READY   STATUS    RESTARTS   AGE     IP            NODE   NOMINATED NODE   READINESS GATES
frontend-7c96b4cbfb-7lmt7   1/1     Running   0          8m46s   10.1.141.67   vm     <none>           <none>
backend-6478c64696-94lx7    1/1     Running   0          8m35s   10.1.141.68   vm     <none>           <none>
cache-575bd6d866-87w9z      1/1     Running   0          6m13s   10.1.141.69   vm     <none>           <none>

root@vm:/home/user# microk8s kubectl exec frontend-7c96b4cbfb-7lmt7 -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:02:10 --:--:--     0
curl: (28) Failed to connect to cache port 80 after 130979 ms: Operation timed out
command terminated with exit code 28

### Разрешающие правила

root@vm:/home/user# microk8s kubectl apply -f np-frontend.yaml
networkpolicy.networking.k8s.io/frontend created
root@vm:/home/user# microk8s kubectl apply -f np-cache.yaml
networkpolicy.networking.k8s.io/cache created
root@vm:/home/user# microk8s kubectl apply -f np-backend.yaml
networkpolicy.networking.k8s.io/backend created

### Проверим

root@vm:/home/user# microk8s kubectl exec frontend-7c96b4cbfb-7lmt7 -- curl --max-time 10 backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    79  100    79    0     0  96695      0 --:--:-- --:--:-- --:--:-- 79000
Praqma Network MultiTool (with NGINX) - backend-6478c64696-94lx7 - 10.1.141.68


root@vm:/home/user# microk8s kubectl exec backend-6478c64696-94lx7 -- curl --max-time 10 cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    77  100    77    0     0  39834      0 --:--:-- --:--:-- --:--:-- 77000
Praqma Network MultiTool (with NGINX) - cache-575bd6d866-87w9z - 10.1.141.69


root@vm:/home/user# microk8s kubectl exec cache-575bd6d866-87w9z -- curl --max-time 10 backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timed out after 10000 milliseconds
command terminated with exit code 28


root@vm:/home/user# microk8s kubectl exec cache-575bd6d866-87w9z -- curl --max-time 10 backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:10 --:--:--     0
curl: (28) Connection timed out after 10001 milliseconds
command terminated with exit code 28
```

