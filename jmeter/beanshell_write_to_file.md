# Beanshell - How to write to file

To write to a file in JMeter using Beanshell, you can use the following code:

## Create file or erase it's contents
```java
String out_file = "path/to/file.txt";
String write_line = "This is a line to write to the file";

// Without the "append" parameter, it will create the file or erase it's contents
FileOutputStream logfile = new FileOutputStream(out_file);
FileWriter fWriter = new FileWriter(out_file, true);
BufferedWriter buff = new BufferedWriter(fWriter);
buff.write("");
buff.close();
fWriter.close();
```


## Append to file

```java
String out_file = "path/to/file.txt";
String write_line = "This is a line to write to the file";

FileOutputStream logfile = new FileOutputStream(out_file, true);
FileWriter fWriter = new FileWriter(out_file, true);
BufferedWriter buff = new BufferedWriter(fWriter);
buff.write(write_line);
buff.write(System.getProperty("line.separator"));
buff.close();
fWriter.close();
```


