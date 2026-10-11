package providers {
import injection.Injector;

import flash.utils.Dictionary;

public class InjectorUsingProvider extends ForwardingProvider {

    public var injector:Injector;

    public function InjectorUsingProvider(injector:Injector, provider:DependencyProvider) {
        super(provider);
        this.injector = injector;
    }

    override public function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary):Object {
        return provider.apply(targetType, injector, injectParameters);
    }

}
}
