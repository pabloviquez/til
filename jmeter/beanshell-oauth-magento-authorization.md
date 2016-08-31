# Magento OAuth Authorization Header Constructor (With Beanshell)

## References

**OAuth Magento Reference** http://devdocs.magento.com/guides/m1x/api/rest/authentication/oauth_authentication.html#OAuthAuthentication-OAuthProcess

## For **/oauth/initiate**

### NOTES
Requires you to enter the values of 
* OAUTH_CONSUMER_SECRET
* OAUTH_CALLBACK
* OAUTH_CONSUMER_KEY
* OAUTH_SIGNATURE_METHOD


String oSignature; // oauth_signature
String oSecret = vars.get("");

Map oSignatureMap = new TreeMap();
oSignatureMap.put("oauth_version", vars.get("OAUTH_VERSION"));
oSignatureMap.put("oauth_nonce", generateNonce());
oSignatureMap.put("oauth_callback", vars.get("OAUTH_CALLBACK"));
oSignatureMap.put("oauth_consumer_key", vars.get("OAUTH_CONSUMER_KEY"));
oSignatureMap.put("oauth_signature_method", vars.get("OAUTH_SIGNATURE_METHOD"));

```java
import org.apache.commons.httpclient.auth.DigestScheme;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.jmeter.protocol.http.control.Header;
import org.apache.jmeter.config.Argument;
import org.apache.jmeter.config.Arguments;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.util.TreeMap;
import java.util.Map;
import java.util.Date;
import java.util.TimeZone;
import java.util.Calendar;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.apache.jmeter.protocol.http.control.Header;
import java.util.UUID;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

// REPLACE THESE VALUES WITH YOURS
String oCKey = "OAUTH CONSUMER KEY HERE";
String oSecret = "OAUTH CONSUMER SECRET HERE";
String oCallback = "OAUTH CALLBACK VALUE HERE";
// END REPLACING

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

/**
 * Construct and returns the OAuth signature
 * 
 * @return String
 */
String getOAuthSignature(Map params, String baseUrl, String httpMethod, String consumerSecret, String oTokenSecret) {
    String baseSignature;
    String signingKey;
    Base64 base64 = new Base64();

    baseSignature = httpMethod.toUpperCase() + "&" +
        URLEncoder.encode(baseUrl) + "&" +
        URLEncoder.encode(getQueryString(params));

    signingKey = consumerSecret + "&";
    if (oTokenSecret.length() > 0) {
        signingKey = signingKey + oTokenSecret;
    }

    SecretKeySpec secretKeySpec = new SecretKeySpec(signingKey.getBytes(), "HmacSHA1");
    Mac mac = Mac.getInstance("HmacSHA1");
    mac.init(secretKeySpec);
    String encodedData = new String(base64.encode(mac.doFinal(baseSignature.getBytes())));
    return encodedData;
}

/**
 * Retrieves the OAuth authorization header
 * 
 * @return String
 */
String getAuthorizationHeader(String realm, Map params) {
    StringBuilder stringBuilder = new StringBuilder();
    stringBuilder.append("OAuth realm=\"" + URLEncoder.encode(realm) + "\"");
    for (String key : params.keySet()) {
        if (stringBuilder.length() > 0) {
            stringBuilder.append(",");
        }

       stringBuilder.append(key);
        stringBuilder.append("=");
        if (params.get(key).length() > 0) {
            stringBuilder.append("\"" + URLEncoder.encode(params.get(key)) + "\"");
        }
    }

    return stringBuilder.toString();
}

/**
 * Generates and retrieves a Nonce random string
 * 
 * @return String
 */
String generateNonce() {
    Base64 base64 = new Base64();
    Date now = new Date();
    long epoch = now.getTime();
    String nonceBase = UUID.randomUUID().toString() + "-" + epoch;
    MessageDigest md = MessageDigest.getInstance("MD5");
    byte[] thedigest = md.digest(nonceBase.getBytes());

    String finalNonce = new String(base64.encode(thedigest), StandardCharsets.UTF_8);
    return finalNonce;
}

// Request Parameters
String baseUrl = sampler.getUrl().toString();
String baseParams = sampler.getArguments().toString();

// OAuth Vars
String oNonce = generateNonce(); // oauth_nonce
String oSignature; // oauth_signature

Map oSignatureMap = new TreeMap();
oSignatureMap.put("oauth_version", "1.0");
oSignatureMap.put("oauth_nonce", generateNonce());
oSignatureMap.put("oauth_callback", oCallback);
oSignatureMap.put("oauth_consumer_key", oCKey);
oSignatureMap.put("oauth_signature_method", "HMAC-SHA1");

// Calculate the timestamp
Date now = new Date();
long epoch = (now.getTime() / 1000);

oSignatureMap.put("oauth_timestamp", "" + epoch);

// Append the request parameters
Arguments arguments = sampler.getArguments();
for (int i=0; i < arguments.getArgumentCount() ; i++) {
    Argument argument = arguments.getArgument(i);
    String name = argument.getName();
    String value = argument.getValue();
    oSignatureMap.put(name, URLEncoder.encode(value));
}

oSignature = getOAuthSignature(oSignatureMap, baseUrl, sampler.getMethod(), oSecret, "");
oSignatureMap.put("oauth_signature", oSignature);

// Construct the Authorization
String oAuthAuthorization = getAuthorizationHeader(baseUrl, oSignatureMap);
sampler.getHeaderManager().add(new Header("Authorization", oAuthAuthorization));
```