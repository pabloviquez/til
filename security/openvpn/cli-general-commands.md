# OpenVPN General Commands

## List all users

```
cd /usr/local/openvpn_as/scripts/
./sacli UserPropGet
```

## Query user properties

```
USERNAME="USERNAMEHERE"

cd /usr/local/openvpn_as/scripts/
./sacli --pfilt ${USERNAME} UserPropGet
```

## OpenVPN Config

```/usr/local/openvpn_as/etc/as.conf```