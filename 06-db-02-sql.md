## Домашнее задание к занятию "2. SQL"

## Задача 1

- Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
```
version: '3'
services:
 db:
   container_name: pg12
   image: postgres:12
   environment:
     POSTGRES_USER: kali
     POSTGRES_PASSWORD: 123
     POSTGRES_DB: start_db
   ports:
     - "5434:5434"
   volumes:
     - database_volume:/home/database/
     - backup_volume:/home/backup/

volumes:
 database_volume:
 backup_volume:
```

Поднимаем docker-compose и запускаем bash внутри контейнера pg12:

```
$ docker-compose up -d
$ sudo docker exec -it pg12 bash
```

## Задача 2

### В БД из задачи 1:

- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

### Таблица orders:

- id (serial primary key)
- наименование (string)
- цена (integer)

### Таблица clients:

- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

### Приведите:

- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

## Решение
- создайте пользователя test-admin-user и БД test_db
```
root@28d7ec20b83e:/# createdb test_db -U kali
root@28d7ec20b83e:/# psql -d test_db -U kali
psql (12.14 (Debian 12.14-1.pgdg110+1))
Type "help" for help.
```
```
test_db=# CREATE USER test_admin_user;
CREATE ROLE
```

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
```
test_db=# CREATE TABLE orders
(
   id SERIAL PRIMARY KEY,
   наименование TEXT,
   цена INTEGER
);
CREATE TABLE
test_db=# CREATE TABLE clients
(
    id SERIAL PRIMARY KEY,
    фамилия TEXT,
    "страна проживания" TEXT,
    заказ INTEGER,
    FOREIGN KEY (заказ) REFERENCES orders(id)
);
CREATE TABLE
test_db=# CREATE INDEX country_index ON clients ("страна проживания");
CREATE INDEX
test_db=#
```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
```
test_db=# GRANT ALL ON TABLE orders TO test_admin_user;
GRANT
test_db=# GRANT ALL ON TABLE clients TO test_admin_user;
GRANT
test_db=#
```
- создайте пользователя test-simple-user
```
test_db=# CREATE USER test_simple_user;
CREATE ROLE
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```
test_db=# GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE orders TO test_simple_user;
GRANT
test_db=# GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE clients TO test_simple_user;
GRANT
```
- итоговый список БД после выполнения пунктов выше.

![Ссылка 1](https://github.com/Firewal7/devops-netology/blob/main/image/06-db-02-sql-1.jpg)

- описание таблиц (describe)

![Ссылка 2](https://github.com/Firewal7/devops-netology/blob/main/image/06-db-02-sql-2.jpg)

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```
test_db=# SELECT grantee, table_catalog, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name IN ('orders','clients');
```

![Ссылка 3](https://github.com/Firewal7/devops-netology/blob/main/image/06-db-02-sql-3.jpg)


## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

- Таблица orders

 |Наименование|цена|
 |------------|----|
 |Шоколад| 10 |
 |Принтер| 3000 |
 |Книга| 500 |
 |Монитор| 7000|
 |Гитара| 4000|

- Таблица clients

 |ФИО|Страна проживания|
 |------------|----|
 |Иванов Иван Иванович| USA |
 |Петров Петр Петрович| Canada |
 |Иоганн Себастьян Бах| Japan |
 |Ронни Джеймс Дио| Russia|
 |Ritchie Blackmore| Russia|

## Решение
- наполним таблицы требуемыми тестовыми данными:
```
test_db=# INSERT INTO orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
```
- Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы
```
SELECT COUNT (*) FROM orders;
SELECT COUNT (*) FROM clients;
```

![Ссылка 4](https://github.com/Firewal7/devops-netology/blob/main/image/06-db-02-sql-4.jpg)

## Задача 4 

### Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

### Используя foreign keys свяжите записи из таблиц, согласно таблице:

 |ФИО|Заказ|
 |------------|----|
 |Иванов Иван Иванович| Книга |
 |Петров Петр Петрович| Монитор |
 |Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.
```
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Книга') WHERE фамилия='Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Монитор') WHERE фамилия='Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET заказ=(select id from orders where наименование='Гитара') WHERE фамилия='Иоганн Себастьян Бах';
UPDATE 1
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса. Подсказка - используйте директиву UPDATE.


![Ссылка 5](https://github.com/Firewal7/devops-netology/blob/main/image/06-db-02-sql-5.jpg)


## Задача 5

### Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

![Ссылка 6](https://github.com/Firewal7/devops-netology/blob/main/image/06-db-02-sql-6.jpg)

### Приведите получившийся результат и объясните что значат полученные значения.

- Seq Scan это метод последовательного чтения данных из таблицы clients;
- цифры 0.00 — ожидаемые затраты на получение первой строки, далее 18.10 — ожидаемые затраты на получение всех строк, rows - ожидаемое число строк, width - ожидаемый средний размер строк.
- Каждая запись сравнивается с условием "заказ" IS NOT NULL. Если условие выполняется, запись вводится в результат. Иначе — отбрасывается.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
```
root@28d7ec20b83e:/# pg_dump -U kali test_db > /home/backup/test_db.backup
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).


![Ссылка 7](https://github.com/Firewal7/devops-netology/blob/main/image/06-db-02-sql-7.jpg)


Поднимите новый пустой контейнер с PostgreSQL.

```
docker run --name pg12_kali -e POSTGRES_PASSWORD=1234 -d postgres:12
```

Восстановите БД test_db в новом контейнере. Cкопируем файл дампа из контейнера pg12 в контейнер pg12_kali:
```
$ docker cp pg12:/home/backup/test_db.backup backup/ && docker cp backup/test_db.backup pg12_kali:/home/
```
- и восстановим базу:
```
psql -U postgres -d test_db -f /home/test_db.backup
```
