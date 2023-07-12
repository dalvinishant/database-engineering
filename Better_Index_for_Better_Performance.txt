
-- Consider the following schema

-- index_on_practical(a int, b int, c int)

[Scenario 1]

+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
| Table           | Non_unique | Key_name     | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Ignored |
+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
| index_practical |          1 | index_on_b   |            1 | b           | A         |       20365 |     NULL | NULL   | YES  | BTREE      |         |               | NO      |
| index_practical |          1 | index_on_a   |            1 | b           | A         |         192 |     NULL | NULL   | YES  | BTREE      |         |               | NO      |
+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+

-- When queried using condition on a, DB chooses to use index_on_a to fetch data
SELECT c FROM index_on_practical WHERE a = 100;

-- When queried using condition on b, DB chooses to use index_on_b to fetch data
SELECT c FROM index_on_practical WHERE b = 100;

-- When queried using condition for a AND b, DB chooses to find intersection obtained via index_on_a and index_on_b to fetch data
SELECT c FROM index_on_practical WHERE a = 100 AND b = 100;

-- When queried using condition for a OR b, DB chooses to do union for results obtained via index_on_a and index_on_b
SELECT c FROM index_on_practical WHERE a = 100 OR b = 100;

[Scenario 2]

+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
| Table           | Non_unique | Key_name     | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Ignored |
+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
| index_practical |          1 | index_on_a_b |            1 | b           | A         |         192 |     NULL | NULL   | YES  | BTREE      |         |               | NO      |
+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+

-- When queried using condition on a, DB chooses to use index_on_a_b to fetch data
SELECT c FROM index_on_practical WHERE a = 100;

-- When queried using condition on b, DB chooses to do a SEQUENTIAL SCAN to fetch data
SELECT c FROM index_on_practical WHERE b = 100;

-- Reason why DB does not choose index_on_a_b : This is because indexes are always applied from left to right not right to left
-- That implies, you cannot lookup index index_a_b without having a first to search b
-- This also implies, you can lookup using index_a_b to search for a like in the example above

-- When queried using condition for a AND b, DB chooses to use index_a_b which is very fast
SELECT c FROM index_on_practical WHERE a = 100 AND b = 100;

-- When queried using condition on a OR b, DB chooses to do a SEQUENTIAL SCAN to fetch data
SELECT c FROM index_on_practical WHERE a = 100 OR b = 100;

-- Reason similar to above, here although we have 'a' as a filtering criteria, since there is an 'OR' we'd still require
-- a full sequential scan for 'b'

[Scenario 3]

+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
| Table           | Non_unique | Key_name     | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Ignored |
+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+
| index_practical |          1 | index_on_b   |            1 | b           | A         |       20365 |     NULL | NULL   | YES  | BTREE      |         |               | NO      |
| index_practical |          1 | index_on_a_b |            1 | b           | A         |         192 |     NULL | NULL   | YES  | BTREE      |         |               | NO      |
+-----------------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+

-- When queried using condition on a, DB chooses to use index_on_a_b to fetch data
SELECT c FROM index_on_practical WHERE a = 100;

-- When queried using condition on b, DB chooses to use index_on_b to fetch data
SELECT c FROM index_on_practical WHERE b = 100;

-- When queried using condition for a AND b, DB chooses to use index_on_a_b
SELECT c FROM index_on_practical WHERE a = 100 AND b = 100;

-- When queried using condition for a OR b, DB chooses to do union for results obtained via index_on_a_b and index_on_b
SELECT c FROM index_on_practical WHERE a = 100 OR b = 100;

-- Notice here that we are using index 'index_on_a_b' to search for rows with a = 100 and index 'index_on_b' to search for rows b = 100
-- and then doing a union operation.
-- As a result, since both the indexes are being used, we don't actually need to scan the entire table
-- Although required number of scans are higher, still they are lesser than sequential scan on entire table