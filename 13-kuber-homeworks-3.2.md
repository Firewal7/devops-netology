# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/)

```
root@master:/home/user# git clone https://github.com/kubernetes-sigs/kubespray
Cloning into 'kubespray'...
remote: Enumerating objects: 71883, done.
remote: Counting objects: 100% (374/374), done.
remote: Compressing objects: 100% (227/227), done.
remote: Total 71883 (delta 131), reused 320 (delta 122), pack-reused 71509
Receiving objects: 100% (71883/71883), 22.68 MiB | 17.25 MiB/s, done.
Resolving deltas: 100% (40296/40296), done.

root@master:/home/user# curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10
Collecting pip
  Downloading pip-23.3.1-py3-none-any.whl.metadata (3.5 kB)
Collecting wheel
  Downloading wheel-0.42.0-py3-none-any.whl.metadata (2.2 kB)
Downloading pip-23.3.1-py3-none-any.whl (2.1 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.1/2.1 MB 7.3 MB/s eta 0:00:00
Downloading wheel-0.42.0-py3-none-any.whl (65 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 65.4/65.4 kB 4.4 MB/s eta 0:00:00
Installing collected packages: wheel, pip
Successfully installed pip-23.3.1 wheel-0.42.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

root@master:/home/user# python3.10 -m pip --version
pip 23.3.1 from /usr/local/lib/python3.10/dist-packages/pip (python 3.10)

root@master:/home/user/kubespray# pip install -r requirements.txt
Collecting ansible==8.5.0 (from -r requirements.txt (line 1))
  Downloading ansible-8.5.0-py3-none-any.whl.metadata (7.9 kB)
Collecting cryptography==41.0.4 (from -r requirements.txt (line 2))
  Downloading cryptography-41.0.4-cp37-abi3-manylinux_2_28_x86_64.whl.metadata (5.2 kB)
Collecting jinja2==3.1.2 (from -r requirements.txt (line 3))
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 1.7 MB/s eta 0:00:00
Collecting jmespath==1.0.1 (from -r requirements.txt (line 4))
  Downloading jmespath-1.0.1-py3-none-any.whl (20 kB)
Collecting MarkupSafe==2.1.3 (from -r requirements.txt (line 5))
  Downloading MarkupSafe-2.1.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (3.0 kB)
Collecting netaddr==0.9.0 (from -r requirements.txt (line 6))
  Downloading netaddr-0.9.0-py3-none-any.whl.metadata (5.1 kB)
Collecting pbr==5.11.1 (from -r requirements.txt (line 7))
  Downloading pbr-5.11.1-py2.py3-none-any.whl (112 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 112.7/112.7 kB 2.6 MB/s eta 0:00:00
Collecting ruamel.yaml==0.17.35 (from -r requirements.txt (line 8))
  Downloading ruamel.yaml-0.17.35-py3-none-any.whl.metadata (18 kB)
Collecting ruamel.yaml.clib==0.2.8 (from -r requirements.txt (line 9))
  Downloading ruamel.yaml.clib-0.2.8-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl.metadata (2.2 kB)
Collecting ansible-core~=2.15.5 (from ansible==8.5.0->-r requirements.txt (line 1))
  Downloading ansible_core-2.15.7-py3-none-any.whl.metadata (7.0 kB)
Collecting cffi>=1.12 (from cryptography==41.0.4->-r requirements.txt (line 2))
  Downloading cffi-1.16.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (1.5 kB)
Requirement already satisfied: PyYAML>=5.1 in /usr/lib/python3/dist-packages (from ansible-core~=2.15.5->ansible==8.5.0->-r requirements.txt (line 1)) (5.4.1)
Collecting packaging (from ansible-core~=2.15.5->ansible==8.5.0->-r requirements.txt (line 1))
  Downloading packaging-23.2-py3-none-any.whl.metadata (3.2 kB)
Collecting resolvelib<1.1.0,>=0.5.3 (from ansible-core~=2.15.5->ansible==8.5.0->-r requirements.txt (line 1))
  Downloading resolvelib-1.0.1-py2.py3-none-any.whl (17 kB)
Collecting pycparser (from cffi>=1.12->cryptography==41.0.4->-r requirements.txt (line 2))
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 118.7/118.7 kB 2.9 MB/s eta 0:00:00
Downloading ansible-8.5.0-py3-none-any.whl (47.5 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 47.5/47.5 MB 16.6 MB/s eta 0:00:00
Downloading cryptography-41.0.4-cp37-abi3-manylinux_2_28_x86_64.whl (4.4 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.4/4.4 MB 12.7 MB/s eta 0:00:00
Downloading MarkupSafe-2.1.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Downloading netaddr-0.9.0-py3-none-any.whl (2.2 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.2/2.2 MB 8.9 MB/s eta 0:00:00
Downloading ruamel.yaml-0.17.35-py3-none-any.whl (112 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 112.9/112.9 kB 4.3 MB/s eta 0:00:00
Downloading ruamel.yaml.clib-0.2.8-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (526 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 526.7/526.7 kB 28.9 MB/s eta 0:00:00
Downloading ansible_core-2.15.7-py3-none-any.whl (2.2 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.2/2.2 MB 13.1 MB/s eta 0:00:00
Downloading cffi-1.16.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (443 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 443.9/443.9 kB 46.7 MB/s eta 0:00:00
Downloading packaging-23.2-py3-none-any.whl (53 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 53.0/53.0 kB 5.4 MB/s eta 0:00:00
Installing collected packages: resolvelib, netaddr, ruamel.yaml.clib, pycparser, pbr, packaging, MarkupSafe, jmespath, ruamel.yaml, jinja2, cffi, cryptography, ansible-core, ansible
  Attempting uninstall: MarkupSafe
    Found existing installation: MarkupSafe 2.0.1
    Uninstalling MarkupSafe-2.0.1:
      Successfully uninstalled MarkupSafe-2.0.1
  Attempting uninstall: jinja2
    Found existing installation: Jinja2 3.0.3
    Uninstalling Jinja2-3.0.3:
      Successfully uninstalled Jinja2-3.0.3
  Attempting uninstall: cryptography
    Found existing installation: cryptography 3.4.8
    Uninstalling cryptography-3.4.8:
      Successfully uninstalled cryptography-3.4.8
Successfully installed MarkupSafe-2.1.3 ansible-8.5.0 ansible-core-2.15.7 cffi-1.16.0 cryptography-41.0.4 jinja2-3.1.2 jmespath-1.0.1 netaddr-0.9.0 packaging-23.2 pbr-5.11.1 pycparser-2.21 resolvelib-1.0.1 ruamel.yaml-0.17.35 ruamel.yaml.clib-0.2.8
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
```

