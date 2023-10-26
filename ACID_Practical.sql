
-- Tables in Use

+------------------------+
| Tables_in_udemy_course |
+------------------------+
| products               |
| sales                  |
+------------------------+


-- SCHEMA

 TABLE : products
+-----------+---------------------+------+-----+---------+----------------+
| Field     | Type                | Null | Key | Default | Extra          |
+-----------+---------------------+------+-----+---------+----------------+
| pid       | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| name      | text                | YES  |     | NULL    |                |
| price     | double              | YES  |     | NULL    |                |
| inventory | int(11)             | YES  |     | NULL    |                |
+-----------+---------------------+------+-----+---------+----------------+

TABLE : sales
+--------+---------------------+------+-----+---------+----------------+
| Field  | Type                | Null | Key | Default | Extra          |
+--------+---------------------+------+-----+---------+----------------+
| saleid | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| pid    | int(11)             | YES  |     | NULL    |                |
| price  | double              | YES  |     | NULL    |                |
| qty    | int(11)             | YES  |     | NULL    |                |
+--------+---------------------+------+-----+---------+----------------+

-- ACID Examples

-- Atomicity

MariaDB [udemy_course]> BEGIN;
Query OK, 0 rows affected (0.001 sec)

MariaDB [udemy_course]> select * from products;
+-----+-------+--------+-----------+
| pid | name  | price  | inventory |
+-----+-------+--------+-----------+
|   1 | Phone | 999.99 |       100 |
+-----+-------+--------+-----------+
1 row in set (0.006 sec)

