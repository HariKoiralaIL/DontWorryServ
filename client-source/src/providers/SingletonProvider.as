package providers {
import injectionpoints.TypeDescription;
import injectionpoints.PreDestroyInjectionPoint;

import injection.utils.SsInternal;

import injection.Injector;
import injection.InjectorError;

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

public class SingletonProvider implements DependencyProvider {

    private var responseType:Class;
    private var creatingInjector:Injector;
    private var response:Object;
    private var destroyed:Boolean;

    public function SingletonProvider(responseType:Class, creatingInjector:Injector) {
        this.responseType = responseType;
        this.creatingInjector = creatingInjector;
    }

    public function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary):Object {
        return response = response || createResponse(creatingInjector);
    }

    public function destroy():void {
        destroyed = true;
        if (!response) {
            return;
        }
        var info:TypeDescription = creatingInjector.getTypeDescription(responseType);
        var point:PreDestroyInjectionPoint = info.preDestroyMethods;
        while (point) {
            point.applyInjection(response, responseType, creatingInjector);
            point = PreDestroyInjectionPoint(point.next);
        }
        response = null;
    }

    private function createResponse(injector:Injector):Object {
        if (destroyed) {
            throw new InjectorError("Forbidden usage of unmapped singleton provider for type " + getQualifiedClassName(responseType));
        }
        return injector.SsInternal::instantiateUnmapped(responseType);
    }

}
}
