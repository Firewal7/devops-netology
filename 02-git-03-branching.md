## Домашнее задание к занятию «Ветвления в Git»
 
### Задание «Ветвление, merge и rebase»

Шаг 1. Предположим, что есть задача — написать скрипт, выводящий на экран параметры его запуска. Давайте посмотрим, как будет отличаться работа над этим скриптом с использованием ветвления, merge и rebase.

Создайте в своём репозитории каталог branching и в нём два файла — merge.sh и rebase.sh — с содержимым:
```
#!/bin/bash
# display command line options

count=1
for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1 ))
done
```
Этот скрипт отображает на экране все параметры одной строкой, а не разделяет их.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# ls -la
total 8
drwxr-xr-x  2 root root 4096 May 14 09:35 .
drwxr-xr-x 10 root root 4096 May 14 09:33 ..
-rw-r--r--  1 root root    0 May 14 09:35 merge.sh
-rw-r--r--  1 root root    0 May 14 09:35 rebase.sh
```

Шаг 2. Создадим коммит с описанием prepare for merge and rebase и отправим его в ветку main.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git add *                                   
                                                                                                 
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'prepare for merge and rebase'
[main 7d23527] prepare for merge and rebase
 2 files changed, 16 insertions(+)
 create mode 100644 branching/merge.sh
 create mode 100644 branching/rebase.sh
```

### Подготовка файла merge.sh

Шаг 1. Создайте ветку git-merge.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git checkout -b git-merge                   
Switched to a new branch 'git-merge'
                                                                                  
```
Шаг 2. Замените в ней содержимое файла merge.sh на:
```
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done
```
Шаг 3. Создайте коммит merge: @ instead *, отправьте изменения в репозиторий.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'merge: @ instead *'
[git-merge 1b1e54a] merge: @ instead *
 1 file changed, 2 insertions(+), 2 deletions(-)

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git push origin git-merge
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Compressing objects: 100% (8/8), done.
Writing objects: 100% (8/8), 804 bytes | 804.00 KiB/s, done.
Total 8 (delta 3), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (3/3), completed with 1 local object.
remote: 
remote: Create a pull request for 'git-merge' on GitHub by visiting:
remote:      https://github.com/Firewal7/devops-netology/pull/new/git-merge
remote: 
To https://github.com/Firewal7/devops-netology.git
 * [new branch]      git-merge -> git-merge
```
Шаг 4. Разработчик подумал и решил внести ещё одно изменение в merge.sh:
```
#!/bin/bash
# display command line options

count=1
while [[ -n "$1" ]]; do
    echo "Parameter #$count = $1"
    count=$(( $count + 1 ))
    shift
done
```

Теперь скрипт будет отображать каждый переданный ему параметр отдельно.

Шаг 5. Создайте коммит merge: use shift и отправьте изменения в репозиторий.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'merge: use shift'  
[git-merge 653c0d8] merge: use shift
 1 files changed, 3 insertions(+), 2 deletions(-)
                                                                                               
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git push origin git-merge       
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 459 bytes | 459.00 KiB/s, done.
Total 4 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To https://github.com/Firewal7/devops-netology.git
   1b1e54a..653c0d8  git-merge -> git-merge
```


### Изменим main

Шаг 1. Вернитесь в ветку main. Шаг 2. Предположим, что пока мы работали над веткой git-merge, кто-то изменил main. Для этого изменим содержимое файла rebase.sh на:
```
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "\$@ Parameter #$count = $param"
    count=$(( $count + 1 ))
done

echo "====="
```
В этом случае скрипт тоже будет отображать каждый параметр в новой строке.

Шаг 3. Отправляем изменённую ветку main в репозиторий.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git push origin main     
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/Firewal7/devops-netology.git
   ac171c8..7d23527  main -> main
```

### Подготовка файла rebase.sh

Шаг 1. Предположим, что теперь другой участник нашей команды не сделал git pull либо просто хотел ответвиться не от последнего коммита в main, а от коммита, когда мы только создали два файла merge.sh и rebase.sh на первом шаге.
Для этого при помощи команды git log найдём хеш коммита prepare for merge and rebase и выполним git checkout на него так: git checkout 8baf217e80ef17ff577883fda90f6487f67bbcea (хеш будет другой).
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git checkout 7d235275c758acd0c3da94586b7f9c7b1b1aee54
M       branching/rebase.sh
Note: switching to '7d235275c758acd0c3da94586b7f9c7b1b1aee54'.

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git branch                                           
* (HEAD detached at 7d23527)
  FETCH_HEAD
  fix
  git-merge
  main
