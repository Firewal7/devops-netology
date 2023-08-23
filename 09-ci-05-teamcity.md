## Домашнее задание к занятию 11 «Teamcity»

### Подготовка к выполнению

1. В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа jetbrains/teamcity-server.
2. Дождитесь запуска teamcity, выполните первоначальную настройку.
3. Создайте ещё один инстанс (2CPU4RAM) на основе образа jetbrains/teamcity-agent. Пропишите к нему переменную окружения SERVER_URL: "http://<teamcity_url>:8111".

![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-1.jpg)

4. Авторизуйте агент.
![Ссылка 2](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-2.jpg)
5. Сделайте fork репозитория.
6. Создайте VM (2CPU4RAM) и запустите playbook.

<details>
<summary>ansible-playbook</summary>

└─# ansible-playbook -i /home/kali/nexus/mnt-homeworks/09-ci-05-teamcity/infrastructure/inventory/cicd/hosts.yml site.yml

PLAY [Get Nexus installed] *****************************************************

TASK [Gathering Facts] *********************************************************
ok: [nexus-01]

TASK [Create Nexus group] ******************************************************
ok: [nexus-01]

TASK [Create Nexus user] *******************************************************
ok: [nexus-01]

TASK [Install JDK] *************************************************************
ok: [nexus-01]

TASK [Create Nexus directories] ************************************************
ok: [nexus-01] => (item=/home/nexus/log)
ok: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3)
ok: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3/etc)
ok: [nexus-01] => (item=/home/nexus/pkg)
ok: [nexus-01] => (item=/home/nexus/tmp)

TASK [Download Nexus] **********************************************************
changed: [nexus-01]

TASK [Unpack Nexus] ************************************************************
changed: [nexus-01]

TASK [Link to Nexus Directory] *************************************************
changed: [nexus-01]

TASK [Add NEXUS_HOME for Nexus user] *******************************************
changed: [nexus-01]

TASK [Add run_as_user to Nexus.rc] *********************************************
changed: [nexus-01]

TASK [Raise nofile limit for Nexus user] ***************************************
changed: [nexus-01]

TASK [Create Nexus service for SystemD] ****************************************
changed: [nexus-01]

TASK [Ensure Nexus service is enabled for SystemD] *****************************
changed: [nexus-01]

TASK [Create Nexus vmoptions] **************************************************
changed: [nexus-01]

TASK [Create Nexus properties] *************************************************
changed: [nexus-01]

TASK [Lower Nexus disk space threshold] ****************************************
skipping: [nexus-01]

TASK [Start Nexus service if enabled] ******************************************
changed: [nexus-01]

TASK [Ensure Nexus service is restarted] ***************************************
skipping: [nexus-01]

TASK [Wait for Nexus port if started] ******************************************
ok: [nexus-01]

PLAY RECAP *********************************************************************
nexus-01                   : ok=17   changed=11   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0 

</details>

### Основная часть

1. Создайте новый проект в teamcity на основе fork.

![Ссылка 3](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-3.jpg)

2. Сделайте autodetect конфигурации.

![Ссылка 4](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-4.jpg)

3. Сохраните необходимые шаги, запустите первую сборку master.

![Ссылка 5](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-5.jpg)

4. Поменяйте условия сборки: если сборка по ветке master, то должен происходит mvn clean deploy, иначе mvn clean test.

![Ссылка 6](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-6.jpg)

5. Для deploy будет необходимо загрузить settings.xml в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.

![Ссылка 7](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-7.jpg)

6. В pom.xml необходимо поменять ссылки на репозиторий и nexus.
7. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.

![Ссылка 8](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-8.jpg)

![Ссылка 9](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-9.jpg)

8. Мигрируйте build configuration в репозиторий.

![Ссылка 10](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-10.jpg)

9. Создайте отдельную ветку feature/add_reply в репозитории.
```
┌──(root㉿kali)-[/home/kali/nexus/fork]
└─# git branch feature/add_reply

┌──(root㉿kali)-[/home/kali/nexus/fork]
└─# git checkout feature/add_reply
Switched to branch 'feature/add_reply'

┌──(root㉿kali)-[/home/kali/nexus/fork]
└─# git branch -a
* feature/add_reply
  master
  remotes/origin/master
```

10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово hunter.
```
public String sayHunter(){
   return "Hello hunter!";
}
```
11. Дополните тест для нового метода на поиск слова hunter в новой реплике.
```
	@Test
	public void netologySaysHunter() {
		assertThat(welcomer.sayHunter(), containsString("hunter"));
	}

```
12. Сделайте [push](https://github.com/Firewal7/example-teamcity/commit/0555cd5b94c450bc5ed106ccc152da74acac5f15) всех изменений в новую ветку репозитория.


13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.

![Ссылка 11](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-11.jpg)

14. Внесите изменения из произвольной ветки feature/add_reply в master через [Merge](https://github.com/Firewal7/example-teamcity/pull/1/files).

15. Убедитесь, что нет собранного артефакта в сборке по ветке master.

![Ссылка 12](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-12.jpg)

16. Настройте конфигурацию так, чтобы она собирала .jar в артефакты 
сборки.

![Ссылка 13](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-13.jpg)

17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.

![Ссылка 14](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-14.jpg)
![Ссылка 15](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-05-teamcity-15.jpg)

18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.
19. В ответе пришлите ссылку на репозиторий.

[Ссылка](https://github.com/Firewal7/example-teamcity)