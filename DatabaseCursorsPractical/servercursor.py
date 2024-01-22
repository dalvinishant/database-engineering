import psycopg2
import time as t

con = psycopg2.connect(
	host = "localhost",
	port="5433",
	user="postgres",
	password="root",
	database="postgres"
)

s = t.time()
# client side cursor init
cur = con.cursor("test_server")
e = (t.time() - s)*1000

print(f'Cursor established in {e} ms')

s = t.time()
cur.execute('select * from employees')
e = (t.time() - s)*1000
print(f'Query all rows in {e} ms')

s = t.time()
rows = cur.fetchmany(50)
e = (t.time() - s)*1000
print(f'Fetching first 50 rows in {e} ms')

cur.close()
con.close()