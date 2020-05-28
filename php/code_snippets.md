# Code Snippets

## Debugging Snippets

Name | Zend Studio | Visual Studio
--- | --- | ---
`DEBUG` | ```sdkjskd``` | `slsk`
`DEBUG_LOG` | `// DEBUG - START
error_log(__CLASS__ . '::' . __FUNCTION__ . '(' . __LINE__ . ')');
error_log('${TXT_VAR_TO_DEBUG} ' . print_r(${VAR_TO_DEBUG}, true));
// DEBUG - END` | `
"DEBUG_LOG": {
    "prefix": "DEBUG_LOG",
    "body": [
      "// DEBUG - START"
      "error_log(__CLASS__ . '::' . __FUNCTION__ . '(' . __LINE__ . ')');"
      "error_log('$${1} ' . print_r($${1}, true));"
      "// DEBUG - END"
    ],
    "description": "DEBUG - Print to PHP error log"
  }`

