#### Practical Purpose
- Spin up two postgres instance with docker
- Make one master another one standby
- connect standby to master
- Make master aware of the standby

### Creating Docker Master and Standby Instance

- Create a folder
mkdir vol
mkdir rep (to copy data to host from container)

- Creating Master
docker run \
	--name pmaster (name of container)
	-p 5432:5432 \ (port)
	-v /Users/user/Dev/Database\ Engineering/DatabaseReplicationPratical/rep/pmaster_data:/var/lib/postgresql/data \ (volume we want to copy to host)
	-e POSTGRES_PASSWORD=root  \ (environment variable)
	-d postgres

- Above command creates `pmaster_data` inside `rep` folder

- Creating Standby
docker run
	--name pstandby (name of container)
	-p 5432:5432  (port)
	-v /Users/user/Dev/Database\ Engineering/DatabaseReplicationPratical/rep/pstandby_data:/var/lib/postgresql/data  (volume we want to copy to host)
	-e POSTGRES_PASSWORD=root  (environment variable)
	-d postgres

- Above command creates `pmstandby_data` inside `rep` folder

- Now replace `pstandby_data` with `pmaster_data`
mv pstandby_data pstandby_data_bk (creates a backup folder)
cp -R pmaster_data pstandby_data (copies and replaces pmaster_data into pstandby_data)

### Why are we copying pmaster_data into pstandby_data?
- We need `pmaster` and `pstandby` to be exact replica of each other
- Alternatively, pgbackup can also be used

- Stop the containers once
docker stop pmaster pstandby

### Setting Up Master and Standby

- Goto rep/pmaster_data and Edit pg_hba.conf to append the following
host replication postgres all md5

- Goto rep/pstandby_data and edit postgresql.conf the following
primary_conninfo = 'application_name=standby1 host=172.17.0.2 port=5432 user=postgres password=root'

(We set host=172.17.0.2 because, this is what we get in `docker inspect pmaster` )

- Create a signal file in pstandby_data folder
touch stanby.signal

- Goto rep/pmaster_data and edit vi postgresql.conf the following
synchronous_standby_names = 'first 1 (standby1)'

- Start both the containers
docker start pmaster pstandby


#### Pros & Cons of Replication
- Pros
	- Horizontal Scalability (Reads are scalable)
	- Make region based queries - DB per region
- Cons
	- Scaling Writes is quite complex(multi-master)
	- Eventual Consistency (not necessarily a con)
	- Slow writes (in case of synchronous replication)