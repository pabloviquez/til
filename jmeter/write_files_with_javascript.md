# JMeter : How to write to a file using JavaScript

Let's say you have JMeter writing to a file.

1. Add a JSR223 Sample
2. Set language to javascript

## Exmple
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

## Reference
For all the possible methods you can use, go to: https://docs.oracle.com/javase/7/docs/api/java/io/PrintWriter.html

[Example JMeter plan!](./plans/LogFileWritter.jmx)
