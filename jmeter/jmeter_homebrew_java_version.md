# Jmeter Java Version Using Homebrew

JMeter installed with homebrew uses the Java version that comes with the default setup.

In my case (_when this post was written_):
```
$ ls -l /usr/local/opt/openjdk
lrwxr-xr-x  1 xxxxx xxxx    24B Feb 22 17:04 /usr/local/opt/openjdk@ -> ../Cellar/openjdk/19.0.2
```

## Change it to use another version

> **Will required sudo permissions**

Look for the Jmeter start file:
```
$ which jmeter
/usr/local/bin/jmeter
```

<br>
Using the editor of your preference, change the file contents to:

```bash
#!/bin/bash
# To get available versions:
#   usr/libexec/java_home -V
export JAVA_VMVER="1.8"
export JAVA_HOME="$(/usr/libexec/java_home -v ${JAVA_VMVER})"

# Get JMeter Path
JMETER_LIB_EXEC=$(brew list -1 jmeter |grep '/libexec/bin/jmeter$' |head -n 1)

echo "--"
echo "-- JMeter start with custom Java Home."
echo "--"
echo "-- Java version requested: ${JAVA_VMVER}"
echo "-- Java Home: ${JAVA_HOME}"
echo "--"
echo "-- JMeter Path: ${JMETER_LIB_EXEC}"
echo "--"

# Execute JMeter with the new Java Home
exec "${JMETER_LIB_EXEC}"  "$@"

```