package providers {
import injection.Injector;

import flash.utils.Dictionary;

public class ForwardingProvider implements DependencyProvider {

    public var provider:DependencyProvider;

    public function ForwardingProvider(provider:DependencyProvider) {
        this.provider = provider;
    }

    public function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary):Object {
        return provider.apply(targetType, activeInjector, injectParameters);
    }

    public function destroy():void {
        provider.destroy();
    }

}
}
