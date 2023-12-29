# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---

- [Конфиги Terraform]()

root@vm-mint:/home/msi/devops-netology/14-clopro-homeworks-1.2# terraform apply

```
yandex_compute_instance_group.vp-nlb-ig: Still creating... [50s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [1m0s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [1m10s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [1m20s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [1m30s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [1m40s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [1m50s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [2m0s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [2m10s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Still creating... [2m20s elapsed]
yandex_compute_instance_group.vp-nlb-ig: Creation complete after 2m23s [id=cl1au9rkda57muhefcl9]
yandex_lb_network_load_balancer.vp-nlb-1: Creating...
yandex_lb_network_load_balancer.vp-nlb-1: Creation complete after 4s [id=enppkmocul149u0getq8]

Apply complete! Resources: 9 added, 0 changed, 1 destroyed.

Outputs:

nlb-address = tolist([
  "158.160.137.209",
])
pic-url = "https://sofin-netology-bucket-2023.storage.yandexcloud.net/image.png"
```

### Переходим по адресу: http://158.160.137.209

![Ссылка 1]()

### Список Виртуальных машин: 

![Ссылка 2]()

### Удалил одну VM:

![Ссылка 3]()

### Проверяем доступность: http://158.160.137.209

![Ссылка 4]()