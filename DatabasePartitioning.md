
#### What is database partitioning

-	Partitioning is spliting a table into smaller partitions which can be logically represented as single entity


*Horizontal Partitioning*
- Horizontal Paritioning splits into partition row-wise

*Vertical Partitioning*
- Vertical Partitioning split into partitions column-wise

#### Partitioning Types

*By Range*
	- For e.g partition based on dates

*By List*
	- Discrete Values (like state, zip code etc)

*By Hash*
	- Hash functions (consistent hashing)

#### Horizontal Partitioning vs Sharding

-	HP splits big table into multiple tables in same database, client is agnostic
-	Sharding splits big table into multiple tables across multiple database servers
-	HP table name changes (or schema)
-	Sharding everything is same but server changes

#### Pros of Partitioning

-	Improve query performance when accessing a single partition
	-	Partitions are smaller as compared to entire table, hence smaller index
	-	Smaller index implies faster performance
-	Sequential Scan vs Scattered Index Scan
	-	Since data is partitioned, DB access only the required parition(s) which makes index lookup even faster
-	Better for bulk loading
	- here database takes care of sorting rows into suitable partitions
-	Archive old data that are barely accessed into cheap storage

#### Cons of Partitioning

-	Updates to the rows that move a particular row to a different partition
	-	This movement is slow and could fail sometimes
-	Inefficient queries could accidently can scan all partitions, which might result in
	even slower performance
-	Schema changes are challenging (DBMS manages it though)
