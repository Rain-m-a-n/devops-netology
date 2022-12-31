### Домашнее задание к занятию "3.2. Работа в терминале. Лекция 2"
1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа: опишите ход своих мыслей, если считаете, что она могла бы быть другого типа.
    * CD встроенная в оболочку команда, которая будет доступна при установке ОС, т.е. её не нужно будет дополнительно устанавливать из пакетов. 
1. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l?
    * grep -c ```<some string> <some_file>```
1. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
    * bortnik@prometeus:~$ **pstree -p**
      ```
      systemd(1)─┬─ModemManager(785)─┬─{ModemManager}(796)
                 │                   └─{ModemManager}(802)
                 ├─VGAuthService(716)
                 ├─agetty(938) 
      ```
    * родителем для всех процессов является **systemd**
1. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
    * **Команда:** ls -z 2> /dev/pts/1
    * **Результат** будет выведен на другом терминале:  
      ls: неверный ключ — «z»  
      По команде «ls --help» можно получить дополнительную информацию.
1. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.  
     * **Получится**
     * **Команда:** ```cat <file1.txt >file2.txt```
     * **Результат**
     ```
        bortnik@MyFirstVM:~$ cat file1.txt file2.txt
        test 1
        test2 
     ```
     ```
     bortnik@MyFirstVM:~$ cat <file1.txt >file2.txt
     bortnik@MyFirstVM:~$ cat file1.txt file2.txt
     test 1
     test2
     
     test 1
     test2
     ```
1. Получится ли, находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
    * **Получится** , но вывод в графическом режиме мы не увидим, необходимо будет переключиться ctrl+alt+F5 (на моём пк так).
    **Команда:**  ls -l /home/stas/ > /dev/tty5
1. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
    * **Команда** bash 5>&1:
      Создаёт новый дискриптор 5 и перенаправляет его в STDOUT  
      ```bortnik@centos:/proc$ ls -l /proc/$$/fd
      итого 0
      lrwx------ 1 bortnik bortnik 64 дек 29 15:04 0 -> /dev/pts/0
      lrwx------ 1 bortnik bortnik 64 дек 29 15:04 1 -> /dev/pts/0
      lrwx------ 1 bortnik bortnik 64 дек 29 15:04 2 -> /dev/pts/0
      lrwx------ 1 bortnik bortnik 64 дек 29 15:04 255 -> /dev/pts/0
      lrwx------ 1 bortnik bortnik 64 дек 29 15:04 5 -> /dev/pts/0
      ``` 
     * **Команда:** echo netology > /proc/$$/fd/5
      ```
      bortnik@centos:/proc$ echo netology > /proc/$$/fd/5
      netology
      ```
      **Команда:** echo netology > &5, будет иметь такой же вывод
      ```
      bortnik@centos:/proc$ echo netology >&5
      netology
      ```
      всё потому что вывод дискриптора 5 мы сделали на STDOUT.
1. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?
     * **Команда:** 
       ```
       bortnik@centos:/proc$ ls -z 5>&2 2>&1 1>&5 | grep z
       ls: неверный ключ — «z»
       ```
1. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?
     * /proc/$$/environ — Описание окружения, в котором работает процесс. Оно может быть полезно для просмотра 
       содержимого окружения, если вам надо, например, посмотреть, была ли установлена переменная окружения перед запуском программы. 
     * Аналогичный вывод можно получить командой:  
       **env**
1. Используя man, опишите что доступно по адресам ```/proc/<PID>/cmdline, /proc/<PID>/exe```.
    * ```/proc/<PID>/cmdline``` - этот файл только для чтения содержит полную командную строку для процесса, если этот процесс не является зомби.
    * ```/proc/<PID>/exe``` - Символическая ссылка на выполнимый файл запущенной программы.
1. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo. 
    * **Команда:** cat /proc/cpuinfo | grep -i sse    
    * **Результат:** sse4_2
    ```
    bortnik@MyFirstVM:~$ cat /proc/cpuinfo | grep -i sse
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single fsgsbase bmi1 avx2 bmi2 invpcid rdseed clflushopt md_clear flush_l1d arch_capabilities
    ```
1. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty.
Это можно подтвердить командой tty, которая упоминалась в лекции 3.2.
    * Принудительное выделение псевдотерминала, нужно добавить **-t** 
    ```
    bortnik@MyFirstVM:~$ tty
    /dev/pts/1
    bortnik@MyFirstVM:~$ ssh -t localhost 'tty'
    bortnik@localhost's password:
    /dev/pts/0
    Connection to localhost closed.
    ```
1. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.
    * Для реализации необходимо внести изменения в файл:   */etc/sysctl.d/10-ptrace.conf*     
    установить значение 
    kernel.yama.ptrace_scope = **0**
    * Узнать PID процесса командой **ps -a** 
    * Перетянуть процесс к себе командой 
    reptyr PID
1. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте? что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
    * Команда **tee** - используется для разделения выводимых программой данных, таким образом данные могут быть использованы для вывода на дисплей и сохранены в файл. Также команда может быть использована для получения промежуточных данных до того, как они будут изменены другой программой или командой. Команда tee считывает стандартный ввод (stdin), после чего записывает его в стандартный вывод (stdout) и одновременно копирует его в подготовленный файл или переменную/
    * **echo** - встроена в Shell.
    * **tee** - исполняемый файл, поэтому после конвеера он запускается с повышенными правами. 
    * Можно так же изменить файл, требующий привелегий другой командной:  
    *sudo sh -c "echo 'string ' >> /root/new_file"*