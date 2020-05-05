# How to run or execute a command as a different user

```
USER="some-sys-user"
CMD="touch myfile.txt"
sudo su -c "${CMD}" -s /bin/bash ${USER}
```