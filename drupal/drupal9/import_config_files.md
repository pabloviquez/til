# Programatically Import Config Files

Let's say I have a new field that I want to create programatically using YML configuration files, or programatically I want update the entity form display view, and all of this inside a module.

## Where to use it?
Normally, this types of cases will happen in the `.install` file.

## Example
* Module name: MyMod
* Install file name: `mymod.install`

```
/**
 * Reads, parses and process configuration files.
 *
 * Example, create a new field:
 * @code
 * $storage_file = 'field.storage.ENTITY.FIELDNAME';
 * $field_file = 'field.field.....FIELDNAME';
 * _mymod_config_import('create', $storage_file, $field_file);
 * @endcode
 *
 * Update a config file like display form, example:
 * @code
 * $display_form = 'core.entity_form_display.ENTITY.....default.yml';
 * _mymod_config_import('update', $display_form);
 * @endcode
 *
 * @param string $operation
 *   Operation type, supported: create, update.
 * @param string $storage_file_name
 *   Storage configuration file without the extension.
 * @param string $field_file_name
 *   Field file configuratin without the extension.
 * @param string $config_module
 *   Configuration module to look for the fields. If not provided, the path for
 *   the YML files will be: "../config/default", however if provided, the
 *   location used will be the MOD_PATH/config/config_updates.
 *
 * @throws \Exception
 *   Throws an exception if the $operation is not allowed or the module $config_module does
 *   not exists or the directory MOD_PATH/config/config_updates is not present.
 */
function _mymod_config_import(
  string $operation,
  string $storage_file_name,
  string $field_file_name = NULL,
  string $config_module = NULL): void {

  // @todo Test function with an update operation.
  $allowedOperations = [
    'update',
    'create',
  ];

  if (!in_array($operation, $allowedOperations)) {
    throw new \Exception('Operation not supported.');
  }

  $config_path = '../config/default';
  if ($config_module) {
    $mod_path = drupal_get_path('module', $config_module);
    if (!$mod_path) {
      throw new \Exception(
        "Module {$config_module} not found, unable to {$operation} fields.");
    }

    $config_path = "{$mod_path}/config/config_updates";
  }

  /** @var \Drupal\Core\Config\FileStorage $source */
  $file_storage = new FileStorage($config_path);

  /** @var \Drupal\Core\Config\CachedStorage $config_storage */
  $config_storage = \Drupal::service('config.storage');

  /** @var \Drupal\Component\EventDispatcher\ContainerAwareEventDispatcher $event_dispatcher */
  $event_dispatcher = \Drupal::service('event_dispatcher');

  /** @var \Drupal\Core\Config\ConfigManager $config_manager */
  $config_manager = \Drupal::service('config.manager');
  $entity_type = $config_manager->getEntityTypeIdByName($storage_file_name);

  /** @var \Drupal\Core\Config\TypedConfigManager  $type_manager */
  $type_manager = \Drupal::service('config.typed');

  /** @var \Drupal\Core\Entity\EntityTypeManager $entity_type_manager */
  $entity_type_manager = \Drupal::service('entity_type.manager');

  /** @var \Drupal\field\FieldStorageConfigStorage $entity_storage */
  $entity_storage = $entity_type_manager->getStorage($entity_type);

  /** @var \Drupal\Core\Config\Config $config */
  $old_config = new Config(
    $storage_file_name,
    $config_storage,
    $event_dispatcher,
    $type_manager
  );

  /** @var \Drupal\Core\Config\Config $config */
  $new_config = new Config(
    $storage_file_name,
    $config_storage,
    $event_dispatcher,
    $type_manager
  );

  $data = $file_storage->read($storage_file_name);
  $new_config->setData($data);

  $method = 'import' . ucfirst($operation);
  $entity_storage->$method($storage_file_name, $new_config, $old_config);

  if ($field_file_name) {
    $config_storage->write($field_file_name, $file_storage->read($field_file_name));
  }
}
```