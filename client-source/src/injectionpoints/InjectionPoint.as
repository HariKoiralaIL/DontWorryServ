package injectionpoints {

import flash.utils.Dictionary;

import injection.Injector;

/**
 * Base class for one place a dependency is injected (constructor, property,
 * method, ...). Injection points of a type are kept in a singly linked list:
 * `next` links to the following point and, on the head of a list, `last`
 * points at the tail so appending is O(1).
 */
public class InjectionPoint {

    public var next:InjectionPoint;
    public var last:InjectionPoint;
    public var injectParameters:Dictionary;

    public function applyInjection(target:Object, targetType:Class, injector:Injector):void {
    }

}
}
