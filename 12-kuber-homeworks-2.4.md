# Домашнее задание к занятию «Управление доступом»

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Чеклист готовности к домашнему заданию

1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
```
root@vm1:/home/user# openssl genrsa -out sofin.key 2048
root@vm1:/home/user# openssl req -new -key sofin.key -out sofin.csr -subj "/CN=sofin/O=group1"
root@vm1:/home/user# openssl x509 -req -in sofin.csr -CA /var/snap/microk8s/6070/certs/ca.crt -CAkey /var/snap/microk8s/6070/certs/ca.key -CAcreateserial -out sofin.crt -days 500
Certificate request self-signature ok
subject=CN = sofin, O = group1
```
2. Настройте конфигурационный файл kubectl для подключения.

```
root@vm1:/home/user# kubectl config set-context sofin-context --cluster=microk8s-cluster --user=sofin
Context "sofin-context" created.

root@vm1:/home/user# kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.129.0.6:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
- context:
    cluster: microk8s-cluster
    user: sofin
  name: sofin-context
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: REDACTED
- name: sofin
  user:
    client-certificate: /home/user/cert/sofin.crt
    client-key: /home/user/cert/sofin.key
```
3. Создайте роли и все необходимые настройки для пользователя.

```
root@vm1:/home/user# kubectl apply -f role_binding.yaml
rolebinding.rbac.authorization.k8s.io/pod-reader created
root@vm1:/home/user# kubectl apply -f role.yaml
role.rbac.authorization.k8s.io/pod-desc-logs created
```
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).

```
Добавляем в роль verbs: где ["watch", "list"]

root@vm1:/home/user# kubectl get role pod-desc-logs -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"rbac.authorization.k8s.io/v1","kind":"Role","metadata":{"annotations":{},"name":"pod-desc-logs","namespace":"default"},"rules":[{"apiGroups":[""],"resources":["pods","pods/log"],"verbs":["watch","list","get"]}]}
  creationTimestamp: "2023-10-26T15:43:45Z"
  name: pod-desc-logs
  namespace: default
  resourceVersion: "2126"
  uid: 834c7ee6-790d-4059-b028-554274d91f82
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - pods/log
  verbs:
  - watch
  - list
  - get

```
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

[role_binding.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-2.4/role_binding.yaml)

[role.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-2.4/role.yaml)

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------

