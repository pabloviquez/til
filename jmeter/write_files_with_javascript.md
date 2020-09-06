# JMeter : How to write to a file using JavaScript

Let's say you have JMeter writing to a file.

1. Add a JSR223 Sample
2. Set language to javascript

## Example 1 - Simple Writter
```
var outfile = "./log_file.txt";
var logs = array(
  "Some log A",
  "Some log B",
  "Some log C",
  "Some log D",
  "Some log E"
);

// Get the writter
var writer = new java.io.PrintWriter(outfile);

var total = logs.length;
for(var i = 0; i < total; i++) {
  log.info(logs[i]);
  writer.println(row);
}

writer.close()
```

## Example 2 - Append

The previous example works well when you need to write all at once, however if you need to
write, close the file and later write again (aka append) then the following snippet works for you:

```
var outfile = "./log_file.txt";
var row = "This line will be appended";

// Open the file writer in "append" mode
var filewriter = new java.io.FileWriter(outFile, true);
var writer = new java.io.PrintWriter(filewriter);
writer.println(row);
writer.close()
```


## Reference
For all the possible methods you can use, go to:
* https://docs.oracle.com/javase/7/docs/api/java/io/PrintWriter.html
* https://docs.oracle.com/javase/7/docs/api/java/io/FileWriter.html

[Download :: JMeter plan Example](./plans/LogFileWritter.jmx)
