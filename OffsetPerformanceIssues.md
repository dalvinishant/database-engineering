#### Why not to use offset while querying
- Offset is evaluated after the result set is generated.
- For E.g:-
	- Consider following schema:
		- news(id int serial primary key, news_title varchar)
		- Scenario 1:
			- Query 	: SELECT id, news_title FROM news ORDER BY id DESC LIMIT 10 OFFSET 0
			- Execution	: Here, execution is pretty straight forward, where we are only fetching last 10 rows from heap
		- Scenario 2:
			- Query		: SELECT id, news_title FROM news ORDER BY id DESC LIMIT 10 OFFSET 100
			- Execution	: Here, when query is executed, DB fetches last 110 rows(or pages having 110 rows) from heap --> This should be avoided as its too much overhead
			- As offset increases, the overhead to fetch rows for calculating offset also increases

#### Alternative to avoid use of offset
- Offset use can be avoided by using last used id (given id field is an ordered index)
- Consider the following query:
	- Query		: SELECT id, news_title FROM news WHERE id < last_used_id ORDER BY id DESC LIMIT 10;
	- Execution : DB makes use of Reverse Index Scan since id is an indexed field and the numbers of rows scans are very low
