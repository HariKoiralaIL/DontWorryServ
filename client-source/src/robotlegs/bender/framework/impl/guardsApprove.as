package robotlegs.bender.framework.impl {
import injection.Injector;

/**
 * Returns true only if every guard approves. A function guard approves by returning
 * a truthy value; a class guard is instantiated (via the injector when one is supplied)
 * and approves unless its approve() method returns false.
 */
public function guardsApprove(guards:Array, injector:Injector = null):Boolean {
    var guard:Object;
    for each (guard in guards) {
        if (guard is Function) {
            if ((guard as Function)()) {
                continue;
            }
            return false;
        }
        if (guard is Class) {
            guard = injector ? injector.getInstance(guard as Class) : new (guard as Class)();
        }
        if (guard.approve() == false) {
            return false;
        }
    }
    return true;
}
}
