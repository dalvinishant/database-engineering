

## Setup
- Init docker container for postgres
```
docker run --name pgbase -p 5433:5432 -e POSTGRES_PASSWORD=root postgres
```

- Init docker container for pgadmin
```
docker run --name pgadmin -p 5555:80 -e PGADMIN_DEFAULT_EMAIL='admin@nomail.com' -e PGADMIN_DEFAULT_PASSWORD='root'  -d dpage/pgadmin4
```

- Execute insert1mil.py script using, to insert records into postgres DB
```
python3 run insert1mil.py
```

## Objective

- Objective is to compare the time taken by server side cursor and client side cursor

## Execution

- For Server Side cursor
	- Execute
	- ```
		python3 run servercursor.py
	```
- For Client Side cursor
	- Execute
	- ```
		python3 run clientcursor.py
	```

*Compare the time taken for executing the query and parsing the result in both the cases*