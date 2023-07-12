#### Database Types

- Row-Oriented Database (Row Store)
- Column-Oriented (Columnar) (Column Store)

#### Row Oriented Database

- Tables are stored as rows in disk
- A single block IO read to the table fetches multiple rows along with their columns
- More IOs are required to find a particular row in a table scan but once you find the row you get all the columns for that row.
- This leads to wasteful reads since we might pull column which we don't require


#### Column Oriented Database

- Tables are stored as columns first in disk
- A single block io read to the table fetches multiple columns with all matching rows
- Less IOs are required to get more values of a give column. But working with multiple columns require more IO
- OLAP