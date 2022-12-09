# devops-netology

### Домашняя работа *Бортников С.В.*

#### файлы будут проигнорированы в будущем благодаря добавленному .gitignore

1. Любые файлы с расширением tfstate
1. Любые файлы содержащие в имени tfstate с любым расширением
1. файл crash.log 
1. Файлы начинающиеся на crash. с расширением log
1. Все файлы с расмширением tfvars
1. Все файлы с расмширением tfvars.json
1. Файл override.tf
1. Файл override.tf.json
1. Любой файл в конце имени которого _override.tg
1. Любой файл в конце имени которого _override.tg.json
1. скрытый конфигурационный файл terraformrc
1. Файл terraform.rc

### Домашнее задание к занятию "2.4 Инструменты Git"

#### **1.** Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
aefead2207ef7e2aa5dc81a34aedf0cad4c32545
- (команда: git show aefea)
#### **2.** Какому тегу соответствует коммит 85024d3?
commit 85024d3100126de36331c6982bfaac02cdab9e76 **(tag: v0.12.23)**
- (Команда git show 85024d3)

#### **3.** Сколько родителей у коммита b8d720? Напишите их хеши.
Два родителя:
1. 56cd7859e05c36c06b56d013b55a252d0bb7e158
1. 9ea88f22fc6269854151c571162c5bcf958bee2b

- (Команда: git show b8d720^
) 
- (Команда: git show b8d720^2
)

#### **4** Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
1. 33ff1c03bb **(tag: v0.12.24) v0.12.24**
2. b14b74c493 [Website] vmc provider links
1. 3f235065b9 Update CHANGELOG.md 
2. 6ae64e247b registry: Fix panic when server is unreachable
1. 5c619ca1ba website: Remove links to the getting started guide's old location
1. 06275647e2 Update CHANGELOG.md
1. d5f9411f51 command: Fix bug when using terraform login on Windows
1. 4b6d06cc5d Update CHANGELOG.md
1. dd01a35078 Update CHANGELOG.md
1. 225466bc3e Cleanup after **v0.12.23 release**

- (Команда: git log ^v0.12.23 v0.12.24 --oneline)

#### **5.** Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточия перечислены аргументы).
8c928e83589d90a031f811fae52a81be7153e82f

- (Команда: git log -S'func providerSource' --oneline)


