## Домашнее задание к занятию 9 «Процессы CI/CD»

### Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).
2. Пропишите в inventory playbook созданные хосты.
3. Добавьте в files файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.
4. Запустите playbook, ожидайте успешного завершения.

<details>
<summary>└─# ansible-playbook -i inventory/cicd/hosts.yml site.yml</summary>
┌──(root㉿kali)-[/home/…/lesson/devops-netology/09-ci-03-cicd/infrastructure]
└─# sudo ansible-playbook -i inventory/cicd/hosts.yml site.yml

PLAY [Get OpenJDK installed] ********************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************
ok: [sonar-01]

TASK [install unzip] ****************************************************************************************************************************
ok: [sonar-01]

TASK [Upload .tar.gz file conaining binaries from remote storage] *******************************************************************************
ok: [sonar-01]

TASK [Ensure installation dir exists] ***********************************************************************************************************
ok: [sonar-01]

TASK [Extract java in the installation directory] ***********************************************************************************************
skipping: [sonar-01]

TASK [Export environment variables] *************************************************************************************************************
ok: [sonar-01]

PLAY [Get PostgreSQL installed] *****************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************
ok: [sonar-01]

TASK [Change repo file] *************************************************************************************************************************
ok: [sonar-01]

TASK [Install PostgreSQL repos] *****************************************************************************************************************
ok: [sonar-01]

TASK [Install PostgreSQL] ***********************************************************************************************************************
ok: [sonar-01]

TASK [Init template1 DB] ************************************************************************************************************************
changed: [sonar-01]

TASK [Start pgsql service] **********************************************************************************************************************
ok: [sonar-01]

TASK [Create user in system] ********************************************************************************************************************
ok: [sonar-01]

TASK [Create user for Sonar in PostgreSQL] ******************************************************************************************************
changed: [sonar-01]

TASK [Change password for Sonar user in PostgreSQL] *********************************************************************************************
changed: [sonar-01]

TASK [Create Sonar DB] **************************************************************************************************************************
changed: [sonar-01]

TASK [Copy pg_hba.conf] *************************************************************************************************************************
ok: [sonar-01]

PLAY [Prepare Sonar host] ***********************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************
ok: [sonar-01]

TASK [Create group in system] *******************************************************************************************************************
ok: [sonar-01]

TASK [Create user in system] ********************************************************************************************************************
ok: [sonar-01]

TASK [Set up ssh key to access for managed node] ************************************************************************************************
ok: [sonar-01]

TASK [Allow group to have passwordless sudo] ****************************************************************************************************
ok: [sonar-01]

TASK [Increase Virtual Memory] ******************************************************************************************************************
ok: [sonar-01]

TASK [Reboot VM] ********************************************************************************************************************************
changed: [sonar-01]

PLAY [Get Sonarqube installed] ******************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************
ok: [sonar-01]

TASK [Get distrib ZIP] **************************************************************************************************************************
ok: [sonar-01]

TASK [Unzip Sonar] ******************************************************************************************************************************
skipping: [sonar-01]

TASK [Move Sonar into place.] *******************************************************************************************************************
changed: [sonar-01]

TASK [Configure SonarQube JDBC settings for PostgreSQL.] ****************************************************************************************
changed: [sonar-01] => (item={'regexp': '^sonar.jdbc.username', 'line': 'sonar.jdbc.username=sonar'})
changed: [sonar-01] => (item={'regexp': '^sonar.jdbc.password', 'line': 'sonar.jdbc.password=sonar'})
changed: [sonar-01] => (item={'regexp': '^sonar.jdbc.url', 'line': 'sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance'})
changed: [sonar-01] => (item={'regexp': '^sonar.web.context', 'line': 'sonar.web.context='})

TASK [Generate wrapper.conf] ********************************************************************************************************************
changed: [sonar-01]

TASK [Symlink sonar bin.] ***********************************************************************************************************************
ok: [sonar-01]

TASK [Copy SonarQube systemd unit file into place (for systemd systems).] ***********************************************************************
ok: [sonar-01]

TASK [Ensure Sonar is running and set to start on boot.] ****************************************************************************************
changed: [sonar-01]

