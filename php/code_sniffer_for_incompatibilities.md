# How to use CodeSniffer for PHP Incompatibilities

I have a project I want to check without installing everything locally.

## Dependencies
* Composer installed locally
* PHP installed locally

## Steps
1. Download the PHP Code Sniffer Phar
2. Get the PHP Compatibility Sniffer
3. Configure
4. Run

**Context**
For the sake of this post, the code to test is from TCExam, this project runs on PHP 5.6 and I want to test it against PHP 8.2.

The directory structure is the following:
```
/my_project
  /tcexam
```


### Step 1-2
```
cd my_project

# Download PHP Code Sniffer
wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar

# Creates a vendor dir with the sniffer plugin
composer require phpcompatibility/php-compatibility
```

### Step 3-4
```
# Do some initial configs
php -d \
  memory_limit=-1 \
  ./phpcs.phar \
  --config-set colors 1

php -d \
  memory_limit=-1 \
  ./phpcs.phar \
  --config-set severity 1

# Run the report
php -d memory_limit=-1 \
  -d error_log=$(pwd)/error.log \
  -d log_errors=1 \
  ./phpcs.phar -p \
  --standard=./vendor/phpcompatibility/php-compatibility/PHPCompatibility \
  --ignore="*/vendor/*" \
  --runtime-set testVersion 8.2 \
  tcexam
```


