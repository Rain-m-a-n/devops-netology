## Домашнее задание к занятию «2.4. Инструменты Git»


#### **1.** Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea

aefead2207ef7e2aa5dc81a34aedf0cad4c32545

- (команда: git show aefea)

#### **2.** Какому тегу соответствует коммит 85024d3?

commit 85024d3100126de36331c6982bfaac02cdab9e76 **(tag: v0.12.23)**

- (Команда git show 85024d3)

#### **3.** Сколько родителей у коммита b8d720? Напишите их хеши

Два родителя:

1. 56cd7859e05c36c06b56d013b55a252d0bb7e158
1. 9ea88f22fc6269854151c571162c5bcf958bee2b

- (Команда: git show b8d720^
)
- (Команда: git show b8d720^2
)

#### **4** Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24

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

#### **5.** Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточия перечислены аргументы)

8c928e83589d90a031f811fae52a81be7153e82f

- (Команда: git log -S'func providerSource' --oneline)

#### **6.** Найдите все коммиты в которых была изменена функция globalPluginDirs
> **78b1220558** Remove config.go and update things using its aliases  
> **52dbf94834** keep .terraform.d/plugins for discovery  
> **41ab0aef7a** Add missing OS_ARCH dir to global plugin paths  
> **66ebff90cd** move some more plugin search path logic to command  
> **8364383c35** Push plugin discovery down into command package  

- (команды: )
    1. **git grep -c 'globalPluginDirs'**- отбирает и показывает количество совпадений в файлах  
    1. **git log -s -L :globalPluginDirs:plugins.go --oneline** - выводит коммиты в в которых изменялась указанная функция  

#### **7.** Кто автор функции synchronizedWriters?

- (Команды:) 
    1. **git log -S 'synchronizedWriters' --oneline** - выводит коммиты, в которых есть совпадения с указанно функцией. Берём самый нижний.   
    1. **git show 5ac311e2a9 -s --pretty=%an** -  выводит автора коммита.
    
