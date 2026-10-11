package logging {

import flash.utils.Dictionary;

import injection.Injector;
import providers.DependencyProvider;

import robotlegs.bender.framework.api.IContext;

/**
 * Dependency provider that supplies each injection target with a logger
 * from the context, created for the class being injected into.
 */
public class LoggerProvider implements DependencyProvider {

    private var context:IContext;

    public function LoggerProvider(context:IContext) {
        this.context = context;
    }

    public function apply(targetType:Class, injector:Injector, injectParameters:Dictionary):Object {
        return this.context.getLogger(targetType);
    }

    public function destroy():void {
    }

}
}
