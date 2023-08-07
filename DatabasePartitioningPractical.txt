

-- Database Partitioning Example on MariaDB (MySQl - InnoDB)

-- Create Table with following schema
create table grades_org (id serial not null, g int not null);

+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | YES  | UNI | NULL    |       |
| g     | int(11) | NO   | MUL | NULL    |       |
+-------+---------+------+-----+---------+-------+

-- Inserting around 10 M rows
insert into grades_org(g) select floor(rand()*100) from seq_0_to_10000000;

-- Create Index on column g
create index index_on_g from grades_org(g);

-- Sample query to fetch from grade_org table using condition on column g
analyze select count(*) from grades_org where g = 30;
+------+-------------+------------+------+---------------+------------+---------+-------+--------+-----------+----------+------------+-------------+
| id   | select_type | table      | type | possible_keys | key        | key_len | ref   | rows   | r_rows    | filtered | r_filtered | Extra       |
+------+-------------+------------+------+---------------+------------+---------+-------+--------+-----------+----------+------------+-------------+
|    1 | SIMPLE      | grades_org | ref  | index_on_g    | index_on_g | 4       | const | 207226 | 100239.00 |   100.00 |     100.00 | Using index |
+------+-------------+------------+------+---------------+------------+---------+-------+--------+-----------+----------+------------+-------------+

-- Sample query to fetch from grade_org table using range type of condition on column g
analyze select count(*) from grades_org where g BETWEEN 30 and 35;
+------+-------------+------------+-------+---------------+------------+---------+------+---------+-----------+----------+------------+--------------------------+
| id   | select_type | table      | type  | possible_keys | key        | key_len | ref  | rows    | r_rows    | filtered | r_filtered | Extra                    |
+------+-------------+------------+-------+---------------+------------+---------+------+---------+-----------+----------+------------+--------------------------+
|    1 | SIMPLE      | grades_org | range | index_on_g    | index_on_g | 4       | NULL | 1241948 | 599069.00 |   100.00 |     100.00 | Using where; Using index |
+------+-------------+------------+-------+---------------+------------+---------+------+---------+-----------+----------+------------+--------------------------+

-- At this point, we have a table with 10M records having 2 columns with index

-- Now, here although indexing in itself is pretty optimized, because the size of the table is quite large
-- scanning through index and fetching values also becomes slow.
-- We can make this faster using partitioning the table. However, it is to be noted that whether partitioning should be done or not
-- entirely depends on the nature of the data since partitions comes with its own set of considerations

-- create a table for partitioning (In this practical, we are not modifying the existing table, instead creating a new one)
create table grades_parts(id int auto_increment not null, g int not null, primary key (id, g))

+-------+---------+------+-----+---------+----------------+
| Field | Type    | Null | Key | Default | Extra          |
+-------+---------+------+-----+---------+----------------+
| id    | int(11) | NO   | PRI | NULL    | auto_increment |
| g     | int(11) | NO   | PRI | NULL    |                |
+-------+---------+------+-----+---------+----------------+

-- Notice that primary key comprises of 2 columns, (id, g). This is because, MariaDB requires unique or primary key constraint
-- on the columns that we are using for partitioning. This is because, it needs to ensure that each row in a particular
-- partition is uniquely identified. On the other hand, DBMS like Postgres, they do not require unique constraint.

-- Creating Partitions of type Range on grades_parts table, based on following slabs
-- partition g0035 for values of g in 0 to 35
-- partition g3560 for values of g in 36 to 60
-- partition g6080 for values of g in 61 to 80
-- partition g80100 for values of g in 81 to 100

alter	table
 	grades_parts
partition by range (g) -- this line specifies the type of the partition along with column
(
	partition g0035 values less than (35), -- Here, g0035 is the partition name and (35) denotes the range for bucketization
	partition g3560 values less than (60),
	partition g6080 values less than (80),
	partition g80100 values less than (100),
);
-- Note: Still we don't have any data in table grades_part till this point

