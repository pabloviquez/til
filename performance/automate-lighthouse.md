# How to Automate Google Lighthouse Tests

## Scenario
Let's say I want to test multiple URLs and do that in an automated process. I can use Lighthouse to generate reports for each URL and then compare the results.

## Solution
The solution for my case, is to install Lighthouse as a local dependency and then create a script that will read a file with URLs and run the Lighthouse tests for each URL.


# Lighthouse Installation & Single Test

### NPM Package Setup
According to the [Lighthouse documentation](https://developer.chrome.com/docs/lighthouse/overview), you install the package globally or locally. In this case, I will install it locally, as I do not want to have a global dependencies.

Create the file: `package.json` with the following content:
```json
{
  "name": "lighthouse-performance",
  "version": "1.0.0",
  "description": "Lighthouse Performance Testing",
  "scripts": {
    "test": "test",
    "lighthouse": "lighthouse",
    "lighthouse-help": "lighthouse --help"
  },
  "keywords": [
    "automation",
    "lighthouse"
  ],
  "author": "Pablo Viquez <pviquez@pabloviquez.com>",
  "license": "ISC",
  "dependencies": {
    "lighthouse": "^12.2.0"
  }
}
```

### Install
```bash
npm install
```

### Run Lighthouse Report for a Single URL
```bash
npm run lighthouse https://www.pabloviquez.com
```

### Run Lighthouse Report with JSON, HTML, and CSV Outputs
```bash
npm run lighthouse \
  -- \
  --view \
  --output=html,json,csv \
  --output-path=.$(date '+%Y%m%d_%I%M%S')-results.html \
  --verbose \
  https://www.pabloviquez.com/
```

# Lighthouse Automation for Multiple URLs

Create a file called "urls.txt" with the following content:
```txt
https://www.pabloviquez.com/
https://www.url-to-test.com/
https://www.another-url-to-test.com/
```

Create a file called "lighthouse.sh" with the following content:
```bash
#!/bin/bash
# ---------------------------------------------------------------------------------------------
# -- LightHouse Test Script
# --
# -- Will parse the content of a file and run lighthouse tests on each URL.
# --
# -- Usage:
# --   ./lighthouse.sh <file>
# --
# --   <file>  Is a text file with one URL per line.
# --
# -- Author: Pablo Viquez <pviquez@pabloviquez.com>
# -- Version: 1.0
# ---------------------------------------------------------------------------------------------

_FILE_URLS=$1

if [ "${_FILE_URLS}" == "" ] || [ ! -f ${_FILE_URLS} ]; then
  echo "Error: File not provided or not found. (${_FILE_URLS})"
  echo ""
  exit 1
fi

# Append a new line to the file
echo "" >> ${_FILE_URLS}

cat ${_FILE_URLS} | while read url
do
  if [ "${url}" == "" ]; then
    continue
  fi

  # Remove trailing slash
  url=$(echo ${url} | sed -e 's/\/$//g')

  # Remove http:// or https://, also convert / to _
  reportname=$(echo ${url} | sed -e 's/http:\/\///g' -e 's/https:\/\///g' -e 's/\//_/g')

  _OUTFILE="./$(date '+%Y%m%d_%I%M%S')--${reportname}--results.html"
  echo "--"
  echo "-- Testing: ${url}"
  echo "-- Output: ${_OUTFILE}"
  echo "-- Report: ${reportname}"

  npm run lighthouse \
    -- \
    --output=html,json,csv \
    --output-path=${_OUTFILE} \
    ${url}
done

echo "Testing completed."
```

