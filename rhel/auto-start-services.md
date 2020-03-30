# Auto-Start Applications

## Get the list of running/enabled/disabled applications
```
systemctl list-unit-files
```

## Start on reboot

```
systemctl enable SERVICE
```

## Disable on reboot
```
systemctl disable SERVICE
```

### Example - Enable Ngix to boot automatically

```
systemctl enable nginx
```

### Example - Disable Ngix to boot automatically
```
systemctl disable nginx
```
