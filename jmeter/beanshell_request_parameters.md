# Within a Beanshell Pre-Processor, how to get the request paramerers

To get the current request data, you need to access the `sampler` variable.

sampler - (Sampler)- gives access to the current sampler

## Example

```
import org.apache.jmeter.config.Argument;

String url = sampler.getUrl().toString();
String baseParams = sampler.getArguments().toString();
String method = sampler.getMethod();

log.info("Request URL: " + baseUrl);
log.info("Request Method: " + method);
log.info("Request URL: " + baseUrl);

// Iterate the request arguments
Arguments arguments = sampler.getArguments();
for (int i=0; i < arguments.getArgumentCount() ; i++) {
    Argument argument = arguments.getArgument(i);
    String name = argument.getName();
    String value = argument.getValue();

    log.info("Argument: " + name + " = " + value);
}
```


## Reference

* BeanShell PreProcesor Documentation: http://jmeter.apache.org/usermanual/component_reference.html#BeanShell_PreProcessor
* Sample Variable Reference: http://jmeter.apache.org/api/org/apache/jmeter/samplers/Sampler.html