TASK [Allow Sonar time to build on first start.] ************************************************************************************************
skipping: [sonar-01]

TASK [Make sure Sonar is responding on the configured port.] ************************************************************************************
ok: [sonar-01]

PLAY [Get Nexus installed] **********************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************
ok: [nexus-01]

TASK [Create Nexus group] ***********************************************************************************************************************
ok: [nexus-01]

TASK [Create Nexus user] ************************************************************************************************************************
ok: [nexus-01]

TASK [Install JDK] ******************************************************************************************************************************
ok: [nexus-01]

TASK [Create Nexus directories] *****************************************************************************************************************
ok: [nexus-01] => (item=/home/nexus/log)
ok: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3)
ok: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3/etc)
ok: [nexus-01] => (item=/home/nexus/pkg)
ok: [nexus-01] => (item=/home/nexus/tmp)

TASK [Download Nexus] ***************************************************************************************************************************
changed: [nexus-01]

TASK [Unpack Nexus] *****************************************************************************************************************************
changed: [nexus-01]

TASK [Link to Nexus Directory] ******************************************************************************************************************
changed: [nexus-01]

TASK [Add NEXUS_HOME for Nexus user] ************************************************************************************************************
changed: [nexus-01]

TASK [Add run_as_user to Nexus.rc] **************************************************************************************************************
changed: [nexus-01]

TASK [Raise nofile limit for Nexus user] ********************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus service for SystemD] *********************************************************************************************************
changed: [nexus-01]

TASK [Ensure Nexus service is enabled for SystemD] **********************************************************************************************
changed: [nexus-01]

TASK [Create Nexus vmoptions] *******************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus properties] ******************************************************************************************************************
changed: [nexus-01]

TASK [Lower Nexus disk space threshold] *********************************************************************************************************
skipping: [nexus-01]

TASK [Start Nexus service if enabled] ***********************************************************************************************************
changed: [nexus-01]

TASK [Ensure Nexus service is restarted] ********************************************************************************************************
skipping: [nexus-01]

TASK [Wait for Nexus port if started] ***********************************************************************************************************
ok: [nexus-01]

PLAY RECAP **************************************************************************************************************************************
nexus-01                   : ok=17   changed=11   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
sonar-01                   : ok=32   changed=9    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0 
</details>

5. Проверьте готовность SonarQube через браузер.
6. Зайдите под admin\admin, поменяйте пароль на свой.
7. Проверьте готовность Nexus через бразуер.
8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

### Знакомоство с SonarQube

### Основная часть

1. Создайте новый проект, название произвольное.
2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте sonar-scanner --version.
```
┌──(root㉿kali)-[/home/…/devops-netology/09-ci-03-cicd/infrastructure/sonar-scanner-4.8.0.2856-linux]
└─# sonar-scanner --version
INFO: Scanner configuration file: /home/kali/lesson/devops-netology/09-ci-03-cicd/infrastructure/sonar-scanner-4.8.0.2856-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.8.0.2856
INFO: Java 11.0.17 Eclipse Adoptium (64-bit)
INFO: Linux 6.0.0-kali6-amd64 amd64
```
5. Запустите анализатор против кода из директории example с дополнительным ключом -Dsonar.coverage.exclusions=fail.py.

<details>
<summary>└─# sonar-scanner</summary>
┌──(root㉿kali)-[/home/…/lesson/devops-netology/09-ci-03-cicd/example]
└─# sonar-scanner \
  -Dsonar.projectKey=netology \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://158.160.6.92:9000 \
  -Dsonar.login=fab94eddadcf5e78ef6c28c6282c37b1d8754ca3                                                                                           -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /home/kali/lesson/devops-netology/09-ci-03-cicd/infrastructure/sonar-scanner-4.8.0.2856-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.8.0.2856
