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
root@vm2:~# nano hello-world.yaml
root@vm2:~# kubectl apply -f hello-world.yaml
pod/hello-world created
```

```
root@vm2:~# microk8s kubectl get pods
NAME          READY   STATUS    RESTARTS   AGE
hello-world   1/1     Running   0          52s
```

<details>
<summary>curl --insecure localhost:8001</summary>
root@vm2:~# curl --insecure localhost:8001
{
  "paths": [
    "/.well-known/openid-configuration",
    "/api",
    "/api/v1",
    "/apis",
    "/apis/",
    "/apis/admissionregistration.k8s.io",
    "/apis/admissionregistration.k8s.io/v1",
    "/apis/apiextensions.k8s.io",
    "/apis/apiextensions.k8s.io/v1",
    "/apis/apiregistration.k8s.io",
    "/apis/apiregistration.k8s.io/v1",
    "/apis/apps",
    "/apis/apps/v1",
    "/apis/authentication.k8s.io",
    "/apis/authentication.k8s.io/v1",
    "/apis/authorization.k8s.io",
    "/apis/authorization.k8s.io/v1",
    "/apis/autoscaling",
    "/apis/autoscaling/v1",
    "/apis/autoscaling/v2",
    "/apis/batch",
    "/apis/batch/v1",
    "/apis/certificates.k8s.io",
    "/apis/certificates.k8s.io/v1",
    "/apis/coordination.k8s.io",
    "/apis/coordination.k8s.io/v1",
    "/apis/crd.projectcalico.org",
    "/apis/crd.projectcalico.org/v1",
    "/apis/discovery.k8s.io",
    "/apis/discovery.k8s.io/v1",
    "/apis/events.k8s.io",
    "/apis/events.k8s.io/v1",
    "/apis/flowcontrol.apiserver.k8s.io",
    "/apis/flowcontrol.apiserver.k8s.io/v1beta2",
    "/apis/flowcontrol.apiserver.k8s.io/v1beta3",
    "/apis/metrics.k8s.io",
    "/apis/metrics.k8s.io/v1beta1",
    "/apis/networking.k8s.io",
    "/apis/networking.k8s.io/v1",
    "/apis/node.k8s.io",
    "/apis/node.k8s.io/v1",
    "/apis/policy",
    "/apis/policy/v1",
    "/apis/rbac.authorization.k8s.io",
    "/apis/rbac.authorization.k8s.io/v1",
    "/apis/scheduling.k8s.io",
    "/apis/scheduling.k8s.io/v1",
    "/apis/storage.k8s.io",
    "/apis/storage.k8s.io/v1",
    "/healthz",
    "/healthz/autoregister-completion",
    "/healthz/etcd",
    "/healthz/log",
    "/healthz/ping",
    "/healthz/poststarthook/aggregator-reload-proxy-client-cert",
    "/healthz/poststarthook/apiservice-discovery-controller",
    "/healthz/poststarthook/apiservice-openapi-controller",
    "/healthz/poststarthook/apiservice-openapiv3-controller",
    "/healthz/poststarthook/apiservice-registration-controller",
    "/healthz/poststarthook/apiservice-status-available-controller",
    "/healthz/poststarthook/bootstrap-controller",
    "/healthz/poststarthook/crd-informer-synced",
    "/healthz/poststarthook/generic-apiserver-start-informers",
    "/healthz/poststarthook/kube-apiserver-autoregistration",
    "/healthz/poststarthook/priority-and-fairness-config-consumer",
    "/healthz/poststarthook/priority-and-fairness-config-producer",
    "/healthz/poststarthook/priority-and-fairness-filter",
    "/healthz/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/healthz/poststarthook/start-apiextensions-controllers",
    "/healthz/poststarthook/start-apiextensions-informers",
    "/healthz/poststarthook/start-cluster-authentication-info-controller",
    "/healthz/poststarthook/start-deprecated-kube-apiserver-identity-lease-garbage-collector",
    "/healthz/poststarthook/start-kube-aggregator-informers",
    "/healthz/poststarthook/start-kube-apiserver-admission-initializer",
    "/healthz/poststarthook/start-kube-apiserver-identity-lease-controller",
    "/healthz/poststarthook/start-kube-apiserver-identity-lease-garbage-collector",
    "/healthz/poststarthook/start-legacy-token-tracking-controller",
    "/healthz/poststarthook/start-system-namespaces-controller",
    "/healthz/poststarthook/storage-object-count-tracker-hook",
    "/livez",
    "/livez/autoregister-completion",
    "/livez/etcd",
    "/livez/log",
    "/livez/ping",
    "/livez/poststarthook/aggregator-reload-proxy-client-cert",
    "/livez/poststarthook/apiservice-discovery-controller",
    "/livez/poststarthook/apiservice-openapi-controller",
    "/livez/poststarthook/apiservice-openapiv3-controller",
    "/livez/poststarthook/apiservice-registration-controller",
    "/livez/poststarthook/apiservice-status-available-controller",
    "/livez/poststarthook/bootstrap-controller",
    "/livez/poststarthook/crd-informer-synced",
    "/livez/poststarthook/generic-apiserver-start-informers",
    "/livez/poststarthook/kube-apiserver-autoregistration",
    "/livez/poststarthook/priority-and-fairness-config-consumer",
    "/livez/poststarthook/priority-and-fairness-config-producer",
    "/livez/poststarthook/priority-and-fairness-filter",
    "/livez/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/livez/poststarthook/start-apiextensions-controllers",
    "/livez/poststarthook/start-apiextensions-informers",
    "/livez/poststarthook/start-cluster-authentication-info-controller",
    "/livez/poststarthook/start-deprecated-kube-apiserver-identity-lease-garbage-collector",
    "/livez/poststarthook/start-kube-aggregator-informers",
    "/livez/poststarthook/start-kube-apiserver-admission-initializer",
    "/livez/poststarthook/start-kube-apiserver-identity-lease-controller",
    "/livez/poststarthook/start-kube-apiserver-identity-lease-garbage-collector",
    "/livez/poststarthook/start-legacy-token-tracking-controller",
    "/livez/poststarthook/start-system-namespaces-controller",
    "/livez/poststarthook/storage-object-count-tracker-hook",
    "/logs",
    "/metrics",
    "/metrics/slis",
    "/openapi/v2",
    "/openapi/v3",
    "/openapi/v3/",
    "/openid/v1/jwks",
    "/readyz",
    "/readyz/autoregister-completion",
    "/readyz/etcd",
    "/readyz/etcd-readiness",
    "/readyz/informer-sync",
    "/readyz/log",
    "/readyz/ping",
    "/readyz/poststarthook/aggregator-reload-proxy-client-cert",
    "/readyz/poststarthook/apiservice-discovery-controller",
    "/readyz/poststarthook/apiservice-openapi-controller",
    "/readyz/poststarthook/apiservice-openapiv3-controller",
    "/readyz/poststarthook/apiservice-registration-controller",
    "/readyz/poststarthook/apiservice-status-available-controller",
    "/readyz/poststarthook/bootstrap-controller",
    "/readyz/poststarthook/crd-informer-synced",
    "/readyz/poststarthook/generic-apiserver-start-informers",
    "/readyz/poststarthook/kube-apiserver-autoregistration",
    "/readyz/poststarthook/priority-and-fairness-config-consumer",
    "/readyz/poststarthook/priority-and-fairness-config-producer",
    "/readyz/poststarthook/priority-and-fairness-filter",
    "/readyz/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/readyz/poststarthook/start-apiextensions-controllers",
    "/readyz/poststarthook/start-apiextensions-informers",
    "/readyz/poststarthook/start-cluster-authentication-info-controller",
    "/readyz/poststarthook/start-deprecated-kube-apiserver-identity-lease-garbage-collector",
    "/readyz/poststarthook/start-kube-aggregator-informers",
    "/readyz/poststarthook/start-kube-apiserver-admission-initializer",
    "/readyz/poststarthook/start-kube-apiserver-identity-lease-controller",
    "/readyz/poststarthook/start-kube-apiserver-identity-lease-garbage-collector",
    "/readyz/poststarthook/start-legacy-token-tracking-controller",
    "/readyz/poststarthook/start-system-namespaces-controller",
    "/readyz/poststarthook/storage-object-count-tracker-hook",
    "/readyz/shutdown",
    "/version"
  ]
}
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