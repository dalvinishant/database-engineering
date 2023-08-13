
-- SCHEMA to be used
desc deadlock;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | NO   | PRI | NULL    |       |
+-------+---------+------+-----+---------+-------+
1 row in set (0.008 sec)

-- Exclusive Lock example
[Terminal 1]

MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> insert into deadlock values(20);
Query OK, 1 row affected (0.001 sec)

MariaDB [udemy_course]> insert into deadlock values(21); -- TRANSACTION FAILS AT THIS STEP, BECAUSE DB DETECTS A DEADLOCK
ERROR 1213 (40001): Deadlock found when trying to get lock; try restarting transaction

[Terminal 2]

MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> insert into deadlock values(21);
Query OK, 1 row affected (0.002 sec)

MariaDB [udemy_course]> insert into deadlock values(20); -- THIS STEP IS HALTED UNTIL EXCLUSIVE LOCK FOR 20 IS REALEASED(DUE TO ITS FAILURE) FROM TERMINAL 1
Query OK, 1 row affected (13.382 sec)

-- ==========================================================================================

-- Example 2
[Terminal 1]

MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> insert into deadlock values(20);
Query OK, 1 row affected (0.001 sec)

[Terminal 2]

MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> insert into deadlock values(20); -- THIS STEP IS HALTED UNTIL EXCLUSIVE LOCK FOR 20 IS REALEASED FROM TERMINAL 1

[Terminal 1]
MariaDB [udemy_course]> rollback; -- ROLLBACK RELEASES THE EXCLUSIVE LOCK ON VALUE 20
Query OK, 1 row affected (0.001 sec)

[Terminal 2]
MariaDB [udemy_course]> insert into deadlock values(20); -- THIS STEP IN TERMINAL 2 SUCCEEDS SINCE LOCK ON VALUE 20 IS RELEASE FROM TERMINAL 1
Query OK, 1 row affected (0.001 sec)

-- ==========================================================================================

-- Example 3
[Terminal 1]

MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> insert into deadlock values(20);
Query OK, 1 row affected (0.001 sec)

[Terminal 2]

MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> insert into deadlock values(20); -- THIS STEP IS HALTED UNTIL EXCLUSIVE LOCK FOR 20 IS REALEASED FROM TERMINAL 1

[Terminal 1]
MariaDB [udemy_course]> commit; -- ROLLBACK RELEASES THE EXCLUSIVE LOCK ON VALUE 20
Query OK, 1 row affected (0.001 sec)

[Terminal 2]
MariaDB [udemy_course]> insert into deadlock values(20); -- THIS STEP IN TERMINAL 2 FAILS SINCE VALUE 20 WAS COMITTED BY TERMINAL 1 AND AFTER RELEASE LOCK, VALUE 20 WAS ALREADY PRESENT IN TABLE
Duplicate entry '20' for key 'PRIMARY'

-- ==========================================================================================

-- Double Booking Problem

-- SCHEMA to be used
MariaDB [udemy_course]> desc seats;
+-----------+-------------+------+-----+---------+-------+
| Field     | Type        | Null | Key | Default | Extra |
+-----------+-------------+------+-----+---------+-------+
| id        | int(11)     | NO   | PRI | NULL    |       |
| is_booked | int(11)     | YES  |     | NULL    |       |
| name      | varchar(10) | YES  |     | NULL    |       |
+-----------+-------------+------+-----+---------+-------+
3 rows in set (0.005 sec)

[Terminal 1]
start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> select * from seats;
+----+-----------+------+
| id | is_booked | name |
+----+-----------+------+
|  1 |         0 |      |
+----+-----------+------+
1 row in set (0.004 sec)

MariaDB [udemy_course]> update seats set is_booked = 1, name = 'Nishant' WHERE id = 1; -- Updates value for a row
Query OK, 1 row affected (0.004 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [udemy_course]> select * from seats; -- Value wrote by the transaction is visible
+----+-----------+---------+
| id | is_booked | name    |
+----+-----------+---------+
|  1 |         1 | Nishant |
+----+-----------+---------+
1 row in set (0.005 sec)

MariaDB [udemy_course]> commit;
Query OK, 0 rows affected (0.001 sec)

[Terminal 2]
MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> select * from seats;
+----+-----------+------+
| id | is_booked | name |
+----+-----------+------+
|  1 |         0 |      |
+----+-----------+------+
1 row in set (0.001 sec)

MariaDB [udemy_course]> update seats set is_booked = 1, name = 'Aayush' WHERE id = 1;
Query OK, 1 row affected (13.812 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [udemy_course]> select * from seats;
+----+-----------+--------+
| id | is_booked | name   |
+----+-----------+--------+
|  1 |         1 | Aayush |
+----+-----------+--------+
1 row in set (0.022 sec)

-- Note : Here for id 1, values was updated by 2 different transactions, which should not happen if we are serving usecase like FIFO

-- To Resolve this, we use FOR UPDATE to obtain a exclusive lock

[Terminal 1]
start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> select id from seats where id = 1 and is_booked = 0 FOR UPDATE; -- Acquires an EXCLUSIVE LOCK on row  EXPLICITLY where id = 1 for updating, other transactions will have to wait for this lock to be release in order to read
+----+-----------+------+
| id | is_booked | name |
+----+-----------+------+
|  1 |         0 |      |
+----+-----------+------+
1 row in set (0.004 sec)

MariaDB [udemy_course]> update seats set is_booked = 1, name = 'Nishant' WHERE id = 1; -- Updates value for a row
Query OK, 1 row affected (0.004 sec)
Rows matched: 1  Changed: 1  Warnings: 0

-- Meanwhile on Terminal 2
[Terminal 2]
MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> select id from seats where id = 1 and is_booked = 0 FOR UPDATE; -- This transaction is stuck here, until the (other)transaction that has locked this row releases the row this transaction is requesting


[Terminal 1]
MariaDB [udemy_course]> commit;
Query OK, 0 rows affected (0.001 sec)

-- Then on Terminal 2
MariaDB [udemy_course]> select id from seats where id = 1 and is_booked = 0 for update;
Empty set (21.414 sec) -- Notice the time it took, this is because of lock on row with ID = 1

-- ==========================================================================================

-- Double Booking Problem : ALTERNATE SOLUTION

[Terminal 1]
MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]> update seats set is_booked = 1, name = 'ninad' WHERE is_booked = 0 and id = 2; -- Here UPDATE statement IMPLICITLY ACQUIRES A LOCK ON row with id = 2
Query OK, 1 row affected (0.001 sec)
Rows matched: 1  Changed: 1  Warnings: 0

MariaDB [udemy_course]> commit;
Query OK, 0 rows affected (0.002 sec)

-- Meanwhile on Terminal 2

[Terminal 2]
MariaDB [udemy_course]> start transaction;
Query OK, 0 rows affected (0.000 sec)

MariaDB [udemy_course]>  update seats set is_booked=1, name='Dhanshree' where id = 2 and is_booked = 0; -- Here again, Update statement tries to acquire an IMPLICIT LOCK ON row with id = 2
Query OK, 0 rows affected (9.129 sec) -- Notice the time it took, this is because of lock on row with ID = 2 from terminal 1
Rows matched: 0  Changed: 0  Warnings: 0

MariaDB [udemy_course]> commit;
Query OK, 0 rows affected (0.002 sec)

-- Note: It is important to note, that in the above alternate solution, behaviour of the database depends on its implementation.
-- Exact behaviour may not be guranteed in all the databases. Moreover, above behaviour also depends on isolation level of transaction
-- Each database have their own implementation of how they handle, manage and maintain locks in order to maintain consistency for concurrency control
