## Задача 1

*Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.*
[файл](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20баз%20данных/Home_Work_(6.3)/docker-compose.yml)
``` bash
[~]$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                 NAMES
0af17405b4d3   mysql:8   "docker-entrypoint.s…"   7 minutes ago   Up 7 minutes   3306/tcp, 33060/tcp   MySQL_test
```
* Изучите бэкап БД и восстановитесь из него.
  ```bash
  bash-4.4# mysql -u root -p test_db < /db_backup/test_dump.sql 
  Enter password: 
  ```
* Перейдите в управляющую консоль mysql внутри контейнера.
  ```bash 
  bash-4.4# mysql -u root -p
  ```
* Используя команду \h, получите список управляющих команд.
  ```sql
  List of all MySQL commands:
  Note that all text commands must be first on line and end with ';'
  ?         (\?) Synonym for `help'.
  clear     (\c) Clear the current input statement.
  connect   (\r) Reconnect to the server. Optional arguments are db and host.
  delimiter (\d) Set statement delimiter.
  edit      (\e) Edit command with $EDITOR.
  ego       (\G) Send command to mysql server, display result vertically.
  exit      (\q) Exit mysql. Same as quit.
  go        (\g) Send command to mysql server.
  help      (\h) Display this help.
  nopager   (\n) Disable pager, print to stdout.
  notee     (\t) Don't write into outfile.
  pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
  print     (\p) Print current command.
  prompt    (\R) Change your mysql prompt.
  quit      (\q) Quit mysql.
  rehash    (\#) Rebuild completion hash.
  source    (\.) Execute an SQL script file. Takes a file name as an argument.
  status    (\s) Get status information from the server.
  system    (\!) Execute a system shell command.
  tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
  use       (\u) Use another database. Takes database name as argument.
  charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
  warnings  (\W) Show warnings after every statement.
  nowarning (\w) Don't show warnings after every statement.
  resetconnection(\x) Clean session context.
  query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
  ssl_session_data_print Serializes the current SSL session data to stdout or file
  ```
* Найдите команду для выдачи статуса БД и приведите в ответе из её вывода версию сервера БД.
  ```sql
  mysql> status
  --------------
  mysql  Ver 8.0.33 for Linux on aarch64 (MySQL Community Server - GPL)
  ```
* Подключитесь к восстановленной БД и получите список таблиц из этой БД.
  ```bash
  bash-4.4# mysql -u root -p test_db
  Enter password: 
  Reading table information for completion of table and column names
  mysql> show tables;
  +-------------------+
  | Tables_in_test_db |
  +-------------------+
  | orders            |
  +-------------------+
  1 row in set (0.01 sec)
  ``` 
* Приведите в ответе количество записей с price > 300.
  ```sql
  mysql> SELECT * FROM orders;
  +----+-----------------------+-------+
  | id | title                 | price |
  +----+-----------------------+-------+
  |  1 | War and Peace         |   100 |
  |  2 | My little pony        |   500 |
  |  3 | Adventure mysql times |   300 |
  |  4 | Server gravity falls  |   300 |
  |  5 | Log gossips           |   123 |
  +----+-----------------------+-------+
  5 rows in set (0.01 sec)
  mysql> SELECT * FROM orders WHERE price > 300;
  +----+----------------+-------+
  | id | title          | price |
  +----+----------------+-------+
  |  2 | My little pony |   500 |
  +----+----------------+-------+
  1 row in set (0.00 sec)
  mysql> SELECT count(*) FROM orders WHERE price > 300 ;
  +----------+
  | count(*) |
  +----------+
  |        1 |
  +----------+
  1 row in set (0.00 sec)
  ```
В следующих заданиях мы будем продолжать работу с этим контейнером.

## Задача 2

* Создайте пользователя test в БД c паролем test-pass, используя:

  * плагин авторизации mysql_native_password  
  * срок истечения пароля — 180 дней  
  * количество попыток авторизации — 3  
  * максимальное количество запросов в час — 100  
  * аттрибуты пользователя:  
  * Фамилия "Pretty"  
  * Имя "James".  
  ```sql
  mysql> CREATE USER 'test'@'localhost'
      -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
      -> WITH MAX_QUERIES_PER_HOUR 100
      -> PASSWORD EXPIRE INTERVAL 180 day
      -> FAILED_LOGIN_ATTEMPTS 3
      -> ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
  Query OK, 0 rows affected (0.04 sec)
  ```
* Предоставьте привелегии пользователю test на операции SELECT базы test_db.  
  ```sql
  mysql> GRANT SELECT on test_db.* TO 'test'@'localhost';
  Query OK, 0 rows affected, 1 warning (0.02 sec)
  ```
* Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю test и приведите в ответе к задаче.
  ```sql
  mysql> select * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test';
  +------+-----------+------------------------------------------------+
  | USER | HOST      | ATTRIBUTE                                      |
  +------+-----------+------------------------------------------------+
  | test | localhost | {"last_name": "Pretty", "first_name": "James"} |
  +------+-----------+------------------------------------------------+
  1 row in set (0.02 sec)
  ```

## Задача 3

* Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
  ```sql
  mysql> SET profiling=1;
  Query OK, 0 rows affected, 1 warning (0.00 sec)
  mysql> SHOW profiles;
  +----------+------------+----------------+
  | Query_ID | Duration   | Query          |
  +----------+------------+----------------+
  |        1 | 0.00160675 | SHOW profiling |
  +----------+------------+----------------+
  1 row in set, 1 warning (0.00 sec)
* Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
  ```sql
  mysql> SELECT table_name, engine FROM information_schema.tables WHERE table_schema='test_db';
  +------------+--------+
  | TABLE_NAME | ENGINE |
  +------------+--------+
  | orders     | InnoDB |
  +------------+--------+
  1 row in set (0.01 sec)  
* Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:

  * на MyISAM
  ```sql
  mysql> ALTER table orders engine=MyISAM;
  Query OK, 5 rows affected (0.04 sec)
  Records: 5  Duplicates: 0  Warnings: 0
  ```
  * на InnoDB
  ```sql
  mysql> ALTER table orders engine=InnoDB;
  Query OK, 5 rows affected (0.05 sec)
  Records: 5  Duplicates: 0  Warnings: 0
  ```
  ```sql
  mysql>  SHOW profiles;
  +----------+------------+---------------------------------------------------------------------------------------+
  | Query_ID | Duration   | Query                                                                                 |
  +----------+------------+---------------------------------------------------------------------------------------+
  |        1 | 0.00160675 | SHOW profiling                                                                        |
  |        2 | 0.01253025 | SELECT table_name, engine FROM information_schema.tables WHERE table_schema='test_db' |
  |        3 | 0.04485675 | ALTER table orders engine=MyISAM                                                      |
  |        4 | 0.04540775 | ALTER table orders engine=InnoDB                                                      |
  +----------+------------+---------------------------------------------------------------------------------------+
  4 rows in set, 1 warning (0.00 sec)

## Задача 4

Изучите файл my.cnf в директории /etc/mysql.
* по указанному пути нет файла, смог найти его тут:
  ```bash
  find: '/proc/1/map_files': Permission denied
  find: '/proc/1/fdinfo': Permission denied
  /etc/my.cnf
  ```
Измените его согласно ТЗ (движок InnoDB):

* скорость IO важнее сохранности данных;
* нужна компрессия таблиц для экономии места на диске;
* размер буффера с незакомиченными транзакциями 1 Мб;
* буффер кеширования 30% от ОЗУ;
* размер файла логов операций 100 Мб.
Приведите в ответе изменённый файл my.cnf.
  ```bash
  [mysqld]
  #
  # Remove leading # and set to the amount of RAM for the most important data
  # cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
  # innodb_buffer_pool_size = 128M 
  # Remove leading # to turn on a very important data integrity option: logging
  # changes to the binary log between backups.
  # log_bin
  # Remove leading # to set options mainly useful for reporting servers.
  # The server defaults are faster for transactions and fast SELECTs.
  # Adjust sizes as needed, experiment to find the optimal values.
  # join_buffer_size = 128M
  # sort_buffer_size = 2M
  # read_rnd_buffer_size = 2M
  # Remove leading # to revert to previous value for default_authentication_plugin,
  # this will increase compatibility with older clients. For background, see:
  # https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
  # default-authentication-plugin=mysql_native_password
  skip-host-cache
  skip-name-resolve
  datadir=/var/lib/mysql
  socket=/var/run/mysqld/mysqld.sock
  secure-file-priv=/var/lib/mysql-files
  user=mysql

  pid-file=/var/run/mysqld/mysqld.pid
  [client]
  socket=/var/run/mysqld/mysqld.sock
 
  !includedir /etc/mysql/conf.d/

  innodb_flush_log_at_trx_commit=0
  innodb_file_format=Barracuda
  #Barracuda -is the newest file format. It supports all InnoDB row formats including the newer COMPRESSED and DYNAMIC row formats
  innodb_log_buffer_size=1M
  # bash-4.4# cat /proc/meminfo | grep -i memtotal
  # MemTotal:        4027844 kB
  innodb_buffer_pool_size=1.2G
  innodb_log_file_size=100M
  ```
