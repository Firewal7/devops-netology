# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.

[deployment1.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-2.2/deployment1.yaml)

```
root@vm1:/home/user# microk8s kubectl apply -f deployment1.yaml
deployment.apps/deployment created
```
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.

[pvc.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-2.2/pvc.yaml)
[pv.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-2.2/pv.yaml)

```
root@vm1:/home/user# microk8s kubectl apply -f pv.yaml
persistentvolume/pv created

root@vm1:/home/user# microk8s kubectl apply -f pvc.yaml
persistentvolumeclaim/pvc created

root@vm1:/home/user# microk8s kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   1/1     1            1           5m25s

root@vm1:/home/user# microk8s kubectl get pv
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
pv     1Gi        RWO            Delete           Bound    default/pvc                           93s

root@vm1:/home/user# microk8s kubectl get pvc
NAME   STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc    Bound    pv       1Gi        RWO                           69s
```
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории.

```
root@vm1:/home/user#  microk8s kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
deployment-c57b49d9d-lxb5p   2/2     Running   0          6m18s

root@vm1:/home/user# microk8s kubectl exec deployment-c57b49d9d-lxb5p -c multitool  -- tail -n 10 /my/output.txt
Sun Oct 22 10:45:25 UTC 2023
Every 5.0s: date                                            2023-10-22 10:45:30

Sun Oct 22 10:45:30 UTC 2023
Every 5.0s: date                                            2023-10-22 10:45:35

Sun Oct 22 10:45:35 UTC 2023
Every 5.0s: date                                            2023-10-22 10:45:40

Sun Oct 22 10:45:40 UTC 2023
```
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
```
root@vm1:/home/user# microk8s kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
deployment   1/1     1            1           7m24s

root@vm1:/home/user# microk8s kubectl delete deployments deployment
deployment.apps "deployment" deleted

root@vm1:/home/user# microk8s kubectl get pvc
NAME   STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc    Bound    pv       1Gi        RWO                           2m56s

root@vm1:/home/user# microk8s kubectl delete pvc pvc
persistentvolumeclaim "pvc" deleted

root@vm1:/home/user# kubectl get pv
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
pv     1Gi        RWO            Delete           Bound    default/pvc                           3m46s

Файл сохранился на локальном диске ноды.

```
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
```
root@vm1:/home/user# ls /my/pv/output.txt
/my/pv/output.txt

root@vm1:/home/user# microk8s kubectl delete pv pv
persistentvolume "pv" deleted

root@vm1:/home/user# ls /my/pv/output.txt
/my/pv/output.txt
```

При удалении PV не удаляются данные, связанные с PV. Они сохраняются на диске ноды. Удаление PV лишь освобождает ресурсы PV для будущего использования и разрывает связь между PV и PVC.

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.

[Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs)

2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.

[deployment2.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-2.2/deployment2.yaml)
[pvc-nfs.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-2.2/pvc-nfs.yaml)
[sc-nfs.yaml](https://github.com/Firewal7/devops-netology/blob/main/12-kuber-homeworks-2.2/sc-nfs.yaml)

```
root@vm1:/home/user# microk8s kubectl apply -f deployment2.yaml
deployment.apps/multitool created

root@vm1:/home/user# microk8s kubectl apply -f - < sc-nfs.yaml
storageclass.storage.k8s.io/nfs-csi created

root@vm1:/home/user# microk8s kubectl apply -f - < pvc-nfs.yaml
persistentvolumeclaim/my-pvc created

root@vm1:/home/user# microk8s kubectl describe pvc my-pvc
Name:          my-pvc
Namespace:     default
StorageClass:  nfs-csi
Status:        Bound
Volume:        pvc-251da93d-a314-45bd-8b7a-29d1e2d52154
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: nfs.csi.k8s.io
               volume.kubernetes.io/storage-provisioner: nfs.csi.k8s.io
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      1Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       multitool-75f7ccd67-g9f6s
Events:
  Type     Reason                 Age                From                                                     Message
  ----     ------                 ----               ----                                                     -------
  Warning  ProvisioningFailed     27s (x2 over 35s)  persistentvolume-controller                              storageclass.storage.k8s.io "nfs-csi" not found
  Normal   Provisioning           12s                nfs.csi.k8s.io_vm1_e5ceb823-5218-4b9a-bf08-bc8cf2c93a00  External provisioner is provisioning volume for claim "default/my-pvc"
  Normal   ExternalProvisioning   12s (x2 over 12s)  persistentvolume-controller                              waiting for a volume to be created, either by external provisioner "nfs.csi.k8s.io" or manually created by system administrator
  Normal   ProvisioningSucceeded  12s                nfs.csi.k8s.io_vm1_e5ceb823-5218-4b9a-bf08-bc8cf2c93a00  Successfully provisioned volume pvc-251da93d-a314-45bd-8b7a-29d1e2d52154

```
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
```
root@vm1:~/home/user# microk8s kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
multitool-75f7ccd67-g9f6s   2/2     Running   0          9m39s

root@vm1:/home/user# microk8s kubectl exec multitool-75f7ccd67-g9f6s -c multitool  -- tail -n 10 /my/output.txt
Sun Oct 22 11:34:53 UTC 2023
Every 5.0s: date                                            2023-10-22 11:34:58

Sun Oct 22 11:34:58 UTC 2023
Every 5.0s: date                                            2023-10-22 11:35:03

Sun Oct 22 11:35:03 UTC 2023
Every 5.0s: date                                            2023-10-22 11:35:08

Sun Oct 22 11:35:08 UTC 2023
```

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.