# OpenVPN Login Troubleshoot


## Authenticate User
```
cd /usr/local/openvpn_as/scripts/
USER="USERNAME"
PASS="userpassword"
./authcli --user ${USER} --pass ${PASS}
```

## Where are the OpenVPN logs located?

```
/var/log/openvpnas.log
```

