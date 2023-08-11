# How to have multiple PHP versions using Homebrew

## Add the PHP formulae
`brew tap shivammathur/php`

## Install the versions required

### PHP 7.4
`brew install shivammathur/php/php@7.4`

### PHP 8.1
`brew install shivammathur/php/php@8.1`

### PHP 8.2
`brew install shivammathur/php/php@8.2`

## Remove previous PHP links
`brew unlink php`

## Example - To use PHP 8.2 do:
```bash
brew unlink php
brew link --overwrite --force shivammathur/php/php@8.2
```

# TIP
Open`~/.bash_profile` and add the following aliases:

```bash
alias php_7.4='{ brew unlink php; brew link --overwrite --force php@7.4; } &> /dev/null && echo "Local PHP version changed to:"; php -v'
alias php_8.1='{ brew unlink php; brew link --overwrite --force php@8.1; } &> /dev/null && echo "Local PHP version changed to:"; php -v'
alias php_8.2='{ brew unlink php; brew link --overwrite --force php@8.2; } &> /dev/null && echo "Local PHP version changed to:"; php -v'
```

## Example

```bash
$ php -v
PHP 7.4.33 (cli) (built: Aug  4 2023 14:45:21) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
    with Zend OPcache v7.4.33, Copyright (c), by Zend Technologies

$ php_8.2
Local PHP version changed to:
PHP 8.2.9 (cli) (built: Aug  4 2023 10:26:14) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.2.9, Copyright (c) Zend Technologies
    with Zend OPcache v8.2.9, Copyright (c), by Zend Technologies
```