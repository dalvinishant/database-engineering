#### Primay Vs Secondary

*Primary Key*
By default table heap does not have order.
When we add primary key (clustering), everything is ordered around that key. As a result, there is an additional operation is required
However, database engines are smart and they take care of doing this efficiently but still its an overhead.

*Secondary Key*
Secondary key is basically an index where the table is not ordered in itself, however the ordering is maintained sperately. As a result, when this table is queried, rows to fetch are collected from secondary key and then fetched from heap.

Postgres have all the keys are secondary keys
