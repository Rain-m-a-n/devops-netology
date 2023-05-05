## Задача 1

**Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.**
[docker-compose.yml](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20баз%20данных/Home_Work_(6.4)/docker-compose.yml)
* Подключитесь к БД PostgreSQL, используя psql.
  ```bash
  root@4b87c2ae6266:/# psql -U postgres
  psql (13.10 (Debian 13.10-1.pgdg110+1))
  Type "help" for help.

  postgres=#
  ```
* Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

**Найдите и приведите управляющие команды для:**

* вывода списка БД
  ```sql
  postgres=# \l
                                   List of databases
     Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
  -----------+----------+----------+------------+------------+-----------------------
   postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
   template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
             |          |          |            |            | postgres=CTc/postgres
   template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
             |          |          |            |            | postgres=CTc/postgres
  (3 rows)
  ```
* подключения к БД
  ```sql
  postgres=# \c postgres 
  You are now connected to database "postgres" as user "postgres".
  postgres=# 
  ```
* вывода списка таблиц
  ```sql
  postgres=# \dtS
                      List of relations
     Schema   |          Name           | Type  |  Owner   
  ------------+-------------------------+-------+----------
   pg_catalog | pg_aggregate            | table | postgres
   pg_catalog | pg_am                   | table | postgres
   pg_catalog | pg_amop                 | table | postgres
   pg_catalog | pg_amproc               | table | postgres
   pg_catalog | pg_attrdef              | table | postgres
   pg_catalog | pg_attribute            | table | postgres
   pg_catalog | pg_auth_members         | table | postgres
   .........
   (62 rows)
  ```
* вывода описания содержимого таблиц
  ```sql
  postgres=# \dS+ pg_range
                                    Table "pg_catalog.pg_range"
      Column    |  Type   | Collation | Nullable | Default | Storage | Stats target | Description 
  --------------+---------+-----------+----------+---------+---------+--------------+-------------
   rngtypid     | oid     |           | not null |         | plain   |              | 
   rngsubtype   | oid     |           | not null |         | plain   |              | 
   rngcollation | oid     |           | not null |         | plain   |              | 
   rngsubopc    | oid     |           | not null |         | plain   |              | 
   rngcanonical | regproc |           | not null |         | plain   |              | 
   rngsubdiff   | regproc |           | not null |         | plain   |              | 
  Indexes:
      "pg_range_rngtypid_index" UNIQUE, btree (rngtypid)
  Access method: heap
  ```
* выхода из psql.
  ```sql
  postgres=# \q
  root@4b87c2ae6266:/# 
  ```

## Задача 2

**Используя psql, создайте БД test_database.**
  ```sql
  postgres=# CREATE DATABASE test_database;
  CREATE DATABASE
  ```
* Изучите бэкап БД.

* Восстановите бэкап БД в test_database.
  ```bash
  root@4b87c2ae6266:~# psql -d test_database < /db_backup/test_dump.sql 
  SET
  SET
  SET
  SET
  SET
   set_config 
  ------------
 
  (1 row)

  SET
  SET
  SET
  SET
  SET
  SET
  CREATE TABLE
  ERROR:  must be member of role "postgres"
  CREATE SEQUENCE
  ERROR:  must be member of role "postgres"
  ALTER SEQUENCE
  ALTER TABLE
  COPY 8
   setval 
  --------
        8
  (1 row)

  ALTER TABLE
  ```
* Перейдите в управляющую консоль psql внутри контейнера.
  ```bash
  root@4b87c2ae6266:~# psql --dbname=test_database
  psql (13.10 (Debian 13.10-1.pgdg110+1))
  Type "help" for help.

  test_database=> 
  ```
* Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
  ```sql
  test_database=> \d
               List of relations
   Schema |     Name      |   Type   | Owner 
  --------+---------------+----------+-------
   public | orders        | table    | root
   public | orders_id_seq | sequence | root
  (2 rows)
  test_database=> analyze orders;
  ANALYZE
  ```

* Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
  ```sql
  test_database=> SELECT tablename, attname, avg_width FROM pg_stats WHERE avg_width IN (SELECT MAX(avg_width) FROM pg_stats WHERE tablename = 'orders') and tablename = 'orders';
   tablename | attname | avg_width 
  -----------+---------+-----------
   orders    | title   |        16
  (1 row)
  ```

Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат.

## Задача 3

**Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.**

* Предложите SQL-транзакцию для проведения этой операции.
  ```sql
  test_database=# \conninfo 
  You are connected to database "test_database" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
  test_database=# BEGIN;
  BEGIN
  test_database=*# CREATE TABLE orders_1 (LIKE orders);
  CREATE TABLE
  test_database=*# INSERT INTO orders_1 SELECT * FROM orders WHERE price > 499;
  INSERT 0 3
  test_database=*# DELETE FROM orders WHERE price > 499;
  DELETE 3
  test_database=*# CREATE TABLE orders_2 (LIKE orders);
  CREATE TABLE
  test_database=*# INSERT INTO orders_2 SELECT * FROM orders WHERE price < 499; 
  INSERT 0 4
  test_database=*# DELETE FROM orders WHERE price < 499;
  DELETE 4
  test_database=*# COMMIT;
  COMMIT
  test_database=# \dt
            List of relations
   Schema |   Name   | Type  |  Owner   
  --------+----------+-------+----------
   public | orders   | table | postgres
   public | orders_1 | table | postgres
   public | orders_2 | table | postgres
  (3 rows)
  ``` 
* Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?
  * можно было избежать разбиения таблицы вручную, необходимо было определить тип на моменте создания - partitioned table.
    ```sql
    CREATE TABLE orders (id integer NOT NULL, title character varying(80) NOT NULL, price integer DEFAULT 0) PARTITION BY RANGE (price);
    CREATE TABLE orders_1 PARTITION OF orders FOR VALUES GREATER THAN ('499');
    CREATE TABLE orders_2 PARTITION OF orders FOR VALUES FROM ('0') TO ('499');
  ```
## Задача 4

**Используя утилиту pg_dump, создайте бекап БД test_database.**

* Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?
   ```sql 
    CREATE TABLE public.orders (id integer NOT NULL,title character varying(80) NOT NULL UNIQUE,price integer DEFAULT 0);
   ```
