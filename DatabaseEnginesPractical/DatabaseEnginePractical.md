- Create a docker container for mysql
	- docker run --name ms -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root mysql
		- Change the host port if already in use
	- docker exec -it ms bash
- Run Following commands
```
mysql> create database test;
Query OK, 1 row affected (0.01 sec)

mysql> use test;
Database changed
mysql> create table employees_myisam (id int primary key auto_increment, name text) engine = myisam; (by default engine = InnoDB, this differs from DB to DB)
Query OK, 0 rows affected (0.02 sec)

mysql> show engines; (to show engines supported by your DB)

mysql> create table employees_innodb (id int primary key auto_increment, name text)
 engine = innodb;
Query OK, 0 rows affected (0.06 sec)
```

- Run index.js file along with breakpoints to understand database engine behaviour