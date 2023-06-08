## Домашнее задание к занятию 5 «Тестирование roles»
### Подготовка к выполнению

1. Установите molecule: pip3 install "molecule==3.5.2".
2. Выполните docker pull aragast/netology:latest — это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

```
└─# molecule --version                 
molecule 3.5.2 using python 3.10 
    ansible:2.14.1
    delegated:3.5.2 from molecule
                                                                                                                                                           
└─# docker image ls                    
REPOSITORY          TAG       IMAGE ID       CREATED        SIZE
eqlabs/pathfinder   latest    19e6e36fbb3d   13 days ago    373MB
nginx               latest    904b8cb13b93   3 months ago   142MB
aragast/netology    latest    b453a84e3f7a   8 months ago   2.46GB
pycontribs/centos   8         fec8cb567d93   2 years ago    749MB
pycontribs/centos   7         bafa54e44377   2 years ago    488MB
pycontribs/ubuntu   latest    42a4e3b21923   3 years ago    664MB
```
### Основная часть

Ваша цель — настроить тестирование ваших ролей.

Задача — сделать сценарии тестирования для vector.

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите molecule test -s centos_7 внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.

- Уствновил роль ansible-clickhouse ansible-galaxy install -r requirements.yml -p roles
- Установил molecule: pip3 install "molecule==3.4.0"
- Установил lint: pip3 install "ansible-lint<6.0.0"
- Установил driver docker: pip3 install molecule_docker
- Установил flake8 pip3 install flake8
- Запустил molecule test -s centos_7
```
└─# molecule test -s centos_7
INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/vagrant/.cache/ansible-compat/7e099f/modules:/home/vagrant/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/vagrant/.cache/ansible-compat/7e099f/collections:/home/vagrant/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/vagrant/.cache/ansible-compat/7e099f/roles:/home/vagrant/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > lint
COMMAND: yamllint .
ansible-lint
flake8

fatal: not a git repository (or any of the parent directories): .git
Traceback (most recent call last):
  File "/usr/bin/ansible-lint", line 11, in <module>
    load_entry_point('ansible-lint==4.2.0', 'console_scripts', 'ansible-lint')()
  File "/usr/lib/python3/dist-packages/ansiblelint/__main__.py", line 153, in main
    args = get_playbooks_and_roles(options=options)
  File "/usr/lib/python3/dist-packages/ansiblelint/utils.py", line 772, in get_playbooks_and_roles
    files = OrderedDict.fromkeys(sorted(subprocess.check_output(
  File "/usr/lib/python3.8/subprocess.py", line 415, in check_output
    return run(*popenargs, stdout=PIPE, timeout=timeout, check=True,
  File "/usr/lib/python3.8/subprocess.py", line 516, in run
    raise CalledProcessError(retcode, process.args,
subprocess.CalledProcessError: Command '['git', 'ls-files', '*.yaml', '*.yml']' returned non-zero exit status 128.
/bin/bash: line 2: flake8: command not found
CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/vagrant/.ansible/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи molecule init scenario --driver-name docker.
```
└─# molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/vagrant/.ansible/roles/vector-role/molecule/default successfully.
```
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
```
└─# molecule init scenario centos8 --driver-name docker
INFO     Initializing new scenario centos8...
INFO     Initialized scenario in /home/vagrant/.ansible/roles/vector-role/molecule/centos8 successfully.
```
```
└─# molecule init scenario ubuntu_latest --driver-name docker
INFO     Initializing new scenario ubuntu_latest...
INFO     Initialized scenario in /home/vagrant/.ansible/roles/vector-role/molecule/ubuntu_latest successfully.
```
4. Добавьте несколько assert в verify.yml-файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).
```
# This is an example playbook to execute Ansible tests.

- name: Verify
  hosts: all
  gather_facts: false
  vars:
    vector_config_path: /etc/vector/vector.yaml
  tasks:

  - name: Get Vector version
    ansible.builtin.command: "vector --version"
    changed_when: false
    register: vector_version
  - name: Assert Vector instalation
    assert:
      that: "'{{ vector_version.rc }}' == '0'"

  - name: Validation Vector configuration
    ansible.builtin.command: "vector validate --no-environment --config-yaml {{ vector_config_path }}"
    changed_when: false
    register: vector_validate
  - name: Assert Vector validate config
    assert:
      that: "'{{ vector_validate.rc }}' == '0'"
```
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
```
PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validation Vector configuration] *****************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu_latest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_latest > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```
6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

[Ссылка на vector](https://github.com/Firewal7/vector-roles/tree/1.0.0)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](https://github.com/Firewal7/devops-netology/tree/main/08-ansible-05-testing/example).
2. Запустите docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду tox, посмотрите на вывод.
4. Создайте облегчённый сценарий для molecule с драйвером molecule_podman. Проверьте его на исполнимость.
5. Пропишите правильную команду в tox.ini, чтобы запускался облегчённый сценарий.
6. Запустите команду tox. Убедитесь, что всё отработало успешно.
7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на ваш репозиторий и скриншоты этапов выполнения задания.

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.
