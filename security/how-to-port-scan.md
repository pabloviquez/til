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


# Update - With NetCat

I want to scan for open ports only, do a quick initial scan.

```
nc -v -z -w 1 -G 1 somehost.or.ipaddress.com 20-1024
```
Check and wait for 1 second for all ports from 20 to 1024. Will result in something like:

I didn't use the `-n` which avoids DNS lookup as I was using a domain name, however, to make it faster, avoid DNS lookups using the `-n`

```bash
$ nc -v -z -w 1 -G 1 somehost.or.ipaddress.com 20-1024
nc: connectx to somehost.or.ipaddress.com port 20 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 21 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 22 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 23 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 24 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 25 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 26 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 27 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 28 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 29 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 30 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 31 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 32 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 33 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 34 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 35 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 36 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 37 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 38 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 39 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 40 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 41 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 42 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 43 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 44 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 45 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 46 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 47 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 48 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 49 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 50 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 51 (tcp) failed: Operation timed out
nc: connectx to somehost.or.ipaddress.com port 52 (tcp) failed: Operation timed out
 connectx to home.pabloviquez.com port 24 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 25 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 26 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 27 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 28 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 29 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 30 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 31 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 32 (tcp) failed: Operation timed out
...
nc: connectx to home.pabloviquez.com port 51 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 52 (tcp) failed: Operation timed out
Connection to home.pabloviquez.com port 53 [tcp/domain] succeeded!
nc: connectx to home.pabloviquez.com port 54 (tcp) failed: Operation timed out
nc: connectx to home.pabloviquez.com port 55 (tcp) failed: Operation timed out
```

The scan for port 53, tells me the port is open, however does not tell me if it's responding. More investigation is needed to understand the port services or capabilities.