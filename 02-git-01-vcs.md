## Домашнее задание к занятию "Системы контроля версий"
 

### Задача 1. Создать и настроить репозиторий для дальнейшей работы на курсе.

В рамках курса вы будете писать скрипты и создавать конфигурации для различных систем, которые необходимо сохранять для будущего использования. Сначала надо создать и настроить локальный репозиторий, после чего добавить удалённый репозиторий на GitHub.

### Создание репозитория и первого коммита.

1. Зарегистрируйте аккаунт на https://github.com/. Если предпочитаете другое хранилище для репозитория, можно использовать его.

2. Создайте публичный репозиторий, который будете использовать дальше на протяжении всего курса, желательное с названием devops-netology. Обязательно поставьте галочку Initialize this repository with a README.

![Скриншот](https://github.com/Firewal7/devops-netology/blob/main/image/02-01-git-1.jpg)

3. Создайте авторизационный токен для клонирования репозитория.

![Скриншот](https://github.com/Firewal7/devops-netology/blob/main/image/02-01-git-2.jpg)


4. Склонируйте репозиторий, используя протокол HTTPS (git clone ...).
```
┌──(root㉿kali)-[/home/kali/lesson]
└─# git clone https://github.com/Firewal7/devops-netology.git
Cloning into 'devops-netology'...
remote: Enumerating objects: 32, done.
remote: Counting objects: 100% (32/32), done.
remote: Compressing objects: 100% (24/24), done.
remote: Total 32 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (32/32), 51.09 KiB | 670.00 KiB/s, done.
```
5. Перейдите в каталог с клоном репозитория (cd devops-netology).

6. Произведите первоначальную настройку Git, указав своё настоящее имя, чтобы нам было проще общаться, и email (git config --global user.name и git config --global user.email johndoe@example.com).
```
└─# git config -l
credential.helper=wincred
alias.c=config
user.email=sofinra@yandex.ru
user.name=Firewal7
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
remote.origin.url=https://github.com/Firewal7/devops-netology.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.main.remote=origin
branch.main.merge=refs/heads/main
```
7. Выполните команду git status и запомните результат.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```
8. Отредактируйте файл README.md любым удобным способом, тем самым переведя файл в состояние Modified.

9. Ещё раз выполните git status и продолжайте проверять вывод этой команды после каждого следующего шага.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```
10. Теперь посмотрите изменения в файле README.md, выполнив команды git diff и git diff --staged.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git diff
diff --git a/README.md b/README.md
index 8b13789..d00491f 100644
--- a/README.md
+++ b/README.md
@@ -1 +1 @@
-
+1

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git diff --staged
```
11. Переведите файл в состояние staged (или, как говорят, просто добавьте файл в коммит) командой git add README.md.
```┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git add README.md
```
12. И ещё раз выполните команды git diff и git diff --staged. Поиграйте с изменениями и этими командами, чтобы чётко понять, что и когда они отображают.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git diff

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git diff --staged
diff --git a/README.md b/README.md
index 8b13789..d00491f 100644
--- a/README.md
+++ b/README.md
@@ -1 +1 @@
-
+1
```
13. Теперь можно сделать коммит git commit -m 'First commit'.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'First commit'
[main c7c9329] First commit
 1 file changed, 1 insertion(+), 1 deletion(-)
```
14. И ещё раз посмотреть выводы команд git status, git diff и git diff --staged.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git diff

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git diff --staged
```
### Создание файлов .gitignore и второго коммита.

1. Создайте файл .gitignore (обратите внимание на точку в начале файла), проверьте его статус сразу после создания.
2. Добавьте файл .gitignore в следующий коммит (git add...).
3. На одном из следующих блоков вы будете изучать Terraform, давайте сразу создадим соотвествующий каталог terraform и внутри этого каталога — файл .gitignore по примеру: https://github.com/github/gitignore/blob/master/Terraform.gitignore.
4. В файле README.md опишите своими словами, какие файлы будут проигнорированы в будущем благодаря добавленному .gitignore.
5. Закоммитьте все новые и изменённые файлы. Комментарий к коммиту должен быть Added gitignore.
```
──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'Added gitignore'
[main 3cb8c43] Added gitignore
 2 files changed, 43 insertions(+), 1 deletion(-)
 create mode 100644 .gitignore
```
### Эксперимент с удалением и перемещением файлов (третий и четвёртый коммит).

1. Создайте файлы will_be_deleted.txt (с текстом will_be_deleted) и will_be_moved.txt (с текстом will_be_moved) и закоммите их с комментарием Prepare to delete and move.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'Prepare to delete and move'
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        will_be_deleted.txt
        will_be_moved.txt

nothing added to commit but untracked files present (use "git add" to track)
```
2. В случае необходимости обратитесь к официальной документации — здесь подробно описано, как выполнить следующие шаги.
3. Удалите файл will_be_deleted.txt с диска и из репозитория.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git rm will_be_deleted.txt
rm 'will_be_deleted.txt'

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        deleted:    will_be_deleted.txt
```
4. Переименуйте (переместите) файл will_be_moved.txt на диске и в репозитории, чтобы он стал называться has_been_moved.txt.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git mv will_be_moved.txt has_been_moved.txt

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        renamed:    will_be_moved.txt -> has_been_moved.txt
```
5. Закоммитьте результат работы с комментарием Moved and deleted.
```
──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git add .

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'Moved and deleted'
[main 4473d6f] Moved and deleted
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename will_be_moved.txt => has_been_moved.txt (100%)

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git push
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 244 bytes | 244.00 KiB/s, done.
Total 2 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To https://github.com/Firewal7/devops-netology
   ebe246f..4473d6f  main -> main
```




