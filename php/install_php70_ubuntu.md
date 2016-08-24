# Install PHP 7.0.x

You can use the latest build using the Ondřej Surý repository: `https://launchpad.net/~ondrej/+archive/ubuntu/php`

## Install Key

```
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
```

## Install PHP and Packages

```
sudo apt-get -y -V install php7.0
sudo apt-get -y -V install php7.0-dev php7.0-cli
sudo apt-get -y -V install php7.0-curl php7.0-soap php7.0-intl php-gettext php7.0-ldap  php7.0-mcrypt
sudo apt-get -y -V install php7.0-sybase php7.0-memcache php7.0-memcached php7.0-mysqlnd php7.0-apcu
sudo apt-get -y -V install php7.0-gd php7.0-imagick
sudo apt-get -y -V install phpunit php-pear php7.0-xdebug
```