# Function to get a query string

```java
import java.net.URLEncoder;
import java.util.TreeMap;
import java.util.Map;

/**
 *  Generate URL-encoded query string 
 *  
 *  @return String
 */
String getQueryString(Map params) {
    StringBuilder stringBuilder = new StringBuilder();

    for (String key : params.keySet()) {
        if (stringBuilder.length() > 0) {
            stringBuilder.append("&");
        }

        stringBuilder.append(key);
        stringBuilder.append("=");
        stringBuilder.append(URLEncoder.encode(params.get(key)));
    }

    return stringBuilder.toString();
}

Map params = new TreeMap();
Arguments arguments = sampler.getArguments();
for (int i=0; i < arguments.getArgumentCount() ; i++) {
    Argument argument = arguments.getArgument(i);
    String name = argument.getName();
    String value = argument.getValue();
    params.put(name, value);
}

// Alphabetic order (OAuth ready)
String queryString = getQueryString(params);
```