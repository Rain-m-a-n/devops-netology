1. Узнайте о **sparse** (разряженных) файлах.
    * **Разрежённый файл** (англ. sparse file) — файл, в котором последовательности нулевых байтов заменены на информацию об этих последовательностях (список дыр).
    * **Дыра** (англ. hole) — последовательность нулевых байт внутри файла, не записанная на диск. Информация о дырах (смещение от начала файла в байтах и количество байт) хранится в метаданных ФС.
    * Преимущества:
        * экономия дискового пространства.
        * ускорение записи на диск.
        * увеличение срока службы дисков.
    * Недостатки:
        * фрагментация при частой записи в дыры.
        * невозможность записи данных в дыры при отсутствии свободного места на диске.
1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
    * Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode. Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл. Различаются только имена файлов.
    * Символическая ссылка обладает собственными правами доступа, так как сама является небольшим файлом, который содержит путь до целевого файла.
1. Замените содержимое Vagrantfile, в виртуальной машине должны появиться два дополнительных диска размером по 2.5 Гб.
    ```bash
      bortnik@sysadm-fs:~$ lsblk
      NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      loop0                       7:0    0 67.8M  1 loop /snap/lxd/22753
      loop1                       7:1    0   62M  1 loop /snap/core20/1611
      loop3                       7:3    0 49.8M  1 loop /snap/snapd/17950
      loop4                       7:4    0 63.3M  1 loop /snap/core20/1778
      loop5                       7:5    0 91.9M  1 loop /snap/lxd/24061
      sda                         8:0    0   64G  0 disk
      ├─sda1                      8:1    0    1M  0 part
      ├─sda2                      8:2    0    2G  0 part /boot
      └─sda3                      8:3    0   62G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm  /
      sdb                         8:16   0  2.5G  0 disk
      sdc                         8:32   0  2.5G  0 disk
    ``` 
1. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
    ```bash
      root@sysadm-fs:/home/bortnik# lsblk
      NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      loop0                       7:0    0 67.8M  1 loop /snap/lxd/22753
      loop1                       7:1    0   62M  1 loop /snap/core20/1611
      loop3                       7:3    0 49.8M  1 loop /snap/snapd/17950
      loop4                       7:4    0 63.3M  1 loop /snap/core20/1778
      loop5                       7:5    0 91.9M  1 loop /snap/lxd/24061
      sda                         8:0    0   64G  0 disk
      ├─sda1                      8:1    0    1M  0 part
      ├─sda2                      8:2    0    2G  0 part /boot
      └─sda3                      8:3    0   62G  0 part
        └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm  /
      sdb                         8:16   0  2.5G  0 disk
      ├─sdb1                      8:17   0    2G  0 part
      └─sdb2                      8:18   0  511M  0 part
      sdc                         8:32   0  2.5G  0 disk
1. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
   * Командой: *sfdisk -d /dev/sdb > sdb-tables.txt*  - выгружаем в файл разметку диска
   * Командой: *sfdisk /dev/sdc < sdb-tables.txt*  - переносим разметку на другой диск
        ```bash
        root@sysadm-fs:/home/bortnik# lsblk
        NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
        loop0                       7:0    0 67.8M  1 loop /snap/lxd/22753
        loop1                       7:1    0   62M  1 loop /snap/core20/1611
        loop3                       7:3    0 49.8M  1 loop /snap/snapd/17950
        loop4                       7:4    0 63.3M  1 loop /snap/core20/1778
        loop5                       7:5    0 91.9M  1 loop /snap/lxd/24061
        sda                         8:0    0   64G  0 disk
        ├─sda1                      8:1    0    1M  0 part
        ├─sda2                      8:2    0    2G  0 part /boot
        └─sda3                      8:3    0   62G  0 part
          └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm  /
        sdb                         8:16   0  2.5G  0 disk
        ├─sdb1                      8:17   0    2G  0 part
        └─sdb2                      8:18   0  511M  0 part
        sdc                         8:32   0  2.5G  0 disk
        ├─sdc1                      8:33   0    2G  0 part
        └─sdc2                      8:34   0  511M  0 part
        ```
1. Соберите mdadm RAID1 на паре разделов 2 Гб.
    * **mdadm** --create --verbose /dev/md1 -l **1** -n 2 /dev/sdb1 /dev/sdc1  
1. Соберите mdadm RAID0 на второй паре маленьких разделов.
    * **mdadm** --create --verbose /dev/md1 -l **0** -n 2 /dev/sdb2 /dev/sdc2
      ```bash
      sdb                         8:16   0  2.5G  0 disk
      ├─sdb1                      8:17   0    2G  0 part
      │ └─md1                     9:1    0    2G  0 raid1
      └─sdb2                      8:18   0  511M  0 part
        └─md0                     9:0    0 1017M  0 raid0
      sdc                         8:32   0  2.5G  0 disk
      ├─sdc1                      8:33   0    2G  0 part
      │ └─md1                     9:1    0    2G  0 raid1
      └─sdc2                      8:34   0  511M  0 part
        └─md0                     9:0    0 1017M  0 raid0
      ```
1. Создайте 2 независимых PV на получившихся md-устройствах.
    ```bash
      root@sysadm-fs:/home/bortnik# pvcreate /dev/md0 /dev/md1
      WARNING: xfs signature detected on /dev/md0 at offset 0. Wipe it? [y/n]: y
        Wiping xfs signature on /dev/md0.
      WARNING: xfs signature detected on /dev/md1 at offset 0. Wipe it? [y/n]: y
        Wiping xfs signature on /dev/md1.
        Physical volume "/dev/md0" successfully created.
        Physical volume "/dev/md1" successfully created.
      root@sysadm-fs:/home/bortnik# pvdisplay
      --- Physical volume ---
      PV Name               /dev/sda3
      VG Name               ubuntu-vg
      PV Size               <62.00 GiB / not usable 0
      Allocatable           yes
      PE Size               4.00 MiB
      Total PE              15871
      Free PE               7936
      Allocated PE          7935
      PV UUID               zsjUIf-lkCP-mcQc-77AQ-EnRV-aROu-2kC8c0

      "/dev/md0" is a new physical volume of "1017.00 MiB"
      --- NEW Physical volume ---
      PV Name               /dev/md0
      VG Name
      PV Size               1017.00 MiB
      Allocatable           NO
      PE Size               0
      Total PE              0
      Free PE               0
      Allocated PE          0
      PV UUID               5eYmU0-hOLn-ag41-ZpR7-Ib8R-pyKj-KSehzY

     "/dev/md1" is a new physical volume of "<2.00 GiB"
     --- NEW Physical volume ---
     PV Name               /dev/md1
     VG Name
     PV Size               <2.00 GiB
     Allocatable           NO
     PE Size               0
     Total PE              0
     Free PE               0
     Allocated PE          0
     PV UUID               iObytv-fYbn-XGCd-GBEk-n5J0-PQ1y-h20RzM
    ```
1. Создайте общую volume-group на этих двух PV.
     ```bash
     root@sysadm-fs:/home/bortnik# vgcreate Netology /dev/md0 /dev/md1
     Volume group "Netology" successfully created 
     ```
1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
    ```bash
    root@sysadm-fs:/home/bortnik# lvcreate -L 100 Netology -ntestvg /dev/md0
    Logical volume "testvg" created.
    ```
1. Создайте mkfs.ext4 ФС на получившемся LV.
    ```bash
    root@sysadm-fs:/home/bortnik# mkfs.ext4 /dev/Netology/testvg
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done
    ```
1. Смонтируйте этот раздел в любую директорию, например, /tmp/new      
    root@sysadm-fs:/home/bortnik# mkdir -p /tmp/new
    root@sysadm-fs:/home/bortnik# mount /dev/Netology/testvg /tmp/new
1. Поместите туда тестовый файл.
     wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz 
1. Прикрепите вывод lsblk.
    ```bash
    root@sysadm-fs:/tmp/new# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 63.3M  1 loop  /snap/core20/1778
    loop1                       7:1    0 49.8M  1 loop  /snap/snapd/17950
    loop2                       7:2    0 67.8M  1 loop  /snap/lxd/22753
    loop3                       7:3    0   62M  1 loop  /snap/core20/1611
    loop4                       7:4    0 91.9M  1 loop  /snap/lxd/24061
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    2G  0 part  /boot
    └─sda3                      8:3    0   62G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part 
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md0                     9:0    0 1017M  0 raid0
        └─Netology-testvg     253:1    0  100M  0 lvm   /tmp/new
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md0                     9:0    0 1017M  0 raid0
        └─Netology-testvg     253:1    0  100M  0 lvm   /tmp/new
