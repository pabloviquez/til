# Install Free Valid SSL on Server

**Lets Encrypt** is a free service that allows you to have SSL certificates on the server for free.

https://letsencrypt.org/

### Certbot

Automatically enable HTTPS on your website with EFF's Certbot, deploying Let's Encrypt certificates.

**Do not work for localhost or local servers**

```

wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
./certbot-auto

```

## References & Notes

**Must READ**
https://wiki.mozilla.org/Security/Server_Side_TLS

**To the point and easy to follow notes** https://raymii.org/s/tutorials/Strong_SSL_Security_On_Apache2.html

**Mozilla SSL Configuration Generator** https://mozilla.github.io/server-side-tls/ssl-config-generator/

## Apache Virtual Host Configuration Example


```
<VirtualHost *:443>
    # Enable SSL
    SSLEngine on
    SSLCertificateFile /full/path/for/pem/file.pem
    SSLCertificateKeyFile /full/path/for/key/file.key

    # Strong SSL
    # https://raymii.org/s/tutorials/Strong_SSL_Security_On_Apache2.html
    #SSLCompression off
    SSLProtocol All -SSLv2 -SSLv3
    SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
    SSLHonorCipherOrder on

    # Requires mod_header
    Header always set Strict-Transport-Security "max-age=15768000"

    <FilesMatch "\.(cgi|shtml|phtml|php)$">
                    SSLOptions +StdEnvVars
    </FilesMatch>

    BrowserMatch "MSIE [2-6]" \
            nokeepalive ssl-unclean-shutdown \
            downgrade-1.0 force-response-1.0
    # MSIE 7 and newer should be able to use keepalive
    BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

    Include sites-enabled/designstudio.cnf
</VirtualHost>
```

### SSLCompression off
The CRIME attack uses SSL Compression to do its magic

### SSLv2 and SSLv3
SSL v2 is insecure, so we need to disable it. We also disable SSLv3, as TLS 1.0 suffers a downgrade attack, allowing an attacker to force a connection to use SSLv3 and therefore disable forward secrecy.

SSLv3 allows exploiting of the POODLE bug

### The Cipher Suite
Forward Secrecy ensures the integrity of a session key in the event that a long-term key is compromised. PFS accomplishes this by enforcing the derivation of a new key for each and every session.

This means that when the private key gets compromised it cannot be used to decrypt recorded SSL traffic.

### Forward Secrecy & Diffie Hellman Ephemeral Parameters
The concept of forward secrecy is simple: client and server negotiate a key that never hits the wire, and is destroyed at the end of the session. The RSA private from the server is used to sign a Diffie-Hellman key exchange between the client and the server. The pre-master key obtained from the Diffie-Hellman handshake is then used for encryption. Since the pre-master key is specific to a connection between a client and a server, and used only for a limited amount of time, it is called Ephemeral.

If you have Apache 2.4.8 or later and OpenSSL 1.0.2 or later, you can generate and specify your DH params file:

```
#Generate the parameters
cd /etc/ssl/certs
openssl dhparam -out dhparam.pem 4096

# Add the following to your Apache config.
SSLOpenSSLConfCmd DHParameters "/etc/ssl/certs/dhparam.pem"
```

