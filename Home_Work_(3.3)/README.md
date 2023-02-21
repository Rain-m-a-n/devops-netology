1. Какой системный вызов делает команда cd?
    * ```chdir("/tmp")             = 0```
1. Попробуйте использовать команду file на объекты разных типов в файловой системе. Используя strace выясните, где находится база данных file, на основании которой она делает свои догадки.
    * **Команда File:** - осуществляет определение типов переданных элементов файловой системы (файлов, директорий, ссылок, именованных каналов и сокетов). Данная утилита исследует содержимое файлов, а не ограничивается проверкой их расширений.
    * openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
    * создал файл с помощью vim
    * удалил **swp**
    * **Команда:** lsof | grep deleted
    ```bash
    bortnik@MyFirstVM:~$ lsof | grep deleted
    vim       1965                        bortnik    3u      REG              253,0    12288    1310824 /home/bortnik/.test_proc.txt.swp (deleted)
    ```
    * ```Определяем дескриптор командой: ls -l /proc/<PID>/fd```
    ```bash
    bortnik@MyFirstVM:~$ ls -l /proc/1965/fd
    total 0
    lrwx------ 1 bortnik bortnik 64 Dec 31 05:23 0 -> /dev/pts/0
    lrwx------ 1 bortnik bortnik 64 Dec 31 05:23 1 -> /dev/pts/0
    lrwx------ 1 bortnik bortnik 64 Dec 31 05:23 2 -> /dev/pts/0
    lrwx------ 1 bortnik bortnik 64 Dec 31 05:23 3 -> '/home/bortnik/.test_proc.txt.swp (deleted)'
    ```
    * Обнуляем файл командой: ```> /proc/1965/fd/3```
    * Проверяем результат:
    ```bash
    bortnik@MyFirstVM:~$ lsof | grep deleted
    vim       1965                        bortnik    3u      REG              253,0        0    1310824 /home/bortnik/.test_proc.txt.swp (deleted)
    ```
1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
    * Процесс при завершении (как нормальном, так и в результате не обрабатываемого сигнала) освобождает все свои ресурсы и становится «зомби» — пустой записью в таблице процессов, хранящей статус завершения, предназначенный для чтения родительским процессом.Зомби-процесс существует до тех пор, пока родительский процесс не прочитает его статус с помощью системного вызова wait(), в результате чего запись в таблице процессов будет освобождена.
1. В iovisor BCC есть утилита opensnoop. На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты?
    * 
    ```bash
    bortnik@MyFirstVM:~$ sudo opensnoop-bpfcc
    PID    COMM               FD ERR PATH
    1118   vminfo              5   0 /var/run/utmp
    684    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
    684    dbus-daemon        20   0 /usr/share/dbus-1/system-services
    684    dbus-daemon        -1   2 /lib/dbus-1/system-services
    684    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
    690    irqbalance          6   0 /proc/interrupts
    690    irqbalance          6   0 /proc/stat
    690    irqbalance          6   0 /proc/irq/20/smp_affinity
    690    irqbalance          6   0 /proc/irq/0/smp_affinity
    690    irqbalance          6   0 /proc/irq/1/smp_affinity
    690    irqbalance          6   0 /proc/irq/8/smp_affinity
    690    irqbalance          6   0 /proc/irq/12/smp_affinity
    690    irqbalance          6   0 /proc/irq/14/smp_affinity
    690    irqbalance          6   0 /proc/irq/15/smp_affinity
    1118   vminfo              5   0 /var/run/utmp
    ```
1. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.
    * uname({sysname="Linux", nodename="MyFirstVM", ...}) = 0
    * **proc/version** - Эта строка определяет текущую версию ядра. Он включает содержимое /proc/sys/kernel/ostype, /proc/sys/kernel/osrelease и /proc/sys/kernel/version.
1. Чем отличается последовательность команд через ; и через && в bash? Есть ли смысл использовать в bash &&, если применить set -e?
     * Последовательность **(&&)** - это логическое **И**, где вторая команда выполняется только после успешного выполнения первой. 
     * Последовательность **(;)** - выполняет и выводит результат команды в указанной последовательности.
     * **set -e** - прервать выполнение немедленно, если код возврата команды не равен 0.
1. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?
    * **-e** - выход немедленно, если результат команды != 0
    * **-u** - Считать неустановленные переменные ошибкой при подстановке.
    * **-x** - Печатать команды и их аргументы по мере их выполнения.
    * **-o pipefail** - возвращаемое значение конвейера - это статус последней команды для завершения с ненулевым статусом или ноль, если ни одна команда не завершилась с ненулевым статусом
    * В сценариях хорошо исмпользовать для траблшутинга. Т.к. будет более информативный вывод. 
1. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
    * PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT"
       or "S") will display to describe the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent
                
                For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group

    * bortnik@MyFirstVM:~$ ps -o stat  
      STAT  
      Ss  
      R+
    * Поэтому второй и последующий символ можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).