1. Протестируйте целостность файла:  
    ```bash
    root@sysadm-fs:/tmp/new# gzip -t /tmp/new/test.gz | echo $?  
    0
    ```
1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
    ```bash
    root@sysadm-fs:/tmp/new# pvmove /dev/md0 /dev/md1
    /dev/md0: Moved: 20.00%
    /dev/md0: Moved: 100.00%
    ```
    ```bash
    root@sysadm-fs:/tmp/new# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 63.3M  1 loop  /snap/core20/1778
    loop1                       7:1    0 49.8M  1 loop  /snap/snapd/17950
    loop2                       7:2    0 67.8M  1 loop  /snap/lxd/22753
    loop3                       7:3    0   62M  1 loop  /snap/core20/1611
    loop4                       7:4    0 91.9M  1 loop  /snap/lxd/24061
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    2G  0 part  /boot
    └─sda3                      8:3    0   62G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    │   └─Netology-testvg     253:1    0  100M  0 lvm   /tmp/new
    └─sdb2                      8:18   0  511M  0 part
      └─md0                     9:0    0 1017M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    │   └─Netology-testvg     253:1    0  100M  0 lvm   /tmp/new
    └─sdc2                      8:34   0  511M  0 part
      └─md0                     9:0    0 1017M  0 raid0
1. Сделайте --fail на устройство в вашем RAID1 md.
    ```bash
    root@sysadm-fs:/tmp/new# mdadm /dev/md1 --fail /dev/sdc1
    mdadm: set /dev/sdc1 faulty in /dev/md1
    ```
1. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.    
    
    [ 3717.402632] <font color='yellow'>md/raid1:md1</font><font color='red'>: Disk failure on sdc1, disabling device.</font>  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<space> <font color='red'> md/raid1:md1: Operation continuing on 1 devices.</font>
1. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:    
    ```bash
    root@sysadm-fs:/tmp/new# gzip -t /tmp/new/test.gz | echo $?  
    0
    ```