package providers {
import injection.Injector;

import flash.utils.Dictionary;

public class ValueProvider implements DependencyProvider {

    private var _value:Object;

    public function ValueProvider(value:Object) {
        _value = value;
    }

    public function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary):Object {
        return _value;
    }

    public function destroy():void {
    }

}
}