### Подготовка файлa host.yaml

```
all:
  hosts:
    master:
      ansible_host: 10.129.0.13
      ip: 10.129.0.13
      access_ip: 10.129.0.13
      ansible_user: user
    worker1:
      ansible_host: 10.129.0.6
      ip: 10.129.0.6
      access_ip: 10.129.0.6
      ansible_user: user
    worker2:
      ansible_host: 10.129.0.11
      ip: 10.129.0.11
      access_ip: 10.129.0.11
      ansible_user: user
    worker3:
      ansible_host: 10.129.0.33
      ip: 10.129.0.33
      access_ip: 10.129.0.33
      ansible_user: user
    worker4:
      ansible_host: 10.129.0.7
      ip: 10.129.0.7
      access_ip: 10.129.0.7
      ansible_user: user
  children:
    kube_control_plane:
      hosts:
        master:
    kube_node:
      hosts:
        worker1:
        worker2:
        worker3:
        worker4: 
    etcd:
      hosts:
        master:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```

### Добавим PRIVATE KEY на master чтобы ansible имел возможность подключаться к worker

```
root@master:~/.ssh# cat id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3Bl1nNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAterhABAAABlwAAAAdzc2gtcn
NhAAAAAwEAAQAAAYEAxk5g6ZFiCywPnNTI1V09SseueovH+mYclY3gKvZWOJqyo8KHl26/
NwNMHDVDtMA4QUh5VvrXEE9LmMDbR/YaHRJ3mSP7DsdJCTCMO+ypeIFYvnvhFtSvruzQdu
BZPmTsj9nodi6NvnDz/3g/gUPHl6Ga6Mw8kgSzsl3LBcuEVg/KLsijGNGbE6BroY3rUEb0
4eXqB4/mqTLnewnnuuOeCFSOLtVN89Oxq3U5SfBJQbUHFUd+z5XIzx1tMbvovklEPSNg06
Clr5hRtcSc0Mjt4QUW+jTEyCw4mrA75v4zkXpCr10PjBXPmtksaOoYtgW7JD5lgBy8ozxI
tSs9PO/dU+tkXaZgUz14T/OWPKy+Fv07M/VVs945CFWDbeLG71WHysYDPB62XY64B7T9MH
LT7g7FJvCyh8gZ+uhxbPmB8UA4CM+UOew1tFSsftbQvEUkhCu4C0jAqq5xgGT7QZWs3faG
pi1O8xUo/OCDwLBc1cKbzqDcYfxedFQ36pFW06jzAAAFgP06CBP9OggTAAAAB3NzaC1yc2
EAAAGBAMZOYOmRYgssD5zUyNVdPUrHrnqLx/pmHJWN4Cr2VjiasqPCh5duvzcDTBw1Q7TA
OEFIeVb61xBPS5jA20f2Gh0Sd5kj+w7HSQkwjDvsqXiBWL574RbUr67s0HbgWT5k7I/Z6H
Yujb5w8/94P4FDx5ehmujMPJIEs7JdywXLhFQvyi7IoxjRmxOga6GN61BG9OHl6geP5qky
53sJ57rjnghUji7VTfPTsat1OUnwSUG1BxVHfs+VyM8dbTG76L5JRD0jYNOgpa+YUbXEnN
```

