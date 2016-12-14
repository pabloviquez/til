# How to open a specific port on MAC

On mac you can allow an application to receive incomming transmissions:

System Preferences > Security & Privacy > Firewall

## Open a specific port

I wanted to open the port 9000 in my computer. To do that, I edited the file `/etc/pf.conf` 

Add this line at the bottom of the file:

```
pass in proto tcp from any to any port 9000

```

Then reload the file:

```bash

sudo pfctl -vnf /etc/pf.conf

```

[ Test it, monitoring traffic ](how-to-monitor-certain-port-traffic.md)
