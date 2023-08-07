
#### What is Sharding?

- Partitioning of rows based on a column/shard key
- Essentially distributing table across multiple databases instances

*How to make sure that query hits the correct database instance?*

#### Consistent Hashing

- Hashing: For a given input you get the same, consistent output
- Consistent hashing is used for Hash-ring
	- For E.g:
		- Let's say there are 3 databases instances(servers)
		- DB1, DB2, DB3
		- A hash-ring is nothing but consistent hashing implemented over multiple databases.
		- For a given i/p, which database is responsible for handling the o/p is mapped using a hash function

