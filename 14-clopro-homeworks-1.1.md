# Домашнее задание к занятию «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.

```
root@vm-mint:/home/msi/devops-netology# ssh -i /root/.ssh/id.rsa ubuntu@158.160.116.100
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-156-generic x86_64)

ubuntu@public:~/$ ping google.com
PING google.com (173.194.220.100) 56(84) bytes of data.
64 bytes from lk-in-f100.1e100.net (173.194.220.100): icmp_seq=1 ttl=58 time=21.1 ms
64 bytes from lk-in-f100.1e100.net (173.194.220.100): icmp_seq=2 ttl=58 time=21.0 ms
64 bytes from lk-in-f100.1e100.net (173.194.220.100): icmp_seq=3 ttl=58 time=20.9 ms

```
![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/14-clopro-homeworks-1.1.jpg)

3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

```
ubuntu@public:~/$ ssh -i /home/ubuntu/.ssh/id.rsa ubuntu@192.168.20.17
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-156-generic x86_64)

ubuntu@private:~$ ping google.com
PING google.com (216.58.209.206) 56(84) bytes of data.
64 bytes from hem09s03-in-f14.1e100.net (216.58.209.206): icmp_seq=1 ttl=54 time=25.5 ms
64 bytes from hem09s03-in-f14.1e100.net (216.58.209.206): icmp_seq=2 ttl=54 time=24.4 ms
64 bytes from hem09s03-in-f14.1e100.net (216.58.209.206): icmp_seq=3 ttl=54 time=24.4 ms
```



Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

---