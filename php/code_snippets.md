# Debugging Snippets

## DEBUG_PHP

**Description**:  DEBUG - Outputs and exit

### Zend Studio
```
// DEBUG - START
echo "\n<pre>\n";
echo __FILE__ . '::' . __METHOD__ . '(' . __LINE__ . ")\n";
var_dump(${VAR_TO_DEBUG});
echo "\n</pre>\n";
exit;
// DEBUG - END

```

### Visual Studio
```
  "DEBUG_PHP": {
    "prefix": "DEBUG_PHP",
    "body": [
      "// DEBUG - START",
      "echo \"\n<pre>\n\";",
      "echo __FILE__ . '::' . __METHOD__ . '(' . __LINE__ . \")\n\";",
      "var_dump(${VAR_TO_DEBUG});",
      "echo \"\n</pre>\n\";",
      "exit;",
      "// DEBUG - END"
    ],
    "description": "DEBUG - Prints and exit"
  }
```


## DEBUG_LOG

**Description**:  DEBUG - Print to PHP error log

### Zend Studio
```php
// DEBUG - START
error_log(__CLASS__ . '::' . __FUNCTION__ . '(' . __LINE__ . ')');
error_log('${TXT_VAR_TO_DEBUG} ' . print_r(${VAR_TO_DEBUG}, true));
// DEBUG - END
```

### Visual Studio
```javascript
  "DEBUG_LOG": {
    "prefix": "DEBUG_LOG",
    "body": [
      "// DEBUG - START"
      "error_log(__CLASS__ . '::' . __FUNCTION__ . '(' . __LINE__ . ')');"
      "error_log('$${1} ' . print_r($${1}, true));"
      "// DEBUG - END"
    ],
    "description": "DEBUG - Print to PHP error log"
  }
```
