
#### Full Table Scan (Why B-Tree?)

-	To find a row (or a couple of rows) on a large table we perform
	full table scan
-	Tables are nothing but files that have pages which have rows in them.
	As a result, reading large tables is slow since it requires a lot of
	I/Os
-	We need a way to reduce this

#### What is B-Tree

-	B-Tree is a Balanced Data Structure for fast traversal
-	B-Tree has Nodes
-	In B-Tree of 'm' degree some nodes can have (m) child nodes
-	Node has upto (m-1) elements
	-	Each element has a key and value ( and a pointer to next left node and next right node)
	-	The value is usually data pointer to the row
	-	Data pointer can point to primary key or tuple
	-	Root Node, internal node and leaf ndoes
	-	A node = disk page (**IMPORTANT**)

#### Limitation of B-Tree

-	Elements in all nodes store both the key and the value
-	As a result, internal nodes take more space thus require more IO and can slow down traversal
-	Range queries are slow because of random access (you need traverse back and forth)
	-	Need to traverse
	-	No.of IOs may increase

#### What is different in B+Tree

-	Values are only stored in leaf nodes
	-	This implies internal nodes are smaller since they only store keys and they
		can fit more elements
-	Leaf nodes are "linked" so once you fina a key you can find all values before and after
	that key

#### B+Tree and DBMS Considerations

-	Cost of leaf pointer (which is cheap compared to B-Tree)
-	1 Node fits a DBMS page (true in case of most DBMS)
-	Can fit internal nodes easily in memory for fast traversal
-	Leaf nodes can live in data files in the heap
-	Most DBMS use B+Tree for indexing

#### Storage Cost in Postfres vs MySQL

-	B+ Tree secondary index values can either point directly to the tuple(Postgres) or
	to the primary key(MySQL)
-	If the Primary Key data type is expensive this can cause bloat in all secondary indexes
	for databases such MySQL (innoDB)
-	Leaf nodse in MySQL(InnoDB) contains the full row since its an
	IOT(Index OrganizedTable) / clustered index