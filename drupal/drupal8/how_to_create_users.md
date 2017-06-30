# How to create users in Drupal 8 programatically

To create users you need to use the Drupal user entity class ```Drupal\user\Entity\User``` as follow:

```
use Drupal\user\Entity\User;

$usersToCreate = array(
    array(
        'name' => 'user_01',
        'mail' => 'no-reply-user_01@domain.com',
        'pass' => 'MyVeryStrongPasswordThatNoBodyKnows',
        'field_custom_field' => 'custom value',
        'status' => '1',
        'timezone' => 'America/New_York',
    ),
    array(
        'name' => 'user_02',
        'mail' => 'no-reply-user_02@domain.com',
        'pass' => 'MyVeryStrongPasswordThatNoBodyKnows',
        'field_custom_field' => 'custom value',
        'status' => '0',
        'timezone' => 'America/New_York',
    ),
);


foreach ($usersToCreate as $userData) {
    /** @var Drupal\user\Entity\User $user */
    $user = User::create($userData);

    // If you need to add the user to a particular role
    //$user->addRole('moderator');
    $user->save();
}
```

Done!