```

 Шаг 2. Создадим ветку git-rebase, основываясь на текущем коммите. 
 ```
 ┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git checkout -b git-rebase                           
Switched to a new branch 'git-rebase'
 ```

 Шаг 3. И изменим содержимое файла rebase.sh на следующее, тоже починив скрипт, но немного в другом стиле:
```
#!/bin/bash
# display command line options

count=1
for param in "$@"; do
    echo "Parameter: $param"
    count=$(( $count + 1 ))
done

echo "====="
```
Шаг 4. Отправим эти изменения в ветку git-rebase с комментарием git-rebase 1.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'git-rebase 1'    
[git-rebase 66b9ece] git-rebase 1
 1 file changed, 4 insertions(+), 2 deletions(-)
```
Шаг 5. И сделаем ещё один коммит git-rebase 2 с пушем, заменив echo "Parameter: $param" на echo "Next parameter: $param".
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git commit -m 'git-rebase 2'
[git-rebase de7659e] git-rebase 2
 1 file changed, 1 insertion(+), 1 deletion(-)

 ┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git push origin git-rebase  
Enumerating objects: 11, done.
Counting objects: 100% (11/11), done.
Compressing objects: 100% (8/8), done.
Writing objects: 100% (8/8), 772 bytes | 154.00 KiB/s, done.
Total 8 (delta 3), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (3/3), completed with 1 local object.
remote: 
remote: Create a pull request for 'git-rebase' on GitHub by visiting:
remote:      https://github.com/Firewal7/devops-netology/pull/new/git-rebase
remote: 
To https://github.com/Firewal7/devops-netology.git
 * [new branch]      git-rebase -> git-rebase
```

### Промежуточный итог

Мы сэмулировали типичную ситуации в разработке кода, когда команда разработчиков работала над одним и тем же участком кода, и кто-то из разработчиков предпочитает делать merge, а кто-то — rebase. Конфликты с merge обычно решаются просто, а с rebase бывают сложности, поэтому давайте смержим все наработки в main и разрешим конфликты.

Если всё было сделано правильно, то на странице network в GitHub, находящейся по адресу https://github.com/ВАШ_ЛОГИН/ВАШ_РЕПОЗИТОРИЙ/network, будет примерно такая схема:

![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/02-git-03-branching-1.jpg)

### Merge

Сливаем ветку git-merge в main и отправляем изменения в репозиторий, должно получиться без конфликтов:
```
$ git merge git-merge
Merge made by the 'recursive' strategy.
 branching/merge.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
$ git push
#!/bin/bash
Enumerating objects: 1, done.
Counting objects: 100% (1/1), done.
Writing objects: 100% (1/1), 223 bytes | 223.00 KiB/s, done.
Total 1 (delta 0), reused 0 (delta 0), pack-reused 0
```
В результате получаем такую схему:

![Ссылка 2](https://github.com/Firewal7/devops-netology/blob/main/image/02-git-03-branching-2.jpg)

### Rebase

Шаг 1. Перед мержем ветки git-rebase выполним её rebase на main. Да, мы специально создали ситуацию с конфликтами, чтобы потренироваться их решать. Шаг 2. Переключаемся на ветку git-rebase и выполняем git rebase -i main. В открывшемся диалоге должно быть два выполненных коммита, давайте заодно объединим их в один, указав слева от нижнего fixup. В результате получаем:
```
$ git rebase -i main
Auto-merging branching/rebase.sh
CONFLICT (content): Merge conflict in branching/rebase.sh
error: could not apply dc4688f... git 2.3 rebase @ instead *
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply dc4688f... git 2.3 rebase @ instead *
```
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git rebase -i main
Auto-merging branching/rebase.sh
CONFLICT (content): Merge conflict in branching/rebase.sh
error: could not apply 66b9ece... git-rebase 1
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply 66b9ece... git-rebase 1
```
Если посмотреть содержимое файла rebase.sh, то увидим метки, оставленные Git для решения конфликта:
```
cat rebase.sh
#!/bin/bash
# display command line options
count=1
for param in "$@"; do
<<<<<<< HEAD
    echo "\$@ Parameter #$count = $param"
=======
    echo "Parameter: $param"
>>>>>>> dc4688f... git 2.3 rebase @ instead *
    count=$(( $count + 1 ))
done
```
Шаг 3. Удалим метки, отдав предпочтение варианту:
```
echo "\$@ Parameter #$count = $param"
```
Шаг 4. Сообщим Git, что конфликт решён git add rebase.sh и продолжим rebase git rebase --continue.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git add rebase.sh

┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git rebase --continue 
Auto-merging branching/rebase.sh
CONFLICT (content): Merge conflict in branching/rebase.sh
error: could not apply de7659e... git-rebase 2
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply de7659e... git-rebase 2
```
Шаг 5. Опять получим конфликт в файле rebase.sh при попытке применения нашего второго коммита. Давайте разрешим конфликт, оставив строчку echo "Next parameter: $param".

Шаг 6. Далее опять сообщаем Git о том, что конфликт разрешён — git add rebase.sh — и продолжим rebase — git rebase --continue.

В результате будет открыт текстовый редактор, предлагающий написать комментарий к новому объединённому коммиту:
```
# This is a combination of 2 commits.
# This is the 1st commit message:

Merge branch 'git-merge'

# The commit message #2 will be skipped:

# git 2.3 rebase @ instead * (2)
```
Все строчки, начинающиеся на #, будут проигнорированны.

После сохранения изменения Git сообщит:
```
Successfully rebased and updated refs/heads/git-rebase
```
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git add rebase.sh
                                                                                                 
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git rebase --continue
[detached HEAD 21f7f65] git-rebase 2
 1 file changed, 1 insertion(+), 1 deletion(-)
Successfully rebased and updated refs/heads/git-rebase.
```
Шаг 7. И попробуем выполнить git push либо git push -u origin git-rebase, чтобы точно указать, что и куда мы хотим запушить.

Эта команда завершится с ошибкой:
```
git push
To github.com:andrey-borue/devops-netology.git
 ! [rejected]        git-rebase -> git-rebase (non-fast-forward)
error: failed to push some refs to 'git@github.com:andrey-borue/devops-netology.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git push -u origin git-rebase
To https://github.com/Firewal7/devops-netology.git
 ! [rejected]        git-rebase -> git-rebase (non-fast-forward)
error: failed to push some refs to 'https://github.com/Firewal7/devops-netology.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
Это произошло, потому что мы пытаемся перезаписать историю.

Шаг 8. Чтобы Git позволил нам это сделать, добавим флаг force:
```
git push -u origin git-rebase -f
Enumerating objects: 10, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 12 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 443 bytes | 443.00 KiB/s, done.
Total 4 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:andrey-borue/devops-netology.git
 + 1829df1...e3b942b git-rebase -> git-rebase (forced update)
Branch 'git-rebase' set up to track remote branch 'git-rebase' from 'origin'.
```
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git push -u origin git-rebase -f
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 384 bytes | 384.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To https://github.com/Firewal7/devops-netology.git
 + de7659e...21f7f65 git-rebase -> git-rebase (forced update)
branch 'git-rebase' set up to track 'origin/git-rebase'.
```
Шаг 9. Теперь можно смержить ветку git-rebase в main без конфликтов и без дополнительного мерж-комита простой перемоткой:
```
$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

$ git merge git-rebase
Updating 6158b76..45893d1
Fast-forward
 branching/rebase.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
 ```

 ```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git checkout main
Switched to branch 'main'
Your branch is ahead of 'gitlab/main' by 1 commit.
  (use "git push" to publish your local commits)
                                                                                                 
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git branch                  
  FETCH_HEAD
  fix
  git-merge
  git-rebase
* main
                                                                                                 
┌──(root㉿kali)-[/home/kali/lesson/devops-netology/branching]
└─# git merge git-rebase
Updating 0543f10..21f7f65
Fast-forward
 branching/rebase.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 ```
В качестве результата работы по всем заданиям приложите ссылку на .md-файл в вашем репозитории.
