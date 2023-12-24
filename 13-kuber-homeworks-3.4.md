# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

```
Я решаю использовать стратегию пошагового обновления (Rolling update). 
Этот метод предполагает плавную замену подсистем с предыдущей версией приложения на подсистемы с новой версией, без остановки работы всего кластера. 
В случае возникновения проблем, есть возможность быстро вернуться к предыдущему состоянию.
```

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.

Конфиг: [deployment.yaml](deployment.yaml)

Конфиг: [svc.yaml](svc.yaml)

```
root@vm1:~# microk8s kubectl apply -f deployment.yaml
deployment.apps/deployment created
root@vm1:~# microk8s kubectl apply -f svc.yaml
service/svc created
root@vm1:~# microk8s kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
deployment-666dcf88d-979lp   2/2     Running   0          87s
deployment-666dcf88d-qkwjs   2/2     Running   0          87s
deployment-666dcf88d-qkwgf   2/2     Running   0          87s
deployment-666dcf88d-tg5xp   2/2     Running   0          87s
deployment-666dcf88d-lns5m   2/2     Running   0          87s
```

2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
```
Обновляем. Меняем в deployment.yaml параметр image: nginx:1.19 на 1.20.

Добавляем стартегию:
strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1

root@vm1:~# microk8s kubectl get pod -o wide
NAME                          READY   STATUS              RESTARTS   AGE     IP            NODE   NOMINATED NODE   READINESS GATES
deployment-666dcf88d-mflg6    2/2     Running             0          8s      10.1.225.18   vm1    <none>           <none>
deployment-666dcf88d-pc6gg    2/2     Running             0          8s      10.1.225.19   vm1    <none>           <none>
deployment-666dcf88d-7sffn    2/2     Running             0          4s      10.1.225.20   vm1    <none>           <none>
deployment-666dcf88d-b6jvt    2/2     Running             0          4s      10.1.225.21   vm1    <none>           <none>
deployment-666dcf88d-48n4r    0/2     ContainerCreating   0          1s      <none>        vm1    <none>           <none>
deployment-74b9bc5569-7mztv   2/2     Terminating         0          5m3s    10.1.225.13   vm1    <none>           <none>
deployment-74b9bc5569-t4z6s   2/2     Terminating         0          4m47s   10.1.225.17   vm1    <none>           <none>

Обновились.

root@vm1:~# microk8s kubectl get pod -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP            NODE   NOMINATED NODE   READINESS GATES
deployment-666dcf88d-mflg6   2/2     Running   0          13s   10.1.225.18   vm1    <none>           <none>
deployment-666dcf88d-pc6gg   2/2     Running   0          13s   10.1.225.19   vm1    <none>           <none>
deployment-666dcf88d-7sffn   2/2     Running   0          9s    10.1.225.20   vm1    <none>           <none>
deployment-666dcf88d-b6jvt   2/2     Running   0          9s    10.1.225.21   vm1    <none>           <none>
deployment-666dcf88d-48n4r   2/2     Running   0          6s    10.1.225.22   vm1    <none>           <none>

root@vm1:~# kubectl describe deployment deployment
Name:                   deployment
Namespace:              default
CreationTimestamp:      Sun, 24 Dec 2023 10:19:37 +0000
Labels:                 app=main
Annotations:            deployment.kubernetes.io/revision: 4
Selector:               app=main
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:  app=main
  Containers:
   nginx:
    Image:        nginx:1.19
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
   network-multitool:
    Image:       wbitt/network-multitool
    Ports:       8080/TCP, 11443/TCP
    Host Ports:  0/TCP, 0/TCP
    Limits:
      cpu:     10m
      memory:  20Mi
    Requests:
      cpu:     1m
      memory:  20Mi
    Environment:
      HTTP_PORT:   8080
      HTTPS_PORT:  11443
    Mounts:        <none>
  Volumes:         <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  deployment-566fcf8d84 (0/0 replicas created), deployment-74b9bc5569 (0/0 replicas created)
NewReplicaSet:   deployment-666dcf88d (5/5 replicas created)
Events:
  Type    Reason             Age                 From                   Message
  ----    ------             ----                ----                   -------
  Normal  ScalingReplicaSet  52s (x19 over 12m)  deployment-controller  (combined from similar events): Scaled up replica set deployment-666dcf88d to 4 from 3

```
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
```
Меняем в deployment.yaml параметр image: nginx:1.20 на 1.28.

root@vm1:~# microk8s kubectl apply -f deployment.yaml
deployment.apps/deployment configured
root@vm1:~# microk8s kubectl get pod
NAME                          READY   STATUS             RESTARTS   AGE
deployment-666dcf88d-mflg6    2/2     Running            0          2m18s
deployment-666dcf88d-pc6gg    2/2     Running            0          2m18s
deployment-666dcf88d-7sffn    2/2     Running            0          2m14s
deployment-666dcf88d-b6jvt    2/2     Running            0          2m14s
deployment-768978d8d4-b6v5c   1/2     ImagePullBackOff   0          6s
deployment-768978d8d4-zl9q4   1/2     ImagePullBackOff   0          6s
```
4. Откатиться после неудачного обновления.

```
root@vm1:/home/user# microk8s kubectl rollout undo deployment deployment
deployment.apps/deployment rolled back
root@vm1:/home/user#  microk8s kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
deployment-666dcf88d-mflg6   2/2     Running   0          21m
deployment-666dcf88d-pc6gg   2/2     Running   0          21m
deployment-666dcf88d-7sffn   2/2     Running   0          21m
deployment-666dcf88d-b6jvt   2/2     Running   0          21m
deployment-666dcf88d-qv9pd   2/2     Running   0          6s
```