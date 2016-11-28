# If Oneliner

I have a Vagrant machine with one shared directory for assets.

This directory is stored on a external drive since it's heavy and I do not want to either load all assets on the VM or my machine.

The following command, checks if the external drive was mounted and if does creates a symlink to it, if not creates a symlink to another directory so the drive is mounted always.

```bash
[ -d '/Volumes/HDASSETS' ]&&ln -s /Volumes/HDASSETS/var/assets/media media||ln -s empty_media media
```

