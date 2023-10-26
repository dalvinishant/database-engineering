
#### Seq Scan, Index Scan and Index Only Scan

*Key Index*
-A key index is an index created on one or more columns that make up the primary key of a table. It is also referred to as a primary index.
-The primary key uniquely identifies each record in a table and enforces its uniqueness.
-By default, most database systems automatically create a clustered key index for the primary key, which determines the physical order of data on disk.
-Key indexes provide fast access to specific rows based on their primary key values, allowing for efficient retrieval of individual records.

*Non-key Index:*
-A non-key index (or secondary index) is an index created on one or more columns that are not part of the primary key.
-Non-key indexes are created to improve the performance of queries involving columns other than the primary key.
-They help accelerate search, sorting, and filtering operations based on the indexed columns.
-Unlike the primary key, non-key indexes do not enforce uniqueness, meaning multiple rows can have the same indexed column values.
-Non-key indexes are useful for optimizing queries that involve WHERE clauses, JOIN operations, or ORDER BY clauses on columns that are frequently accessed.

In summary, a key index is specifically associated with the primary key of a table and provides unique identification and fast access to individual records. On the other hand, a non-key index is created on columns that are not part of the primary key and is used to enhance performance for searching, sorting, and filtering operations involving those columns.

*Example*

Consider the following schema
+----------+-----------+----------+
|   id     |    name   |   grade  |
+----------+-----------+----------+
|   int    |  varchar  |  varchar |
+----------+-----------+----------+

Following are the scenarios demonstrate application of index

1. When Index is not present on id field
	Q :- SELECT id FROM table WHERE id = 2000;
	- In this case, DB adopts a sequential scan (i.e each row is scanned) to fetch the rows that satisfy the condition

2. When Index is present on id field and only id(primary key column) field is being fetched from query
	Q :- SELECT id FROM table WHERE id = 2000;
	- In this case, DB does an INDEX ONLY SCAN to fetch the rows that satisfy the condition (in this case only 1 row)
	- INDEX ONLY SCAN : This means, you've hit the jackpot doing the most efficient lookup on a database with huge data
		- INDEX ONLY SCAN infers, that DB Engine only had to lookup index and not actually fetch the data from disk to return the response

3. When index in present on id field but other fields (other than primary key)
	Q :- SELECT * FROM table WHERE id = 2000; (Notice the *, i.e columns that are not indexed are to be fetched)
	- In this case, DB does an INDEX SCAN (not INDEX ONLY SCAN) to fetch the rows that satisfy the condition
	- INDEX SCAN: This means, you're query is still pretty optimized, but takes some effort to fetch the required data
		- INDEX SCAN infers, that DB Engine does a lookup on the index, gets the rows to fetch, then does a lookup to fetch data from the disk




