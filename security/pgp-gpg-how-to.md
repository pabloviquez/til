# PGP (Pretty Good Privacy) - GnuPG (Privacy Guard)

GnuPG is a complete and free implementation of the OpenPGP standard as defined by RFC4880 (also known as **PGP**).

## How to view keys?

**List Keys**
```bash
gpg --list-keys
```

**Long Format**
```bash
gpg --list-secret-keys --keyid-format=long

```

Returns something like:
```
$ gpg --list-keys --keyid-format=long

/Users/lol/.gnupg/pubring.kbx
--------------------------------------
pub   rsa4096/130427EBEE0879FC 2023-08-04 [SC] [expires: 2026-08-03]
      9CCB9A44EEF7660E74FF0C5C130427EBEE0879FC
uid                 [ultimate] Pablo Viquez <my_name@myemail.com>
```

**Explanation**
|Value|Description|
|---|---|
|`pub`| Public key|
|`rsa4096` |Cipher used.|
|`130427EBEE0879FC` | Long ID |
|`2023-08-04` | Issue date |
|`[SC]` |Signing, Certification|
|`[expires: 2026-08-03]` | Expiration date |
|`9CCB9A44EEF7660E74FF0C5C130427EBEE0879FC` | Fingerprint |
| `uid` | The User ID of the key. Name and email. |
| `[ultimate]` | Trust level. |


## Import another person key

When you want to encrypt a file using someone's else public key.

```bash
gpg --import PUBLIC_KEY_FILE_HERE
```

## Create a Key

GPG supports multiple key signing algorithms. The ones supported by GitHub are:
* RSA
* ElGamal
* DSA
* ECDH
* ECDSA
* EdDSA

The one recommended to use is RSA 2048 or RSA 4096.
> The overwhelming majority of users will be well-served by generating
> 2048-bit RSA keys. This is the default behavior for GnuPG.

```bash
gpg --default-new-key-algo rsa4096 --gen-key
```

To get a full feature set of questions do:
```bash
gpg --full-generate-key
```

## Encrypt a file
```bash
gpg --encrypt --trust-model always --recipient WHICH_KEY_TO_USE ${FILE_TO_ENCRYPT}
```

### Encrypt a file for someone
Let's say I got a key fromn an user name: `mynamekey`

```bash
gpg --encrypt --trust-model always --recipient WHICH_KEY_TO_USE ${FILE_TO_ENCRYPT}
```


## Decrypt a file

GPG will search and try the available keys to decrypt the file.

```bash
gpg -d FILE_ENCRIPTED.xxx.gpg
```

## Export Keys
For backup or any other pourpuse, the way to export the private and public keys is:

### Private
```bash
gpg --export-secret-key --armor KEY_NAMEHERE > prv.key
```

### Public
```bash
gpg --export --armor KEY_NAMEHERE > pub.key
```