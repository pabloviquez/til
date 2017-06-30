# How to create user roles in Drupal 8 programatically

To create users you need to use the Drupal user entity class ```Drupal\user\Entity\Role``` as follow:

```
use Drupal\user\Entity\Role;

$role = Role::create([
    'id' => 'my_awesome_role',
    'label' => 'My Awesome Role'
]);

$role->save();

```

Done!