# Use multiple PHP Versions

**Unix Only** at least, the following steps

By using `ppa:ondrej/php` repository you can switch from PHP versions

## Apache

Disable PHP 5.6, enable PHP 7.0
```
sudo a2dismod php5.6
sudo a2enmod php7.0
sudo service apache2 restart
```

## CLI - Debian & Ubuntu

### List possible alternatives:

```bash
sudo update-alternatives --list php
```

**Example**
```
> sudo update-alternatives --list php

/usr/bin/php5
/usr/bin/php7.0

```

### Switch version of PHP on CLI

```bash
sudo update-alternatives --config php
```

**Example**

```bash
> update-alternatives --config php

There are 2 choices for the alternative php (providing /usr/bin/php).

  Selection    Path             Priority   Status
------------------------------------------------------------
* 0            /usr/bin/php7.0   70        auto mode
  1            /usr/bin/php5     50        manual mode
  2            /usr/bin/php7.0   70        manual mode

Press enter to keep the current choice[*], or type selection number: 1
update-alternatives: using /usr/bin/php5 to provide /usr/bin/php (php) in manual mode.

```

**Test**
```
> php -v
PHP 5.6.23-1+deprecated+dontuse+deb.sury.org~precise+1 (cli) 
Copyright (c) 1997-2016 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies
    with Zend OPcache v7.0.6-dev, Copyright (c) 1999-2016, by Zend Technologies
```

## How does it work

Everything is installed under `/etc/alternatives`

```bash
> which php
/usr/bin/php

> ls -la /usr/bin/ph*
lrwxrwxrwx 1 root root      22 Aug  4 17:21 /usr/bin/phar -> /etc/alternatives/phar
-rwxr-xr-x 1 root root   14823 Jun 24 09:49 /usr/bin/phar5
lrwxrwxrwx 1 root root      12 Aug 22 12:59 /usr/bin/phar7.0 -> phar.phar7.0
lrwxrwxrwx 1 root root      27 Aug 24 00:16 /usr/bin/phar.phar -> /etc/alternatives/phar.phar
-rwxr-xr-x 1 root root   14826 Aug 22 12:59 /usr/bin/phar.phar7.0
lrwxrwxrwx 1 root root      21 Aug  4 17:21 /usr/bin/php -> /etc/alternatives/php
-rwxr-xr-x 1 root root 8903880 Jun 24 09:50 /usr/bin/php5
-rwxr-xr-x 1 root root 4344960 Aug 22 13:00 /usr/bin/php7.0
lrwxrwxrwx 1 root root      28 Aug  4 17:22 /usr/bin/php-config -> /etc/alternatives/php-config
-rwxr-xr-x 1 root root    5369 Jun 24 09:49 /usr/bin/php-config5
-rwxr-xr-x 1 root root    4179 Aug 22 12:59 /usr/bin/php-config7.0
lrwxrwxrwx 1 root root      24 Aug  4 17:22 /usr/bin/phpize -> /etc/alternatives/phpize
-rwxr-xr-x 1 root root    4730 Jun 24 09:49 /usr/bin/phpize5
-rwxr-xr-x 1 root root    4662 Aug 22 12:59 /usr/bin/phpize7.0
-rwxr-xr-x 1 root root    2119 Dec 13  2010 /usr/bin/phpunit


> ls -la /etc/alternatives/ph*
lrwxrwxrwx 1 root root 16 Aug 24 00:16 /etc/alternatives/phar -> /usr/bin/phar7.0
lrwxrwxrwx 1 root root 32 Aug 24 00:16 /etc/alternatives/phar.1.gz -> /usr/share/man/man1/phar7.0.1.gz
lrwxrwxrwx 1 root root 21 Aug 24 00:16 /etc/alternatives/phar.phar -> /usr/bin/phar.phar7.0
lrwxrwxrwx 1 root root 37 Aug 24 00:16 /etc/alternatives/phar.phar.1.gz -> /usr/share/man/man1/phar.phar7.0.1.gz
lrwxrwxrwx 1 root root 13 Aug 24 23:46 /etc/alternatives/php -> /usr/bin/php5
lrwxrwxrwx 1 root root 29 Aug 24 23:46 /etc/alternatives/php.1.gz -> /usr/share/man/man1/php5.1.gz
lrwxrwxrwx 1 root root 22 Aug 24 00:16 /etc/alternatives/php-config -> /usr/bin/php-config7.0
lrwxrwxrwx 1 root root 38 Aug 24 00:16 /etc/alternatives/php-config.1.gz -> /usr/share/man/man1/php-config7.0.1.gz
lrwxrwxrwx 1 root root 18 Aug 24 00:16 /etc/alternatives/phpize -> /usr/bin/phpize7.0
lrwxrwxrwx 1 root root 34 Aug 24 00:16 /etc/alternatives/phpize.1.gz -> /usr/share/man/man1/phpize7.0.1.gz

```