MariaDB [udemy_course]> update products set inventory = inventory - 10;
Query OK, 1 row affected (0.024 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [udemy_course]> select * from products;
+-----+-------+--------+-----------+
| pid | name  | price  | inventory |
+-----+-------+--------+-----------+
|   1 | Phone | 999.99 |        90 |
+-----+-------+--------+-----------+
1 row in set (0.002 sec)

MariaDB [udemy_course]> Ctrl-C -- exit!

-- Upon running the same query on another terminal, since above transaction did not commit
-- , changes did not reflect

MariaDB [udemy_course]> select * from products;
+-----+-------+--------+-----------+
| pid | name  | price  | inventory |
+-----+-------+--------+-----------+
|   1 | Phone | 999.99 |       100 |
+-----+-------+--------+-----------+

-- NOTE: Upon hitting SELECT query on products table we didn't see any updates, because the transaction didn't commit


-- Isolation

[Terminal  1]

MariaDB [udemy_course]> BEGIN;
Query OK, 0 rows affected (0.003 sec)

MariaDB [udemy_course]> select * from sales;
+--------+------+--------+------+
| saleid | pid  | price  | qty  |
+--------+------+--------+------+
|      1 |    1 | 999.99 |   10 |
+--------+------+--------+------+
1 row in set (0.003 sec)

MariaDB [udemy_course]> select pid, count(*) from sales group by pid;
+------+----------+
| pid  | count(*) |
+------+----------+
|    1 |        1 |
+------+----------+
1 row in set (0.004 sec)


[Terminal 2]

MariaDB [udemy_course]> insert into sales(pid, price, qty) values(1, 99.99, 10);
Query OK, 1 row affected (0.005 sec)

MariaDB [udemy_course]> update products set inventory = inventory-10 where pid = 1;
Query OK, 1 row affected (0.002 sec)
Rows matched: 1  Changed: 1  Warnings: 0

-- ----------------------------------------------------
[Terminal 1]

MariaDB [udemy_course]> select pid, count(*) from sales group by pid;
+------+----------+
| pid  | count(*) |
+------+----------+
|    1 |        1 |
+------+----------+
1 row in set (0.003 sec)

MariaDB [udemy_course]> select * from products;
+-----+-------+--------+-----------+
| pid | name  | price  | inventory |
+-----+-------+--------+-----------+
|   1 | Phone | 999.99 |        90 |
+-----+-------+--------+-----------+
1 row in set (0.003 sec)

-- Notice that here count and qty did not update in Terminal 1's transaction even
-- if it was updated in Terminal 2's transaction below

[Terminal 2]

MariaDB [udemy_course]> select * from sales;
+--------+------+--------+------+
| saleid | pid  | price  | qty  |
+--------+------+--------+------+
|      1 |    1 | 999.99 |   10 |
|      2 |    1 |  99.99 |   10 |
+--------+------+--------+------+
2 rows in set (0.003 sec)

MariaDB [udemy_course]> select * from products;
+-----+-------+--------+-----------+
| pid | name  | price  | inventory |
+-----+-------+--------+-----------+
|   1 | Phone | 999.99 |        80 |
+-----+-------+--------+-----------+
1 row in set (0.002 sec)

-- ----------------------------------------------------
[Terminal 1]

MariaDB [udemy_course]> commit;
Query OK, 0 rows affected (0.000 sec)

-- After Commit, when we try running the same query, we get the updated result

MariaDB [udemy_course]> select pid, count(*) from sales group by pid;
+------+----------+
| pid  | count(*) |
+------+----------+
|    1 |        2 |
+------+----------+

-- Incase of isolation, transaction that began before, did not read updates written by other transaction later

-- Isolation Levels

-- Isolation levels are configurable at global and transaction level.
-- Different isolation levels define how concurrency and data consistency has to be handled

[Terminal 1]
MariaDB [udemy_course]> SET TRANSACTION ISOLATION LEVEL READ COMMITTED;;
Query OK, 0 rows affected (0.001 sec)

ERROR: No query specified

MariaDB [udemy_course]> BEGIN
    -> ;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> SELECT * FROM sales;
+--------+------+--------+------+
| saleid | pid  | price  | qty  |
+--------+------+--------+------+
|      1 |    1 | 999.99 |   10 |
|      2 |    1 |  99.99 |   10 |
+--------+------+--------+------+
2 rows in set (0.003 sec)

[ Terminal 2 ]

MariaDB [udemy_course]> insert into sales(pid, price, qty)
    -> values(1, 99.99, 10);
Query OK, 1 row affected (0.005 sec)

MariaDB [udemy_course]> update products set inventory = inventory-10 where pid = 1;
Query OK, 1 row affected (0.002 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [udemy_course]> select * from sales;
+--------+------+--------+------+
| saleid | pid  | price  | qty  |
+--------+------+--------+------+
|      1 |    1 | 999.99 |   10 |
|      2 |    1 |  99.99 |   10 |
+--------+------+--------+------+
2 rows in set (0.003 sec)

-- ----------------------------------------------------

[ Terminal 1]

MariaDB [udemy_course]> SELECT * FROM sales;
+--------+------+--------+------+
| saleid | pid  | price  | qty  |
+--------+------+--------+------+
|      1 |    1 | 999.99 |   10 |
|      2 |    1 |  99.99 |   10 |
|      3 |    1 |  98.99 |   10 |
+--------+------+--------+------+
3 rows in set (0.001 sec)

MariaDB [udemy_course]> commit;
Query OK, 0 rows affected (0.000 sec)

-- Note: Here in READ COMMITTED isolation level, changes from other transaction (Terminal 2) immediately
-- reflected in current transaction (Terminal 1) even before committing

-- Read Phenomena

-- Phantom Reads : Phantom read can be avoided using serialization which will basically isolates a transaction
-- by executing transaction in a serial manner. Serialization results in using different mechanism such as locking table
-- inorder to ensure highest data consistency and transaction isolation. This might affect performance

-- Serialization

[ Terminal 1 ]
MariaDB [udemy_course]> SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;;
Query OK, 0 rows affected (0.026 sec)

MariaDB [udemy_course]> BEGIN WORK;
Query OK, 0 rows affected (0.026 sec)

MariaDB [udemy_course]> select pid, sum(price) from sales group by pid;
+------+------------+
| pid  | sum(price) |
+------+------------+
|    1 |    1316.96 |
+------+------------+
1 row in set (0.003 sec)

[ Terminal 2 ]
MariaDB [udemy_course]> insert into sales(pid, price, qty) values(1, 20, 9);

-- Note : Here update by other transaction is put on hold until current transaction is done reading

[ Terminal 1 ]
MariaDB [udemy_course]> commit;
Query OK, 0 rows affected (0.001 sec)

[ Terminal 2 ]
MariaDB [udemy_course]> insert into sales(pid, price, qty) values(1, 20, 9);
Query OK, 1 row affected (7.657 sec)

-- Notice, post commit on current transaction(Terminal 1), other transaction(Terminal 2) was able to finish, hence the delay in INSERT operation


-- Repeatable Read : Repeatable Read makes use of MVCC - Multi Version Concurrency Control
