#### ROW_ID

- Internal and System Maintained
    - In case of InnoDB, row_id is same as primary key
    - In case of Postgres, a system column row_id(tuple_id) is present

### Page

- Depending on the storage model(row or column store), the rows are stored and read in logical pages
- Database doesn't read a single row, it reads a page or more in a single IO and we get a lot of rows in that IO
- Each page has a size (for e.g 8KB in postgres, 16KB in MySQL)
- These pages are stored on disk
- Pages have start and end

#### IO

- An IO is an operation, its a Read request to the disk
- IO can fetch 1 or more pages depending on the disk partitions
- An IO cannot read a single row, its a page with many rows in them, you get them for free
- IOs are expensive, have as minimum as possible
- Some IOs in operating systems goes to OS cache and not disk

*Note: It is not possible to read a particular row from page, however it is possible to read a particular page and rows within that page are available for free*

#### Heap

- Heap as a data structure is used to store pages one after another for table
- This is where actual data is stored including everything(i.e metadata + rows)
- Traversing heap is expensive

#### Index

- Another data structure seperate from heap that has "pointers" to the heap (B-Tree is used)
- It has part of the data and used to quickly search for something
- Index can be created for one or more column
- Once you find value of index, you go to the heap to fetch more information
- Index tells you EXACTLY which page to fetch in the heap instead of taking the hit to scan every page in the heap
- Index is also stored in pages and cost IO to pull entries of the index
- Smaller the index, the more it can fit in memory the faster the search
- Sometimes the heap can be organized around a single index (which is also called clustered index or an Index Organized Table[IOT])
- MySQL InnoDB always have a primary key(clustered index) order indexes pointing to primary key "value"
- Postgres only have secondary indexes and all indexes point directly to the row_id which lives in the heap
- Any Update, all the keys get updated in IOT

