# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

[deployment1.yaml]()

```
root@vm1:/home/user# microk8s kubectl apply -f deployment1.yaml
deployment.apps/deployment created

root@vm1:/home/user# microk8s kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   1/1     1            1           16s

root@vm1:/home/user# microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-7bd9c887c4-s75kx   2/2     Running   0          21s

root@vm1:/home/user# microk8s kubectl exec deployment-7bd9c887c4-s75kx -c multitool  -- tail -n 10 /my/output.txt
Sat Oct 21 08:34:31 UTC 2023
Every 5.0s: date                                            2023-10-21 08:34:36

Sat Oct 21 08:34:36 UTC 2023
Every 5.0s: date                                            2023-10-21 08:34:41

Sat Oct 21 08:34:41 UTC 2023
Every 5.0s: date                                            2023-10-21 08:34:47
```

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

[deployment2.yaml]()

```
root@vm1:/home/user# microk8s kubectl apply -f deployment2.yaml
daemonset.apps/daemonset created

root@vm1:/home/user# microk8s kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
deployment-7bd9c887c4-s75kx   2/2     Running   0          9m5s
daemonset-z2m4x               1/1     Running   0          2m2s

root@vm1:/home/user#  microk8s kubectl exec daemonset-z2m4x -it -- sh
/ # tail -n 10 /var/log/syslog
Oct 21 08:41:52 vm1 microk8s.daemon-kubelite[2761]: I1021 08:41:52.558423    2761 handler.go:232] Adding GroupVersion crd.projectcalico.org v1 to ResourceManager
Oct 21 08:41:52 vm1 microk8s.daemon-kubelite[2761]: I1021 08:41:52.558501    2761 handler.go:232] Adding GroupVersion crd.projectcalico.org v1 to ResourceManager
Oct 21 08:41:52 vm1 microk8s.daemon-kubelite[2761]: I1021 08:41:52.558654    2761 handler.go:232] Adding GroupVersion crd.projectcalico.org v1 to ResourceManager
Oct 21 08:43:07 vm1 systemd[1]: Started snap.microk8s.microk8s.6d638a81-6fef-468c-87ed-53c9701e641a.scope.
Oct 21 08:43:07 vm1 systemd[1]: snap.microk8s.microk8s.6d638a81-6fef-468c-87ed-53c9701e641a.scope: Deactivated successfully.
Oct 21 08:43:09 vm1 systemd[1]: Starting Cleanup of Temporary Directories...
Oct 21 08:43:09 vm1 systemd[1]: run-containerd-runc-k8s.io-7c80cbc858e1cecd4b5398b52aeda0a8a9b4c76637ef018a1c7897b08536605b-runc.qQLSlK.mount: Deactivated successfully.
Oct 21 08:43:09 vm1 systemd[1]: systemd-tmpfiles-clean.service: Deactivated successfully.
Oct 21 08:43:09 vm1 systemd[1]: Finished Cleanup of Temporary Directories.
Oct 21 08:43:33 vm1 systemd[1]: Started snap.microk8s.microk8s.d90ce080-911f-4693-be4b-f318a52f2a16.scope.
```
------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------