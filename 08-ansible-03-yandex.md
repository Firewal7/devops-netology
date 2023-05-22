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
        - name: Get clickhouse distrib (rescue)
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
    - name: Flush handlers to restart clickhouse
      ansible.builtin.meta: flush_handlers
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      become: true
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc != 82
      changed_when: create_db.rc == 0


- name: Install vector
  tags: vector
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
        url: https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm
        dest: ./vector-{{ vector_version }}-1.x86_64.rpm
        mode: "0644"
    - name: Install vector packages
      become: true
      ansible.builtin.yum:
        name: vector-{{ vector_version }}-1.x86_64.rpm
      notify: Start vector service

- name: Install lighthouse
  tags: lighthouse
  hosts: lighthouse

  handlers:
    - name: Start nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  tasks:
    - name: Install Nginx
      become: true
      ansible.builtin.yum:
        name: nginx
        state: present
      notify: Start nginx service
    - name: Install git | Install Nginx
      become: true
      ansible.builtin.yum:
        name: git
        state: present
      notify: Start nginx service
    - name: Create Nginx config | Install Nginx
      become: true
      ansible.builtin.template:
        src: nginx.j2
        dest: /etc/nginx/nginx.conf
        mode: "0644"
      notify: Start nginx service
    - name: Create Nginx config lighthouse | Install Nginx
      become: true
      ansible.builtin.template:
        src: lighthouse.j2
        dest: /etc/nginx/conf.d/lighthouse.conf
        mode: "0644"
      notify: Start nginx service
    - name: Start Nginx
      become: true
      ansible.builtin.systemd:
        name: nginx
        state: started
    - name: Autorun Nginx
      become: true
      ansible.builtin.systemd:
        name: nginx
        enabled: true
    - name: Create directory
      become: true
      ansible.builtin.file:
        path: /var/www/lighthouse
        state: directory
        owner: nginx
        group: nginx
        mode: "0755"
    - name: Copy lighthouse from git
      ansible.builtin.git:
        repo: "{{ lighthouse_vcs }}"
        version: master
        dest: "/var/www/lighthouse"
      become: true
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ansible-lint site.yml
WARNING  Listing 1 violation(s) that are fatal
yaml[new-line-at-end-of-file]: No new line character at the end of file
site.yml:124

Read documentation for instructions on how to ignore specific rule violations.

                      Rule Violation Summary                      
 count tag                           profile rule associated tags 
     1 yaml[new-line-at-end-of-file] basic   formatting, yaml     

Failed after min profile: 1 failure(s), 0 warning(s) on 1 files.
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
Завершился с ошибкой.
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ansible-playbook site.yml -i inventory/prod.yml --check
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details

PLAY [Install Clickhouse] **********************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
The authenticity of host '158.160.18.202 (158.160.18.202)' can't be established.
ED25519 key fingerprint is SHA256:FTdYOjBDlNe/IYQLTbAxu2RatKN8mnHeqVwZkCZpnan.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
fatal: [clickhouse-01]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Warning: Permanently added '158.160.18.202' (ED25519) to the list of known hosts.\r\nConnection closed by 158.160.18.202 port 22", "unreachable": true}

PLAY RECAP *************************************************************************************************************************************************************
clickhouse-01              : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] *****************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ********************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install vector] *********************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *****************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ************************************************************************************************************************
ok: [vector-01]

PLAY [Install lighthouse] *****************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install Nginx] **********************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install git | Install Nginx] ********************************************************************************************************************
ok: [lighthouse-01]

TASK [Create Nginx config | Install Nginx] ************************************************************************************************************
ok: [lighthouse-01]

TASK [Create Nginx config lighthouse | Install Nginx] *************************************************************************************************
ok: [lighthouse-01]

TASK [Start Nginx] ************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Autorun Nginx] **********************************************************************************************************************************
ok: [lighthouse-01]

TASK [Create directory] *******************************************************************************************************************************
ok: [lighthouse-01]

TASK [Copy lighthouse from git] ***********************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP ********************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
lighthouse-01              : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ssh admin@158.160.18.202
[admin@clickhouse-01 ~]$  cat /etc/nginx/conf.d/lighthouse.conf
server {
    listen       80;
    server_name  localhost;

    access_log /var/log/nginx/lighthouse_access__access_log compression;
    error_log /var/log/nginx/lighthouse_access_log_error_log;

    location / {
        root   /var/www/lighthouse;
        index   index.html;
    }
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/08-ansible-03-yandex]
└─# ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Clickhouse] *****************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ********************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install vector] *********************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *****************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ************************************************************************************************************************
ok: [vector-01]

PLAY [Install lighthouse] *****************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install Nginx] **********************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install git | Install Nginx] ********************************************************************************************************************
ok: [lighthouse-01]

TASK [Create Nginx config | Install Nginx] ************************************************************************************************************
ok: [lighthouse-01]

TASK [Create Nginx config lighthouse | Install Nginx] *************************************************************************************************
ok: [lighthouse-01]

TASK [Start Nginx] ************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Autorun Nginx] **********************************************************************************************************************************
ok: [lighthouse-01]

TASK [Create directory] *******************************************************************************************************************************
ok: [lighthouse-01]

TASK [Copy lighthouse from git] ***********************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP ********************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
lighthouse-01              : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.


Ссылка на readme файл [https://github.com/Firewal7/devops-netology/blob/main/08-ansible-03-yandex/README.md]

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

[https://github.com/Firewal7/devops-netology/blob/main/08-ansible-03-yandex.md]

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

