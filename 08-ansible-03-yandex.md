# Домашнее задание к занятию "3. Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.
```
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - name: Mess with clickhouse distrib
      block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
            mode: "0644"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
            mode: "0644"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: started
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      become: true
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc != 82
      changed_when: create_db.rc == 0

- name: Install Vector
  hosts: vector
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector_{{ vector_version }}-1_amd64.deb"
        dest: "./vector-{{ vector_version }}.dpkg"
        mode: "0644"
    - name: Install vector packages
      become: true
      ansible.builtin.apt:
        deb: ./vector-{{ vector_version }}.dpkg
      notify: start vector service

- name: Install nginx
  hosts: lighthouse
  handlers:
    - name: Restart Nginx Service
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  tasks:
    - name: Install nginx
      become: true
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true
      notify: restart nginx service

- name: Install lighthouse
  hosts: lighthouse
  handlers:
    - name: Restart nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  pre_tasks:
    - name: Install unzip
      become: true
      ansible.builtin.apt:
        name: unzip
        state: present
        update_cache: true
  tasks:
    - name: Get lighthouse distrib
      ansible.builtin.get_url:
        url: "https://github.com/VKCOM/lighthouse/archive/refs/heads/master.zip"
        dest: "./lighthouse.zip"
        mode: "0644"
    - name: Unarchive lighthouse distrib into nginx
      become: true
      ansible.builtin.unarchive:
        src: ./lighthouse.zip
        dest: /var/www/html/
        remote_src: true
      notify: restart nginx service
    - name: Make nginx config
      become: true
      ansible.builtin.template:
        src: /home/kali/lesson/devops-netology/08-ansible-03-yandex/templates/default.j2
        dest: /etc/nginx/sites-enabled/default
        mode: "0644"
      notify: restart nginx service
    - name: Remove lighthouse distrib
      ansible.builtin.file:
        path: "./lighthouse.zip"
        state: absent
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ansible-lint site.yml

Passed with production profile: 0 failure(s), 0 warning(s) on 1 files.
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ansible-playbook site.yml -i inventory/prod.yml --check

PLAY [Install Clickhouse] *************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "user", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "user", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Start clickhouse service] *******************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ****************************************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ********************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [Install nginx] ******************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install nginx] ******************************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY [Install lighthouse] *************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install unzip] ******************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Get lighthouse distrib] *********************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Unarchive lighthouse distrib into nginx] ****************************************************************************************************************************************************************
fatal: [lighthouse-01]: FAILED! => {"changed": false, "msg": "Source './lighthouse.zip' does not exist"}

PLAY RECAP ****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
lighthouse-01              : ok=5    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] *************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "user", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "user", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Start clickhouse service] *******************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ********************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [Install nginx] ******************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install nginx] ******************************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY [Install lighthouse] *************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install unzip] ******************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Get lighthouse distrib] *********************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Unarchive lighthouse distrib into nginx] ****************************************************************************************************************************************************************
.d...p...?? lighthouse-master/
.d...p...?? lighthouse-master/css/
.d...p...?? lighthouse-master/img/
.d...p...?? lighthouse-master/js/
.d...p...?? lighthouse-master/js/ace-min/
.d...p...?? lighthouse-master/js/ace-min/snippets/
changed: [lighthouse-01]

TASK [Make nginx config] **************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Remove lighthouse distrib] ******************************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "./lighthouse.zip",
-    "state": "file"
+    "state": "absent"
 }

changed: [lighthouse-01]

RUNNING HANDLER [Restart nginx service] ***********************************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP ****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=9    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 

```
```
┌──(root㉿kali)-[~/.ssh]
└─# ssh user@158.160.11.169

user@lighthouse-01:~$ cat /etc/nginx/sites-enabled/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html/lighthouse-master;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                try_files $uri $uri/ =404;
        }
}
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] *************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "user", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "user", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ****************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Start clickhouse service] *******************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *****************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ********************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [Install nginx] ******************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install nginx] ******************************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY [Install lighthouse] *************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install unzip] ******************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Get lighthouse distrib] *********************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Unarchive lighthouse distrib into nginx] ****************************************************************************************************************************************************************
.d...p...?? lighthouse-master/
.d...p...?? lighthouse-master/css/
.d...p...?? lighthouse-master/img/
.d...p...?? lighthouse-master/js/
.d...p...?? lighthouse-master/js/ace-min/
.d...p...?? lighthouse-master/js/ace-min/snippets/
changed: [lighthouse-01]

TASK [Make nginx config] **************************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Remove lighthouse distrib] ******************************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "./lighthouse.zip",
-    "state": "file"
+    "state": "absent"
 }

changed: [lighthouse-01]

RUNNING HANDLER [Restart nginx service] ***********************************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP ****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=9    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.


Ссылка на readme файл [https://github.com/Firewal7/devops-netology/blob/main/08-ansible-03-yandex/README.md]

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

[https://github.com/Firewal7/devops-netology/blob/08-ansible-03-yandex/08-ansible-03-yandex/site.yml]

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

