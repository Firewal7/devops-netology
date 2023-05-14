## Домашнее задание к занятию «Основы Git»
 
### Задание 1. Знакомимся с GitLab и Bitbucket

#### GitLab

Создадим аккаунт в GitLab, если у вас его ещё нет:

1. GitLab. Для регистрации можно использовать аккаунт Google, GitHub и другие.
2. После регистрации или авторизации в GitLab создайте новый проект, нажав на ссылку Create a projet. Желательно назвать также, как и в GitHub — devops-netology и visibility level, выбрать Public.
3. Галочку Initialize repository with a README лучше не ставить, чтобы не пришлось разрешать конфликты.
4. Если вы зарегистрировались при помощи аккаунта в другой системе и не указали пароль, то увидите сообщение: You won't be able to pull or push project code via HTTPS until you set a password on your account. Тогда перейдите по ссылке из этого сообщения и задайте пароль. Если вы уже умеете пользоваться SSH-ключами, то воспользуйтесь этой возможностью (подробнее про SSH мы поговорим в следующем учебном блоке).
5. Перейдите на страницу созданного вами репозитория, URL будет примерно такой: https://gitlab.com/YOUR_LOGIN/devops-netology. Изучите предлагаемые варианты для начала работы в репозитории в секции Command line instructions.
6. Запомните вывод команды git remote -v.
7. Из-за того, что это будет наш дополнительный репозиторий, ни один вариант из перечисленных в инструкции (на странице вновь созданного репозитория) нам не подходит. Поэтому добавляем этот репозиторий, как дополнительный remote, к созданному репозиторию в рамках предыдущего домашнего задания: git remote add gitlab https://gitlab.com/YOUR_LOGIN/devops-netology.git.
8. Отправьте изменения в новый удалённый репозиторий git push -u gitlab main.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git push -u gitlab main
git: 'credential-wincred' is not a git command. See 'git --help'.
Username for 'https://gitlab.com': Firewal7
Password for 'https://Firewal7@gitlab.com': 
git: 'credential-wincred' is not a git command. See 'git --help'.
Enumerating objects: 359, done.
Counting objects: 100% (359/359), done.
Compressing objects: 100% (202/202), done.
Writing objects: 100% (359/359), 2.32 MiB | 1.97 MiB/s, done.
Total 359 (delta 115), reused 359 (delta 115), pack-reused 0
remote: Resolving deltas: 100% (115/115), done.
To https://gitlab.com/Firewal7/devops-netology.git
 * [new branch]      main -> main
branch 'main' set up to track 'gitlab/main'.
```
9. Обратите внимание, как изменился результат работы команды git remote -v.

Если всё проделано правильно, то результат команды git remote -v должен быть следующий:
```
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/devops-netology]
└─# git remote -v
gitlab  https://gitlab.com/Firewal7/devops-netology.git (fetch)
gitlab  https://gitlab.com/Firewal7/devops-netology.git (push)
origin  https://github.com/Firewal7/devops-netology.git (fetch)
origin  https://github.com/Firewal7/devops-netology.git (push)
```
Дополнительно можете добавить удалённые репозитории по ssh, тогда результат будет примерно такой:
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git remote -v                                                        
gitlab  https://gitlab.com/Firewal7/devops-netology.git (fetch)
gitlab  https://gitlab.com/Firewal7/devops-netology.git (push)
gitlab-ssh      git@gitlab.com:Firewal7/devops-netology.git (fetch)
gitlab-ssh      git@gitlab.com:Firewal7/devops-netology.git (push)
origin  https://github.com/Firewal7/devops-netology.git (fetch)
origin  https://github.com/Firewal7/devops-netology.git (push)
origin-ssh      git@github.com:Firewal7/devops-netology.git (fetch)
origin-ssh      git@github.com:Firewal7/devops-netology.git (push)
```
Выполните push локальной ветки main в новые репозитории.

Подсказка: git push -u gitlab main. На этом этапе история коммитов во всех трёх репозиториях должна совпадать.

### Задание 2. Теги

Представьте ситуацию, когда в коде была обнаружена ошибка — надо вернуться на предыдущую версию кода, исправить её и выложить исправленный код в продакшн. Мы никуда не будем выкладывать код, но пометим некоторые коммиты тегами и создадим от них ветки.

1. Создайте легковестный тег v0.0 на HEAD-коммите и запуште его во все три добавленных на предыдущем этапе upstream.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git tag v0.0    
                                                                                                
