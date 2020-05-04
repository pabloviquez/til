# How to encrypt and decrypt files with password

## Encrypt using DES3
```
openssl des3 -salt -in file.tar.gz -out file.tar.gz.enc
```

## Decrypt, DES3
```
openssl des3 -d -salt -in file.tar.gz.enc -out file.tar
```


## Encrypt using AES-256-CBC

```
openssl aes-256-cbc -a -salt -in file_to_encript.txt -out file_to_encript.txt.enc
```

## Decrypt AES-256-CBC

```
openssl aes-256-cbc -d -a -in file_to_encript.txt.enc -out file_to_encript.txt
```