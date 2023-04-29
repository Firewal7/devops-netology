## Домашнее задание "Основы Terraform. Yandex Cloud"

### Задача 1

1. Изучите проект. В файле variables.tf объявлены переменные для yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. Вы можете выбрать иной способ безопасно передать секретные данные в terraform.
3. Сгенерируйте или используйте свой текущий ssh ключ. Запишите его открытую часть в переменную vms_ssh_root_key.
4. Инициализируйте проект, выполните код. Исправьте возникшую ошибку. Ответьте в чем заключается ее суть?
5. Ответьте, что означает preemptible = true и core_fraction в параметрах ВМ? Как это может пригодится в процессе обучения? Ответ в документации Yandex cloud.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ,

[Скриншот ЛК Yandex Cloud](https://github.com/Firewal7/8.-Terraform-Yandex-Cloud/blob/main/1.jpg)

- скриншот успешного подключения к консоли ВМ через ssh,

[Скриншот подключение по ssh](https://github.com/Firewal7/8.-Terraform-Yandex-Cloud/blob/main/2.jpg)

- ответы на вопросы.

  Суть ошибки в том что в файле main.tf было указано одно ядро, для разворачивания ВМ на Yandex Cloud минимальное количество ядер для ВМ 2. 

- preemptible = true это значит создать прерываюмую ВМ, которая работает не более 24 часов и может быть остановлена Compute Cloud в любой момент.
   - Мне кажется что, preemptible может пригодиться если забыли удалить ресурсы на Yandex Cloud, не съело ваш баланс. Плюс прерываемая ВМ по стоимости гораздо дешевле. (подойдет для учебных целей). 

- core_fraction указывает базовую производительность ядра в процентах.
   - Гарантированная доля vCPU, которая будет выделена ВМ. ВМ с гарантированной долей меньше 100% обеспечивают указанный уровень производительности с вероятностью временного повышения вплоть до 100%. Такие ВМ подходят для задач, которые не требуют постоянной гарантии производительности vCPU на 100%. Подойдёт для обучения, уменьшение затрат на ВМ. 
   

### Задача 2

1. Изучите файлы проекта.
2. Замените все "хардкод" значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ . Пример: vm_web_name.
3. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.
4. Проверьте terraform plan (изменений быть не должно).

[Скриншот переменных](https://github.com/Firewal7/8.-Terraform-Yandex-Cloud/blob/main/3.jpg)

### Задача 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ: "netology-develop-platform-db" , cores = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом vm_db_ в том же файле.
3. Примените изменения.

[Скриншот ВМ](https://github.com/Firewal7/8.-Terraform-Yandex-Cloud/blob/main/4.1.jpg)

### Задача 4

1. Объявите в файле outputs.tf отдельные output, для каждой из ВМ с ее внешним IP адресом.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды terraform output

```
┌──(root㉿kali)-[/home/…/lesson/terraform2/02/src]
└─# terraform output
vm_external_ip_address_db = "10.0.1.21"
vm_external_ip_address_web = "10.0.1.21"
```

### Задание 5

1. В файле locals.tf опишите в одном local-блоке имя каждой ВМ, используйте интерполяцию по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.
3. Примените изменения.

[Скриншот](https://github.com/Firewal7/8.-Terraform-Yandex-Cloud/blob/main/5.1.jpg)

### Задание 6

1. Вместо использования 3-х переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедените их в переменные типа map с именами "vm_web_resources" и "vm_db_resources".
```
resource "yandex_compute_instance" "platform" {
  name        = local.web
  platform_id = "standard-v1"
  resources {
    cores         = var.vm_web_resources.cores
    memory        = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
}

resource "yandex_compute_instance" "platform-db" {
  name        = "local.db"
  platform_id = "standard-v1"
  resources {
    cores         = var.vm_db_resources.cores
    memory        = var.vm_db_resources.memory
    core_fraction = var.vm_db_resources.core_fraction
}
```
```
variable "vm_web_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 1
    core_fraction  = 5
 }
}

variable "vm_db_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 1
    core_fraction  = 5
  }
}
```
2. Так же поступите с блоком metadata {serial-port-enable, ssh-keys}, эта переменная должна быть общая для всех ваших ВМ.
```
variable "vms_ssh_root_key" {
  type = map(any)
  default = {
   serial-port-enable   = 1
   ssh-keys             = "ssh-rsa AAAA
}

  metadata = {
    serial-port-enable = var.vms_ssh_root_key.serial-port-enable
    ssh-keys           = var.vms_ssh_root_key.ssh-keys
  }
```
[Скриншот](https://github.com/Firewal7/8.-Terraform-Yandex-Cloud/blob/main/6.2.jpg)

3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan (изменений быть не должно).
```

      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vm_external_ip_address_db  = (known after apply)
  + vm_external_ip_address_web = (known after apply)
```
