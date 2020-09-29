# Node with multiple path alias

I have a node that requires to respond **without redirection** to multiple path aliases.

### Example
```
SELECT id,alias,status FROM path_alias WHERE path like '/node/123456'
+--------+--------------------------------------------------------------------------------------------+--------+
| id     | alias                                                                                      | status |
+--------+--------------------------------------------------------------------------------------------+--------+
| 921031 | /aura-cacia-gray-matter-batter-essential-oil0-5-fl-oz                                      |      1 |
| 921036 | /essential-oils/aura-cacia-gray-matter-batter-essential-oil0-5-fl-oz                       |      1 |
| 921041 | /essential-oils/benefit-driven-blends/aura-cacia-gray-matter-batter-essential-oil0-5-fl-oz |      1 |
| 921046 | /essential-oils/essential-oil-blends/aura-cacia-gray-matter-batter-essential-oil0-5-fl-oz  |      1 |
| 921051 | /aura-cacia-gray-matter-batter-essential-oil0-5-fl-oz                                      |      1 |
+--------+--------------------------------------------------------------------------------------------+--------+
5 rows in set (0.00 sec)
```

# Why is redirecting?
Basically, internally, when a inboud processor kicks in, initially recives the original request, let's say: ```/aura-cacia-gray-matter-batter-essential-oil0-5-fl-oz``` however, at some point this URL gets translated into the node URL: ```/node/123456```.

At this point, one module will query ```Drupal\path_alias\AliasManager``` for the path alias for the URL and this is where the redirection may happen. Basically because it will return the first path matching the node.

## DEBUG :: Where does the redirect happens?

The request subscriber checks if the route matches the alias, if it does not, redirects to the alias.
```\Drupal\redirect\EventSubscriber\RouteNormalizerRequestSubscriber::onKernelRequestRedirect```

## DEBUG :: How to stop?
Register a processor before RouteNormalizerRequestSubscriber and set the event property _disable_route_normalizer == true.

# Code

## Service File Code
```
  mymod.path_subscriber:
    class: Drupal\mymod\Services\Path\PathSubscriber
    arguments:
      - '@path_alias.manager'
    tags:
     - { name: path_processor_inbound }
     - { name: event_subscriber }
```

## Service File
```
<?php
namespace Drupal\mymod\Services\Path;

use Drupal\path_alias\AliasManager;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\KernelEvents;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Drupal\Core\PathProcessor\InboundPathProcessorInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class PathSubscriber implements InboundPathProcessorInterface, EventSubscriberInterface
{
    /**
     * Drupal alias manager
     *
     * @var Drupal\path_alias\AliasManager
     */
    protected $_aliasManager;

    /**
     * Request stack
     *
     * @var RequestStack
     */
    protected $_requestStack;

    /**
     * Public constructor
     *
     * @param AliasManager $aliasManager
     */
    public function __construct(AliasManager $aliasManager)
    {
        $this->_aliasManager = $aliasManager;
    }

    /**
     * Returns an array of event names this subscriber wants to listen to.
     *
     * The array keys are event names and the value can be:
     *
     *  * The method name to call (priority defaults to 0)
     *  * An array composed of the method name to call and the priority
     *  * An array of arrays composed of the method names to call and respective
     *    priorities, or 0 if unset
     *
     * For instance:
     *
     *  * ['eventName' => 'methodName']
     *  * ['eventName' => ['methodName', $priority]]
     *  * ['eventName' => [['methodName1', $priority], ['methodName2']]]
     *
     * The code must not depend on runtime state as it will only be called at compile time.
     * All logic depending on runtime state must be put into the individual methods handling the events.
     *
     * @link https://api.drupal.org/api/drupal/core!core.api.php/group/events/8.9.x
     * @return array The event names to listen to
     */
    public static function getSubscribedEvents()
    {
        $events[KernelEvents::REQUEST][] = ['onKernelRequestMultipleAliasCheck', 30];
        return $events;
    }

    /**
     * Handles the redirect if any found.
     *
     * @param \Symfony\Component\HttpKernel\Event\GetResponseEvent $event
     *   The event to process.
     */
    public function onKernelRequestMultipleAliasCheck(GetResponseEvent $event)
    {
        // Get requested path
        $path = $event->getRequest()->getPathInfo();

        // Get node matching path
        $alias = $this->_aliasManager->getPathByAlias($path);
        if ($alias && strpos($alias, '/node/') !== false) {
            $event->getRequest()->attributes->set('_disable_route_normalizer', true);
        }
    }

    /**
     * Processes the inbound path.
     *
     * Implementations may make changes to the request object passed in but should
     * avoid all other side effects. This method can be called to process requests
     * other than the current request.
     *
     * @param string $path
     *   The path to process, with a leading slash.
     * @param \Symfony\Component\HttpFoundation\Request $request
     *   The HttpRequest object representing the request to process. Note, if this
     *   method is being called via the path_processor_manager service and is not
     *   part of routing, the current request object must be cloned before being
     *   passed in.
     *
     * @return string
     *   The processed path.
     */
    public function processInbound($path, Request $request)
    {
        return $path;
    }
}
```