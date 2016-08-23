# MySQL Silent Install with Pre determined Password


## Ubuntu, Version 5.7

Setting default password to **123456**

```
sudo apt-get install -y -V  debconf-utils

sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-tools select'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-distro select ubuntu'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-5.7'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Apply'

export DEBIAN_FRONTEND=noninteractive
wget http://dev.mysql.com/get/mysql-apt-config_0.7.3-1_all.deb
dpkg --install mysql-apt-config_0.7.3-1_all.deb
apt-get update

# Set default password
debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123456'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123456'

debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password 123456'
debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password 123456'

apt-get -y -V install mysql-server mysql-client

```


## Ubuntu, Version 5.6

Setting default password to **123456**


```
wget http://dev.mysql.com/get/mysql-apt-config_0.6.0-1_all.deb
dpkg -i mysql-apt-config_0.6.0-1_all.deb
apt-get update

# Set default password
debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123456'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123456'
apt-get -y -V install mysql-server mysql-client

```
