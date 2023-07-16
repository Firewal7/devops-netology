## Домашнее задание к занятию 10 «Jenkins»

### Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.

![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-1.jpg)

2. Установить Jenkins при помощи playbook.

<details>
<summary>ansible-playbook</summary>

┌──(root㉿kali)-[/home/…/lesson/devops-netology/09-ci-04-jenkins/infrastructure]
└─# ansible-playbook -i inventory/cicd/hosts.yml site.yml

PLAY [Preapre all hosts] ***************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************
ok: [jenkins-master-01]
ok: [jenkins-agent-01]

TASK [Create group] ********************************************************************************************************************************************
ok: [jenkins-master-01]
ok: [jenkins-agent-01]

TASK [Create user] *********************************************************************************************************************************************
ok: [jenkins-master-01]
ok: [jenkins-agent-01]

TASK [Install JDK] *********************************************************************************************************************************************
changed: [jenkins-master-01]
changed: [jenkins-agent-01]

PLAY [Get Jenkins master installed] ****************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************
ok: [jenkins-master-01]

TASK [Get repo Jenkins] ****************************************************************************************************************************************
changed: [jenkins-master-01]

TASK [Add Jenkins key] *****************************************************************************************************************************************
changed: [jenkins-master-01]

TASK [Install epel-release] ************************************************************************************************************************************
changed: [jenkins-master-01]

TASK [Install Jenkins and requirements] ************************************************************************************************************************
changed: [jenkins-master-01]

TASK [Ensure jenkins agents are present in known_hosts file] ***************************************************************************************************
# 51.250.101.58:22 SSH-2.0-OpenSSH_7.4
# 51.250.101.58:22 SSH-2.0-OpenSSH_7.4
# 51.250.101.58:22 SSH-2.0-OpenSSH_7.4
# 51.250.101.58:22 SSH-2.0-OpenSSH_7.4
# 51.250.101.58:22 SSH-2.0-OpenSSH_7.4
changed: [jenkins-master-01] => (item=jenkins-agent-01)
[WARNING]: Module remote_tmp /home/jenkins/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when running as another user.
To avoid this, create the remote_tmp dir with the correct permissions manually

TASK [Start Jenkins] *******************************************************************************************************************************************
changed: [jenkins-master-01]

PLAY [Prepare jenkins agent] ***********************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************
ok: [jenkins-agent-01]

TASK [Add master publickey into authorized_key] ****************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Create agent_dir] ****************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Add docker repo] *****************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install some required] ***********************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Update pip] **********************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install Ansible] *****************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Reinstall Selinux] ***************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Add local to PATH] ***************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Create docker group] *************************************************************************************************************************************
ok: [jenkins-agent-01]

TASK [Add jenkinsuser to dockergroup] **************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Restart docker] ******************************************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install agent.jar] ***************************************************************************************************************************************
changed: [jenkins-agent-01]

PLAY RECAP *****************************************************************************************************************************************************
jenkins-agent-01           : ok=17   changed=12   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
jenkins-master-01          : ok=11   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 

</details>

3. Запустить и проверить работоспособность.

![Ссылка 2](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-2.jpg)

4. Сделать первоначальную настройку.

![Ссылка 3](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-3.jpg)

### Основная часть

1. Сделать Freestyle Job, который будет запускать molecule test из любого вашего репозитория с ролью.

<details>
<summary>Freestyle Job</summary>

![Ссылка 4](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-4.jpg)
![Ссылка 5](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-5.jpg)
![Ссылка 6](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-6.jpg)
![Ссылка 7](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-7.jpg)

</details>

2. Сделать Declarative Pipeline Job, который будет запускать molecule test из любого вашего репозитория с ролью.

<details>
<summary>Declarative Pipeline Job</summary>

![Ссылка 8](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-8.jpg)
![Ссылка 9](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-9.jpg)
![Ссылка 10](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-10.jpg)

</details>

3. Перенести Declarative Pipeline в репозиторий в файл Jenkinsfile.

[Jenkinsfile](https://github.com/Firewal7/vector-role/blob/main/pipeline/jenkinsfile)

4. Создать Multibranch Pipeline на запуск Jenkinsfile из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из pipeline.
6. Внести необходимые изменения, чтобы Pipeline запускал ansible-playbook без флагов --check --diff, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами --check --diff.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл ScriptedJenkinsfile.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.


