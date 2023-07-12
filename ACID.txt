## What is Transaction ?

- It is a collection of queries, which is considered as One unit of Work
- For e.g. Depositing amount in an account
    - First you fetch amount (SELECT), then deduct amount from your account (UPDATE), then add amount to another account (UPDATE)

#### Transaction Lifespan

- Transaction BEGIN
- Transaction COMMIT
- Transaction ROLLBACK
- Database crash -> do rollback

#### Nature of Transactions

- Usually transaction are used to change and modify data
- However, it can be a read only transaction

*Atomicity*

- All the queries in a transaction must succeed
- If one query fails, all prior sucessful queries in the transaction should rollback
- If DB went down prior to commit of a transaction, all the successful queries in the transaction should rollback
- Lack of automicity leads to inconsistency


*Isolation*

Isolation is result of having transaction run in complete isolation with respect to other transactions

Read phenomena

- Dirty Reads : Trying to read something that is not yet committed by other transaction
    - In Dirty read, there is inconsistency within the transaction

- Non-repeatable reads : Read some record which got updated later

- Phantom reads : fetched rows from table which got updated later (i.e rows got added/removed)

- Lost Updates : Some other transaction updated what you wrote

Isolation Levels

- Read Uncommitted - No isolation, any change from outside is visible to the transaction, committed or not ( Dirty Reads )

- Read committed - Each query in a transaction only sees committed changes by other transactions

- Repeatable Read - The transaction will make sure that when a query reads a row, that row will remain unchanged while its running (To avoid Non-repeatable reads, still phantom reads might occur)

- Snapshot - Each query in a transaction only sees changes that have been committed up to the start of the transaction. Its like a snapshot version of the database at the moment. (Gets rid of all the read phenomenas)

- Serializable - Transations are run as if they serialized one after the other

*Note : Each DBMS implements Isolation levels differently*

Database Implementation of Isolation

- Pessimistic - Row Level Locs, Table Locks, Page Locks to avoid lost updates
- Optimistic - No Locks, just track if things changes and fail the transaction if so
- Repeatable read "locks" the rows it reads but it could be expensice if you read a lot of rows, postgres implements RR as snapshot.
- Serializable are usually implemented with optimistic concurrency control, you can implement it pessimistically with SELECT FOR UPDATE

*Consistency*

Some Database sacrify consistency for speed

- Consistency in Data : What you have in disk is it what you actually have
- Consistency in Reads : This is something applicable at a system level.
- Defined by the User
- Referential Integrity
- Atomicity : Atomic transaction lead to consistency
- Isolation : Based on isolation, consistency is affected

Consistency in Reads:
- If a transaction committed a change will a new transaction immediately see the change?
- Affects the system as a whole
- Relational and NoSQL databases suffer from this
- Eventual Consistency : I will be consistent in some time

*Durability*

Process of persisting the changes that user make to a non-volatile system.

i.e. all the updates/writes should be persisted.

- Changes made by a committed transactions must be persisted in a durable non-volative storage

Durability Techniques
    - WAL : Write Ahead Log (More of a change log -> Deltas)
    - Asynchronous snapshot
    - Append Only File (AOF)

This ensures light weight way of ensuring durability without actually worrying about data

WAL
    - Writing a lot of data to disk is expensive(indexes, data, files, columns etc)
    - Hence DBMS persist a compressed version of changes known as WAL (Write Ahead Log)

OS Cache
    - A write request in OS usually goes to the OS cache (but it will tell database, write successfully)
    - When the writes go to the OS Cache, an OS crash, machine restart could lead to loss of data
    - Fsync OS command forces writes to always go to the disk (Forces the writes to the disk by force, it is slow but safe)

