# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 

```
root@vm1:/home/user# helm version
version.BuildInfo{Version:"v3.13.1", GitCommit:"3547a4b5bf5edb5478ce352e18858d8a552a4110", GitTreeState:"clean", GoVersion:"go1.20.8"}

Файлы из гита для деплоя.

root@vm1:/home/user# git clone https://github.com/aak74/kubernetes-for-beginners.git

root@vm1:/home/user# cd kubernetes-for-beginners/40-helm/01-templating/charts/

Создам шаблон

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# helm template 01-simple
---
# Source: hard/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: demo
  labels:
    app: demo
spec:
  ports:
    - port: 80
      name: http
  selector:
    app: demo
---
# Source: hard/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  labels:
    app: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
        - name: hard
          image: "nginx:1.16.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          resources:
            limits:
              cpu: 200m
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 128Mi

Поменял номер версии приложения.

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# cat 01-simple/Chart.yaml
apiVersion: v2
name: hard
description: A minimal chart for demo

type: application

version: 0.1.2
appVersion: "1.18.0"
```
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

```
root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# helm template 01-simple

Проверяем.
---
# Source: hard/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: demo
  labels:
    app: demo
spec:
  ports:
    - port: 80
      name: http
  selector:
    app: demo
---
# Source: hard/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  labels:
    app: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
        - name: hard
          image: "nginx:1.18.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          resources:
            limits:
              cpu: 200m
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 128Mi

Копируем конфиг.

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# microk8s kubectl config view --raw > ~/.kube/config  

Установка. 

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# helm install demo1 01-simple
NAME: demo1
LAST DEPLOYED: Fri Oct 27 10:19:08 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
Deployed version 1.18.0.

---------------------------------------------------------

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
demo1   default         1               2023-10-27 10:19:08.343233928 +0000 UTC deployed        hard-0.1.2      1.18.0 

Запустим несколько версий приложения.

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# helm upgrade demo1 --set replicaCount=3 01-simple
Release "demo1" has been upgraded. Happy Helming!
NAME: demo1
LAST DEPLOYED: Fri Oct 27 10:21:59 2023
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
Deployed version 1.18.0.

---------------------------------------------------------

bash: root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts#: kubectl get pod

NAME                    READY   STATUS    RESTARTS   AGE
demo-7697566486-jmk6c   1/1     Running   0          3m44s
demo-7697566486-6bx9w   1/1     Running   0          53s
demo-7697566486-tb6qw   1/1     Running   0          53s

Удалим helm demo1, затем создадим новый в namespace.

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# helm uninstall demo1
release "demo1" uninstalled

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# helm install demo2 --namespace app1 --create-namespace --wait --set replicaCount=2 01-simple
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /root/.kube/config
NAME: demo2
LAST DEPLOYED: Fri Oct 27 10:39:14 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
Deployed version 1.18.0.

---------------------------------------------------------

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# helm install demo2 --namespace app2 --create-namespace --wait --set replicaCount=1 01-simple
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /root/.kube/config
NAME: demo2
LAST DEPLOYED: Fri Oct 27 10:40:03 2023
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
Deployed version 1.18.0.

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# kubectl get pod -n app1
NAME                    READY   STATUS    RESTARTS   AGE
demo-7697566486-cknhv   1/1     Running   0          95s
demo-7697566486-6krz6   1/1     Running   0          95s

root@vm1:/home/user/kubernetes-for-beginners/40-helm/01-templating/charts# kubectl get pod -n app2
NAME                    READY   STATUS    RESTARTS   AGE
demo-7697566486-ql4zt   1/1     Running   0          52s

---------------------------------------------------------


```
### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

