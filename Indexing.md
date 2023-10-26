#### Difference between seq scan vs index scan vs bitmap scan

*Seq Scan*
- Seq Scan involves scanning each row and evaluating the condition provided within the query

*Index Scan*
- Index scan involves doing a lookup in index first and then fetching the required pages then rows that satisfy the condition
provided withtin the query

*Bit Map scan*
- Bitmap index scan basically involves in creating a bit wise maps on a column's distinct value or range of values.
- In this bitmap, each bit represents that page/row is marked as 0 or 1. If the page contains the rows that satisfy the criteria (have that particular distinct value or lie within that range), its corresponding bit is marked as 1.

*How does a bit map index scan work?*
- When a table is queried on a column having bitmap index, the given condition is evaluated using the bitmap.
- Bitmap lookup is pretty straight forward. Consider the following example.
    +-------------+------------+
    |   name      |   age      |
    +--------------------------+

    In this case, when the table is queried as follows.
    SELECT name FROM person WHERE age > 25

    Bitmaps on Age table looks like:-
        1-10 | 10-20 | 20-30 | 30-40
        1000 | 0001  | 0010  | 0100

    Following would be the execution plan
        - Get Bitmaps on age column having age  > 25
            | 20-30 | 30-40
            | 0010  | 0100
        - Do a Bit wise OR operation, we get
            | 0110 |
        - Now, do a heap scan (i.e. fetch the rows from table)
        - Re-evaluate the condition
        - Return the result
