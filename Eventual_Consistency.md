

*Eventual Consistency is mostly required for NoSQL Databases*

#### Consistency are of 2 types

- Consistency in Data
- Consistency in Reads

*Consistency in Data*

- When you have normalized view of data, it is important that data is consistent across
    - RDBMS ensures consistency
- Defined by the user
- Referential Integrity (foreign key)
- Atomicity
- Isolation

*Consistency in Reads*

- Consistency in Reads becomes a challenge when there are multiple DBs (for e.g : Master Slave DB Nodes)
- Both Relational and NoSQL DBs suffer from this
- Eventual Consistency as the name suggest is the lag when the data becomes consistent across all nodes so that incoming read transactions read the updated data
- You need ACID in order to achieve eventual consistency