# How to enable Slow Query Log / Slow Log

I'm using MySQL for an application and I need to record all queries that are executed in the DB.

One way to do this is using the MySQL Slow Log records.

## Requirements
I want to acomplish the following:
1. Use slow log in table (not log file).
2. Set the global threshold to 0 seconds (will log all queries).
3. Disable the log once I'm done recording what I want.

## Initial DB State

```
mysql> show variables like '%slow%';
+---------------------------+-------------------------------------------+
| Variable_name             | Value                                     |
+---------------------------+-------------------------------------------+
| log_slow_admin_statements | OFF                                       |
| log_slow_slave_statements | OFF                                       |
| slow_launch_time          | 2                                         |
| slow_query_log            | OFF                                       |
| slow_query_log_file       | /bitnami/mysql/data/a569e083975b-slow.log |
+---------------------------+-------------------------------------------+
```

I need to switch to use tables instead of log files and also set the threshold to 0.

## Set to tables & Start logging

```
SET GLOBAL log_output = 'TABLE';
SET GLOBAL long_query_time = 0;
SET GLOBAL slow_query_log = 'On';
```

## Query Slow Query Log
```
  SELECT start_time,
         user_host,
         query_time,
         lock_time,
         rows_sent,
         rows_examined,
         db,
         last_insert_id,
         insert_id,
         server_id,
         sql_text,
         thread_id
    FROM mysql.slow_log
ORDER BY start_time DESC
   LIMIT 10;
```

### Get the log for a specific DB
```
  SELECT start_time,
         user_host,
         query_time,
         lock_time,
         rows_sent,
         rows_examined,
         db,
         last_insert_id,
         insert_id,
         server_id,
         sql_text,
         thread_id
    FROM mysql.slow_log
WHERE db = 'some_db_name'
ORDER BY start_time DESC
   LIMIT 10;
`

### Turn Logging Off
```
SET GLOBAL slow_query_log = 'Off';
```

# Cleanup the Slow Query Table
```
TRUNCATE mysql.slow_log;
```