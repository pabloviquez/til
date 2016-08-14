# Install PHP 5.6.x

You can use the latest build using the Ondřej Surý repository: `https://launchpad.net/~ondrej/+archive/ubuntu/php`

## Install Key

```
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
```

## Install PHP and Packages

```
sudo apt-get -y -V install php5.6 php5.6-cli php5.6-dev
sudo apt-get -y -V install php5.6-cli php5.6-pear php5.6-intl php5.6-sybase php5.6-apcu php5.6-curl php5.6-memcache php5.6-memcached php5.6-gettex
sudo apt-get -y -V install php5.6-gd php5.6-imagick php5.6-ldap
sudo apt-get -y -V install php5.6-intl php5.6-sybase php5.6-apcu
sudo apt-get -y -V install php5.6-mcrypt php5.6-mysqlnd php5.6-xdebug
sudo apt-get -y -V install php-gettext phpunit
```