const app = require('express')();
const {Client} = require("pg");
const crypto = require("crypto")
const cors = require('cors');
const HashRing = require("hashring");
const hr = new HashRing();

// app.use(cors());

hr.add("5432")
hr.add("5433")
hr.add("5434")

const clients = {
	"5432": new Client({
		"host": "localhost",
		"port": "5432",
		"user": "postgres",
		"password": "root",
		"database": "postgres"
	}),
	"5433": new Client({
		"host": "localhost",
		"port": "5433",
		"user": "postgres",
		"password": "root",
		"database": "postgres"
	}),
	"5434": new Client({
		"host": "localhost",
		"port": "5434",
		"user": "postgres",
		"password": "root",
		"database": "postgres"
	})
}
connect()
async function connect(){
	await clients["5432"].connect();
	await clients["5433"].connect();
	await clients["5434"].connect();
}

app.get("/:urlId", async (req, res) => {
	const urlId = req.params.urlId
	const server = hr.get(urlId)
	console.log(urlId)
	const result = await clients[server].query("SELECT * FROM URL_TABLE WHERE url_id = $1;", [urlId]);
	if(result.rowCount > 0){
		res.send({
			"urlID": urlId,
			"url": result.rows[0],
			"server": server
		})
	}else{
		res.sendStatus(404)
	}
})

app.post("/",  async (req, res) => {
	const url = req.query.url;
	//consistently hash to get a port!
	const hash = crypto.createHash("sha256").update(url).digest("base64")
	const urlID = hash.substr(0, 5)
	const server = hr.get(urlID)

	await clients[server].query("insert into url_table (url, url_id) values($1, $2)", [url, urlID])

	res.send({
		"urlID": urlID,
		"url": url,
		"server": server
	})

})

app.listen(8081, () => console.log("Listening 8081"))