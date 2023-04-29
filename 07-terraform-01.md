## Домашнее задание к занятию 7. «Введение в Terraform»

### Задача 1

- Перейдите в каталог src. Скачайте все необходимые зависимости, использованные в проекте.
```
┌──(root㉿kali)-[/home/kali/lesson/terraform1]
└─# git clone https://github.com/Firewal7/ter-homeworks.git
Cloning into 'ter-homeworks'...
remote: Enumerating objects: 262, done.
remote: Counting objects: 100% (39/39), done.
remote: Compressing objects: 100% (37/37), done.
remote: Total 262 (delta 15), reused 6 (delta 2), pack-reused 223
Receiving objects: 100% (262/262), 65.27 KiB | 742.00 KiB/s, done.
Resolving deltas: 100% (120/120), done.
```
- Изучите файл .gitignore. В каком terraform файле допустимо сохранить личную, секретную информацию?
```
personal.auto.tfvars - позволяет именовать файлы с переменными (в том числе секретными)
```
- Выполните код проекта. Найдите в State-файле секретное содержимое созданного ресурса random_password. Пришлите его в качестве ответа.
```
──(root㉿kali)-[/home/…/terraform1/ter-homeworks/01/src]
└─# terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_password.random_string will be created
  + resource "random_password" "random_string" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = false
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_password.random_string: Creating...
random_password.random_string: Creation complete after 0s [id=none]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

![terraform.tfstate](https://github.com/Firewal7/7.-Terraform/blob/main/3.jpg)

- Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла main.tf. Выполните команду terraform -validate. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.
1. Error: Missing name for resource (Ошибка: Отсутствует имя для ресурса)
```
Error: Missing name for resource.
│
│   on main.tf line 24, in resource "docker_image":
│   24: resource "docker_image" {
│
│ All resource blocks must have 2 labels (type, name).
```
Нужно добавить имя nginx
```
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}
```
2. Неверное имя ресурса, а именно 1nginx. (Имя должно начинаться с буквы или подчеркивания и может содержать только буквы, цифры, подчеркивания и тире.)
```
Error: Invalid resource name
│
│   on main.tf line 28, in resource "docker_container" "1nginx":
│   28: resource "docker_container" "1nginx" {
│
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
```
Переименновали название имени nginx_1
```
resource "docker_container" "nginx_1" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"
  ports {
    internal = 80
    external = 8000
  }
}
```
- Выполните код. В качестве ответа приложите вывод команды docker ps
```
┌──(root㉿kali)-[/home/…/terraform1/ter-homeworks/01/src]
└─# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
39df73b6d219   904b8cb13b93   "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds   0.0.0.0:8000->80/tcp   example_i2R7AkMrLCc7T9gf
```
- Замените имя docker-контейнера в блоке кода на hello_world, выполните команду terraform apply -auto-approve. Объясните своими словами, в чем может быть опасность применения ключа -auto-approve ?
  
 terraform apply -auto-approve Пропускает интерактивное утверждение плана перед применением
```
└─# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
79030609a858   904b8cb13b93   "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds   0.0.0.0:8000->80/tcp   hello_world
```
- Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.
```
┌──(root㉿kali)-[/home/…/terraform1/ter-homeworks/01/src]
└─# cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.3.7",
  "serial": 45,
  "lineage": "daed9d12-bef8-1e97-1962-f63d257a60ea",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
- Объясните, почему при этом не был удален docker образ nginx:latest ?(Ответ найдите в коде проекта или документации)
```
Keep_locally - (Необязательно, логическое значение) Если true, то образ Docker не будет удален при операции уничтожения. Если это ложь, он удалит изображение из локального хранилища докера при операции уничтожения.
```


### Задача 2

- Изучите в документации provider Virtualbox от shekeriev.
- Создайте с его помощью любую виртуальную машину.
  
В качестве ответа приложите plan для создаваемого ресурса.

```
┌──(root㉿kali)-[/home/…/src/2*/terraform-provider-virtualbox/examples]
└─# terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # virtualbox_vm.vm1 will be created
  + resource "virtualbox_vm" "vm1" {
      + cpus      = 1
      + id        = (known after apply)
      + image     = "https://app.vagrantup.com/shekeriev/boxes/debian-11/versions/0.2/providers/virtualbox.box"
      + memory    = "512 mib"
      + name      = "debian-11"
      + status    = "running"
      + user_data = "/home/kali/lesson/terraform1/ter-homeworks/01/src/2*/user_data"

      + network_adapter {
          + device                 = "IntelPro1000MTDesktop"
          + host_interface         = "vboxnet1"
          + ipv4_address           = (known after apply)
          + ipv4_address_available = (known after apply)
          + mac_address            = (known after apply)
          + status                 = (known after apply)
          + type                   = "hostonly"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + IPAddress = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.

```
