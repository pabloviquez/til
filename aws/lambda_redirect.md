# AWS Lambda JS Redirect

I was required to do a simple redirect based on the device user agent:

## Logic
* If Android, redirect to Google Play Store
* If iPhone, redirect to Apple App Store


## Solution - Code
```
'use strict';

/**
 * AT&T DirectTV - App redirect page
 *
 * Depending on the user agent used, we need to redirect clients
 * to the respective App Store
 *
 * Android: https://play.google.com/store/apps/details?id=com.directv.dvrscheduler
 *     iOS: https://itunes.apple.com/us/app/directv/id307386350
 *
 */
exports.handler = (event, context, callback) => {
    const headers = event.headers;

    const store_android = 'https://play.google.com/store/apps/details?id=com.directv.dvrscheduler';
    const store_iphone = 'https://itunes.apple.com/us/app/directv/id307386350';
    const uadetect = /Mobile|iP(hone|od|ad)|Android|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune/;

    // Detect UA and redirect accordingly
    var detection = uadetect.exec(headers['User-Agent']);
    var mobileDevice = '';
    
    if (detection !== null && detection.length > 0) {
        mobileDevice = detection[0];
    }

    // Select Store
    var storeUrl = '';
    switch(mobileDevice) {
        case 'Mobile' :
        case 'Android' :
            storeUrl = store_android;
            break;
        case 'iPhone' :
        default:
            storeUrl = store_iphone;
            break;
    }
    
    callback(null, { 
        statusCode: 302,
        headers: {
            'Location': storeUrl
        }
    });
};

```