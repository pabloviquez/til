# AWS RDS - mysqldump times out

I have an AWS RDS MySQL database, and I tried to export the data, however it keeps giving me a timeout.

## Issue

```
> mysqldump -h myaws.rds.database.com database > database.sql
Error 2013: Lost connection to MySQL server during query when dumping table
```

## Solution
To be able to resolve this, you need to compress the database communication between client-server:

```
mysqldump -h attthanks-prod-db-a.cueogitufcyw.us-east-1.rds.amazonaws.com \
    --single-transaction \
    --opt \
    --routines \
    --triggers \
    --disable-keys \
    --databases  MYDATABASENAME \
    --compress > database.sql
```