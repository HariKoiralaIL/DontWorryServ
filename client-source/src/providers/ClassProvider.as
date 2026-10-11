package providers {
import injection.utils.SsInternal;

import injection.Injector;

import flash.utils.Dictionary;

public class ClassProvider implements DependencyProvider {

    private var responseType:Class;

    public function ClassProvider(responseType:Class) {
        this.responseType = responseType;
    }

    public function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary):Object {
        return activeInjector.SsInternal::instantiateUnmapped(responseType);
    }

    public function destroy():void {
    }

}
}
