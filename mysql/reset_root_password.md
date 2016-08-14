# Reset MySQL root Password

## Ubuntu, MySQL Version 5.7

A simpler way to reset the MySQL password is to start the server without the privileges loaded.

To do that, you need to stop the MySQL server and then start MySQL without the grant tables `(--skip-grant-tables)`


### Stop the server
sudo /etc/init.d/mysql stop

### Start MySQL
```
mysqld_safe --skip-grant-tables &
```

### Login
```
mysql -uroot
```

### Update the password
```
USE mysql;

UPDATE user 
   SET authentication_string = PASSWORD('123456'),
       password_expired = 'N'
 WHERE User = 'root' AND Host = 'localhost';

FLUSH PRIVILEGES;
```

## MySQL 5.7 Notes

Since version 5.7.6, the user table change the password field to `authentication_string`



### Reference
https://dev.mysql.com/doc/refman/5.7/en/resetting-permissions.html