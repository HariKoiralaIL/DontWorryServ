package robotlegs.bender.framework.impl {
import injection.Injector;

/**
 * Runs each hook: a function is invoked directly, a class is instantiated
 * (via the injector when one is supplied) and its hook() method is called.
 */
public function applyHooks(hooks:Array, injector:Injector = null):void {
    var hook:Object;
    for each (hook in hooks) {
        if (hook is Function) {
            (hook as Function)();
        } else {
            if (hook is Class) {
                hook = injector ? injector.getInstance(hook as Class) : new (hook as Class)();
            }
            hook.hook();
        }
    }
}
}
