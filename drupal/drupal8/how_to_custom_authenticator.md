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

## Service file
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

The magic in this service configuration file is the tag section. By adding the tag name *authentication_provider*,
Drupal automatically will add the service to the authenticator provider list using as key the *provider_id* data.

### Important notes about the service definition
* You must use as *provider_id* the module name
* Arguments can be whatever, just make sure you pass to your class whatever instance you will need

## Authenticator implementation

You must implement the interface *Drupal\Core\Authentication\AuthenticationProviderInterface* for your authenticator to work
and basically implement 2 methods:
* *public function applies(Request $request)*
* *public function authenticate(Request $request)*

