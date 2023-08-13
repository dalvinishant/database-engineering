
#### What is Exclusive Lock
- When a transaction obtains exclusive(special) privilege on a certain value(rows) to read/write, so that no other transaction can read. Fail the transactions that try to do so if a value is having exclusive lock
- If a transaction wants obtain an exclusive lock, there must not be any shared lock on the value

#### What is Shared Lock
- When a transaction obtains special privilege on a certain value(rows) to read, so that no other transaction can write. Fail the transactions that try to do so if a value is having shared lock
- If a transaction wants obtain an shared lock, there must not be any exclusive lock on the value

Shared Lock and Exclusive Lock was introduced to ensure consistency

#### Deadlock
- When transactions are awaiting Locks to be release in an interdependent manner