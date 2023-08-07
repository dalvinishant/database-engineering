
*Check DatabaseShardingPractical.sql file*
- We are creating a file that we want to run on our database instance to create a table

*Check Dockerfile*
- Dockerfile has the commands to
	- Pull Postgres Image
	- Copy our .sql (above) to the image (docker container that we create)

*Build Image*
docker build -t pgshard .

*Create Containers*
docker run --name pgshard1 -p 5432:5432 -d pgshard
docker run --name pgshard2 -p 5433:5432 -d pgshard
docker run --name pgshard3 -p 5433:5432 -d pgshard

*Get Pgadmin image*
docker pull dpage/pgadmin4

*Create pgadmin container*
docker run --name pgadmin -p 5555:80 -e PGADMIN_DEFAULT_EMAIL='admin@nomail.com' -e PGADMIN_DEFAULT_PASSWORD='root'  -d dpage/pgadmin4

*Register Postgres servers to Pgadmin*
Go to pg admin on http://localhost:5555/browser
login using email and password set while creating container
Right click on servers, then register server

*Init Node project*
create a folder for project
go to project folder

npm init -y  -> (This creates a node project with basic package.json)

create index.js file

*Write code in index.js for implementing a url shortner*
what index.js does?
- using "pg" npm package connect to the databases that we created earlier
- what are we supposed to do?
	- Upon hiting node server with a short url, we should get the actual url (this is what url shortner is for)
		- for e.g : I should be able to go to www.google.com if I type something like http:localhost/asqwe
	- In order to implement this, we use "hashring" for consistent hashing across databases
	- Why hashring and consistent hashing?
		- We have multiple database servers
		- In each database server we have a table having same schema (defination of sharding:- Multiple Database servers, same table with same schema)
		- Since we have multiple database servers, we need to decide where(i.e in which database server) do we want to store mapping between short url and the actual url
		- this mapping would be decided using consistent-hashing and "hashring" is a node package that helps us with it
	- We create and store mapping for short url and actual url by running several post API calls from browser
	- Each call has the actual url which is converted to short url and stored in one of the database servers
	- Once database servers have the mapping populated, we fetch the actual url from short url
	- Again, we do a get API call using the short url
	- This API, internally takes the short urlid, gets the server from hashring (hashring tells us where the actual url is for the given short url)
	- Once we have the server, we connect to that server and run the query to fetch actual url details

*Pros of Sharding*
- Scalability:
	- Data is scalabale since it resides in multiple locations in tranches
	- Processing is scalable since sharding involves data being in stored in multiple database instances, which implies multiple database servers
- Security: Access to the shards can be in restricted mode
- Optimal: Since data is distributed, index size is smaller, hence faster queries

*Cons of Sharding*
- Complex for clients - Clients need to be aware about the shards
- Transactions across shards is a problem - Since we are dealing with multiple database instances, it is difficult to query across shards
- Rollbacks are very hard
- Schema changes are very difficult - Change needs to be propogated across shards
- Joins are very difficult