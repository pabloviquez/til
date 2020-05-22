# How to Create or Renew Automatically a Let's Encrypt Certificate and Install it on OpenVPN

The following script will try to create or renew a certificate with Let's Encrypt and install it on OpenVPN.

Must be executed as root.

```
sudo bash renew.sh
```

## Script

**File: renew.sh**
```bash
# -----------------------------------------------------------------------------
# -- OpenVPN SSL Certificate Renewal
# --
# --
# -- @author Pablo Viquez <pviquez@pabloviquez.com>
# -----------------------------------------------------------------------------

CUSER=$(whoami)
DOMAIN="domain_here.com"
ADMIN_EMAIL="DevOps Admin Email here@domain.com"

echo "****************************************************************"
echo "**"
echo "** OpenVPN SSL Certificate Renewal Script"
echo "**"
echo -n "** Executing @ "
date
echo "**"
echo "** Domain to renew: ${DOMAIN}"
echo "** User running script: ${CUSER}"
echo "**"
echo "****************************************************************"
echo ""

if [ ${CUSER} != "root" ]; then
  echo "Error :: Must be executed using root"
  echo "Cannot continue, will not continue"
  exit
fi

echo "Switching directory"
cd /usr/local/openvpn_as/scripts

echo "Stop apache web server"
service apache2 stop

echo "Renewing certificate"
certbot certonly --standalone -n -d ${DOMAIN} --agree-tos --email ${ADMIN_EMAIL}

echo "Restart certificate"
service apache2 restart

echo "Installing certificate"
./sacli --key "cs.cert" --value_file "/etc/letsencrypt/live/${DOMAIN}/cert.pem" ConfigPut
./sacli --key "cs.ca_bundle" --value_file "/etc/letsencrypt/live/${DOMAIN}/chain.pem" ConfigPut
./sacli --key "cs.priv_key" --value_file "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" ConfigPut

echo "Restarting OpenVPN"
./sacli start

```