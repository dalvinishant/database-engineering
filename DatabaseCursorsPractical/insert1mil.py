import psycopg2

con = psycopg2.connect(
	host = "localhost",
	port="5433",
	user="postgres",
	password="root",
	database="postgres"
)
cur = con.cursor()

for i in range(100000):
	cur.execute('insert into employees (id, name) values (%s, %s)', (i, f'test{i}'))
con.commit()

con.close()