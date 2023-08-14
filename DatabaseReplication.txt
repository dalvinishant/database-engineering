
#### What is Replication?
- Replication in Databases involves sharing information as to ensure consistency between redundant databases
- This is to improve the reliability, fault tolerance and accessibility among the databases

#### Master/Backup Replication
- One Master/Leader node that accepts writes/ddls(create, alter, update etc)
- One or more backup/standup nodes that recieve those writes from the master
- Many Read only nodes where data is replicated from Master
- Simple to implement, no conflicts
- Master/backup replication model is a eventual consistency model.
	- What this does is, multiple clients can connect to backup nodes for DML related queries.
	- At the same time, clients can also connect to Master when updated data is required immediately
- This is scalable

#### Multi-Master Replication
- Multiple master/leader node that accepts writes/ddls
- One or more backup/follower nodes that recieve writes from multple masters
- In this case, conflicts can arise and they need to resolved

#### Synchronous vs Asynchronous Replication
- Synchronous Replication, A write transaction to the master will be locked until it is written to the backup/standby nodes
	- First 2, First 1 or Any
	- If you decide to have a COMPLETE synchronous replication, you are having complete consistency (not eventual consistency).
	- This takes a hit on transaction time, since we need to sync the transaction everywhere
- Asynchronous Replication, A write transaction is considered successful if it is written to the master, then asynchronously the writes are applied to the backup nodes