INFO: Java 11.0.17 Eclipse Adoptium (64-bit)
INFO: Linux 6.0.0-kali6-amd64 amd64
INFO: User cache: /root/.sonar/cache
INFO: Analyzing on SonarQube server 9.1.0
INFO: Default locale: "en_US", source code encoding: "UTF-8" (analysis is platform dependent)
INFO: Load global settings
INFO: Load global settings (done) | time=176ms
INFO: Server id: 9CFC3560-AYlKaUks8Gy3rwWdVWs2
INFO: User cache: /root/.sonar/cache
INFO: Load/download plugins
INFO: Load plugins index
INFO: Load plugins index (done) | time=73ms
INFO: Load/download plugins (done) | time=172ms
INFO: Process project properties
INFO: Process project properties (done) | time=22ms
INFO: Execute project builders
INFO: Execute project builders (done) | time=4ms
INFO: Project key: netology
INFO: Base dir: /home/kali/lesson/devops-netology/09-ci-03-cicd/example
INFO: Working dir: /home/kali/lesson/devops-netology/09-ci-03-cicd/example/.scannerwork
INFO: Load project settings for component key: 'netology'
INFO: Load project settings for component key: 'netology' (done) | time=64ms
INFO: Load quality profiles
INFO: Load quality profiles (done) | time=119ms
INFO: Load active rules
INFO: Load active rules (done) | time=2593ms
INFO: Indexing files...
INFO: Project configuration:
INFO:   Excluded sources for coverage: fail.py
INFO: 1 file indexed
INFO: 0 files ignored because of scm ignore settings
INFO: Quality profile for py: Sonar way
INFO: ------------- Run sensors on module netology
INFO: Load metrics repository
INFO: Load metrics repository (done) | time=83ms
INFO: Sensor Python Sensor [python]
WARN: Your code is analyzed as compatible with python 2 and 3 by default. This will prevent the detection of issues specific to python 2 or python 3. You can get a more precise analysis by setting a python version in your configuration via the parameter "sonar.python.version"
INFO: Starting global symbols computation
INFO: 1 source file to be analyzed
INFO: Load project repositories
INFO: Load project repositories (done) | time=54ms
INFO: 1/1 source file has been analyzed
INFO: Starting rules execution
INFO: 1 source file to be analyzed
INFO: 1/1 source file has been analyzed
INFO: Sensor Python Sensor [python] (done) | time=982ms
INFO: Sensor Cobertura Sensor for Python coverage [python]
INFO: Sensor Cobertura Sensor for Python coverage [python] (done) | time=5ms
INFO: Sensor PythonXUnitSensor [python]
INFO: Sensor PythonXUnitSensor [python] (done) | time=1ms
INFO: Sensor CSS Rules [cssfamily]
INFO: No CSS, PHP, HTML or VueJS files are found in the project. CSS analysis is skipped.
INFO: Sensor CSS Rules [cssfamily] (done) | time=1ms
INFO: Sensor JaCoCo XML Report Importer [jacoco]
INFO: 'sonar.coverage.jacoco.xmlReportPaths' is not defined. Using default locations: target/site/jacoco/jacoco.xml,target/site/jacoco-it/jacoco.xml,build/reports/jacoco/test/jacocoTestReport.xml
INFO: No report imported, no coverage information will be imported by JaCoCo XML Report Importer
INFO: Sensor JaCoCo XML Report Importer [jacoco] (done) | time=3ms
INFO: Sensor C# Project Type Information [csharp]
INFO: Sensor C# Project Type Information [csharp] (done) | time=0ms
INFO: Sensor C# Analysis Log [csharp]
INFO: Sensor C# Analysis Log [csharp] (done) | time=24ms
INFO: Sensor C# Properties [csharp]
INFO: Sensor C# Properties [csharp] (done) | time=0ms
INFO: Sensor JavaXmlSensor [java]
INFO: Sensor JavaXmlSensor [java] (done) | time=1ms
INFO: Sensor HTML [web]
INFO: Sensor HTML [web] (done) | time=3ms
INFO: Sensor VB.NET Project Type Information [vbnet]
INFO: Sensor VB.NET Project Type Information [vbnet] (done) | time=0ms
INFO: Sensor VB.NET Analysis Log [vbnet]
INFO: Sensor VB.NET Analysis Log [vbnet] (done) | time=23ms
INFO: Sensor VB.NET Properties [vbnet]
INFO: Sensor VB.NET Properties [vbnet] (done) | time=0ms
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=5ms
INFO: SCM Publisher SCM provider for this project is: git
INFO: SCM Publisher 1 source file to be analyzed
INFO: SCM Publisher 1/1 source file have been analyzed (done) | time=217ms
INFO: CPD Executor Calculating CPD for 1 file
INFO: CPD Executor CPD calculation finished (done) | time=9ms
INFO: Analysis report generated in 120ms, dir size=103.0 kB
INFO: Analysis report compressed in 61ms, zip size=14.4 kB
INFO: Analysis report uploaded in 93ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://158.160.6.92:9000/dashboard?id=netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://158.160.6.92:9000/api/ce/task?id=AYlKsuTLAoU1PTOFhWfR
INFO: Analysis total time: 6.749 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 8.291s
INFO: Final Memory: 9M/156M
INFO: ------------------------------------------------------------------------
</details>

