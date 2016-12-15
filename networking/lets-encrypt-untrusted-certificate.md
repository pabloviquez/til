# Lets-Encrypt Untrusted Certificate

I have a website with an LetsEncrypt SSL, however when I try to make a CURL or socket request using PHP I'm getting the following error:

```
Unable to enable crypto on TCP connection mysite.com: make sure the "sslcafile" or "sslcapath" option are properly set for the environment.
```

## Problem
CURL is unable to verify the SSL certificate against the CA (certificae authority).

The error says (in layman's terms) : **"I'm unable to verify the certificate because I do not have the CA (Certificate Authority) certificate to validate against"**

## Simptons

* Browsers trust the website, they are able to verify the certificate
* Curl throws errors:
```
> curl https://my-awesome-website.com
curl: (60) server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
More details here: http://curl.haxx.se/docs/sslcerts.html

curl performs SSL certificate verification by default, using a "bundle"
 of Certificate Authority (CA) public keys (CA certs). If the default
 bundle file isn't adequate, you can specify an alternate file
 using the --cacert option.
If this HTTPS server uses a certificate signed by a CA represented in
 the bundle, the certificate verification probably failed due to a
 problem with the certificate (it might be expired, or the name might
 not match the domain name in the URL).
If you'd like to turn off curl's verification of the certificate, use
 the -k (or --insecure) option.
root@SJO-DEV-21:/var/www/logs# curl -vvv https://my-awesome-website.com
* Rebuilt URL to: https://my-awesome-website.com/
*   Trying 10.8.0.92...
* Connected to my-awesome-website.com (10.8.0.92) port 443 (#0)
* found 173 certificates in /etc/ssl/certs/ca-certificates.crt
* found 696 certificates in /etc/ssl/certs
* ALPN, offering http/1.1
* SSL connection using TLS1.2 / ECDHE_RSA_AES_128_GCM_SHA256
* server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
* Closing connection 0
curl: (60) server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
More details here: http://curl.haxx.se/docs/sslcerts.html

```

## Debug

To verify the error, we can use OpenSSL in the server to see what's going on:

`openssl s_client -showcerts -connect my-awesome-website.com:443`

**Result**

```
CONNECTED(00000003)
depth=0 CN = my-awesome-website.com
verify error:num=20:unable to get local issuer certificate
verify return:1
depth=0 CN = my-awesome-website.com
verify error:num=21:unable to verify the first certificate
verify return:1
---
Certificate chain
 0 s:/CN=my-awesome-website.com
   i:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
-----BEGIN CERTIFICATE-----
MIIFFjCCA/6gAwIBAgISA+VrgjGFR60YZR9rug+1PPspMA0GCSqGSIb3DQEBCwUA
...
...
-----END CERTIFICATE-----
---
Server certificate
subject=/CN=my-awesome-website.com
issuer=/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
---
No client certificate CA names sent
Peer signing digest: SHA512
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 1997 bytes and written 431 bytes
---
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
    Session-ID: B78268DD77D5B5F77CEF38B1113927C5CEF41ACD0C9E04E666CCB13B4FE3000E
    Session-ID-ctx:
    Master-Key: 4D6F0ECDDFEC97743EDA19FB367BD154A550CC0867A6B85767DFD03A5F2204C61D24061B2E77ED345FD1CD67E0F826BB
    Key-Arg   : None
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    TLS session ticket lifetime hint: 300 (seconds)
    TLS session ticket:
    0000 - a3 06 35 d4 c7 5e f2 02-81 c1 dc 7e 49 57 5d d0   ..5..^.....~IW].
    0010 - 26 c2 8c c3 65 0a a8 89-f1 e0 9d b1 48 de cf 91   &...e.......H...
    0020 - 61 ad dd ef 4d 95 7d a3-aa 11 4e 12 3c d4 01 ff   a...M.}...N.<...
    0030 - aa a8 1c 6a 4a 94 ac 40-fb 0c 01 21 36 7c 3e 35   ...jJ..@...!6|>5
    0040 - 15 11 d9 c9 c9 f1 c5 4e-a7 89 30 17 76 48 15 c0   .......N..0.vH..
    0050 - 44 77 d4 ec 36 1c 93 4c-b1 6d f0 17 c0 21 de b5   Dw..6..L.m...!..
    0060 - d0 3f b5 62 71 33 62 8d-e9 24 f5 cd 48 b8 8e 12   .?.bq3b..$..H...
    0070 - bd c1 b8 e6 ed c7 19 8d-12 3d 7a 35 df 96 9d bc   .........=z5....
    0080 - 14 c4 af ba 1e cf af 04-54 1f e8 6b 00 f5 ba 6e   ........T..k...n
    0090 - 5a 77 a2 e7 4a df 41 50-06 ad 78 6b 37 5b 2c 46   Zw..J.AP..xk7[,F
    00a0 - db 89 df f4 a3 17 a8 10-bd 61 21 50 ef 42 18 d1   .........a!P.B..
    00b0 - a8 11 14 bf a7 4e 82 b4-c6 c4 f7 dd 57 a0 95 ac   .....N......W...

    Start Time: 1481832346
    Timeout   : 300 (sec)
    Verify return code: 21 (unable to verify the first certificate)
```


There are several errors here:
```
depth=0 CN = my-awesome-website.com
verify error:num=20:unable to get local issuer certificate
verify return:1
depth=0 CN = my-awesome-website.com
verify error:num=21:unable to verify the first certificate
verify return:1
```

## Analysis

The problem here is that Apache is not configured correctly, the certificate its using, has **only** the server certificate, it does not have the full chain.

This problem happens with certificates from intermediate CA's, like in this case.

# Solution

Instead of using the `cert.pem` in the Apache configuration, use the `fullchain.pem` certificate.

## Error

Apache configuration with problems:

```
SSLEngine on
SSLCertificateFile /etc/letsencrypt/live/my-awesome-website.com/cert.pem
SSLCertificateKeyFile /etc/letsencrypt/live/my-awesome-website.com/privkey.pem
```

## Good Configuration
```
SSLEngine on
SSLCertificateFile /etc/letsencrypt/live/my-awesome-website.com/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/my-awesome-website.com/privkey.pem
```

Make the change and restart the web server: `sudo service apache2 restart`

# Test Again...

`openssl s_client -showcerts -connect my-awesome-website.com:443`

**Results - NO ERRORS!**

```
CONNECTED(00000003)
depth=2 O = Digital Signature Trust Co., CN = DST Root CA X3
verify return:1
depth=1 C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
verify return:1
depth=0 CN = my-awesome-website.com
verify return:1
---
---
Certificate chain
 0 s:/CN=my-awesome-website.com
   i:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
-----BEGIN CERTIFICATE-----
MIIFFjCCA/6gAwIBAgISA+VrgjGFR60YZR9rug+1PPspMA0GCSqGSIb3DQEBCwUA
...
o4dO1AxVvA9RvlOPTgL8k9RwsCRsojg93gGp5dHcQxhTiDJiyzsX1d+KtPb3zfHn
SuTmZ9C3sbVkYg==
-----END CERTIFICATE-----
 1 s:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
   i:/O=Digital Signature Trust Co./CN=DST Root CA X3
-----BEGIN CERTIFICATE-----
MIIEkjCCA3qgAwIBAgIQCgFBQgAAAVOFc2oLheynCDANBgkqhkiG9w0BAQsFADA/
...
PfZ+G6Z6h7mjem0Y+iWlkYcV4PIWL1iwBi8saCbGS5jN2p8M+X+Q7UNKEkROb3N6
KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg==
-----END CERTIFICATE-----
---
Server certificate
subject=/CN=my-awesome-website.com
issuer=/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
---
No client certificate CA names sent
Peer signing digest: SHA512
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 3174 bytes and written 431 bytes
---
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
    Session-ID: 4F3102358D4D17519EF44E6DB6B2EA696EE5FEF89D3C4D0D9A5DE6AB42048F8A
    Session-ID-ctx:
    Master-Key: C34859B3E042B2504BA9A07B8C1C3BDCB024C278ACAEED074A4CC6A9E12DE8C489C15334D8913185E01609F7507F9BEE
    Key-Arg   : None
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    TLS session ticket lifetime hint: 300 (seconds)
    TLS session ticket:
    0000 - ab 4d 03 e0 33 d7 ea 8e-f5 58 e2 7a 1c 90 41 3c   .M..3....X.z..A<
    0010 - 3a 7a 32 fa fa 95 d2 48-73 16 5d da 3a d6 2f 5b   :z2....Hs.].:./[
    0020 - 3e c1 cd 76 aa e5 a6 ae-fd 4a 27 88 54 02 d6 9a   >..v.....J'.T...
    0030 - 31 27 ce 11 51 5f 59 33-72 a3 96 80 64 a1 4f 00   1'..Q_Y3r...d.O.
    0040 - c3 f5 b4 8b 4e 1b 9f 28-6e 67 ae 7e 6f 06 e8 40   ....N..(ng.~o..@
    0050 - 75 1c 13 2f b0 c2 29 ce-6b e6 f4 e8 99 c3 91 45   u../..).k......E
    0060 - 16 b0 d6 7a 00 95 e7 2b-7f 63 52 70 f2 e2 07 c6   ...z...+.cRp....
    0070 - 2c d6 bd cd 2c 9b 4f 7c-51 93 8f 1e 91 bc 6d d8   ,...,.O|Q.....m.
    0080 - 1d 75 cc 11 e6 79 e4 52-40 52 72 85 12 ec 35 c3   .u...y.R@Rr...5.
    0090 - d1 d9 ac 38 70 62 c4 c4-58 0f 1f f0 80 f6 f4 ab   ...8pb..X.......
    00a0 - 40 2d de e7 04 cf 56 e6-4b 16 8c 7c 29 58 14 13   @-....V.K..|)X..
    00b0 - 05 50 9d 21 4e 0d 56 f9-41 3c 1a d9 be 1a 13 24   .P.!N.V.A<.....$

    Start Time: 1481834336
    Timeout   : 300 (sec)
    Verify return code: 0 (ok)
---
```