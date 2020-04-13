# OpenVPN CLI - Change User Password

To change the user password, you need to execute the ```sacli``` tool as follow:


```
username="myusername"
new_password="this-is-my-highly-secure-password"

cd /usr/local/openvpn_as/scripts/
./sacli --user ${username} --new_pass ${new_password} SetLocalPassword
```
