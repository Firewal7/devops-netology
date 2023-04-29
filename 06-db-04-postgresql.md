## Домашнее задание к занятию 4. «PostgreSQL»

### Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя psql.

Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

```
┌──(root㉿kali)-[/home/kali/lesson/sql4]
└─# docker volume create kali
kali

┌──(root㉿kali)-[/home/kali/lesson/sql4]
└─# docker run --name postgresql -e POSTGRES_PASSWORD=netology -d -p 5432:5432 -v kali:/var/lib/postgresql/data postgres:13
407c58ddb1ec41c098bb5e4b1e72d99d12f9330f38cc50c6ea85ca60590314a0

┌──(root㉿kali)-[/home/kali/lesson/sql4]
└─# docker exec -it postgresql bash
root@407c58ddb1ec:/#

root@407c58ddb1ec:/# psql -U postgres
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.

postgres=#
```

Найдите и приведите управляющие команды для:

- вывода списка БД
```
postgres=# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |
       Description
-----------+----------+----------+------------+------------+-----------------------+---------+------------+---------
-----------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7901 kB | pg_default | default
administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | unmodifi
able empty database
           |          |          |            |            | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | default
template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            |
(3 rows)
```
- подключения к БД,
```
postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".
```
- вывода списка таблиц,
```
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
 pg_catalog | pg_authid               | table | postgres
 pg_catalog | pg_cast                 | table | postgres
 pg_catalog | pg_class                | table | postgres
 pg_catalog | pg_collation            | table | postgres
 pg_catalog | pg_constraint           | table | postgres
 pg_catalog | pg_conversion           | table | postgres
 pg_catalog | pg_database             | table | postgres
 pg_catalog | pg_db_role_setting      | table | postgres
 pg_catalog | pg_default_acl          | table | postgres
 pg_catalog | pg_depend               | table | postgres
 pg_catalog | pg_description          | table | postgres
 pg_catalog | pg_enum                 | table | postgres
 pg_catalog | pg_event_trigger        | table | postgres
 pg_catalog | pg_extension            | table | postgres
 pg_catalog | pg_foreign_data_wrapper | table | postgres
 pg_catalog | pg_foreign_server       | table | postgres
 pg_catalog | pg_foreign_table        | table | postgres
 pg_catalog | pg_index                | table | postgres
 pg_catalog | pg_inherits             | table | postgres
 pg_catalog | pg_init_privs           | table | postgres
 pg_catalog | pg_language             | table | postgres
--More--
```
- вывода описания содержимого таблиц,
```
postgres=# \dS+

postgres-#             List of relations
postgres-#    Schema   |          Name           | Type  |  Owner
postgres-# ------------+-------------------------+-------+----------
postgres-#  pg_catalog | pg_aggregate            | table | postgres
postgres-#  pg_catalog | pg_am                   | table | postgres
postgres-#  pg_catalog | pg_amop                 | table | postgres
postgres-#  pg_catalog | pg_amproc               | table | postgres
postgres-#  pg_catalog | pg_attrdef              | table | postgres
postgres-#  pg_catalog | pg_attribute            | table | postgres
postgres-#  pg_catalog | pg_auth_members         | table | postgres
postgres-#  pg_catalog | pg_authid               | table | postgres
postgres-#  pg_catalog | pg_cast                 | table | postgres
postgres-#  pg_catalog | pg_class                | table | postgres
postgres-#  pg_catalog | pg_collation            | table | postgres
postgres-#  pg_catalog | pg_constraint           | table | postgres
postgres-#  pg_catalog | pg_conversion           | table | postgres
postgres-#  pg_catalog | pg_database             | table | postgres
postgres-#  pg_catalog | pg_db_role_setting      | table | postgres
postgres-#  pg_catalog | pg_default_acl          | table | postgres
postgres-#  pg_catalog | pg_depend               | table | postgres
postgres-#  pg_catalog | pg_description          | table | postgres
postgres-#  pg_catalog | pg_enum                 | table | postgres
postgres-#  pg_catalog | pg_event_trigger        | table | postgres
postgres-#  pg_catalog | pg_extension            | table | postgres
postgres-#  pg_catalog | pg_foreign_data_wrapper | table | postgres
postgres-#  pg_catalog | pg_foreign_server       | table | postgres
postgres-#  pg_catalog | pg_foreign_table        | table | postgres
postgres-#  pg_catalog | pg_index                | table | postgres
postgres-#  pg_catalog | pg_inherits             | table | postgres
postgres-#  pg_catalog | pg_init_privs           | table | postgres
postgres-#  pg_catalog | pg_language       
--More--
```
- выхода из psql.
```
postgres=# \q
root@407c58ddb1ec:/#
```
### Задача 2

Используя psql, создайте БД test_database.
```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=#
```
Изучите бэкап БД.

Восстановите бэкап БД в test_database.
```
┌──(root㉿kali)-[/home/kali/lesson/sql4]
└─# docker cp /home/kali/lesson/sql4/test_dump.sql postgresql:/tmp

┌──(root㉿kali)-[/home/kali/lesson/sql4]
└─# docker exec -it postgresql bash
root@407c58ddb1ec:/# psql -U postgres -f /tmp/test_dump.sql test_database
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
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)
```
Перейдите в управляющую консоль psql внутри контейнера.
```
root@407c58ddb1ec:/# psql -U postgres
psql (13.10 (Debian 13.10-1.pgdg110+1))
Type "help" for help.

postgres=#
```
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#
```
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.

Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат.
```
test_database=# SELECT avg_width FROM pg_stats WHERE tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)

test_database=#
```

### Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.
```
test_database=# CREATE TABLE orders_more_499_price (CHECK (price > 499)) INHERITS (orders);
CREATE TABLE
test_database=# INSERT INTO orders_more_499_price SELECT * FROM orders WHERE price > 499;
INSERT 0 3
test_database=# CREATE TABLE orders_less_499_price (CHECK (price <= 499)) INHERITS (orders);
CREATE TABLE
test_database=# INSERT INTO orders_LESS_499_price SELECT * FROM orders WHERE price <= 499;
INSERT 0 5
test_database=# DELETE FROM ONLY orders;
DELETE 8
test_database=# \dt
                 List of relations
 Schema |         Name          | Type  |  Owner
--------+-----------------------+-------+----------
 public | orders                | table | postgres
 public | orders_less_499_price | table | postgres
 public | orders_more_499_price | table | postgres
(3 rows)
```

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

- можно
```
CREATE RULE orders_insert_to_more AS ON INSERT TO orders WHERE ( price > 499 ) DO INSTEAD INSERT INTO orders_more_499_price VALUES (NEW.*);
CREATE RULE orders_insert_to_less AS ON INSERT TO orders WHERE ( price <= 499 ) DO INSTEAD INSERT INTO orders_less_499_price VALUES (NEW.*);
```

### Задача 4 

Используя утилиту pg_dump, создайте бекап БД test_database.
```
root@407c58ddb1ec:/# export PGPASSWORD=netology && pg_dump -h localhost -U postgres test_database > /tmp/test_database_backup.sql
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

- Добавить UNIQUE

```
CREATE TABLE public.orders_2 (
    id integer,
    title character varying(80) UNIQUE,
    price integer
);
```

