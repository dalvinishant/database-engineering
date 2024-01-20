## What is a database engine
	- Library that takes care of the on disk storage and CRUD
		- Can be as simple as key-value store
		- Or as rich and complex as full support ACID transactions with foreign keys
	- DBMS can use database engine and build features on top (server replication, isolation, stored procedures, etc)
	- Sometimes referred as Storage Engine or embedded database
	- One can create their own database using a database engine to fit a particular usecase
	- Some DBMS gives you the flexibility to switch engines like MySQL & MariadDB
	- Some DBMS comes with a built-in engine that you can't change (Postgres)

## MyISAM
- Stands for Indexed sequential access method
	- Implies directly points to row on the disk
	- This makes reads extremely fast
- B-Tree(Balanced tree) indexes point to the rows directly
- No Transaction support
	- Does not support ACID
- Open Source, owned by Oracle
- Inserts are fast, updates and deletes are problematic(fragments)
	- Because of ISAM(Indexed Sequentail Access Method), end of the file is always known, making writes fast.
	- However, updating or deleting the rows in between leads to updating indexes/pointers etc for entire table, leading to very slow updates or deletes.
	- It might lead to corruption too
- Database crashes corrupts table
	- One needs to manually repair using some utility to recover the table
- Supports only table level locking
	- Not row level locking causing concurrency writes/reads issue

## InnoDB
- B+Tree - with indexes point to the primary key and PK points to the row
	- There is always a primary key in InnoDB
	- Any Index that gets created, it points to the primary key. (And Primary Key points to the actual row -> That's powerful)
- Replaces MyISAM
- Default for MySQL & MariaDB
- Supports ACID for transactions
- Supports Foreign Key ( for referential integrity )
- Row level locking
	- Required for ACID, for exclusive locking
- Spatial Operations (able to perform Geographic Information Systems required operations )

## XtraDB
- Fork of InnoDB
- Was default for MariaDB until 10.1

## SQLite
- Very popular embedded database for local data
- B-Tree (LSM extension)
- Postgress-like syntax
- Supports ACID and table locking
- Does not support row-locking
- Concurrent read & writes
- WebSQL uses SQLite

## Aria
- Very similar to MyISAM
- Crash-safe unlike to MyISAM
- Not owned by Oracle

## Berkeley DB
- One of the oldest DBs (Now owned by Oracle)
- Key-value embedded database
- Supports ACID transactions, locks, replications etc
- Used to used in bitcoin core ( now switched to LevelDB )
- Used in MemcacheDB

## LeveDB
- Built by google
- Log Structured Merge Tree
	- Great for high inserts
	- No B-Tree to rebalance which means very fast writes
	- Nothing is ever deleted (usually)
- No transactions
- Why is it LevelsDB?
	- LevelsDB has these levels
		- Memtable
			- In memory table
			- Parallely also write it to WAL(Write Ahead Log), which also writes it to the disk immediately
		- Level 0 (young level)
		- Level 1 - 6
	- Data to write is passed to another level as soon a levels size is reached
	- As files grow large levels are merged and then flushed to disk
	- Used in bitcoin core, AutCad, Minecraft

## RocksDB
- Facebook forked LevelDB in 2012 to become RocksDB
- Fast inserts, fast reads, no b-tree, transactional
- High Performance, Multi-threaded
- MyRocks for MySQL, MariaDB and Percona
- MongoRocks for MongoDB