### Запускаем playbook

```
root@master:/home/user/kubespray# ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v

PLAY RECAP **************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
master                     : ok=739  changed=146  unreachable=0    failed=0    skipped=1266 rescued=0    ignored=8
worker1                    : ok=512  changed=91   unreachable=0    failed=0    skipped=777  rescued=0    ignored=1
worker2                    : ok=512  changed=91   unreachable=0    failed=0    skipped=776  rescued=0    ignored=1
worker3                    : ok=512  changed=91   unreachable=0    failed=0    skipped=776  rescued=0    ignored=1
worker4                    : ok=512  changed=91   unreachable=0    failed=0    skipped=776  rescued=0    ignored=1

Sunday 10 December 2023  08:05:41 +0000 (0:00:00.330)       
===============================================================================
download : Download_file | Download item ------------------------------------------------------------------------------------------------------------------------------------ 80.16s
container-engine/nerdctl : Download_file | Download item -------------------------------------------------------------------------------------------------------------------- 51.18s
container-engine/containerd : Download_file | Download item ----------------------------------------------------------------------------------------------------------------- 46.25s
container-engine/crictl : Download_file | Download item --------------------------------------------------------------------------------------------------------------------- 45.11s
container-engine/runc : Download_file | Download item ----------------------------------------------------------------------------------------------------------------------- 45.01s
network_plugin/calico : Wait for calico kubeconfig to be created ------------------------------------------------------------------------------------------------------------ 43.73s
download : Download_container | Download image if required ------------------------------------------------------------------------------------------------------------------ 38.87s
download : Download_file | Download item ------------------------------------------------------------------------------------------------------------------------------------ 35.50s
container-engine/crictl : Extract_file | Unpacking archive ------------------------------------------------------------------------------------------------------------------ 31.60s
container-engine/nerdctl : Extract_file | Unpacking archive ----------------------------------------------------------------------------------------------------------------- 31.42s
download : Download_container | Download image if required ------------------------------------------------------------------------------------------------------------------ 27.84s
download : Download_container | Download image if required ------------------------------------------------------------------------------------------------------------------ 27.41s
download : Download_file | Download item ------------------------------------------------------------------------------------------------------------------------------------ 27.20s
kubernetes/control-plane : Kubeadm | Initialize first master ---------------------------------------------------------------------------------------------------------------- 26.82s
container-engine/containerd : Download_file | Validate mirrors -------------------------------------------------------------------------------------------------------------- 24.32s
container-engine/runc : Download_file | Validate mirrors -------------------------------------------------------------------------------------------------------------------- 23.64s
container-engine/crictl : Download_file | Validate mirrors ------------------------------------------------------------------------------------------------------------------ 23.45s
container-engine/nerdctl : Download_file | Validate mirrors ----------------------------------------------------------------------------------------------------------------- 23.37s
kubernetes/kubeadm : Join to cluster ---------------------------------------------------------------------------------------------------------------------------------------- 22.59s
kubernetes/preinstall : Update package management cache (APT) --------------------------------------------------------------------------------------------------------------- 21.78s
```

```
exit
root@master:/home/user/kubespray# kubectl get nodes
NAME        STATUS   ROLES           AGE   VERSION
master      Ready    control-plane   84m   v1.26.7
worker1     Ready    <none>          83m   v1.26.7
worker2     Ready    <none>          83m   v1.26.7
worker3     Ready    <none>          83m   v1.26.7
worker4     Ready    <none>          83m   v1.26.7
```