6. Посмотрите результат в интерфейсе.

![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-03-cicd-1.jpg)

7. Исправьте ошибки, которые он выявил, включая warnings.
8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.
![Ссылка 2](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-03-cicd-2.jpg)
9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.

### Знакомство с Nexus

### Основная часть

1. В репозиторий maven-public загрузите артефакт с GAV-параметрами:
- groupId: netology;
- artifactId: java;
- version: 8_282;
- classifier: distrib;
- type: tar.gz.

2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.
4. В ответе пришлите файл maven-metadata.xml для этого артефекта.

[maven-metadata.xml](https://github.com/Firewal7/devops-netology/blob/main/09-ci-03-cicd/infrastructure/files/maven-metadata.xml)

### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с maven.
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из apache-maven-<version>/conf/settings.xml упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте mvn --version.
```
┌──(root㉿kali)-[/home/…/09-ci-03-cicd/infrastructure/apache-maven-3.9.3/bin]
└─#  mvn --version 
Apache Maven 3.9.3 (21122926829f1ead511c958d89bd2f672198ae9f)
Maven home: /home/kali/lesson/devops-netology/09-ci-03-cicd/infrastructure/apache-maven-3.9.3
Java version: 17.0.6, vendor: Debian, runtime: /usr/lib/jvm/java-17-openjdk-amd64
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "6.0.0-kali6-amd64", arch: "amd64", family: "unix"
```
5. Заберите директорию mvn с pom.

### Основная часть

1. Поменяйте в pom.xml блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).
2. Запустите команду mvn package в директории с pom.xml, ожидайте успешного окончания.
```
┌──(root㉿kali)-[/home/…/09-ci-03-cicd/infrastructure/apache-maven-3.9.3/bin]
└─#  mvn package
[INFO] Scanning for projects...
[INFO]
[INFO] --------------------< com.netology.app:simple-app >---------------------
[INFO] Building simple-app 1.0-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/3.3.0/maven-resources-plugin-3.3.0.pom
-------------------------------------------------------------------------------
--------------------------------ВЫВОД ПРОПУЩЕН---------------------------------
-------------------------------------------------------------------------------
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar (1.0 MB at 3.1 MB/s)
[WARNING] JAR will be empty - no content was marked for inclusion!
[INFO] Building jar: /home/kali/lesson/devops-netology/09-ci-03-cicd/infrastructure/apache-maven-3.9.3/simple-app-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  12.135 s
[INFO] Finished at: 2023-07-13T12:30:16-04:00
[INFO] ------------------------------------------------------------------------
```
3. Проверьте директорию ~/.m2/repository/, найдите ваш артефакт.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/09-ci-03-cicd]
└─# ls ~/.m2/repository/netology/java/8_282/
total 16
-rw-r--r-- 1 root root 835 Mar 13 22:13 java-8_282-distrib.tar.gz
-rw-r--r-- 1 root root  40 Mar 13 22:13 java-8_282-distrib.tar.gz.sha1
-rw-r--r-- 1 root root 390 Mar 13 22:13 java-8_282.pom.lastUpdated
-rw-r--r-- 1 root root 175 Mar 13 22:13 _remote.repositories
```
4. В ответе пришлите исправленный файл pom.xml.

[pom.xml](https://github.com/Firewal7/devops-netology/blob/main/09-ci-03-cicd/pom.xml)