# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

```
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.11.0"
    name: clickhouse 
```

```
┌──(root㉿kali)-[/home/…/lesson/devops-netology/08-ansible-04-role/playbook]
└─# cat requirements.yml
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.11.0"
    name: clickhouse 
```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-04-role]
└─# ansible-galaxy install -r requirements.yml
Starting galaxy role install process
- extracting clickhouse to /root/.ansible/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
```
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
```
┌──(root㉿kali)-[/home/…/devops-netology/08-ansible-04-role/playbook/roles]
└─# ansible-galaxy role init vector-role
- Role vector-role was created successfully
┌──(root㉿kali)-[/home/…/08-ansible-04-role/playbook/roles/vector-role]
└─# ls    
defaults  files  handlers  meta  README.md  tasks  templates  tests  vars
```
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры.
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
```
┌──(root㉿kali)-[/home/…/devops-netology/08-ansible-04-role/playbook/roles]
└─# ansible-galaxy role init lighthouse-role
- Role lighthouse-role was created successfully
┌──(root㉿kali)-[/home/…/08-ansible-04-role/playbook/roles/lighthouse-role]
└─# ls    
defaults  files  handlers  meta  README.md  tasks  templates  tests  vars
```
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
```
┌──(root㉿kali)-[/home/…/lesson/devops-netology/08-ansible-04-role/playbook]
└─# cat requirements.yml
---
- name: clickhouse
  src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.11.0"

- name: vector
  src: git@github.com:Firewal7/vector-role.git
  scm: git
  version: "1.0.1"

- name: lighthouse
  src: git@github.com:Firewal7/lighthouse-role.git
  scm: git
  version: "1.1.1"
```
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
```
---
- name: Install Clickhouse
  hosts: clickhouse
  roles:
    - clickhouse

- name: Install Vector
  hosts: vector
  become: true
  roles:
    - vector

- name: Install lighthouse and Nginx
  hosts: lighthouse

  pre_tasks:
    - name: Lighthouse | Install git
      become: true
      ansible.builtin.yum:
        name: git
        state: present
  roles:
    - lighthouse
```

<img
  src="https://github.com/Firewal7/devops-netology/blob/main/image/08-ansible-04-role-1.jpg"
  alt="image 1.png"
  title="image 1.png"
  style="display: inline-block; margin: 0 auto; max-width: 600px">

```
┌──(root㉿kali)-[/home/…/lesson/devops-netology/08-ansible-04-role/playbook]
└─# cat ./inventory/prod.yml 
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 51.250.96.52
      ansible_user: user
vector:
  hosts:
    vector-01:
      ansible_host: 158.160.1.110
      ansible_user: user
lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: 130.193.41.14
      ansible_user: user
```
```
┌──(root㉿kali)-[/home/…/lesson/devops-netology/08-ansible-04-role/playbook]
└─# ansible-galaxy install -r requirements.yml
Starting galaxy role install process
- clickhouse (1.11.0) is already installed, skipping.
- extracting vector to /root/.ansible/roles/vector
- vector was installed successfully
- extracting lighthouse to /root/.ansible/roles/lighthouse
- lighthouse was installed successfully
```
```
┌──(root㉿kali)-[/home/…/lesson/devops-netology/08-ansible-04-role/playbook]
└─# ansible-playbook -i ./inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Include OS Family Specific Variables] ************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ***********************************************************************************************
included: /root/.ansible/roles/clickhouse/tasks/precheck.yml for clickhouse-01

TASK [clickhouse : Requirements check | Checking sse4_2 support] ****************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Requirements check | Not supported distribution && release] **************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ***********************************************************************************************
included: /root/.ansible/roles/clickhouse/tasks/params.yml for clickhouse-01

TASK [clickhouse : Set clickhouse_service_enable] *******************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Set clickhouse_service_ensure] *******************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ***********************************************************************************************
included: /root/.ansible/roles/clickhouse/tasks/install/yum.yml for clickhouse-01

TASK [clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ****************************************************
ok: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] ***********************************************************
ok: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ***********************************************
ok: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] ***************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ***********************************************************************************************
included: /root/.ansible/roles/clickhouse/tasks/configure/sys.yml for clickhouse-01

TASK [clickhouse : Check clickhouse config, data and logs] **********************************************************************
ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
ok: [clickhouse-01] => (item=/etc/clickhouse-server)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] *****************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Create users.d folder] ******************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate system config] *****************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate users config] ******************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate remote_servers config] *********************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate macros config] *****************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate zookeeper servers config] ******************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] **************************************
skipping: [clickhouse-01]

TASK [clickhouse : Notify Handlers Now] *****************************************************************************************

TASK [clickhouse : include_tasks] ***********************************************************************************************
included: /root/.ansible/roles/clickhouse/tasks/service.yml for clickhouse-01

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: started] ****************************************
ok: [clickhouse-01]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] ******************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ***********************************************************************************************
included: /root/.ansible/roles/clickhouse/tasks/configure/db.yml for clickhouse-01

TASK [clickhouse : Set ClickHose Connection String] *****************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Gather list of existing databases] ***************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Delete database config] *****************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Create database config] *****************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ***********************************************************************************************
included: /root/.ansible/roles/clickhouse/tasks/configure/dict.yml for clickhouse-01

TASK [clickhouse : Config | Generate dictionary config] *************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ***********************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] ***********************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************
ok: [vector-01]

TASK [vector : Get vector distrib] **********************************************************************************************
ok: [vector-01]

TASK [vector : Install vector packages] *****************************************************************************************
ok: [vector-01]

PLAY [Install lighthouse and Nginx] *********************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] *************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse : Install epel-release] ****************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse : Install nginx] ***********************************************************************************************
ok: [lighthouse-01]
TASK [lighthouse : Create nginx config] *****************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse : Lighthouse | Clone repository] *******************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse : Create Lighthouse config] ************************************************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP ***********************************************************************************************************************************************************************************************************
clickhouse-01              : ok=24   changed=0    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
lighthouse-01              : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

10. Выложите playbook в репозиторий.

[Playbook](https://github.com/Firewal7/devops-netology/tree/main/08-ansible-04-role/playbook)

11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

[vector](https://github.com/Firewal7/vector-role)

[lighthouse](https://github.com/Firewal7/lighthouse-role)
