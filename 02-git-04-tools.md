## Домашнее задание к занятию «Инструменты Git»
 
### Задание

В клонированном репозитории:

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
```
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

```
2. Какому тегу соответствует коммит 85024d3?
```
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git show 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 20:56:10 2020 +0000

    v0.12.23
```
3. Сколько родителей у коммита b8d720? Напишите их хеши.
```
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git show --pretty=format:' %P' b8d720
 56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b
```
4. Перечислите хеши и комментарии всех коммитов, которые были сделаны между тегами v0.12.23 и v0.12.24.
```
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git log v0.12.23..v0.12.24 --oneline
33ff1c03bb (tag: v0.12.24) v0.12.24
b14b74c493 [Website] vmc provider links
3f235065b9 Update CHANGELOG.md
6ae64e247b registry: Fix panic when server is unreachable
5c619ca1ba website: Remove links to the getting started guide's old location
06275647e2 Update CHANGELOG.md
d5f9411f51 command: Fix bug when using terraform login on Windows
4b6d06cc5d Update CHANGELOG.md
dd01a35078 Update CHANGELOG.md
225466bc3e Cleanup after v0.12.23 release
```
5. Найдите коммит, в котором была создана функция func providerSource, её определение в коде выглядит так: func providerSource(...) (вместо троеточия перечислены аргументы).
```
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git log -S'func providerSource(' --oneline
8c928e8358 main: Consult local directories as potential mirrors of providers
```
6. Найдите все коммиты, в которых была изменена функция globalPluginDirs.
```
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git grep 'func globalPluginDirs(.*)'
plugins.go:func globalPluginDirs() []string {
                                                                                        
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git log -L :globalPluginDirs:plugins.go  -s --oneline
78b1220558 Remove config.go and update things using its aliases
52dbf94834 keep .terraform.d/plugins for discovery
41ab0aef7a Add missing OS_ARCH dir to global plugin paths
66ebff90cd move some more plugin search path logic to command
8364383c35 Push plugin discovery down into command package
```
7. Кто автор функции synchronizedWriters?
```
┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git log -S'func synchronizedWriters' --oneline
bdfea50cc8 remove unused
5ac311e2a9 main: synchronize writes to VT100-faker on Windows

┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git checkout 5ac311e2a

┌──(root㉿kali)-[/home/kali/lesson/02-02-git/terraform]
└─# git blame -L 15,15 synchronized_writers.go
5ac311e2a91 (Martin Atkins 2017-05-03 16:25:41 -0700 15) func synchronizedWriters(targets ...io.Writer) []io.Writer {
```

В качестве решения ответьте на вопросы и опишите, как были получены эти ответы.