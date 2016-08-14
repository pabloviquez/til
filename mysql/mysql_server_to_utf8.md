# How to set the MySQL Server to use UTF-8 by default

## Ubuntu

Create a new file called `utf8.cnf` inside the directory: `/etc/mysql/conf.d`

Put the following content inside the file:

```
# Setting All Connections to UTF-8
[client]
default-character-set=utf8

[mysql]
default-character-set=utf8

[mysqld]
character-set-server = utf8
collation-server = utf8_general_ci
init-connect='SET NAMES utf8'
```

***Restart the server***

```
sudo service mysql restart
```

***Login and verify***

You should see something like this:

```
> mysql -u -p

mysql> \s
--------------
mysql  Ver 14.14 Distrib 5.7.13, for Linux (x86_64) using  EditLine wrapper

Connection id:          3
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         5.7.13-0ubuntu0.16.04.2 (Ubuntu)
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8
Db     characterset:    utf8
Client characterset:    utf8
Conn.  characterset:    utf8
UNIX socket:            /var/run/mysqld/mysqld.sock
Uptime:                 4 sec

Threads: 1  Questions: 5  Slow queries: 0  Opens: 107  Flush tables: 1  Open tables: 26  Queries per second avg: 1.250
```
