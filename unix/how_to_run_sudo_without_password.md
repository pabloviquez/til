# How to run sudo without password

IF you have a development box that want to remove the password everytime you need to use the super privileges, you can do so by using the `visudo` tool:

```bash
sudo visudo
```

it will edit a file like this one:

```bash
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d

```

## Remove sudo password prompt

If you want to remove the password prompt to certain user, just add following line at the end of the file:

```bash
USERHERE ALL=(ALL) NOPASSWD: ALL
```

## Whats my user?

You can view your user, group and all informarion with several commands:

### View UserID, Group 

```bash

> id
uid=1001(pablo) gid=1001(pablo) groups=1001(pablo),27(sudo),33(www-data)

```

### Just username

```bash
> id -un
pablo

```

**OR**

```bash
> whoami
pablo

```

**OR**

```bash
> echo $USER
pablo
```


