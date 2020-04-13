# How to do a port scan locally and remote

## Install - RHEL
```
sudo yum update
sudo yum install nmap -y
```

## Install Ubuntu
```
sudo apt-get update
sudo apt-get install nmap -y
```

## Scan local computer

```
sudo nmap 127.0.0.1
```

## Scan local network

```
sudo nmap 192.168.0.0/24
```

## Scan a target for all ports
```
sudo nmap 192.168.0.119
```
