const mysql = require('mysql2/promise');

//1 . Run connectMyISAM to understand how transaction works with MyISAM table employees_myisam
// connectMyISAM()
//2. Run connectInnoDB to understand how transaction works with InnoDB table employees_innodb
// connectInnoDB()

async function connectMyISAM(){
	try{
		// Add a breakpoint here
		const con = await mysql.createConnection({
			'host': 'localhost',
			'port': '3307',
			'user': 'root',
			'password': 'root',
			'database': 'test'
		})
		await con.beginTransaction()
		// try inserting into myisam table
		await con.query('INSERT INTO employees_myisam (name) values(?)', ['Nishant'])
		// Do `select * from employees_myisam` on mysql client before following line executes
		// Record is inserted in DB even before commit was executed !!!
		// Why? Because MyISAM does not support transactions!! No row level locks! No ACID! No Rollbacks!
		await con.commit()
		await con.close()
		console.log(result)
	}
	catch(ex){
		console.error(ex)
	}finally{

	}
}

async function connectMyInnoDB(){
	try{
		// Add a breakpoint here
		const con = await mysql.createConnection({
			'host': 'localhost',
			'port': '3307',
			'user': 'root',
			'password': 'root',
			'database': 'test'
		})
		await con.beginTransaction()
		// try inserting into myisam table
		await con.query('INSERT INTO employees_innodb (name) values(?)', ['Nishant'])
		// Do `select * from employees_innodb` on mysql client before following line executes
		// You should expect to see no records . Reason: this transaction is not yet committed
		// However, running following line returns the uncommitted record which we just inserted in the line above
		// Reason: Changes done by the transaction are visible to the transaction
		const [rows, schema] = await con.query("select * from employees_innodb")
		await con.commit()
		await con.close()
		console.log(result)
	}
	catch(ex){
		console.error(ex)
	}finally{

	}
}