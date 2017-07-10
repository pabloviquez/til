# How to create a custom Authenticator

If you want to create your very own authenticator, the steps are pretty straightforward:

## Create your own module
In this case, our module name will be: **api_authenticator**

**Directory Structure**
```
/api_authenticator
    /api_authenticator.info.yml
    /api_authenticator.services.yml
    /src
        /Authentication
            /Provider
                /ApiAuthenticator.php

```

This schema is simple, just add the info file and the services

## Services
Drupal 8 dependency injection is awesome, however might pose a higher learning curve for developers.

**api_authenticator.services.yml**
```
services:
    api_authenticator.api_authenticator:
        class: Drupal\api_authenticator\Authentication\Provider\ApiAuthenticator
        arguments:
            - '@config.factory'
            - '@entity_type.manager'
        tags:
            - { name: authentication_provider, provider_id: api-authenticator, priority: 100 }

```