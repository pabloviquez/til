# How to load and view all configuration keys for a Drupal 8 module

## Context

### Config Factory

The Config Factory is in charge of getting your Config items, it does not contains the actual configurations.

It's defined with the namespace ```Drupal\Core\Config\ConfigFactory```

```
$configFactory = \Drupal::configFactory();
```

### Config Item

By default, it returns an ```ImmutableConfig``` which contains the data for the specific configuration.

```
/** @var Drupal\Core\Config\ImmutableConfig $config */
$config = \Drupal::configFactory()->get('my_module.my_module.specific_item_a');

foreach ($config->getOriginal() as $key => $data) {
    echo "Key {key} => {$data}";
}
```

# What if you have multiple keys?

If you have multiple configurations keys and you need to get them all. For example, if you have the following configuration keys:
* my_module.my_module.specific_item_a
* my_module.my_module.specific_item_b
* my_module.my_module.specific_item_c

and each key has the following schema:

**my_module/config/schema/my_module.schema.yml**

```
my_module.my_module.*:
    type: config_entity
    label: 'My awesome module'
    mapping:
        id:
            type: string
            label: 'machine_name'
        uuid:
            type: string
            label: 'UUID'
        langcode:
            type: string
            label: 'Default language'
        customkey:
            type: string
            label: 'Some value'
            translatable: false
```

And lets say I have previously saved 3 specific items:

**my_module/config/install/my_module.my_module.specific_item_a.yml**
```
id: specific_item_a
customkey: 'Specific value for my specific item'
```

**my_module/config/install/my_module.my_module.specific_item_b.yml**
```
id: specific_item_b
customkey: 'Specific value for my specific item'
```

**my_module/config/install/my_module.my_module.specific_item_c.yml**
```
id: specific_item_c
customkey: 'Specific value for my specific item'
```



## Get all items

```
$configFactory = \Drupal::configFactory();
$keys = $configFactory->listAll('my_module.my_module');
$configurations = $configFactory->loadMultiple($keys);
```

Now we can iterate the configurations:
```
foreach ($configurations as $configKey => $config) {
    // Each $config is a Drupal\Core\Config\ImmutableConfig
    echo "The specific item: {$configKey} has the value: " . $config->get('customkey');
}

```
