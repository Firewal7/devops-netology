---

### Плей Install Clickhouse устанавливает clickhouse на все машины в группе clickhouse указанные в inventory файле.
```
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
```
### Таск Get clickhouse distrib. Скачивает дистрибутивы перечисленные в переменных. Сначала task ищет дистрибутивы без архитектуры, если не находит, то берет дистрибутив с архитектурой x86_64. 

```       
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
```

### Таск Install clickhouse packages. Устанавливает скачанные по списку дистрибутивы. Данный таск, в случае если были внесены изменения, вызывает handler Start clickhouse service.
```            
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
```

### Таск Start clickhouse service. Убеждается что service "clickhouse-server" запущен, либо запускает его.      
```
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: started
```

### Таск Create database. Создаёт базу данных "logs".
```        
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      become: true
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc != 82
      changed_when: create_db.rc == 0
```      
### Хэндлер Start clickhouse service перезапускает сервис "clickhouse-server" в случае если был вызван в таске Install clickhouse packages.

### Плей Install Vector устанавливает vector на все машины в группе Vector указанные в inventory файле.
```
- name: Install Vector
  hosts: vector
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
```

### Таск Get vector distrib. Скачивает дистрибутив vector версии указанной в переменных.
```        
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector_{{ vector_version }}-1_amd64.deb"
        dest: "./vector-{{ vector_version }}.dpkg"
        mode: "0644"
```
### Таск Install vector packages. Устанавливает скачанный в первом таске пакет. Данный таск, в случае если были внесены изменения, вызывает handler Start vector service.       
``` 
    - name: Install vector packages
      become: true
      ansible.builtin.apt:
        deb: ./vector-{{ vector_version }}.dpkg
      notify: start vector service
```      
### Хэндлер Start vector service перезапускает сервис "vector" в случае если был вызван в таске Install vector packages.

### Плей Install Nginx устанавливает Nginx на все машины в группе LightHouse указанные в inventory файле для возможности в дальнейшем запустить на нём сам LightHouse
```
- name: Install nginx
  hosts: lighthouse
  handlers:
    - name: Restart Nginx Service
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
```
### Таск Install nginx устанавливает Nginx, указанной в переменных версии, из репозитория. Данный таск, в случае если были внесены изменения, вызывает handler Restart nginx service.
```        
  tasks:
    - name: Install nginx
      become: true
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true
      notify: restart nginx service
```      
### Хэндлер Restart nginx service перезапускает сервис "nginx" в случае если был вызван в таске Install nginx.

### Плей Install LightHouse устанавливает LightHouse на все машины в группе LightHouse указанные в inventory файле.
```
- name: Install lighthouse
  hosts: lighthouse
  handlers:
    - name: restart nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
```
### Претаск install unzip устанавливает утилиты "unzip" из репозитория. Утилита необходима для распаковки скачиваемого, во время выполнения плея, дистрибутива LightHouse.         
```
  pre_tasks:
    - name: Install unzip
      become: true
      ansible.builtin.apt:
        name: unzip
        state: present
        update_cache: true
```
### Таск Get lighthouse distrib скачивает дистрибутив LightHouse из гита разработчиков.         
```
  tasks:
    - name: Get lighthouse distrib
      ansible.builtin.get_url:
        url: "https://github.com/VKCOM/lighthouse/archive/refs/heads/master.zip"
        dest: "./lighthouse.zip"
        mode: "0644"
```
### Таск Unarchive lighthouse distrib into nginx распаковывает дистрибутив LightHouse в директорию "/var/www/html/". Данный таск, в случае если были внесены изменения, вызывает handler Restart nginx service. 
```        
    - name: Unarchive lighthouse distrib into nginx
      become: true
      ansible.builtin.unarchive:
        src: ./lighthouse.zip
        dest: /var/www/html/
        remote_src: true
      notify: restart nginx service
```
### Таск Make nginx config подготавливает из шаблона конфигурационный файл для Nginx, подставлая в него порт. Данный таск, в случае если были внесены изменения, вызывает handler Restart nginx service. 
```     
    - name: Make nginx config
      become: true
      ansible.builtin.template:
        src: /home/kali/lesson/devops-netology/08-ansible-03-yandex/templates/default.j2
        dest: /etc/nginx/sites-enabled/default
        mode: "0644"
      notify: restart nginx service
```
### Таск Remove lighthouse distrib удаляет скачанный во 2-ом таске дистрибутив.     
``` 
    - name: Remove lighthouse distrib
      ansible.builtin.file:
        path: "./lighthouse.zip"
        state: absent
```
### Хэндлер Restart nginx service перезапускает сервис "nginx" в случае если был вызван в тасках Unarchive lighthouse distrib into nginx или make nginx config.

## Описание файлов переменных

### Файл переменных clickhouse

Файл переменных clickhouse в обязательном порядке должен содержать следующие переменные:
Переменная | Описание
---------- | --------
clickhouse_version | Требуемая к установке версия дистрибутива
clickhouse_packages | Список требуемых к установке пакетов

### Файл переменных vector
Файл переменных vector в обязательном порядке должен содержать следующие переменные:
Переменная | Описание
---------- | --------
vector_version | Требуемая к установке версия дистрибутива

### Файл переменных lighthouse
Файл переменных lighthouse в обязательном порядке должен содержать следующие переменные:
Переменная | Описание
---------- | --------
lighthouse_port | Порт на котором будет доступен lighthouse
