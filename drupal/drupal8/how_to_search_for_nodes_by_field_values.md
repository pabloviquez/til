# Search and load nodes by using field values

## Context
One content type called 'my_content_type' with the following fields:
```
field_abc_data_id
field_xyz_data_id
```

I need to seach all nodes that matches field_abc_data_id with the string 'test'

# 1. Search for the Node IDs (nid)
```php
$storage = \Drupal::entityTypeManager()->getStorage('node');
$query = \Drupal::entityQuery('node')
  ->condition('type', 'my_content_type')
  ->condition('field_abc_data_id', 'test');

$nids = $query->execute();
$nodes = $storage->loadMultiple($nids);

foreach ($nodes as $node) {
    echo "Node title: {$node->title->value}";
}

```

## Reference
https://api.drupal.org/api/drupal/core%21lib%21Drupal.php/function/Drupal%3A%3AentityQuery/8.6.x
