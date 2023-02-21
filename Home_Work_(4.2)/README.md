# Домашнее задание к занятию "Использование Python для решения типовых DevOps задач"

### Цель задания

В результате выполнения этого задания вы:

1. Познакомитесь с синтаксисом Python.
2. Узнаете, для каких типов задач его можно использовать.
3. Воспользуетесь несколькими модулями для работы с ОС.


### Инструкция к заданию

1. Установите Python 3 любой версии.
2. Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md).
3. Заполните недостающие части документа решением задач (заменяйте `???`, остальное в шаблоне не меняйте, чтобы не сломать форматирование текста, подсветку синтаксиса). Вместо логов можно вставить скриншоты по желанию.
4. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
5. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.

### Дополнительные материалы

[Полезные ссылки для модуля "Скриптовые языки и языки разметки"](https://github.com/netology-code/sysadm-homeworks/tree/devsys10/04-script-03-yaml/additional-info)

------

## Задание 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | значение присвоено не будет, нельзя складывать строку и число  |
| Как получить для переменной `c` значение 12?  | c = str(a) + b  |
| Как получить для переменной `c` значение 3?  | c = a + int(b)  |

------

## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
import os

bash_command = ["cd C:\\Netology\\git\\devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
path = os.getcwd()
#is_change = False  Лишняя переменная, нужно удалить
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + prepare_result)
#        break  # нужно удалить, т.к. прерывает цикл после первого найденного совпадения, поэтому не показывает другие изменения. 
```

### Вывод скрипта при запуске при тестировании:
```bash
PS C:\Netology\git\devops-netology> & C:/Users/bortnikovsv/AppData/Local/Microsoft/WindowsApps/python3.10.exe "c:/Netology/git/devops-netology/Home_Work_(4.2)/1.py"
C:\Netology\git\devops-netologyHome_Work_(3.1)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.2)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.3)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.4)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.5)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.6)/README.MD
C:\Netology\git\devops-netologyHome_Work_(3.7)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.8)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.9)/README.md
C:\Netology\git\devops-netologyHome_Work_(4.2)/README.md
PS C:\Netology\git\devops-netology> 
```

------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
import os

dir=input(str("введите директорию для поиска:"))
bash_command = [("cd" " "+ dir), "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
path = os.getcwd()

for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + prepare_result)
```

### Вывод скрипта при запуске при тестировании:
1. вводим произвольный каталог, где не инициализирован Git:
```bash
PS C:\Netology\git\devops-netology> & C:/Users/bortnikovsv/AppData/Local/Microsoft/WindowsApps/python3.10.exe "c:/Netology/git/devops-netology/Home_Work_(4.2)/1.py"
введите директорию для поиска:c:\windows
fatal: not a git repository (or any of the parent directories): .git
```
2. Вводим каталог, где инициализирован Git:
```bash
PS C:\Netology\git\devops-netology> & C:/Users/bortnikovsv/AppData/Local/Microsoft/WindowsApps/python3.10.exe "c:/Netology/git/devops-netology/Home_Work_(4.2)/1.py"
введите директорию для поиска:c:\netology\git\devops-netology
C:\Netology\git\devops-netologyHome_Work_(3.1)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.2)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.3)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.4)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.5)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.6)/README.MD
C:\Netology\git\devops-netologyHome_Work_(3.7)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.8)/README.md
C:\Netology\git\devops-netologyHome_Work_(3.9)/README.md
C:\Netology\git\devops-netologyHome_Work_(4.2)/README.md
PS C:\Netology\git\devops-netology> 
```
------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 
- опрашивает веб-сервисы, 
- получает их IP, 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
import time
import socket

site= ["drive.google.com", "mail.google.com", "google.com"]
#Определяем IP 
d=(socket.gethostbyname_ex(site[0]))[2]
m=(socket.gethostbyname_ex(site[1]))[2]
g=(socket.gethostbyname_ex(site[2]))[2]

#Преобразуем в число
drive=str(d)[2:-2]
mail=str(m)[2:-2]
goog=str(g)[2:-2]

while True:
    print("******************************************")
    for test in site:
        new_addr=socket.gethostbyname_ex(test)[2]
        if new_addr ==d:
            print(f"drive.google.com\t" , "-", drive)
        elif new_addr == m:
            print (f"mail.google.com\t\t" , "-", mail)
        elif new_addr == g:
            print (f"google.com\t\t" , "-", goog)
        else:
            if test == site[0]:
                print (f"[ERROR]", test, "IP mismatch:", d, ">", new_addr)
            elif test == site[1]:
                print (f"[ERROR]", test, "IP mismatch:", m, ">", new_addr)
            elif test == site[2]:
                print (f"[ERROR]", test, "IP mismatch:", m, ">", new_addr)
            else:
               break
    print("******************************************\n")
    time.sleep(10)
```

### Вывод скрипта при запуске при тестировании:
```bash
PS C:\Netology\git\devops-netology> & C:/Users/bortnikovsv/AppData/Local/Microsoft/WindowsApps/python3.10.exe "c:/Netology/git/devops-netology/Home_Work_(4.2)/2.py"
drive.google.com         - 142.251.140.78
mail.google.com          - 142.250.187.101
google.com               - 142.250.187.142
******************************************
drive.google.com         - 142.251.140.78
mail.google.com          - 142.250.187.101
google.com               - 142.250.187.142
******************************************
drive.google.com         - 142.251.140.78
mail.google.com          - 142.250.187.101
google.com               - 142.250.187.142
******************************************
```

------

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз: 
* переносить архив с нашими изменениями с сервера на наш локальный компьютер, 
* формировать новую ветку, 
* коммитить в неё изменения, 
* создавать pull request (PR) 
* и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. 

Мы хотим максимально автоматизировать всю цепочку действий. 
* Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым).
* При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. 
* С директорией локального репозитория можно делать всё, что угодно. 
* Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. 

Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```

----

