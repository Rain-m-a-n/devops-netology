## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.  
  [файл](https://github.com/Rain-m-a-n/devops-netology/blob/master/Администрирование%20баз%20данных/Home_Work_(6.2)/docker-compose.yml)


## Задача 2

*В БД из задачи 1:*

* создайте пользователя test-admin-user и БД test_db;
  ```sql
  post=# CREATE DATABASE test_db;
  CREATE DATABASE
  post=# CREATE USER "test-admin-user";
  CREATE ROLE
  ```
* в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
  ```sql
  test_db=# CREATE TABLE orders (id integer, name varchar(20), cost integer, PRIMARY KEY(id));
  CREATE TABLE
  test_db=# CREATE TABLE clients (id integer PRIMARY KEY, surname varchar(20), country varchar(20), indent integer, FOREIGN KEY (indent) REFERENCES orders(id));
  CREATE TABLE
  ``` 
* предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
  ```sql
  post=# GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";
  GRANT
  ```
* создайте пользователя test-simple-user;
  ```sql
  post=# CREATE USER "test-simple-user" WITH PASSWORD 'test';
  CREATE ROLE
  ```
* предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.
  ```sql
  test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON orders to "test-simple-user";
  GRANT
  test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON clients to "test-simple-user";
  GRANT
  ``` 
  
  |  Таблица orders | Таблица clients  |
  | ---------- | ---------- |
  | id (serial primary key)| id (serial primary key)|
  | наименование (string)|фамилия (string)
  |цена (integer)|страна проживания (string, index)
  |   заказ           | integer  (foreign key orders)
  ---
*Приведите:*

* итоговый список БД после выполнения пунктов выше;
```sql
post=# \l+
                                                                    List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    |     Access privileges      |  Size   | Tablespace |                Description                 
-----------+-------+----------+------------+------------+----------------------------+---------+------------+--------------------------------------------
 post      | post  | UTF8     | en_US.utf8 | en_US.utf8 |                            | 7969 kB | pg_default | 
 postgres  | post  | UTF8     | en_US.utf8 | en_US.utf8 |                            | 7969 kB | pg_default | default administrative connection database
 template0 | post  | UTF8     | en_US.utf8 | en_US.utf8 | =c/post                   +| 7825 kB | pg_default | unmodifiable empty database
           |       |          |            |            | post=CTc/post              |         |            | 
 template1 | post  | UTF8     | en_US.utf8 | en_US.utf8 | =c/post                   +| 7825 kB | pg_default | default template for new databases
           |       |          |            |            | post=CTc/post              |         |            | 
 test_db   | post  | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/post                  +| 8033 kB | pg_default | 
           |       |          |            |            | post=CTc/post             +|         |            | 
           |       |          |            |            | "test-admin-user"=CTc/post |         |            | 
(5 rows)

```

* описание таблиц (describe);
```sql
test_db=# \d+
                    List of relations
 Schema |  Name   | Type  | Owner |  Size   | Description 
--------+---------+-------+-------+---------+-------------
 public | clients | table | post  | 0 bytes | 
 public | orders  | table | post  | 0 bytes | 
(2 rows)
```
* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
```sql
test_db=# SELECT grantee, table_name, privilege_type, is_grantable FROM information_schema.table_privileges Where table_catalog = 'test_db' AND table_schema = 'public';
     grantee      | table_name | privilege_type | is_grantable 
------------------+------------+----------------+--------------
 post             | orders     | INSERT         | YES
 post             | orders     | SELECT         | YES
 post             | orders     | UPDATE         | YES
 post             | orders     | DELETE         | YES
 post             | orders     | TRUNCATE       | YES
 post             | orders     | REFERENCES     | YES
 post             | orders     | TRIGGER        | YES
 test-simple-user | orders     | INSERT         | NO
 test-simple-user | orders     | SELECT         | NO
 test-simple-user | orders     | UPDATE         | NO
 test-simple-user | orders     | DELETE         | NO
 post             | clients    | INSERT         | YES
 post             | clients    | SELECT         | YES
 post             | clients    | UPDATE         | YES
 post             | clients    | DELETE         | YES
 post             | clients    | TRUNCATE       | YES
 post             | clients    | REFERENCES     | YES
 post             | clients    | TRIGGER        | YES
 test-simple-user | clients    | INSERT         | NO
 test-simple-user | clients    | SELECT         | NO
 test-simple-user | clients    | UPDATE         | NO
 test-simple-user | clients    | DELETE         | NO
(22 rows)

```
* список пользователей с правами над таблицами test_db.
```sql
test_db=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of 
------------------+------------------------------------------------------------+-----------
 post             | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  |                                                            | {}
 test-simple-user |                                                            | {}

```

## Задача 3

*Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:*

**Таблица orders**

|Наименование	|цена|
| ----- | -----|   
|Шоколад|	10 | 
|Принтер |	3000 | 
|Книга	|500|  
|Монитор |	7000 | 
|Гитара	|4000  

```sql
test_db=#INSERT INTO orders (id,name,cost) VALUES (1,'Шоколад',10),(2,'Принтер', 3000),(3,'Книга',500),(4,'Монитор',7000),(5,'Гитара',4000);
INSERT 0 5
```
**Таблица clients**  
|ФИО	|Страна проживания|  
| ----- | -----|
|Иванов Иван Иванович	|USA  
|Петров Петр Петрович	|Canada  
|Иоганн Себастьян Бах	|Japan  
|Ронни Джеймс Дио	|Russia  
|Ritchie Blackmore	|Russia  
```sql
test_db=# INSERT INTO clients (id,surname,country) VALUES (1,'Иванов Иван Иванович','USA'),(2,'Петров Петр Петрович','Canada'),(3,'Иоганн Себасьян Бах','Japan'),(4,'Ронни Джеймс Дио','Russia'),(5,'Ritchie Blackmore','Russia');
INSERT 0 5
```
Используя SQL-синтаксис:

  * вычислите количество записей для каждой таблицы.  

Приведите в ответе:

- запросы,
- результаты их выполнения.
  ```sql
  test_db=# SELECT 'orders' AS name_table, count(*) AS number_line FROM orders UNION SELECT 'clients' AS name_table, count(*) AS number_line FROM clients;
  name_table | number_line 
  -----------+-------------
  clients    |           5
  orders     |           5
  (2 rows)

## Задача 4

*Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.*

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

| ФИО	 | Заказ| 
| ------- | ----- |   
|Иванов Иван Иванович	| Книга|  
|Петров Петр Петрович	|Монитор | 
|Иоганн Себастьян Бах	|Гитара  


* Приведите SQL-запросы для выполнения этих операций.  
```sql
test_db=# UPDATE clients SET "indent"=3 WHERE id=1;
UPDATE 1
test_db=# UPDATE clients SET "indent"=4 WHERE id=2;
UPDATE 1
test_db=# UPDATE clients SET "indent"=5 WHERE id=3;
UPDATE 1
```
* Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.
```sql
test_db=# SELECT surname,indent,orders."name" FROM clients JOIN orders ON "indent"=orders."id";
       surname        | indent |  name   
----------------------+--------+---------
 Иванов Иван Иванович |      3 | Книга
 Петров Петр Петрович |      4 | Монитор
 Иоганн Себасьян Бах  |      5 | Гитара
(3 rows)

```
Подсказка: используйте директиву UPDATE.

## Задача 5

*Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).*

Приведите получившийся результат и объясните, что значат полученные значения.
```sql
test_db=# EXPLAIN SELECT * FROM clients WHERE "indent" IS NOT null;
                         QUERY PLAN                         
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..15.30 rows=527 width=124)
   Filter: (indent IS NOT NULL)
