# MySQL InnoDB Crash Recovery

Today I was importing an SQL into a VM and for some reason the machine crashed right in the
middle of the transaction.

After restarting the VM, MySQL didn't start and notice the curruption on the tables.

In this particular case, I knew which tables were problematic, however, troubleshooting them was not easy.

## Troubleshoot :: Start MySQL in Recovery Mode

Config file:  /etc/mysql/mysql.conf.d/mysqld.cnf (Ubuntu Machine)

Added this line:
```
[mysqld]
innodb_force_recovery = 1
```

The innodb_force_recovery try to start MySQL in recovery mode, there's a catch though,
**levels 4 and up do not allow you to drop tables**.

### Levels explanation
`innodb_force_recovery = 1` :: **1 (SRV_FORCE_IGNORE_CORRUPT)** : Lets the server run even if it detects a corrupt page. Tries to make SELECT * FROM tbl_name jump over corrupt index records and pages, which helps in dumping tables.

`innodb_force_recovery = 2` :: **2 (SRV_FORCE_NO_BACKGROUND)** : Prevents the master thread and any purge threads from running. If a crash would occur during the purge operation, this recovery value prevents it.

`innodb_force_recovery = 3` :: **3 (SRV_FORCE_NO_TRX_UNDO)** : Does not run transaction rollbacks after crash recovery.

`innodb_force_recovery = 4` :: ⚠️ **4 (SRV_FORCE_NO_IBUF_MERGE)** : Prevents insert buffer merge operations. If they would cause a crash, does not do them. Does not calculate table statistics. This value can permanently corrupt data files. After using this value, be prepared to drop and recreate all secondary indexes. Sets InnoDB to read-only.

`innodb_force_recovery = 5` :: ⚠️ **5 (SRV_FORCE_NO_UNDO_LOG_SCAN)** : Does not look at undo logs when starting the database: InnoDB treats even incomplete transactions as committed. This value can permanently corrupt data files. Sets InnoDB to read-only.

`innodb_force_recovery = 6` :: ⚠️ **6 (SRV_FORCE_NO_LOG_REDO)** : Does not do the redo log roll-forward in connection with recovery. This value can permanently corrupt data files. Leaves database pages in an obsolete state, which in turn may introduce more corruption into B-trees and other database structures. Sets InnoDB to read-only.


🆘  **TIP** 🆘 Start your DB at level ‼️  **1**, if it fails go for the next level.

## Troubleshoot :: Export the DB

If you manage to start the DB on levels 1-3, then dump the DB:\

```
mysqldump myschema > schema.sql
```

## Troubleshoot :: Run a check on tables

```
mysqlcheck -uroot -p BROKEN_DB
```

If you see a table corrupted, then try to repar it:

```
mysqlcheck -uroot -p -r BROKEN_DB BROKEN_TABLE
```


## Troubleshoot :: innodb_force_recovery 6

If you had to start the DB on recovery level 6, then your redo log has issues.

The redo log is located at the data directory path, in my case, it's located at : `/var/lib/mysql`


```
cd /var/lib/mysql
mv ib_logfile0 ib_logfile0.bak
mv ib_logfile1 ib_logfile1.bak
```

Restart.

## Troubleshoot :: innodb_force_recovery 5

Your undo log is broken.

```
cd /var/lib/mysql
mv ibdata1 ibdata1.bak
```

Restart.


## Troubleshoot :: Unable to drop DB
ibdata1
In this case you need to drop the database manually / physically.

```
cd /var/lib/mysql
rm -Rf BROKEN_DB
```


## References
* https://dev.mysql.com/doc/refman/8.0/en/forcing-innodb-recovery.html