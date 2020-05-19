# Error: No site aliases found

So if you run into this issue and are like WTF! this is why and how to fix it.

## Symptoms
1. You might have a drupal directory with a file like: `aliases.drushrc.php`
2. Your file define all your alias
3. If you run `drush sa --debug` you see something like:

```
 [preflight] Config paths: /var/www/.composer/vendor/drush/drush/drush.yml
 [preflight] Alias paths: 
 [preflight] Commandfile search paths: /var/www/.composer/vendor/drush/drush/src
 [debug] Starting bootstrap to none [0.18 sec, 9.1 MB]
 [debug] Drush bootstrap phase 0 [0.18 sec, 9.1 MB]
 [debug] Try to validate bootstrap phase 0 [0.18 sec, 9.1 MB]
 [success] No site aliases found. [0.18 sec, 9.14 MB]
```

## Problem
The issue most likely is your Drush version. If you're running Drush 9 or above, this configuration file no longer is retrieved.

## What do I do???
Simple, you can convert your alias to the new format YAML version.

So for example, lets say your directory structure looks something like:

```
/app/
  /drush
    aliases.drushrc.php
  /docroot
```

**aliases.drushrc.php**
```
// Application 'foobar', environment 'dev'.
$aliases['dev'] = array (
  'root' => '/var/www/html/foobar/docroot',
  'ac-site' => 'foobar',
  'ac-env' => 'dev',
  'ac-realm' => 'bar',
  'uri' => 'foobar.prod.acquia-sites.com',
  'path-aliases' => array (
    '%drush-script' => 'drush8',
  ),
  'dev.livedev' =>  array (
    'parent' => '@foobar.dev',
    'root' => '/mnt/gfs/foobar.dev/livedev/docroot',
  ),
  'remote-host' => 'foobar.ssh.prod.acquia-sites.com',
  'remote-user' => 'foobar.dev',
);
```

## Convert Legacy Files

Fortunately, Drush has a convert legacy file format tool which can help, just do:

```
drush site:alias-convert
```

Now run again:

```
drush sa
```

This command will read the old legacy file and convert them to YAML format (default format).

**Done!**

## Extra Configs
You can have your site-alias files out of the docroot if you want. Drush have a prefer set of directories where it looks for the configurations.

In my particular case, If I do: `drush sa -vvv` as part of the output, I get:
```
 [preflight] Config paths: /var/www/.composer/vendor/drush/drush/drush.yml
 [preflight] Alias paths: /app/docroot/drush/sites,/app/drush/sites
 [preflight] Commandfile search paths: /var/www/.composer/vendor/drush/drush/src,/app/drush
```

Which means that, I could save the result .yml site alias files in the directories:
* `/app/docroot/drush/sites`
* `/app/drush/sites`