(2 rows)

```
| Значение | Описание |
| -----| -----|
|cost = 0.00| Приблизительная стоимость запуска, время перед выводом данных|
|cost = 15.30| Приблизительная общая стоимость, время на полный вывод данных|
|rows=527| Ожидаемое число строк , которое должно быть выведено|
|width=124| средний размер строк выводимых этим узлом в байтах|

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).
```bash
root@753c2c99cbfc:~# pg_dump -U post -W test_db > /db_backup/test_db.dump
Password: 
root@753c2c99cbfc:~# 
```

Остановите контейнер с PostgreSQL, но не удаляйте volumes.
```bash
[~]$ docker stop 753c2c99cbfc
753c2c99cbfc
[~]$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
[~]$ 
```

Поднимите новый пустой контейнер с PostgreSQL.
```bash
[~]$ docker run --name postgres_v1 -e POSTGRES_PASSWORD=post -d -v "/Users/bortikovsv/VM_Postgres/backup":/db_backup postgres:12         
d5fa05476ddebcfc5b62651e6a21ebaf65ea349d1671a222fc697c1233507dc4
[~]$ docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS      NAMES
d5fa05476dde   postgres:12   "docker-entrypoint.s…"   50 minutes ago   Up 50 minutes   5432/tcp   postgres_v1
[~]$ docker exec -it d5fa05476dde bash
root@d5fa05476dde:/# 
```
Восстановите БД test_db в новом контейнере.
```sql
postgres=# CREATE DATABASE test_db;
CREATE DATABASE
test_db=# CREATE USER "test-admin-user";
CREATE ROLE
test_db=# CREATE USER "test-simple-user" WITH PASSWORD 'test';
CREATE ROLE
test_db=# CREATE USER "post" WITH PASSWORD 'post';
CREATE ROLE
root@d5fa05476dde:/# psql -U postgres test_db < /db_backup/test_db.dump 
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
ALTER TABLE
CREATE TABLE
ALTER TABLE
COPY 5
COPY 5
ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
```
Приведите список операций, который вы применяли для бэкапа данных и восстановления.