```
2. Аналогично создайте аннотированный тег v0.1.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git tag -a v0.1 -m "my version 0.1" 

┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git tag                            
v0.0
v0.1
```
3. Перейдите на страницу просмотра тегов в GitHab (и в других репозиториях) и посмотрите, чем отличаются созданные теги.
 - в GitHub — https://github.com/YOUR_ACCOUNT/devops-netology/releases;
 ![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/02-02-git-1.jpg)

 - в GitLab — https://gitlab.com/YOUR_ACCOUNT/devops-netology/-/tags;
 ![Ссылка 2](https://github.com/Firewal7/devops-netology/blob/main/image/02-02-git-2.jpg)


### Задание 3. Ветки

Давайте посмотрим, как будет выглядеть история коммитов при создании веток.

1. Переключитесь обратно на ветку main, которая должна быть связана с веткой main репозитория на github.
2. Посмотрите лог коммитов и найдите хеш коммита с названием Prepare to delete and move, который был создан в пределах предыдущего домашнего задания.
```
──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git log         
commit 15983c5960eea692ebfb7164294bf8a7bb149478 (HEAD -> main, tag: v0.1, tag: v0.0, origin/main, origin/HEAD, gitlab/main)
Author: Firewal7 <59724407+Firewal7@users.noreply.github.com>
Date:   Sat May 13 12:41:09 2023 +0500

    Add files via upload

commit f59289febc39099e34807b0be2d289e151e33866
Author: Firewal7 <59724407+Firewal7@users.noreply.github.com>
Date:   Wed May 3 22:32:37 2023 +0500

    Add files via upload

commit 0679dd0752d4e86cb01e9125eb4d2f1edb16c804
Author: Firewal7 <sofinra@yandex.ru>
Date:   Wed May 3 13:18:14 2023 -0400

     Prepare to delete and move

commit 48cd9ac934c85241a616ab40268682b7df1bbbc1 (tag: 08-ansible-02-playbook)
Author: Firewal7 <sofinra@yandex.ru>

zsh: suspended  git log
```
3. Выполните git checkout по хешу найденного коммита.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git checkout 0679dd0752d4e86cb01e9125eb4d2f1edb16c804
Note: switching to '0679dd0752d4e86cb01e9125eb4d2f1edb16c804'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 0679dd0 Initial commit
                                                                                                 
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git branch                                           
* (HEAD detached at 0679dd0)
  FETCH_HEAD
  main
```

4. Создайте новую ветку fix, базируясь на этом коммите git switch -c fix.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# sudo git checkout -b fix     
Switched to a new branch 'fix'
                                                                                                 
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git branch                                           
* fix
  main
```
5. Отправьте новую ветку в репозиторий на GitHub git push -u origin fix.
```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git push -u origin fix
git: 'credential-wincred' is not a git command. See 'git --help'.
Username for 'https://github.com': Firewal7
Password for 'https://Firewal7@github.com': 
git: 'credential-wincred' is not a git command. See 'git --help'.
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote: 
remote: Create a pull request for 'fix' on GitHub by visiting:
remote:      https://github.com/Firewal7/devops-netology/pull/new/fix
remote: 
To https://github.com/Firewal7/devops-netology.git
 * [new branch]      fix -> fix
branch 'fix' set up to track 'origin/fix'.
```
6. Посмотрите, как визуально выглядит ваша схема коммитов: https://github.com/YOUR_ACCOUNT/devops-netology/network.

 ![Ссылка 3](https://github.com/Firewal7/devops-netology/blob/main/image/02-02-git-3.jpg)

7. Теперь измените содержание файла README.md, добавив новую строчку.
8. Отправьте изменения в репозиторий и посмотрите, как изменится схема на странице https://github.com/YOUR_ACCOUNT/devops-netology/network и как изменится вывод команды git log.

 ![Ссылка 4](https://github.com/Firewal7/devops-netology/blob/main/image/02-02-git-4.jpg)

```
┌──(root㉿kali)-[/home/kali/lesson/devops-netology]
└─# git log 
commit cc6e2fbaeb30ecbb6b52e890d07966d5a9099a3c (HEAD -> fix, origin/fix)
Author: Roman Sofin <sofinra@yandex.ru>
Date:   Sat May 13 06:20:48 2023 -0400

    new commit

commit 0679dd0752d4e86cb01e9125eb4d2f1edb16c804
Author: Firewal7 <sofinra@yandex.ru>
Date:   Wed May 3 13:18:14 2023 -0400

    Prepare to delete and move

commit 48cd9ac934c85241a616ab40268682b7df1bbbc1 (tag: 08-ansible-02-playbook)
Author: Firewal7 <sofinra@yandex.ru>
Date:   Tue May 2 12:11:41 2023 -0400

    Initial commit

commit 686bdc3c5113f664e8248ad294b0313fc4536fe2
Author: Firewal7 <59724407+Firewal7@users.noreply.github.com>
Date:   Mon May 1 14:24:07 2023 +0500
```

### Задание 4. Упрощаем себе жизнь

Попробуем поработь с Git при помощи визуального редактора.

1. В используемой IDE PyCharm откройте визуальный редактор работы с Git, находящийся в меню View -> Tool Windows -> Git.
2. Измените какой-нибудь файл, и он сразу появится на вкладке Local Changes, отсюда можно выполнить коммит, нажав на кнопку внизу этого диалога.

 ![Ссылка 5](https://github.com/Firewal7/devops-netology/blob/main/image/02-02-git-5.jpg)

3. Элементы управления для работы с Git будут выглядеть примерно так:
4. Попробуйте выполнить пару коммитов, используя IDE.

Если вверху экрана выбрать свою операционную систему, можно посмотреть горячие клавиши для работы с Git. Подробней о визуальном интерфейсе мы расскажем на одной из следующих лекций.

В качестве результата работы по всем заданиям приложите ссылки на ваши репозитории в GitHub, GitLab и Bitbucket.
1. https://github.com/Firewal7/devops-netology
2. https://gitlab.com/Firewal7/devops-netology
