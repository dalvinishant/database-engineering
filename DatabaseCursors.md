## Database Cursors

- A database cursor is a mechanism to traverse and fetch the result set of a query one row at a time.
- Cursors need to be declared before they can be used to fetch data
- Cursors are always executed within a running transaction

*Note: Cursors are executed within a transaction*

## Pros of Cursors
- Saves memory
- Good for streaming
- Cursors can be cancelled

## Cons of Cursors
- Its stateful in nature, i.e. there is a dedicated space allocated for cursors
- Long running trasactions

- In Postgres, an example of server side cursor would look like

```
-- declaration
mysql> DECLARE cursor_name CURSOR FOR SELECT id FROM employees WHERE id BETWEEN 90 AND 100;

-- use
mysql> FETCH cursor_name
+-------+
|	id	|
+-------+
|	20	|
+-------+

mysql> FETCH cursor_name
+-------+
|	id	|
+-------+
|	24	|
+-------+

mysql> ETCH cursor_name
+-------+
|	id	|
+-------+
|	45	|
+-------+
-- Notice each fetch returns next row from the result set
```

## Types of Cursors

- Server-Side Cursors:
	- In a server-side cursor, the cursor is created, managed, and operated on the database server.
	- Working :
		- The SQL query is sent to the database server.
		- The server processes the query and creates a cursor on the server to manage the result set.
		- The application on the client side can fetch rows from the server-side cursor as needed.

- client-side cursor,
	- the cursor is created, managed, and operated on the client application.
	- Working :
		- The SQL query is sent to the database server.
		- The entire result set is fetched from the server and stored on the client side.
		- The application can then navigate through the result set on the client side using the cursor.

## Pros and Cons of Server Side cursor and Client side cursor

- Client side server :
	- Network overhead is quite high if result set is large
	- Client might not have memory to process the result

- Server Side Server:
	- Server does the heavylifting
	- Reduced network overhead since entire result is not passed in a single go
