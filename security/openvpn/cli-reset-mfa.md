# OpenVPN CLI - Reset Multi Factor Authentication

To reset the user Multi-Factor Authentication token do the following:

## Remove and Enter the Multi-factor again.
```
username="USERNAME HERE"
cd /usr/local/openvpn_as/scripts/
sudo ./sacli --user ${username} --lock 0 GoogleAuthLock
```

**NOTE**
```
--lock=  Lock/unlock Google Authenticator key,
         0:unlocked,
         1:locked (if unlocked, will be visible to end user
           in CWS, and will automatically lock on first
           successful VPN login)
```