-- Now, we have created partition based on values from column (g), which look like this
+-----------+-----------+-----------+-----------+
|   g0035   |   g3560   |   g6080   |   g80100  |
+-----------+-----------+-----------+-----------+
| val(0, 35)|val(36, 60)|val(60, 80)|val(80,100)|
+-----------+-----------+-----------+-----------+

-- Insert data into grades_part table from grades_org table
insert into grades_parts select * from grades_org;

-- When inserting rows from grages_org to grades_parts, DBMS manages sorting of rows into relevant partitions
-- this is done via partition function that we specified earlier

-- Note that sequence of creation of partition (i.e. partitioning then inserting or vice versa) does not matter
-- Since partitions are created as part of alter command, DBMS creates partitions and inserts relevant rows in those partitions
-- by creating a temp copy of original table then alter and then insert into partitions

-- Creating Index on grades_parts table
create index index_on_g on grades_parts;

-- Note: Index creation takes care of index creation in each partition individually

-- Sample query to fetch from grade_org table using condition on column g
EXPLAIN PARTITIONS select count(*) from grades_parts where g = 30;

+------+-------------+--------------+------------+------+---------------+------------+---------+-------+--------+-------------+
| id   | select_type | table        | partitions | type | possible_keys | key        | key_len | ref   | rows   | Extra       |
+------+-------------+--------------+------------+------+---------------+------------+---------+-------+--------+-------------+
|    1 | SIMPLE      | grades_parts | g0035      | ref  | index_on_g    | index_on_g | 4       | const | 217038 | Using index |
+------+-------------+--------------+------------+------+---------------+------------+---------+-------+--------+-------------+

-- Sample query to fetch from grade_org table using range type of condition on column g
EXPLAIN PARTITIONS select count(*) from grades_parts where g between 30 and 35;
+------+-------------+--------------+-------------+-------+---------------+------------+---------+------+---------+--------------------------+
| id   | select_type | table        | partitions  | type  | possible_keys | key        | key_len | ref  | rows    | Extra                    |
+------+-------------+--------------+-------------+-------+---------------+------------+---------+------+---------+--------------------------+
|    1 | SIMPLE      | grades_parts | g0035,g3560 | range | index_on_g    | index_on_g | 4       | NULL | 1309294 | Using where; Using index |
+------+-------------+--------------+-------------+-------+---------------+------------+---------+------+---------+--------------------------+

-- Partitioning basically reduces the data size allowing us to query larger data more efficiently
-- Following is the size of original table vs partioned table

SELECT TABLE_NAME, DATA_LENGTH FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'udemy_course' AND TABLE_NAME = 'grades_org';
+------------+-------------+
| TABLE_NAME | DATA_LENGTH |
+------------+-------------+
| grades_org |   361627648 |
+------------+-------------+

SELECT t.TABLE_NAME, t.DATA_LENGTH AS TableSize, PARTITION_NAME, p.DATA_LENGTH AS PartitionSize FROM information_schema.TABLES t JOIN information_schema.PARTITIONS p ON t.TABLE_SCHEMA = p.TABLE_SCHEMA AND t.TABLE_NAME = p.TABLE_NAME WHERE t.TABLE_SCHEMA = 'udemy_course' AND t.TABLE_NAME = 'grades_parts';
+--------------+-----------+----------------+---------------+
| TABLE_NAME   | TableSize | PARTITION_NAME | PartitionSize |
+--------------+-----------+----------------+---------------+
| grades_org   | 361627648 |                |     361627648 | -- This is size of the original table
| grades_parts | 287768576 | g0035          |     100286464 | -- this is the size of a particular partition
| grades_parts | 287768576 | g3560          |      71942144 |
| grades_parts | 287768576 | g6080          |      58294272 |
| grades_parts | 287768576 | g80100         |      57245696 |
+--------------+-----------+----------------+---------------+

