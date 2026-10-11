package injectionpoints {

import injection.Injector;

/**
 * Constructor injection point for classes whose constructor takes no
 * parameters. Skips parameter resolution entirely.
 */
public class NoParamsConstructorInjectionPoint extends ConstructorInjectionPoint {

    public function NoParamsConstructorInjectionPoint() {
        super([], 0, null);
    }

    override public function createInstance(targetType:Class, injector:Injector):Object {
        return new targetType();
    }

}
}
